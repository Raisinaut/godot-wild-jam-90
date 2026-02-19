extends Node3D

@onready var placement_area = $PlacementArea
@onready var objects = $Objects
@onready var boundary = $Boundary


func _ready() -> void:
	placement_area.hide()
	setup_orentiations()

func setup_orentiations() -> void:
	for i : Node3D in objects.get_children():
		make_upright(i, 10)
		randomize_spin(i)
	for i : Node3D in boundary.get_children():
		make_upright(i)
		randomize_spin(i)

func make_upright(node: Node3D, extra_tilt: float = 0) -> void:
	var tilt = get_tilt_vector(extra_tilt)
	node.look_at(to_local(Vector3.UP) + tilt)

func randomize_spin(node: Node3D) -> void:
	node.quaternion.w = randf_range(-1.0, 1.0)

func get_tilt_vector(amount: float) -> Vector3:
	var tilt_vec := Vector3.ZERO
	tilt_vec.x += randf_range(-1.0, 1.0)
	tilt_vec.z += randf_range(-1.0, 1.0)
	return tilt_vec * amount
	
