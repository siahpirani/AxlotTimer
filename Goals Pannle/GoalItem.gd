extends HBoxContainer

var goal_data : Dictionary = {} # Store the goal as a dictionary, default to empty dict
var goal_index : int = -1

signal goal_toggled(index:int, completed:bool)

func set_goal_data(data: Dictionary, index:int):
	goal_data = data
	goal_index = index
	var label : Label = get_node("Label")
	if label:
		label.text = goal_data.get("text", "") # Add safety check, get text safely from dict
	else:
		printerr("ERROR: Label in GoalItem is not valid")
	var checkbox : CheckBox = get_node("CheckBox")
	if checkbox:
		checkbox.set_pressed(goal_data.get("completed", false)) # Add safety check, get boolean safely from dict
	else:
		printerr("ERROR: Checkbox in GoalItem is not valid")

func _ready():
	var checkbox : CheckBox = get_node("CheckBox")
	if checkbox:
		checkbox.toggled.connect(_on_checkbox_toggled)
	else:
		printerr("ERROR: Checkbox in GoalItem is not valid")

func _on_checkbox_toggled(button_pressed: bool):
	emit_signal("goal_toggled", goal_index, button_pressed)
	var label : Label = get_node("Label")
	# Change the label's font color based on the checkbox state
	if label:
		if button_pressed: # Safe access to the value
			label.set("theme_override_colors/font_color", Color(0.5, 0.5, 0.5, 1))
		else:
			label.set("theme_override_colors/font_color", Color(1, 1, 1, 1))
