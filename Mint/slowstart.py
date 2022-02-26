"""
import csv

import pickle
from googleapiclient.discovery import build

# The ID of a sample document.
SPREADSHEET_ID = '1HVFFG53488za0lrGzk0Z39pC2Y5h7ezJH7J3PLB2aeA'
worksheet_name = 'Mint Input'
path_to_csv = '/home/jared/virtboxVMs/vbox memory/window/gsheets/transactions.csv'
path_to_credentials = '/home/jared/virtboxVMs/vbox memory/window/gsheets/credentials.json'


# convenience routines
def find_sheet_id_by_name(sheet_name):
    # ugly, but works
    sheets_with_properties = API \
        .spreadsheets() \
        .get(spreadsheetId=SPREADSHEET_ID, fields='sheets.properties') \
        .execute() \
        .get('sheets')

    for sheet in sheets_with_properties:
        if 'title' in sheet['properties'].keys():
            if sheet['properties']['title'] == sheet_name:
                return sheet['properties']['sheetId']


def push_csv_to_gsheet(csv_path, sheet_id):
    creds = service_account.Credentials.from_service_account_file(self.SERVICE_ACCOUNT_FILE, scopes=self.SCOPES)

    service = build('sheets', 'v4', credentials=creds)
    
    # Insert CSV information into Google Sheet
    sheet = service.spreadsheets()
                        

    csv_path = ""
    csv_files = os.listdir(self.DOWNLOADS_PATH)
    for csv_file in csv_files:
        if csv_file.startswith("lead_export"):
            print("CSV path found")
            csv_path = os.path.join(self.DOWNLOADS_PATH, csv_file)
            print(f'CSV_PATH: {csv_path}')

    if csv_path == "":
        print("No CSV file detected. Must not have downloaded. Please try again.")
    else:
        #add email and owner
        values = (
            (owner, email),
        )
        value_range_body = {
            'majorDimension': 'ROWS',
            'values': values
        }
        service.spreadsheets().values().append(spreadsheetId=self.DATA_SPREADSHEET_ID, 
            valueInputOption='USER_ENTERED',
            range="Sheet1!A1",
            body=value_range_body).execute()

        #add CSV to Google Sheets
        print(f'Attempting to upload CSV file for {email}')
		with open(csv_path, newline='') as f:
			reader = csv.reader(f)
			values = list(reader)
			response = service.spreadsheets().values().append(spreadsheetId=spreadsheetId, \
																valueInputOption='USER_ENTERED', \
																range="Sheet1", \
																body={"values": values}).execute()

        print(f'Deleting CSV file for {email} account')
        deleted = self.removeCSV()
        if deleted == 0:
            print(f'No CSV files detected for {email}')
        else:
            print(f'{deleted} CSV files deleted for {email}.')

        return response


# upload
with open(path_to_credentials, 'rb') as token:
    credentials = pickle.load(token)

API = build('sheets', 'v4', credentials=credentials)

push_csv_to_gsheet(
    csv_path=path_to_csv,
    sheet_id=find_sheet_id_by_name(worksheet_name)
)


###########################################################################################
###########################################################################################
###########################################################################################



def createInputSheet():
	headers = ["Date","Description","Original Description","Amount","Transaction Type","Category","Account Name","Labels","Notes","Updated Amount"]
	ws = ss.add_worksheet(title="Mint Input", rows="1000", cols=len(headers))

	for i in range(1,len(headers)+1):
		ws.update_cell(1, i, headers[i-1])
	ws.format('A1:H1', {'textFormat': {'bold': True}})
	
	return ws

def main():
	creds = service_account.Credentials.from_service_account_file(
	self.SERVICE_ACCOUNT_FILE, scopes=self.SCOPES)

	service = build('sheets', 'v4', credentials=creds)

	# Insert CSV information into Google Sheet
	sheet = service.spreadsheets()

	gc = gspread.service_account(filename='/home/jared/virtboxVMs/vbox memory/window/gsheets/credentials.json')

	#NOTE: file cannot be an xslx from excel, must be a google sheet (can convert easily)
	#NOTE: spreadsheet is full sheet; worksheet is singular page

	""NOTE on terminology
		worksheet
			single page spreadsheet or page in Excel, where you can write, edit and manipulate data
		spreadsheet
			the collection of such worksheets
	""
	ss = gc.open_by_key(DOCUMENT_ID)
	try:
		ws = ss.worksheet("Mint Input")
	#if worksheet doesn't exist, create it with appropriate headers
	except gspread.exceptions.WorksheetNotFound: 
		ws = createInputSheet()

	#Grab Mint data (options to use CSV file locally or to automatically grab using REST API)
	#local CSV route
	mintData = []
	#append extra value at end that is based on debit/credit (e.g. index 3 for value and index 4 for type)
	with open('transactions.csv', 'r') as f:
		reader = list(csv.reader(f))[1:] #modify to list and remove header
		for row in reader:
			amount = float(row[3])
			creditType = row[4]
	
			if creditType == "credit":
				row.append(str(amount))
			else:
				row.append(str(-amount))

	reader = list(reader)
	
	for row in reader:
		print(row)
	

	#Manipulate Mint data

	#Append Mint data (verify if page needs to be extended?)
"""

import csv
from apiclient import discovery
from google.oauth2 import service_account

"""
TODOs:
	clean up file
		remove old chunks above
		consider splicing the other gspread tool for ease of creating/managing pages and data
			use gspread for sake of ease when manipulating?
	begin researching using Mint's REST API to get the CSV

"""
def appendCSV(SPREADSHEET_ID,rangeName,csvPath,service):
	with open(csvPath, newline='') as f:
		reader = csv.reader(f)
		next(reader)
		values = list(reader)

	service.spreadsheets().values().append(spreadsheetId=SPREADSHEET_ID, body={"values": values}, range=rangeName, valueInputOption='USER_ENTERED').execute()

	return 1

def main():
	credentialsPath = '/home/jared/virtboxVMs/vbox memory/window/gsheets/credentials.json'
	scope = "https://www.googleapis.com/auth/drive","https://www.googleapis.com/auth/spreadsheets","https://www.googleapis.com/auth/drive.file",

	#authorize
	try:
		credentials = service_account.Credentials.from_service_account_file(credentialsPath,scopes=scope)
		service = discovery.build('sheets','v4',credentials=credentials)
	except OSError as e:
		print(e)

	SPREADSHEET_ID = '1HVFFG53488za0lrGzk0Z39pC2Y5h7ezJH7J3PLB2aeA'
	rangeName = 'Mint Input'

	#if worksheet doesn't exist, create it with appropriate headers
	SPREADSHEET_ID = '1HVFFG53488za0lrGzk0Z39pC2Y5h7ezJH7J3PLB2aeA'
	worksheetName = 'Mint Input'
	rangeName = 'Mint Input'
	csvPath = '/home/jared/virtboxVMs/vbox memory/window/gsheets/transactions.csv'
	appendCSV(SPREADSHEET_ID,rangeName,csvPath,service)



if __name__ == '__main__':
	main()
