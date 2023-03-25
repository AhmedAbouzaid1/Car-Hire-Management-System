class Customer:
    def __init__(self, db_connector):
        self.db_connector = db_connector

    def add_customer(self, name, address, phone_number, email):
        query = "INSERT INTO customer (name, address, phone_number, email) VALUES (%s, %s, %s, %s)"
        params = (name, address, phone_number, email)
        return self.db_connector.execute_query(query, params)

    def update_customer(self, id, name=None, address=None, phone_number=None, email=None):
        query = "UPDATE customer SET "
        params = []
        if name is not None:
            query += "name = %s, "
            params.append(name)
        if address is not None:
            query += "address = %s, "
            params.append(address)
        if phone_number is not None:
            query += "phone_number = %s, "
            params.append(phone_number)
        if email is not None:
            query += "email = %s, "
            params.append(email)

        query = query[:-2]
        query += " WHERE customer_id = %s"
        params.append(id)
        self.db_connector.execute_query(query, params)

    def delete_customer(self, id):
        query = "DELETE FROM customer WHERE customer_id = %s"
        params = (id,)
        self.db_connector.execute_query(query, params)

    def get_customer(self, id):
        query = "SELECT * FROM customer WHERE customer_id = %s"
        params = (id,)
        result = self.db_connector.execute_select_query(query, params)
        if len(result) > 0:
            return result
        else:
            return None

    def get_all_customers(self):
        query = "SELECT * FROM customer"
        result = self.db_connector.execute_select_query(query)
        if len(result) > 0:
            return result
        else:
            return None
