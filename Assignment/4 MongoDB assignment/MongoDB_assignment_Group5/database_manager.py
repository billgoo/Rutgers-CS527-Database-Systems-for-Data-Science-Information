# -- encoding: utf-8 --

"""
@author: Yan Gu
@Date:
"""

import mysql.connector


class DatabaseManager(object):
    """
    docstring
    """
    conn = None
    cursor = None

    def __init__(self):
        """
        docstring
        """
        self.connect()
        return

    def connect(self):
        """
        docstring
        """
        self.conn = mysql.connector.connect(
            host = "cs527project1group5.cnpt9dsbfddc.us-east-1.rds.amazonaws.com",
            port = 3306,
            user = "admin",
            password = "cs527project1",
            database = "instacart"
        )
        self.cursor = self.conn.cursor(dictionary=True)
        return
