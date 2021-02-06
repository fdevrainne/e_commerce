import os
import pandas as pd, datetime as dt
import psycopg2
from psycopg2 import Error
from argparse import ArgumentParser


user = os.getenv('POSTGRES_USER')
password = os.getenv('POSTGRES_PASSWORD')
host = os.getenv('POSTGRES_HOST')
port = os.getenv('POSTGRES_PORT')
database = os.getenv('POSTGRES_DB')


def main():
	ap = ArgumentParser()
	ap.add_argument('date1',metavar='date1')
	args = ap.parse_args()

	default_date = (dt.datetime.now()- dt.timedelta(days=1)).date()
	date1 = (args.date1 or default_date)

	connection = psycopg2.connect(user=user,
	                              password=password,
	                              host=host,
	                              port=port,
	                              database=database)

	cursor = connection.cursor()

	query = f"""
		INSERT INTO e_commerce.customers_stats (customer_id, day, amount_spent, number_order)
		 SELECT
		 orders.customer_id,
		 '{date1}' AS day,
		 SUM(items.price) AS amount_spent,
		 COUNT(orders.order_status) AS number_order
		 FROM e_commerce.orders
		 LEFT JOIN e_commerce.items ON e_commerce.orders.id = e_commerce.items.order_id
		 WHERE CAST(order_purchase_timestamp AS DATE) = '{date1}'
		 GROUP BY orders.customer_id
		ON CONFLICT (customer_id, day) DO 
		UPDATE 
		SET number_order = EXCLUDED.number_order,
		    amount_spent = EXCLUDED.amount_spent
		;
		COMMIT;
				"""

	cursor.execute(query)

	cursor = connection.cursor()
	cursor.execute(f"""
		SELECT * 
		FROM  e_commerce.customers_stats 
		ORDER BY e_commerce.customers_stats.number_order 
		DESC LIMIT 10""")

	data = cursor.fetchall()
	cursor.close()

	df = pd.DataFrame(data, columns=["id","customer_id","day","amount_spent","number_order"])
	print(f"The ten top customers are :")
	print(df)
	print()

	cursor = connection.cursor()
	cursor.execute(f"""SELECT 
						COUNT(*) AS number_repeater,
						(SELECT COUNT(DISTINCT customers_stats.customer_id) FROM e_commerce.customers_stats) AS number_client
						FROM
						(
						SELECT customers_stats.customer_id, SUM(number_order) AS number_order
						FROM  e_commerce.customers_stats
						GROUP BY customers_stats.customer_id
						) whole_historic
						WHERE whole_historic.number_order>1;""")
	data = cursor.fetchall()
	df = pd.DataFrame(data, columns=["number_repeater","number_client"])
	print(df)

	cursor.close()


if __name__ == "__main__":
    main()
