extends Control

var Is_TimerTab_Open: bool = false
var Is_GoalsTab_Open: bool = false

var TimerScene: PackedScene = preload("res://TimerTab.tscn")  # Store the PackedScene
var TimerPannle: Node = null # Reference to the instance

var GoalsScene: PackedScene = preload("res://Goals Pannle/GoalScene.tscn")
var GoalsSceneNode: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Placeholder for future code if needed.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timers_pannle_button_pressed() -> void:
	if Is_TimerTab_Open:
		# Close and free the TimerPannle
		if TimerPannle != null:
			TimerPannle.queue_free()
			TimerPannle = null
		Is_TimerTab_Open = false
	else:
		# Close Goals panel if open
		if Is_GoalsTab_Open:
			GoalsSceneNode.queue_free()
			GoalsSceneNode = null
			Is_GoalsTab_Open = false
		
		# Create a new instance and add it to the scene
		TimerPannle = TimerScene.instantiate()
		add_child(TimerPannle)
		Is_TimerTab_Open = true

func _on_goals_button_pressed() -> void:
	if Is_GoalsTab_Open:
		# Close and free the GoalsSceneNode
		if GoalsSceneNode != null:
			GoalsSceneNode.queue_free()
			GoalsSceneNode = null
		Is_GoalsTab_Open = false
	else:
		# Close Timer panel if open
		if Is_TimerTab_Open:
			TimerPannle.queue_free()
			TimerPannle = null
			Is_TimerTab_Open = false
		
		# Create a new instance and add it to the scene
		GoalsSceneNode = GoalsScene.instantiate()
		add_child(GoalsSceneNode)
		Is_GoalsTab_Open = true
