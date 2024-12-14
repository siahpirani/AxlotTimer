extends Node

# Constants for file paths
const COINS_SAVE_FILE_NAME : String = "/coins.json"

# Variables to store global timer data
var CountDownTime : int = 0
var PromodoWorkTime : int = 0
var PromodoRestTime : int = 0
var PromodoSessionNumber : int = 0
var CoinCount : int = 0      # Current count of coins
var coin_save_path : String # Path to save file for coins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Stats autoload initialized") # Add this line
	coin_save_path = OS.get_user_data_dir() + COINS_SAVE_FILE_NAME # Separate file for coins
	load_coin_count() # Load the coin count

# Functions for setting different timer values
func passtheCountdowntime(TimeDown: int) -> void:
	CountDownTime = TimeDown

func returncountdowntime() -> int:
	return CountDownTime

func PassThePromodo (WorkTime : int, RestTime : int, SessionNumber : int) -> void:
	PromodoWorkTime = WorkTime
	PromodoRestTime = RestTime
	PromodoSessionNumber = SessionNumber

func ReturnPromodoWorkTime () -> int:
	return PromodoWorkTime

func ReturnPromodoRestTime () -> int:
	return PromodoRestTime

func ReturnPromodoSessionNumber () -> int:
	return PromodoSessionNumber

# Function to add to the coin count
func increment_coins(amount: int) -> void:
	CoinCount += amount
	save_coin_count() # Save after modifying

# Function to get the current coin count
func get_coin_count() -> int:
	return CoinCount

# Save the current coin count to the file
func save_coin_count() -> void:
	var file = FileAccess.open(coin_save_path, FileAccess.WRITE)  # Open file for writing
	if file:
		var json_string : String = JSON.stringify(CoinCount)  # Convert CoinCount to string
		print("Saving coin data: ", CoinCount, " as json: ", json_string) # Log before storing
		file.store_string(json_string)  # Write JSON string to file
		file.close() # Close the file
		print("Coin data saved to: ", coin_save_path, "with value: ", CoinCount) # Log if everything is ok
	else:
		printerr("Error: Unable to open the file for saving coin count: ", coin_save_path) # Error if it can't open

# Loads the coin count from the file
func load_coin_count() -> void:
	print("Attempting to load coin data from:", coin_save_path) # Output log for start of function
	# Verify that file exists
	if not FileAccess.file_exists(coin_save_path):
		print("No existing coin data file found at:", coin_save_path)
		return  # If not, return

	var file = FileAccess.open(coin_save_path, FileAccess.READ) # open the file to read
	if file:
		print("File opened successfully for reading: ", coin_save_path)  # Log if the file was opened correctly
		var json_string : String = file.get_as_text() # Get all the string in the file
		file.close() # Close the file
		# parse the json
		var parsed_data = JSON.parse_string(json_string)

		# try to parse data into int, and update the variable, if not, log error
		if parsed_data != null:
			var parsed_int : int = int(parsed_data)
			CoinCount = parsed_int
			print("Coin data loaded from: ", coin_save_path,"with value: ", CoinCount ) # Log if parsed correctly
		else:
			printerr("Error: Unable to load coin count, parsed data is null")
	else:
		printerr("Error: Unable to open the file for loading coin count: ", coin_save_path) # error if the file could not be opened
