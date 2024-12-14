extends Control

# Constants for time calculations
const SECONDS_IN_MINUTE : int = 60
const SECONDS_IN_HOUR : int = 3600

# Flags to control the stopwatch
var is_StopWatch_Running: bool = true
var is_StopWatch_Paused: bool = false  # Flag to track if the stopwatch is paused
# Timers
var StopWatch_Time: float = 0.0  # Elapsed time in seconds
var time_since_last_coin : float = 0 # track time since coin awarded

# References to UI elements
@onready var StopWatch_Label : Label = $Label_StopWatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Placeholder

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_StopWatch_Running and not is_StopWatch_Paused:
		StopWatch_Time += delta  # Increment stopwatch time if not paused
		time_since_last_coin += delta
		if time_since_last_coin >= SECONDS_IN_MINUTE:
			_award_coin() # Awards a coin
			time_since_last_coin = 0
		update_stopwatch_label()  # Update the label display

# Awards a coin and handles any potential errors
func _award_coin() -> void:
	if Stats != null:
		Stats.increment_coins(1)
	else:
		printerr("Error: Stats singleton is not available")

# Update the stopwatch label
func update_stopwatch_label() -> void:
	# Convert stopwatch time to an integer for modulus operation
	var total_seconds : int = int(StopWatch_Time)
	
	# Calculate hours, minutes, and seconds
	var hours : int = total_seconds / SECONDS_IN_HOUR
	var minutes : int = (total_seconds % SECONDS_IN_HOUR) / SECONDS_IN_MINUTE
	var seconds : int = total_seconds % SECONDS_IN_MINUTE
	
	# Update the label with the formatted time
	StopWatch_Label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

# Function to start/stop the stopwatch
func _on_start_end_button_stop_watch_pressed() -> void:
	queue_free()
	if get_tree() != null:
		get_tree().change_scene_to_file("res://MainScreen.tscn") # return to main scene
	else:
		printerr("Error: Scene tree is not available")

# Function to pause/unpause the stopwatch
func _on_pause_resume_button_stop_watch_2_pressed() -> void:
	if is_StopWatch_Running:
		is_StopWatch_Paused = not is_StopWatch_Paused  # Toggle pause state
