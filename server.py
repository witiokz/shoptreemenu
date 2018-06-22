from flask import Flask, jsonify
import sys
from dal import *

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/api/menu')
def menu():
    dal = DAL()
    menu = dal.get_menu()
    response = jsonify(menu)
    return response


if __name__ == '__main__':
    dal = DAL()

    if len(sys.argv) == 2 and sys.argv[1] == "clean":
        dal.clean()
        print("cleaned")
    else:
        dal.seed_database(10000)
        app.run()
