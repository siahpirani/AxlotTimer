extends Control

var work_timer_passed: int = int(Stats.ReturnPromodoWorkTime())
var rest_timer_passed: int = int(Stats.ReturnPromodoRestTime())
var session_numbers_passed: int = int(Stats.ReturnPromodoSessionNumber())

@onready var work_timer_text = $WorkTimer
@onready var rest_timer_text = $"Rest Timer"
@onready var sessions_text = $Sessionnumber

var is_work_timer_active: bool = true
var current_timer: float = 0.0
var current_session: int = 1
var time_since_last_coin : float = 0 # new variable to track the time since a coin was given

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_timer = work_timer_passed
	update_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_timer > 0:
		current_timer -= delta
		time_since_last_coin += delta
		if time_since_last_coin >= 60:
			Stats.increment_coins(1)
			time_since_last_coin = 0
		update_ui()
	else:
		switch_timer()

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
		end_promodo_cycle()

	update_ui()

# End the Promodo cycle
func end_promodo_cycle() -> void:
	print("Promodo cycle complete!")
	current_timer = 0
	current_session = 1
	is_work_timer_active = true
	self.queue_free()
	get_tree().change_scene_to_file("res://MainScreen.tscn")
	#update_ui()

# Update UI labels
func update_ui() -> void:
	var hours = int(current_timer) / 3600
	var minutes = (int(current_timer) % 3600) / 60
	var seconds = int(current_timer) % 60

	if is_work_timer_active:
		work_timer_text.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
		rest_timer_text.text = ""  # Clear rest timer text
	else:
		rest_timer_text.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
		work_timer_text.text = ""  # Clear work timer text

	sessions_text.text = str(current_session) + "/" + str(session_numbers_passed)


func _on_end_promodo_pressed() -> void:
	self.queue_free()
	get_tree().change_scene_to_file("res://MainScreen.tscn")
