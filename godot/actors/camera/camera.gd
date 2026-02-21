extends Camera3D

const MIN_FOV : float = 4
const MAX_FOV : float = 10

@onready var default_fov := fov

var zoom_tween : Tween = null
var pos_tween : Tween = null


func zoom_to(value: float, duration: float = 1.0) -> Tween:
	var new_fov = lerp(MIN_FOV, MAX_FOV, value)
	zoom_tween = create_tween()
	zoom_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	zoom_tween.tween_property(self, "fov", new_fov, duration)
	return zoom_tween

func reset_zoom(duration: float = 1.0) -> Tween:
	var default_fov_scale = inverse_lerp(MIN_FOV, MAX_FOV, default_fov)
	return zoom_to(default_fov_scale, duration)

func move_to(pos : Vector3, duration: float = 1.0) -> Tween:
	pos_tween = create_tween()
	pos_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pos_tween.tween_property(self, "global_position", pos , duration)
	return pos_tween
