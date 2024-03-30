# Import necessary libraries
import os
import stripe
import pandas as pd
from sqlalchemy import create_engine

# Get password from environment variable
password = os.getenv('POSTGRES_PASS')
port = os.getenv('POSTGRES_PORT')
stripe.api_key = os.getenv('injestion_key')
# Set up database connection
engine = create_engine(f'postgresql://postgres:{password}@localhost:{port}/postgres')

# Define function to fetch data from Stripe
def fetch_sessions_from_stripe():
    sessions = []
    last_id = None
    while True:
        current_page = stripe.checkout.Session.list(limit=100, starting_after=last_id)
        if len(current_page.data) == 0:
            break
        sessions.extend(current_page.data)
        last_id = current_page.data[-1].id
    return sessions

def convert_to_dataframe(data):
    for item in data:
        for key, value in item.items():
            if value is not None:
                item[key] = str(value)
    df = pd.DataFrame(data)
    return df
# Define function to load data into PostgreSQL
def load_data_into_postgres(df, table_name, schema_name):
    df.to_sql(table_name, engine, if_exists='replace', schema=schema_name)

# Fetch data from Stripe
stripe_sessions = fetch_sessions_from_stripe()

# Convert Stripe data to DataFrame
df = convert_to_dataframe(stripe_sessions)

# Load data into PostgreSQL
load_data_into_postgres(df, 'stripe_sessions','landing_python')

# Close database connection
engine.dispose()