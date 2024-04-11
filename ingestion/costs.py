import pandas as pd
import requests
import os
from sqlalchemy import create_engine, text

# Download the Excel file from OneDrive
url = "https://1drv.ms/x/s!An8HNhKkGk3Z3yot2ihn8-ctrOXM?download=1"
response = requests.get(url)
with open('20231218report.xlsx', 'wb') as output:
    output.write(response.content)

# Read the Excel file into a DataFrame
df = pd.read_excel('20231218report.xlsx', engine='openpyxl')


# Connect to your database
password = os.getenv('POSTGRES_PASS')
port = os.getenv('POSTGRES_PORT')

# Set up database connection
engine = create_engine(f'postgresql://postgres:{password}@localhost:{port}/postgres')

# Write the DataFrame to your database
df.to_sql('table_name', engine, if_exists='append', index=False)