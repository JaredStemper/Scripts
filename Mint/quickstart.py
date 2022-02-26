import pickle
from googleapiclient.discovery import build

SPREADSHEET_ID = '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms' # Get this one from the link in browser
worksheet_name = 'Sheet2'
path_to_csv = 'New Folder/much_data.csv'
path_to_credentials = 'Credentials/token.pickle'


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
    with open(csv_path, 'r') as csv_file:
        csvContents = csv_file.read()
    body = {
        'requests': [{
            'pasteData': {
                "coordinate": {
                    "sheetId": sheet_id,
                    "rowIndex": "0",  # adapt this if you need different positioning
                    "columnIndex": "0", # adapt this if you need different positioning
                },
                "data": csvContents,
                "type": 'PASTE_NORMAL',
                "delimiter": ',',
            }
        }]
    }
    request = API.spreadsheets().batchUpdate(spreadsheetId=SPREADSHEET_ID, body=body)
    response = request.execute()
    return response


# upload
with open(path_to_credentials, 'rb') as token:
    credentials = pickle.load(token)

API = build('sheets', 'v4', credentials=credentials)

push_csv_to_gsheet(
    csv_path=path_to_csv,
    sheet_id=find_sheet_id_by_name(worksheet_name)
)




import gspread
from googleapiclient.discovery import build

import csv

# The ID of a sample document.
DOCUMENT_ID = '1HVFFG53488za0lrGzk0Z39pC2Y5h7ezJH7J3PLB2aeA'

def createInputSheet():
	headers = ["Date","Description","Original Description","Amount","Category","Account Name","Labels","Notes","Updated Amount"]
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

	"""NOTE on terminology
		worksheet
			single page spreadsheet or page in Excel, where you can write, edit and manipulate data
		spreadsheet
			the collection of such worksheets
	"""
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
	
	with open(csv_path, newline='') as f:
	reader = csv.reader(f)
	values = list(reader)
	response = service.spreadsheets().values().append(spreadsheetId=spreadsheetId, \
														valueInputOption='USER_ENTERED', \
														range="Sheet1", \
														body={"values": values}).execute()

	#Manipulate Mint data

	#Append Mint data (verify if page needs to be extended?)



if __name__ == '__main__':
	main()
