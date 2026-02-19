extends Node3D

const MAX_SPEED = 20

@onready var detection = %Detection
@onready var animator = $AnimationPlayer

var follow_target : Node3D
var velocity := Vector3.ZERO
var speed : float = 0
var accel : float = 20
var pos_tween : Tween = null
var scale_tween : Tween = null


func _ready() -> void:
	position.y += 0.35
	detection.area_entered.connect(_on_detection_area_entered)

func _process(delta: float) -> void:
	if is_tweening_pos():
		return
	if not follow_target:
		return
	move_toward_target(delta)

func move_toward_target(delta: float) -> void:
	var tar_pos = follow_target.global_position
	speed = min(speed + accel * delta, MAX_SPEED) # accelerate
	global_position = global_position.move_toward(tar_pos, speed * delta) # move
	if global_position.is_equal_approx(follow_target.global_position):
		destroy()

func _on_detection_area_entered(area) -> void:
	top_level = true
	animate_collection()
	animator.speed_scale = 4.0
	detection.set_deferred("monitoring", false)
	follow_target = area

func animate_collection() -> void:
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var shift_vector := Vector3(0, 1, 0)
	var end_pos : Vector3 = global_position + shift_vector
	t.tween_property(self, "global_position", end_pos, 0.25)
	# shrink
	scale_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(self, "scale", Vector3.ZERO, 1.0)

func destroy() -> void:
	queue_free()

func is_tweening_pos() -> bool:
	return pos_tween and pos_tween.is_running()
