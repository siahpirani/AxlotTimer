extends Node2D

@onready var anim_player = $AnimationPlayer

func _ready():
	play_animation_and_continue("CoinMovmentAnime")
	
func play_animation_and_continue(animation_name: String):
	# Disconnect any existing connection for this signal to avoid duplicates
	anim_player.play(animation_name)
	#if anim_player.animation_finished:
		#_on_animation_player_animation_finished(animation_name)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
		#print("Animation '" + anim_name + "' finished!")
		queue_free()  # Clean up this node after the animation
