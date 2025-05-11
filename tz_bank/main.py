import pyodbc

server = "WIN-BJKDK2TGLP8\\SQLEXPRESS"
database = "TZ_Bank"

conn_str = (
    f'DRIVER={{ODBC Driver 18 for SQL Server}};'
    f'SERVER={server};'
    f'DATABASE={database};'
    f'Trusted_Connection=yes;'
    f'Encrypt=no;'
)

con = pyodbc.connect(conn_str)

cursor = con.cursor()

while True:
    main_option = input("Choose section:\nUsers -> 1\nTransactions -> 2\nOther -> 3\nQuit -> 4\n>>>")

    # users
    if main_option == '1':
        option = input("Choose:\nSee all users -> 1\nUsers that have been active for the last 30 days -> 2\nCheck the balance of a user -> 3\nControl the limit of users' cards -> 4\nIdentify VIP users (based on large transactions) -> 5\nList and monitor blocked users -> 6\nShow all cards for a user -> 7\nGive users special privileges (bonus or cashback) -> 8\n>>>")
        if option == '1':
            cursor.execute("select * from users")
            users = cursor.fetchall()
            print(users)
        elif option == '2':
            query = """
                SELECT * FROM users
                WHERE last_active_at >= DATEADD(DAY, -30, GETDATE());
            """
            cursor.execute(query)
            users = cursor.fetchall()
            print(users)
        elif option == '3':
            user_id = input('Enter the user id\n>>>')
            query = f"""
            SELECT id, total_balance 
            FROM users
            where id = {user_id}
            """ 
            cursor.execute(query)
            users = cursor.fetchall()
            print(users)
        elif option == '4':  # Identify VIP users (based on large transactions)
            query = """
                SELECT u.id, u.name, SUM(t.amount) as total_spent
                FROM users u
                JOIN cards c ON u.id = c.user_id
                JOIN transactions t ON c.id = t.from_card_id
                GROUP BY u.id, u.name
                HAVING SUM(t.amount) > 1000000000
            """
            cursor.execute(query)
            print("VIP Users:")
            print(cursor.fetchall())

        elif option == '5':  # Register new user and give welcome bonus
            name = input("Enter name: ")
            phone = input("Enter phone: ")
            email = input("Enter email: ")
            birthdate = input("Enter birthdate (YYYYMMDD): ")
            
            cursor.execute(f"""
                INSERT INTO users (name, phone_number, email, birthdate)
                VALUES (?, ?, ?, ?)""", (name, phone, email, birthdate))
            
            # get user_id of new user
            cursor.execute("SELECT SCOPE_IDENTITY()")
            user_id = cursor.fetchone()[0]

            # create card and give welcome bonus (e.g., 100_000)
            cursor.execute(f"""
                INSERT INTO cards (user_id, balance, is_blocked)
                VALUES (?, 100000, 0)
            """, (user_id,))
            con.commit()
            print("User registered with welcome bonus!")

        elif option == '6':  # List and monitor blocked users
            query = "SELECT * FROM users WHERE is_blocked = 1"
            cursor.execute(query)
            print("Blocked users:")
            print(cursor.fetchall())

        elif option == '7':  # Show all cards for a user
            user_id = input("Enter user ID: ")
            query = f"""
                SELECT * FROM cards
                WHERE user_id = {user_id}
            """
            cursor.execute(query)
            print(f"Cards for user {user_id}:")
            print(cursor.fetchall())

        elif option == '8':  # Give users special privileges (bonus or cashback)
            user_id = input("Enter user ID for cashback:\n>>> ")
            bonus_amount = int(input("Enter bonus amount:\n>>> "))
            cursor.execute(f"""
                UPDATE cards
                SET balance = balance + {bonus_amount}
                WHERE user_id = {user_id}
            """)
            con.commit()
            print(f"{bonus_amount} bonus added to user's cards.")
        else:
            print("invalid input")

    # Transactions

    elif main_option == '2':
        option = input("Choose:\nTransfer -> 1\n2) Daily/Weekly transactions -> 2\n3) Large transactions -> 3\n4) Withdraw/Deposit\n>>> ")

        if option == '1':
            from_card = input("From card ID: ")
            to_card = input("To card ID: ")
            amount = int(input("Amount to transfer: "))

            cursor.execute("SELECT balance FROM cards WHERE id = ?", (from_card,))
            result = cursor.fetchone()
            if result and result[0] >= amount:
                # Deduct from sender
                cursor.execute("UPDATE cards SET balance = balance - ? WHERE id = ?", (amount, from_card))
                # Add to receiver
                cursor.execute("UPDATE cards SET balance = balance + ? WHERE id = ?", (amount, to_card))
                # Record transaction
                cursor.execute("""
                    INSERT INTO transactions (from_card_id, to_card_id, amount, status, transaction_type, is_flagged)
                    VALUES (?, ?, ?, 'success', 'transfer', ?)
                """, (from_card, to_card, amount, amount > 150_000_000))
                con.commit()
                print("Transfer completed.")
            else:
                print("Insufficient funds.")

        elif option == '2':
            period = input("Enter period (daily/weekly): ").strip().lower()
            if period == 'daily':
                cursor.execute("""
                    SELECT * FROM transactions 
                    WHERE created_at >= DATEADD(DAY, -1, GETDATE())
                """)
            elif period == 'weekly':
                cursor.execute("""
                    SELECT * FROM transactions 
                    WHERE created_at >= DATEADD(DAY, -7, GETDATE())
                """)
            else:
                print("Invalid period")
            transactions = cursor.fetchall()
            print(transactions)

        elif option == '3':
            cursor.execute("""
                SELECT * FROM transactions 
                WHERE amount > 150000000
            """)
            flagged = cursor.fetchall()
            print(flagged)

        elif option == '4':
            action = input("Withdraw or Deposit? ").strip().lower()
            card_id = input("Enter card ID: ")
            amount = int(input("Enter amount: "))

            if action == "withdraw":
                cursor.execute("SELECT balance FROM cards WHERE id = ?", (card_id,))
                result = cursor.fetchone()
                if result and result[0] >= amount:
                    cursor.execute("UPDATE cards SET balance = balance - ? WHERE id = ?", (amount, card_id))
                    cursor.execute("""
                        INSERT INTO transactions (from_card_id, amount, status, transaction_type, is_flagged)
                        VALUES (?, ?, 'success', 'withdrawal', ?)
                    """, (card_id, amount, amount > 150_000_000))
                    con.commit()
                    print("Withdrawal successful.")
                else:
                    print("Insufficient funds.")
            elif action == "deposit":
                cursor.execute("UPDATE cards SET balance = balance + ? WHERE id = ?", (amount, card_id))
                cursor.execute("""
                    INSERT INTO transactions (to_card_id, amount, status, transaction_type, is_flagged)
                    VALUES (?, ?, 'success', 'deposit', ?)
                """, (card_id, amount, amount > 150_000_000))
                con.commit()
                print("Deposit successful.")
            else:
                print("Invalid action.")

    if main_option == '3':
        option = input("Choose:\nDaily, weekly, monthly reports -> 1\nMonitor blocked and flagged cards -> 2\nView user's transaction history ->3\nBalance analysis -> 4\nSum of all balances of bank -> 5\n>>>")
        if option == '1':  # Daily, weekly, monthly reports
            period = input("Choose report type (daily/weekly/monthly):\n>>> ").lower()
            if period == 'daily':
                query = "SELECT * FROM transactions WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)"
            elif period == 'weekly':
                query = "SELECT * FROM transactions WHERE created_at >= DATEADD(DAY, -7, GETDATE())"
            elif period == 'monthly':
                query = "SELECT * FROM transactions WHERE created_at >= DATEADD(MONTH, -1, GETDATE())"
            else:
                print("Invalid period.")
                query = None
            if query:
                cursor.execute(query)
                print(cursor.fetchall())

        elif option == '2':  # Monitor blocked and flagged cards
            query = """
                SELECT * FROM cards WHERE is_blocked = 1
                UNION
                SELECT c.* FROM cards c
                JOIN transactions t ON c.id = t.from_card_id OR c.id = t.to_card_id
                WHERE t.is_flagged = 1
            """
            cursor.execute(query)
            print(cursor.fetchall())

        elif option == '3':  # View user's transaction history
            user_id = input("Enter user ID:\n>>> ")
            query = f"""
                SELECT * FROM transactions
                WHERE from_card_id IN (SELECT id FROM cards WHERE user_id = {user_id})
                OR to_card_id IN (SELECT id FROM cards WHERE user_id = {user_id})
                ORDER BY created_at DESC
            """
            cursor.execute(query)
            print(cursor.fetchall())

        elif option == '4':  # Balance analysis
            query_avg = "SELECT AVG(total_balance) AS average_balance FROM users"
            cursor.execute(query_avg)
            print("Average Balance:", cursor.fetchone()[0])

            query_top = """
                SELECT TOP 1 u.id, u.name, COUNT(t.id) AS tx_count FROM users u
                JOIN cards c ON u.id = c.user_id
                JOIN transactions t ON c.id = t.from_card_id OR c.id = t.to_card_id
                GROUP BY u.id, u.name
                ORDER BY tx_count DESC
            """
            cursor.execute(query_top)
            print("Top user by transaction count:", cursor.fetchone())
        elif option == '5':
            query = "SELECT SUM(balance) AS total_balance FROM cards;"
            cursor.execute(query)
            print(f"Sum of all balances of bank: {cursor.fetchone()}")
        else:
            print("Invalid input!")
    elif main_option == '4':
        break
    else:
        print("Invalid input!")
