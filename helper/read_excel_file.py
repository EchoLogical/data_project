import pandas as pd

# Specify the file path
file_path = "..\\files\\ecommerce_needs_discovery.xlsx"

# Membaca sheet tertentu
df = pd.read_excel(file_path, sheet_name='Sheet1')

# Display data
print(df.to_string(index=False))  # Tanpa index