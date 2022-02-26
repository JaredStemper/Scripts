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
