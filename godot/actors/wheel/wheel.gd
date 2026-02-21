extends Node3D

@onready var visibility_flasher = $VisibilityFlasher
@onready var hurtbox = $HurtBox3D
@onready var collision = $Collision

var bounce_interval : float = 0.1
var bounce_time : float = 0.0
var bounce_height : float = 0.01

var speed = 4

func _ready() -> void:
	hurtbox.invincibility_started.connect(_on_invinciblity_started)
	hurtbox.invincibility_ended.connect(_on_invinciblity_ended)

func _process(delta: float) -> void:
	bounce_time += delta
	if bounce_time >= bounce_interval:
		bounce_time = 0.0
	var bounce_amount = sin(PI * get_bounce_progress())
	position.y = bounce_height * bounce_amount

func get_bounce_progress() -> float:
	return bounce_time / bounce_interval


# SIGNALS ----------------------------------------------------------------------
func _on_invinciblity_started() -> void:
	visibility_flasher.active = true
	collision.set_deferred("monitorable", false)
	
func _on_invinciblity_ended() -> void:
	visibility_flasher.active = false
	collision.set_deferred("monitorable", true)
