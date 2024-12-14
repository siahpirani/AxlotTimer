extends Control

# Constants for time calculations
const SECONDS_IN_MINUTE : int = 60
const SECONDS_IN_HOUR : int = 3600

# Variables to store timer durations and session numbers
var work_timer_passed: int = int(Stats.ReturnPromodoWorkTime())
var rest_timer_passed: int = int(Stats.ReturnPromodoRestTime())
var session_numbers_passed: int = int(Stats.ReturnPromodoSessionNumber())

# References to UI elements
@onready var work_timer_text : Label = $WorkTimer
@onready var rest_timer_text : Label = $"Rest Timer"
@onready var sessions_text : Label = $Sessionnumber

# Variables to manage timer state and session progress
var is_work_timer_active: bool = true  # Flag if the work timer is running
var current_timer: float = 0.0       # Current timer value in seconds
var current_session: int = 1         # Current session number
var time_since_last_coin : float = 0 # Track time since last coin was rewarded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_timer = work_timer_passed # Set current time to initial value from stats
	update_ui() # Update the ui

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_timer > 0:
		current_timer -= delta # Decrease the timer if is active
		time_since_last_coin += delta # accumulate the time
		if time_since_last_coin >= SECONDS_IN_MINUTE:
			_award_coin() # Award a coin
			time_since_last_coin = 0
		update_ui() # Update the ui
	else:
		switch_timer() # If timer reaches zero, switch to other timer

# Awards a coin and handles any potential errors
func _award_coin() -> void:
	if Stats != null:
		Stats.increment_coins(1)
	else:
		printerr("Error: Stats singleton is not available")

# Switch between work and rest timers
func switch_timer() -> void:
	if is_work_timer_active:
		is_work_timer_active = false
		current_timer = rest_timer_passed
	else:
		is_work_timer_active = true
		current_session += 1
		current_timer = work_timer_passed

	if current_session > session_numbers_passed:
		end_promodo_cycle() # If session is over, end the pomodoro cycle

	update_ui() # update the ui with new value

# Ends the Promodo cycle and return back to main screen
func end_promodo_cycle() -> void:
	print("Promodo cycle complete!")
	current_timer = 0 # reset current time
	current_session = 1 # reset current session
	is_work_timer_active = true # set work timer to active
	queue_free() # remove scene from scene tree
	if get_tree() != null:
		get_tree().change_scene_to_file("res://MainScreen.tscn") # change back to main screen
	else:
		printerr("Error: Scene tree is not available") # Log any errors

# Updates the UI of the labels
func update_ui() -> void:
	# Calculate hours, minutes and seconds
	var hours : int = int(current_timer) / SECONDS_IN_HOUR
	var minutes : int = (int(current_timer) % SECONDS_IN_HOUR) / SECONDS_IN_MINUTE
	var seconds : int = int(current_timer) % SECONDS_IN_MINUTE

	# Check if it is work time, or rest time, and update text
	if is_work_timer_active:
		work_timer_text.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
		rest_timer_text.text = ""  # Clear rest timer text
	else:
		rest_timer_text.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
		work_timer_text.text = ""  # Clear work timer text

	sessions_text.text = str(current_session) + "/" + str(session_numbers_passed) # update session text


# Called when the end button is pressed
func _on_end_promodo_pressed() -> void:
	queue_free() # Remove scene from the tree
	if get_tree() != null:
		get_tree().change_scene_to_file("res://MainScreen.tscn")  # Change the scene back to main
	else:
		printerr("Error: Scene tree is not available")  # Log any errors
