from flask import Flask, jsonify, request
from connector import DBConnector
from customer import Customer
import os
app = Flask(__name__)
app.config.from_pyfile(os.path.join(".", "app.config"), silent=False)

# MySQL database connection
host = app.config.get('HOST')
user = app.config.get('USER')
password = app.config.get('PASSWORD')
database = app.config.get('DATABASE')

db_connector = DBConnector(host, user, password, database)
customer = Customer(db_connector)


@app.route('/customers', methods=['POST'])
def add_customer():
    name = request.json['name']
    address = request.json['address']
    phone_number = request.json['phone_number']
    email = request.json['email']
    customer_id = customer.add_customer(name, address, phone_number, email)
    return jsonify({'id': customer_id}), 201


@app.route('/customers/<int:id>', methods=['PUT'])
def update_customer(id):
    name = request.json.get('name')
    address = request.json.get('address')
    email = request.json.get('email')
    phone_number = request.json.get('phone_number')
    customer.update_customer(id, name, address, phone_number, email)
    return '', 204


@app.route('/customers/<int:id>', methods=['DELETE'])
def delete_customer(id):
    customer.delete_customer(id)
    return '', 204


@app.route('/customers/<int:id>', methods=['GET'])
def get_customer(id):
    result = customer.get_customer(id)
    if result is None:
        return '', 404
    else:
        return jsonify(result), 200


@app.route('/allcustomers', methods=['GET'])
def fetchAllCustomers():
    result = customer.get_all_customers()
    if result is None:
        return '', 404
    else:
        return jsonify(result), 200


if __name__ == '__main__':
    app.run(debug=True)
