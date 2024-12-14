extends Control

var is_StopWatch_Running: bool = true
var StopWatch_Time: float = 0.0  # Ensure it's a float
var is_StopWatch_Paused: bool = false  # New variable to track if stopwatch is paused
var time_since_last_coin : float = 0 # new variable to track the time since a coin was given

@onready var StopWatch_Label = $Label_StopWatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Placeholder for future code if needed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_StopWatch_Running and not is_StopWatch_Paused:
		StopWatch_Time += delta  # Increment stopwatch time if not paused
		time_since_last_coin += delta
		if time_since_last_coin >= 60:
			Stats.increment_coins(1)
			time_since_last_coin = 0
		update_stopwatch_label()  # Update the label display

# Function to update the stopwatch label
func update_stopwatch_label() -> void:
	# Convert stopwatch time to an integer for modulus operation
	var total_seconds = int(StopWatch_Time)
	
	# Calculate hours, minutes, and seconds
	var hours = total_seconds / 3600  # 3600 seconds in an hour
	var minutes = (total_seconds % 3600) / 60  # Remaining minutes
	var seconds = total_seconds % 60  # Remaining seconds
	
	# Update the label with the formatted time
	StopWatch_Label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

# Function to start/stop the stopwatch
func _on_start_end_button_stop_watch_pressed() -> void:
	self.queue_free()
	get_tree().change_scene_to_file("res://MainScreen.tscn")
# Function to pause/unpause the stopwatch
func _on_pause_resume_button_stop_watch_2_pressed() -> void:
	if is_StopWatch_Running:
		is_StopWatch_Paused = not is_StopWatch_Paused  # Toggle pause state

# Function to switch scenes
