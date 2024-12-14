extends Control

@onready var goal_input : LineEdit = $GoalAddingPannle/GoalInput
@onready var add_goal_button : Button = $GoalAddingPannle/AddGoalButton
@onready var goal_list_container : VBoxContainer = $GoalListContainer
@onready var GoalAddingPannle : Control = $GoalAddingPannle
@onready var labletest : PackedScene = preload("res://Goals Pannle/GoalItem.tscn")
var Is_GoalAdding_Open : bool = false
var goal_item_scene : PackedScene = preload("res://Goals Pannle/GoalItem.tscn") # preload the goal item

var goals : Array[Dictionary] = []  # Array to hold goal data, type hint added
var save_path : String = "" # variable to hold the path to the json file

func _ready():
	save_path =  OS.get_user_data_dir() + "/goals.json"
	load_goals()


func update_goal_ui():
	# Clear existing UI
	for child in goal_list_container.get_children():
		child.queue_free()

	# Update UI for each goal
	for i in goals.size():
		var goal = goals[i]
		var goal_item_instance = goal_item_scene.instantiate()
		goal_item_instance.set_goal_data(goal, i) # send the dictionary to the GoalItem
		goal_item_instance.goal_toggled.connect(_on_goal_item_toggled) # Connect the signal
		goal_list_container.add_child(goal_item_instance)

func _on_adding_goals_pannle_pressed() -> void:
	GoalAddingPannle.visible = not GoalAddingPannle.visible
	Is_GoalAdding_Open = not Is_GoalAdding_Open


func _on_close_adding_pannle_pressed() -> void:
	GoalAddingPannle.visible = false
	Is_GoalAdding_Open = false


func _on_add_goal_button_pressed():
	var goal_text = goal_input.text
	if not goal_text.is_empty():
		var new_goal = {"text": goal_text, "completed": false} # dictionary with text and completed
		goals.append(new_goal)
		goal_input.clear()
		save_goals()
		update_goal_ui()

func _on_goal_item_toggled(index:int, completed:bool):
	if index >= 0 and index < goals.size():
		goals[index]["completed"] = completed
		save_goals()
		print("Goal ", index," completed state:", completed)


func save_goals():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(goals)
		file.store_string(json_string)
		file.close()
	else:
		printerr("Error: Unable to open the file for saving: ", save_path)


func load_goals():
	if not FileAccess.file_exists(save_path):
		return # No file, just do nothing
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var parsed_data = JSON.parse_string(json_string)

		if typeof(parsed_data) == TYPE_ARRAY:
			var loaded_goals : Array[Dictionary] = []
			for item in parsed_data:
				if typeof(item) == TYPE_DICTIONARY:
					loaded_goals.append(item)
				else:
					printerr("Error: Invalid data found in loaded goals, not a dictionary, skipping: ", item)
			goals = loaded_goals
			update_goal_ui()
		else:
			printerr("Error: Unable to load goals, parsed data not an array")
	else:
		printerr("Error: Unable to open the file for loading: ", save_path)
