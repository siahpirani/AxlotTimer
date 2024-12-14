extends Control
@onready var goal_input = $GoalAddingPannle/GoalInput
@onready var add_goal_button = $GoalAddingPannle/AddGoalButton
@onready var goal_list_container = $GoalListContainer
@onready var GoalAddingPannle = $GoalAddingPannle
@onready var labletest :PackedScene = preload("res://Goals Pannle/GoalItem.tscn")
var Is_GoalAdding_Open = false
var goal_item_scene = preload("res://Goals Pannle/GoalItem.tscn") # preload the goal item

	  
var goals = []  # Array to hold goal data

func update_goal_ui():
	# Clear existing UI
	for child in goal_list_container.get_children():
		child.queue_free()

	# Update UI for each goal
	for i in goals.size():
		var goal = goals[i]
		var goal_item_instance = goal_item_scene.instantiate()
		goal_item_instance.set_goal_data(goal,i) # send the dictionary to the GoalItem
		goal_list_container.add_child(goal_item_instance)

func _on_adding_goals_pannle_pressed() -> void:
	if Is_GoalAdding_Open:
		GoalAddingPannle.visible = false
		Is_GoalAdding_Open = false
	else:
		GoalAddingPannle.visible = true
		Is_GoalAdding_Open = true


func _on_close_adding_pannle_pressed() -> void:
	if Is_GoalAdding_Open:
		GoalAddingPannle.visible = false
		Is_GoalAdding_Open = false
	else:
		GoalAddingPannle.visible = true
		Is_GoalAdding_Open = true


func _on_add_goal_button_pressed():
	var goal_text = goal_input.text
	if not goal_text.is_empty():
		var new_goal = {"text": goal_text, "completed": false} # dictionary with text and completed
		goals.append(new_goal)
		goal_input.clear()
		update_goal_ui()
