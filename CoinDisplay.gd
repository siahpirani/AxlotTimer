extends CanvasLayer

@onready var coin_label : Label = $Label

func _process(delta):
	coin_label.text = str(Stats.get_coin_count())
