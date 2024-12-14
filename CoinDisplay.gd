extends CanvasLayer

@onready var coin_label : Label = $Label

func _process(delta):
	if Stats != null:
		coin_label.text = str(Stats.get_coin_count())
	else:
		printerr("Error: Stats singleton is not available")
