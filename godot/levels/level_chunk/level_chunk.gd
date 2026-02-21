class_name LevelChunk
extends Node3D

const placement_area_width: float = 10
const placement_area_length: float = 10

@onready var placement_area = $PlacementArea
@onready var objects = $Objects
@onready var pickups = $Pickups
@onready var boundary = $Boundary

#var placement_area_size: = Vector2(10, 10)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	placement_area.hide()
	setup_orentiations()

func setup_orentiations() -> void:
	for grouping in [objects, pickups, boundary]:
		for i : Node3D in grouping.get_children():
			make_upright(i)
			randomize_spin(i)


# UTILITY ----------------------------------------------------------------------
func make_upright(node: Node3D) -> void:
	node.look_at(to_local(Vector3.UP))

func randomize_spin(node: Node3D) -> void:
	node.quaternion.w = randf_range(-1.0, 1.0)

# CALCULATIONS -----------------------------------------------------------------
func get_tilt_vector(amount: float) -> Vector3:
	var tilt_vec := Vector3.ZERO
	tilt_vec.x += randf_range(-1.0, 1.0)
	tilt_vec.z += randf_range(-1.0, 1.0)
	return tilt_vec * amount
