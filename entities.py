from sqlalchemy import Boolean, Column, ForeignKey, Integer, Numeric, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
metadata = Base.metadata


class Category(Base):
    __tablename__ = 'category'

    id = Column(Integer, primary_key=True, server_default=text("nextval('category_id_seq'::regclass)"))
    name = Column(String(100), nullable=False)
    active = Column(Boolean, nullable=False)
    parent_id = Column(ForeignKey('category.id'))

    parent = relationship('Category', remote_side=[id])
    products = relationship('Product', secondary='product_category')

    items = []


class Product(Base):
    __tablename__ = 'product'

    id = Column(Integer, primary_key=True, server_default=text("nextval('product_id_seq'::regclass)"))
    name = Column(String(100), nullable=False)
    active = Column(Boolean, nullable=False)
    price = Column(Numeric, nullable=False)

    categories = relationship('Category', secondary='product_category')


t_product_category = Table(
    'product_category', metadata,
    Column('product_id', ForeignKey('product.id'), primary_key=True, nullable=False),
    Column('category_id', ForeignKey('category.id'), primary_key=True, nullable=False)
)
