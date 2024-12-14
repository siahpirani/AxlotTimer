extends Control

# Constants for time calculations
const SECONDS_IN_MINUTE : int = 60

@onready var CountDownText : Label = $CountDownText  # Reference to the countdown text label
var countdowntime : float = 0.0 # Remaining countdown time in seconds
var is_Countdown_paused : bool = false # Flag indicating if the countdown is paused
var time_since_last_coin : float = 0.0 # Track time since the last coin was earned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetTheTime()

# Get initial time from Stats singleton
func GetTheTime() -> void:
	if Stats != null:
		countdowntime = Stats.returncountdowntime()
	else:
		printerr("Error: Stats singleton is not available")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if countdown is paused
	if not is_Countdown_paused:
		# Only decrement if there is time left
		if countdowntime > 0:
			countdowntime -= delta  # Decrement the countdown time
			time_since_last_coin += delta # Accumulate time for coin rewards
			
			# Check if enough time has passed to award a coin
			if time_since_last_coin >= SECONDS_IN_MINUTE:
				_award_coin() # Award a coin
				time_since_last_coin = 0 # Reset timer for next coin
		else:
			countdowntime = 0 # Ensure that count down does not go into negative values
		update_CountDown_label() # Update the text label every frame

# Awards a coin and handles any potential errors
func _award_coin():
	if Stats != null:
		Stats.increment_coins(1)
	else:
		printerr("Error: Stats singleton is not available")


# Update the countdown timer label with the formatted time
func update_CountDown_label() -> void:
	# Convert the countdown time to an integer
	var total_seconds : int = int(countdowntime)
	
	# Calculate hours, minutes, and seconds
	var hours : int = total_seconds / 3600
	var minutes : int = (total_seconds % 3600) / 60
	var seconds : int = total_seconds % 60
	
	# Update the label with the formatted time
	CountDownText.text = "%02d:%02d:%02d" % [hours, minutes, seconds]


# Called when the pause/resume button is pressed
func _on_pause_resume_button_promodo_pressed() -> void:
	is_Countdown_paused = not is_Countdown_paused # Toggle pause state

# Called when the end button is pressed
func _on_end_button_countdown_pressed() -> void:
	queue_free() # Remove the scene form the scene tree
	# Change scene back to main screen
	if get_tree() != null:
		get_tree().change_scene_to_file("res://MainScreen.tscn")
	else:
		printerr("Error: Scene tree is not available")
