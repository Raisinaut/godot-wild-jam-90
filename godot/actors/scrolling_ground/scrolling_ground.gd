extends StaticBody3D

@onready var mesh = $MeshInstance3D
@onready var mesh_shader : ShaderMaterial = mesh.material_override

var time : float = 0.0
@export var speed_scale = 1.0

var speed_tween : Tween = null

func _process(delta: float) -> void:
	time += delta * speed_scale
	mesh_shader.set_shader_parameter("external_time", time)

func transition_speed_scale(end_value : float, duration : float) -> Tween:
	if speed_tween: speed_tween.kill()
	speed_tween = create_tween()
	speed_tween.tween_property(self, "speed_scale", end_value, duration)
	return speed_tween
