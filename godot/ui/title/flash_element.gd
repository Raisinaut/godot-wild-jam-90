extends Label

@export_range(0, 1, 0.01) var max_opacity : float = 1.0
@export_range(0, 1, 0.01) var min_opacity : float = 0.0
@export var interval : float = 1.0

var time_passed : float = 0.0


func _process(delta: float) -> void:
	progress_interval(delta)
	update_opacity()

func update_opacity() -> void:
	self_modulate.a = lerp(min_opacity, max_opacity, get_amount_scale())

func get_amount_scale() -> float:
	return sin(PI * get_interval_progress())

func get_interval_progress() -> float:
	return time_passed / interval

func progress_interval(delta) -> void:
	time_passed += delta
	if time_passed >= interval:
		time_passed = 0.0
