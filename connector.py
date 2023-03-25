import mysql.connector


class DBConnector:
    def __init__(self, db_host, db_user, db_password, db_name):
        self.conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        self.cursor = self.conn.cursor()

    def execute_query(self, query, params=None):
        self.cursor.execute(query, params)
        self.conn.commit()
        return self.cursor.lastrowid

    def execute_select_query(self, query, params=None):
        self.cursor.execute(query, params)
        return self.cursor.fetchall()
