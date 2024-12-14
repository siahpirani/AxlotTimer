extends HBoxContainer
var goal_data = {} # Store the goal as a dictionary
var goal_index : int = -1

signal goal_toggled(index:int, completed:bool)

func set_goal_data(data: Dictionary, index:int):
	goal_data = data
	goal_index = index
	var label = get_node_or_null("Label")
	if label:
		label.text = goal_data["text"]
	else:
		print("ERROR: Label in GoalItem is not valid")
	var checkbox = get_node_or_null("CheckBox")
	if checkbox:
		checkbox.set_pressed(goal_data["completed"])
	else:
		print("ERROR: Checkbox in GoalItem is not valid")

func _ready():
	var checkbox = get_node_or_null("CheckBox")
	if checkbox:
		checkbox.toggled.connect(_on_checkbox_toggled)
	else:
		print("ERROR: Checkbox in GoalItem is not valid")

func _on_checkbox_toggled(button_pressed: bool):
	goal_data["completed"] = button_pressed # Modify the completed status
	var label = get_node_or_null("Label")
	# Change the label's font color based on the checkbox state
	if label:
		if goal_data["completed"]:
			label.set("theme_override_colors/font_color", Color(0.5, 0.5, 0.5, 1))
		else:
			label.set("theme_override_colors/font_color", Color(1, 1, 1, 1))
