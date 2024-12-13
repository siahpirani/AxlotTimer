extends Control

var is_StopWatch_Running: bool = false
var total_seconds: int = 60
var is_CountDown_Running: bool = false
var is_Promodo_Running: bool = false
var is_StopWatch_Paused: bool = false  # New variable to track if stopwatch is paused

var PromodoWorkTimer = 600
var PromodoRestTimer = 300
var PromodoSessionNumbers = 1
@onready var CountDown_Text = $TimerTyperButtonConrainer/CountdownButton/Panle_CountDown/Label_CountDown

@onready var stopwatchpanel = $TimerTyperButtonConrainer/StopWatchButton/Panle_StopWatch
@onready var countdownpanel = $TimerTyperButtonConrainer/CountdownButton/Panle_CountDown
@onready var promodopanel = $TimerTyperButtonConrainer/PromodoButton/Panle_Promodo

@onready var PromodoWorkSlide = $TimerTyperButtonConrainer/PromodoButton/Panle_Promodo/HSlider_Work_Promodo
@onready var PromodoRestSlide = $TimerTyperButtonConrainer/PromodoButton/Panle_Promodo/HSlider_Rest_Promodo2
@onready var PromodoSessionNumberSlide = $TimerTyperButtonConrainer/PromodoButton/Panle_Promodo/HSlider_Sessions_Promodo

@onready var PromodoWorkText =$TimerTyperButtonConrainer/PromodoButton/Panle_Promodo/Label_Work_Promodo
@onready var PromodoRestText =$TimerTyperButtonConrainer/PromodoButton/Panle_Promodo/Label_Rest_Promodo
@onready var PromodoSessionNumber =$TimerTyperButtonConrainer/PromodoButton/Panle_Promodo/Label_sessions_Promodo
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Placeholder for future code if needed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_end_button_stop_watch_pressed() -> void:
	var stopwatchscenechild = preload("res://StopWatch/StopWatchScene.tscn").instantiate()
	$".".add_child(stopwatchscenechild)
	#get_tree().change_scene_to_file("res://StopWatch/StopWatchScene.tscn")

func _on_h_slider_count_down_value_changed(value: float) -> void:
	total_seconds = int(value)
	
	# Calculate hours, minutes, and seconds
	var hours = total_seconds / 3600  # 3600 seconds in an hour
	var minutes = (total_seconds % 3600) / 60  # Remaining minutes
	var seconds = total_seconds % 60  # Remaining seconds
	
	# Update the label with the formatted time
	CountDown_Text.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
func _on_start_end_button_count_down_pressed() -> void:
	Stats.passtheCountdowntime(total_seconds)
	var CoundDownSceneChild = preload("res://CountDown/CountDown_Scene.tscn").instantiate()
	$".".add_child(CoundDownSceneChild)

func _on_stop_watch_button_pressed() -> void:
	countdownpanel.visible = false
	promodopanel.visible =false
	stopwatchpanel.visible = true

func _on_countdown_button_pressed() -> void:
	countdownpanel.visible = true
	promodopanel.visible =false
	stopwatchpanel.visible = false

func _on_promodo_button_pressed() -> void:
	countdownpanel.visible = false
	promodopanel.visible =true
	stopwatchpanel.visible = false

func _on_start_end_button_promodo_pressed() -> void:
	Stats.PassThePromodo(PromodoWorkTimer,PromodoRestTimer,PromodoSessionNumbers)
	var PromodoSceneChild = preload("res://Promodo/PromodoFullScreen.tscn").instantiate()
	$".".add_child(PromodoSceneChild)


func _on_h_slider_work_promodo_value_changed(value: float) -> void:
	PromodoWorkTimer = int(value)
	
	# Calculate hours, minutes, and seconds
	var hours = PromodoWorkTimer / 3600  # 3600 seconds in an hour
	var minutes = (PromodoWorkTimer % 3600) / 60  # Remaining minutes
	var seconds = PromodoWorkTimer % 60  # Remaining seconds
	
	# Update the label with the formatted time
	PromodoWorkText.text = "%02d:%02d:%02d" % [hours, minutes, seconds]


func _on_h_slider_rest_promodo_2_value_changed(value: float) -> void:
	PromodoRestTimer = int(value)
	
	# Calculate hours, minutes, and seconds
	var hours = PromodoRestTimer / 3600  # 3600 seconds in an hour
	var minutes = (PromodoRestTimer % 3600) / 60  # Remaining minutes
	var seconds = PromodoRestTimer % 60  # Remaining seconds
	
	# Update the label with the formatted time
	PromodoRestText.text = "%02d:%02d:%02d" % [hours, minutes, seconds]


func _on_h_slider_sessions_promodo_value_changed(value: int) -> void:
	PromodoSessionNumbers = int(value)
	PromodoSessionNumber.text = str(value)
