extends Node3D

var bounce_interval : float = 0.1
var bounce_time : float = 0.0
var bounce_height : float = 0.01

func _process(delta: float) -> void:
	bounce_time += delta
	if bounce_time >= bounce_interval:
		bounce_time = 0.0
	var bounce_amount = sin(PI/2 * get_bounce_progress())
	position.y = bounce_height * bounce_amount

func get_bounce_progress() -> float:
	return bounce_time / bounce_interval
