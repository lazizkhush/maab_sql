import pyodbc

con_str = "DRIVER={SQL SERVER}; SERVER=WIN-BJKDK2TGLP8\\SQLEXPRESS; DATABASE=lesson2; Trusted_Connection=yes;"

con = pyodbc.connect(con_str)
cursor = con.cursor()

cursor.execute("SELECT * FROM photos")

data = cursor.fetchone()


with open("image.png", 'wb') as file:
    file.write(data[1])
