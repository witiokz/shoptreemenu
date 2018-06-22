from sqlalchemy import create_engine, select, func
from sqlalchemy.orm.session import sessionmaker
import random
import string
from datetime import datetime
from entities import *
from config import *

random.seed(datetime.now())

class DAL:
    def __init__(self):
        self.engine = create_engine(CONNECTION)
        self.conn = self.engine.connect()
        self.session_maker = sessionmaker(bind=self.conn, autoflush=False)

    @staticmethod
    def set_fields(json, item, type):
        json["id"] = item.id
        json["name"] = item.name
        json["active"] = item.active
        if type == Product:
            json["price"] = float(item.price)
            json["type"] = "product"
        elif type == Category:
            json["type"] = "category"

    def get_menu(self):
        json = None

        category_map = {}
        for c in self.conn.execute(select([Category]).order_by(Category.id)):
            c_json = {}
            DAL.set_fields(c_json, c, Category)
            category_map[c.id] = c_json

            if c.parent_id in category_map:
                parent = category_map[c.parent_id]
                if not "items" in parent:
                    parent["items"] = []
                parent["items"].append(c_json)
            elif c.name == ROOT_NAME:
                json = c_json
            else:
                raise Exception("Can't find parent category", c.id)

        product_map = {}
        for p in self.conn.execute(select([Product]).order_by(Product.id)):
            p_json = {}
            DAL.set_fields(p_json, p, Product)
            product_map[p.id] = p_json

        for pc in self.conn.execute(select([t_product_category])):
            parent = category_map[pc.category_id]
            if not "items" in parent:
                parent["items"] = []

            product = product_map[pc.product_id]
            parent["items"].append(product)

        return json

    def get_root(self):
        s = select([Category]).where(Category.name == ROOT_NAME)
        query = self.conn.execute(s)
        res = query.fetchone()
        return res

    def clean(self):
        self.conn.execute("DELETE FROM product_category")
        self.conn.execute("DELETE FROM product")
        self.conn.execute("DELETE FROM category")

    def seed_database(self, depth=0):
        root = self.get_root()
        if not root:
            self.conn.execute(Category.__table__.insert(), {
                'name': ROOT_NAME,
                'active': True,
            })
        else:
            return

        for i in range(depth):
            s = select([Category.id]).order_by(func.random())
            parent_id = self.conn.execute(s).fetchone()[0]
            session = self.session_maker()

            if random.random() < 0.2:
                random_name = "C_" + ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(5))
                category = Category()
                category.name = random_name
                category.active = random.choice((True, False))
                category.parent_id = parent_id
                session.add(category)
                print("Add category", random_name, "to", parent_id)
            else:
                random_name = "P_" + ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(6))
                product = Product()
                product.name = random_name
                product.active = random.choice((True, False))
                product.price = random.randrange(1, 10000) / 100
                session.add(product)
                session.flush()

                self.conn.execute(t_product_category.insert(), {
                    'product_id': product.id,
                    'category_id': parent_id
                })

                print("Add product", product.id, random_name, "to", parent_id)

            session.commit()
