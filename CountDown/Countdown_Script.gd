extends Control
@onready var CountDownText = $CountDownText
var countdowntime = 0
var is_Countdown_paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetTheTime()

func GetTheTime():
	countdowntime = Stats.returncountdowntime()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_Countdown_paused:
		countdowntime -= delta  # Increment stopwatch time if not paused
		update_CountDown_label()

func update_CountDown_label() -> void:
	# Convert stopwatch time to an integer for modulus operation
	var total_seconds = int(countdowntime)
	
	# Calculate hours, minutes, and seconds
	var hours = total_seconds / 3600  # 3600 seconds in an hour
	var minutes = (total_seconds % 3600) / 60  # Remaining minutes
	var seconds = total_seconds % 60  # Remaining seconds
	
	# Update the label with the formatted time
	CountDownText.text = "%02d:%02d:%02d" % [hours, minutes, seconds]


func _on_pause_resume_button_promodo_pressed() -> void:
	is_Countdown_paused = not is_Countdown_paused
	

func _on_end_button_countdown_pressed() -> void:
	self.queue_free()
	get_tree().change_scene_to_file("res://MainScreen.tscn")
