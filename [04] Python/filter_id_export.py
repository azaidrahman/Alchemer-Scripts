import pandas as pd
import tkinter as tk
from tkinter import filedialog
import openpyxl
import os

print("Please select main files")
# prompt user to select Excel file
root = tk.Tk()
root.withdraw()
file_path = filedialog.askopenfilename()

# read Excel file into a pandas DataFrame
try:
    df = pd.read_excel(file_path, engine='openpyxl', sheet_name='Main')
except Exception as e:
    print('Error reading Excel file:', e)
    exit()

# prompt user to select the file containing the IDs to match
print("Please select ID File")
root = tk.Tk()
root.withdraw()
id_file = filedialog.askopenfilename()

# print("id File:")
# print(id_file)

# read the ID file contents into a list, skipping empty lines
with open(id_file, 'r') as f:
    id_list = [line.strip() for line in f.readlines() if line.strip()]

# print(id_list)
# filter the data by ID and status
# status = 'Complete'
# filtered_df = df[df['BRID'].isin(id_list) & (df['Status'] == status)]
filtered_df = df[df['BRID'].isin(id_list)]

print(filtered_df)

if filtered_df.empty:
    print('No matching rows found.')
    exit()

dir_path = os.path.dirname(file_path)

# prompt user to enter a name for the new sheet
sheet_name = input('Enter a name for the new sheet: ')
output_path = os.path.join(dir_path, f'{sheet_name}.xlsx')


# write the filtered data to a new sheet in the Excel file
try:
    filtered_df.to_excel(output_path, index=False)
except Exception as e:
    print('Error writing filtered data to Excel file:', e)
