extends Control

# Boolean variables to track if Timer or Goals tabs are open
var Is_TimerTab_Open: bool = false
var Is_GoalsTab_Open: bool = false

# Packed scenes for Timer and Goals UI
var TimerScene: PackedScene = preload("res://TimerTab.tscn")  # Store the PackedScene
var TimerPannle: Node = null # Reference to the instance

var GoalsScene: PackedScene = preload("res://Goals Pannle/GoalListScene.tscn")
var GoalsSceneNode: Node = null

# Packed scene for the coin display UI
var CoinDisplayScene: PackedScene = preload("res://CoinDisplay.tscn")
var CoinDisplayNode : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instantiates and adds the coin display ui into the current scene
	CoinDisplayNode = CoinDisplayScene.instantiate()
	add_child(CoinDisplayNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # no operation

# Function called when the timers panel button is pressed
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
			if GoalsSceneNode != null:
				GoalsSceneNode.queue_free()
				GoalsSceneNode = null
			Is_GoalsTab_Open = false
		
		# Create a new instance and add it to the scene
		TimerPannle = TimerScene.instantiate()
		add_child(TimerPannle)
		Is_TimerTab_Open = true

# Function called when the goals panel button is pressed
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
			if TimerPannle != null:
				TimerPannle.queue_free()
				TimerPannle = null
			Is_TimerTab_Open = false
		
		# Create a new instance and add it to the scene
		GoalsSceneNode = GoalsScene.instantiate()
		add_child(GoalsSceneNode)
		Is_GoalsTab_Open = true
