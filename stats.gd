extends Node

var CountDownTime = 0
var PromodoWorkTime =0
var PromodoRestTime=0
var PromodoSessionNumber=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func passtheCountdowntime(TimeDown):
	CountDownTime = TimeDown
func returncountdowntime() :
	return CountDownTime
func PassThePromodo (WorkTime , RestTime , SessionNumber):
	PromodoWorkTime =WorkTime
	PromodoRestTime=RestTime
	PromodoSessionNumber=SessionNumber
func ReturnPromodoWorkTime ():
	return PromodoWorkTime
func ReturnPromodoRestTime ():
	return PromodoRestTime
func ReturnPromodoSessionNumber ():
	return PromodoSessionNumber
