# Import necessary libraries
import os
import pandas as pd
import requests
from sqlalchemy import create_engine, text

# Get password from environment variable
password = os.getenv('POSTGRES_PASS')
port = os.getenv('POSTGRES_PORT')
sumup_key = os.getenv('sumup_api')  # SumUp API key
# Set up database connection
engine = create_engine(f'postgresql://postgres:{password}@localhost:{port}/postgres')

# Define function to fetch data from SumUp
def fetch_transactions_from_sumup():
    url = "https://api.sumup.com/v0.1/me/transactions/history"
    headers = {"Authorization": f"Bearer {sumup_key}"}

    params = {'limit': 100000} 
    response = requests.get(url, headers=headers, params=params)
    current_page_transactions = response.json()['items']

    return current_page_transactions

def convert_to_dataframe(data):
    for item in data:
        for key, value in item.items():
            if value is not None:
                item[key] = str(value)
    df = pd.DataFrame(data)
    return df

# Define function to load data into PostgreSQL
def load_data_into_postgres(df, table_name, schema_name):
    with engine.begin() as connection:
        connection.execute(text(f"DROP TABLE IF EXISTS {schema_name}.{table_name} CASCADE"))
    df.to_sql(table_name, engine, if_exists='replace', schema=schema_name, index=False)

# Fetch data from SumUp
sumup_transactions = fetch_transactions_from_sumup()

# Convert SumUp data to DataFrame
df = convert_to_dataframe(sumup_transactions)

# Load data into PostgreSQL
load_data_into_postgres(df, 'sumup_transactions','landing_python')

# Close database connection
engine.dispose()