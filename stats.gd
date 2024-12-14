extends Node

var CountDownTime = 0
var PromodoWorkTime = 0
var PromodoRestTime = 0
var PromodoSessionNumber = 0
var CoinCount : int = 0
var coin_save_path : String = ""

func _ready() -> void:
	print("Stats autoload initialized") # Add this line
	coin_save_path = OS.get_user_data_dir() + "/coins.json" # Separate file for coins
	load_coin_count()

func passtheCountdowntime(TimeDown):
	CountDownTime = TimeDown
func returncountdowntime() :
	return CountDownTime
func PassThePromodo (WorkTime , RestTime , SessionNumber):
	PromodoWorkTime =WorkTime
	PromodoRestTime=RestTime
	PromodoSessionNumber=SessionNumber
func ReturnPromodoWorkTime ():
	return PromodoWorkTime
func ReturnPromodoRestTime ():
	return PromodoRestTime
func ReturnPromodoSessionNumber ():
	return PromodoSessionNumber

func increment_coins(amount: int) -> void:
	CoinCount += amount
	save_coin_count()

func get_coin_count() -> int:
	return CoinCount

func save_coin_count():
	var file = FileAccess.open(coin_save_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(CoinCount)
		print("Saving coin data: ", CoinCount, " as json: ", json_string) # Log before storing
		file.store_string(json_string)
		file.close()
		print("Coin data saved to: ", coin_save_path, "with value: ", CoinCount)
	else:
		printerr("Error: Unable to open the file for saving coin count: ", coin_save_path)

func load_coin_count():
	print("Attempting to load coin data from:", coin_save_path)
	if not FileAccess.file_exists(coin_save_path):
		print("No existing coin data file found at:", coin_save_path)
		return  # No file, just do nothing

	var file = FileAccess.open(coin_save_path, FileAccess.READ)
	if file:
		print("File opened successfully for reading: ", coin_save_path) # Log before reading
		var json_string = file.get_as_text()
		file.close()

		var parsed_data = JSON.parse_string(json_string)
		
		if parsed_data != null:
			var parsed_int : int = int(parsed_data)
			CoinCount = parsed_int
			print("Coin data loaded from: ", coin_save_path,"with value: ", CoinCount ) # add this line
		else:
			printerr("Error: Unable to load coin count, parsed data is null")
	else:
		printerr("Error: Unable to open the file for loading coin count: ", coin_save_path)
