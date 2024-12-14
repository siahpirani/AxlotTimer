extends Control

# Constants to be used in the script
const GOAL_SAVE_FILE_NAME : String = "/goals.json"
const COINS_FOR_GOAL_COMPLETION : int = 10

@onready var goal_input : LineEdit = $GoalAddingPannle/GoalInput # Reference to the input line for goals
@onready var add_goal_button : Button = $GoalAddingPannle/AddGoalButton  # Reference to the button to add a goal
@onready var goal_list_container : VBoxContainer = $GoalListContainer # Reference to the container for the goals
@onready var GoalAddingPannle : Control = $GoalAddingPannle # Reference to the goal adding panel
@onready var labletest : PackedScene = preload("res://Goals Pannle/GoalItem.tscn") # Load packed scene for the goal item
var Is_GoalAdding_Open : bool = false # Flag indicating if the goal adding panel is open
var goal_item_scene : PackedScene = preload("res://Goals Pannle/GoalItem.tscn") # Preload the goal item scene

var goals : Array[Dictionary] = []  # Array to hold goal data
var save_path : String  # Path to the save file

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set the save path, with a file name
	save_path = OS.get_user_data_dir() + GOAL_SAVE_FILE_NAME
	# Load saved goals from the file
	load_goals()

# Update the UI list of goals
func update_goal_ui() -> void:
	# Clear the existing goals in the UI container
	for child in goal_list_container.get_children():
		child.queue_free() # Delete previous goals

	# Add all goals to the container
	for i in goals.size():
		var goal = goals[i] # Get the data for goal i
		var goal_item_instance = goal_item_scene.instantiate() # Create an instance of the goal item scene
		# Set the goal data and connect to the signal, and add the instance to the container
		goal_item_instance.set_goal_data(goal, i)
		goal_item_instance.goal_toggled.connect(_on_goal_item_toggled)
		goal_list_container.add_child(goal_item_instance)

# Toggle visibility of the Goal adding panel
func _on_adding_goals_pannle_pressed() -> void:
	GoalAddingPannle.visible = not GoalAddingPannle.visible # Toggle visibility of the panel
	Is_GoalAdding_Open = not Is_GoalAdding_Open # Toggle the flag

# Close the goal adding panel explicitly
func _on_close_adding_pannle_pressed() -> void:
	GoalAddingPannle.visible = false # Set visibility to false
	Is_GoalAdding_Open = false # Set flag to false

# Add a new goal when the add button is pressed
func _on_add_goal_button_pressed() -> void:
	var goal_text : String = goal_input.text # Get the text of the goal from input
	# If text input is not empty, create a new goal
	if not goal_text.is_empty():
		var new_goal : Dictionary = {"text": goal_text, "completed": false} # Create the new dictionary
		goals.append(new_goal) # Add the goal to the array
		goal_input.clear() # Clear the input box
		save_goals() # Save the goals
		update_goal_ui() # Update the ui

# Function called when a goal is toggled
func _on_goal_item_toggled(index:int, completed:bool) -> void:
	# Check if index is valid
	if index >= 0 and index < goals.size():
		# If goal was marked as completed, remove the goal
		if completed:
			_remove_goal(index)
		# if not marked as completed, update the value
		else:
			goals[index]["completed"] = completed
			save_goals()
			print("Goal ", index," completed state:", completed)

# Removes the goal in the given index
func _remove_goal(index: int) -> void:
	# Ensure the index is valid
	if index >= 0 and index < goals.size():
		if Stats != null:
			Stats.increment_coins(COINS_FOR_GOAL_COMPLETION) # Increment coins for completing the goal
		else:
			printerr("Error: Stats singleton is not available")
		goals.remove_at(index) # Remove the goal from the array
		save_goals() # Save goals after removing
		update_goal_ui() # Update the ui
	else:
		printerr("Error: Invalid index in _remove_goal: ", index)

# Saves the goals data to the file
func save_goals() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE) # Open the file in write mode
	if file:
		var json_string : String = JSON.stringify(goals) # stringify the goals to a JSON string
		file.store_string(json_string)  # store the JSON string
		file.close() # close the file
	else:
		printerr("Error: Unable to open the file for saving: ", save_path) # Error log

# Loads the goals from the save file
func load_goals() -> void:
	# Check if the file exists
	if not FileAccess.file_exists(save_path):
		return # If not, return, and do nothing
	
	# Open the file in read mode
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text() # Get the text
		file.close() # Close the file
		# Parse the string into data
		var parsed_data = JSON.parse_string(json_string)
		# Ensure the data loaded is an array
		if typeof(parsed_data) == TYPE_ARRAY:
			var loaded_goals : Array[Dictionary] = [] # Create the array to hold the dictionaries
			# Verify all the items are dictionaries, and only append the valid ones
			for item in parsed_data:
				if typeof(item) == TYPE_DICTIONARY:
					loaded_goals.append(item) # Only append valid items
				else:
					printerr("Error: Invalid data found in loaded goals, not a dictionary, skipping: ", item) # Skip invalid items
			goals = loaded_goals # Assign to the global variable
			update_goal_ui()  # Update the UI
		else:
			printerr("Error: Unable to load goals, parsed data not an array")  # Error log
	else:
		printerr("Error: Unable to open the file for loading: ", save_path)  # Error log
