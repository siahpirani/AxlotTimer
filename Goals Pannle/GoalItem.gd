extends HBoxContainer

# Signal emitted when a goal's checkbox is toggled
signal goal_toggled(index:int, completed:bool)

var goal_data : Dictionary = {} # Stores the goal data
var goal_index : int = -1  # Stores the index of the goal

# Function to set the goal data for this GoalItem
func set_goal_data(data: Dictionary, index:int) -> void:
	goal_data = data
	goal_index = index
	_update_ui()

# Updates the UI of the goal item
func _update_ui() -> void:
	# Get label, or print error
	var label : Label = get_node("Label")
	if label:
		label.text = goal_data.get("text", "") # Safely retrieve text or set empty string if missing
	else:
		printerr("ERROR: Label in GoalItem is not valid")
	
	# Get checkbox, or print error
	var checkbox : CheckBox = get_node("CheckBox")
	if checkbox:
		checkbox.set_pressed(goal_data.get("completed", false)) # Safely get the value from the dictionary or set to false
	else:
		printerr("ERROR: Checkbox in GoalItem is not valid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var checkbox : CheckBox = get_node("CheckBox")
	if checkbox:
		checkbox.toggled.connect(_on_checkbox_toggled) # Connect checkbox signal to the function
	else:
		printerr("ERROR: Checkbox in GoalItem is not valid")


# Function called when the checkbox is toggled
func _on_checkbox_toggled(button_pressed: bool) -> void:
	#Emit the signal for the parent to receive
	emit_signal("goal_toggled", goal_index, button_pressed)
	# update the ui to match the new status
	_update_label_color(button_pressed)

# Changes the label's font color based on the checkbox state
func _update_label_color(button_pressed: bool) -> void:
	var label : Label = get_node("Label")
	if label:
		if button_pressed:
			label.set("theme_override_colors/font_color", Color(0.5, 0.5, 0.5, 1)) # Greyed out for completed
		else:
			label.set("theme_override_colors/font_color", Color(1, 1, 1, 1)) # White for not completed
