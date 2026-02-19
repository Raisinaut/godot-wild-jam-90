extends PathFollow3D

const max_tilt : float = PI/8

@export_category("Movement")
@export var max_speed : float = 8
@export var accel : float = 20.0
@export var decel : float = 10.0
@export var rotation_offset := Vector3(0, PI/2, 0)

var speed : float = 0.0
var last_progress : float = 0.0
var allow_input : bool = true

func _ready() -> void:
	loop = false
	progress_ratio = 0.5
	last_progress = progress_ratio

func _process(delta: float) -> void:
	set_speed(delta)
	move(delta)
	sync_rotation()


# Movement --------------------------------------------------------------------#

func set_speed(delta : float):
	var input_axis = get_input_axis()
	var target_speed = max_speed * input_axis
	if target_speed:
		speed = move_toward(speed, target_speed, accel * delta)
	else:
		speed = move_toward(speed, 0.0, decel * delta)
	# Slow near each path end
	if is_approaching_edge():
		speed = lerp(speed, 0.0, get_damper_weight())

func move(delta: float):
	last_progress = progress
	progress += speed * delta

func sync_rotation():
	var s = get_actual_speed()
	rotation.y = remap(s, -max_speed, max_speed, -max_tilt, max_tilt)
	rotation += rotation_offset

func get_input_axis() -> float:
	if allow_input:
		return Input.get_axis("move_left", "move_right")
	else:
		return 0.0


# Checks ----------------------------------------------------------------------#

func is_approaching_edge() -> bool:
	return sign(get_edge_proximity()) == sign(speed)

func is_touching_top_edge() -> bool:
	return get_edge_proximity() == -1

func is_touching_bottom_edge() -> bool:
	return get_edge_proximity() == 1


# Calculations ----------------------------------------------------------------#

func get_damper_weight():
	return max(abs(get_edge_proximity()) - 0.1, 0.0)

func get_edge_proximity():
	return (ease(progress_ratio, -0.1) - 0.5) * 2

func get_actual_speed():
	return (progress - last_progress) / get_process_delta_time()

func get_speed_magnitude():
	return get_actual_speed() / max_speed
