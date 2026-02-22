extends Node3D

signal died

@onready var visibility_flasher = $VisibilityFlasher
@onready var hurtbox = $HurtBox3D
@onready var collision = $Collision
@onready var stats = $Stats

var bounce_interval : float = 0.1
var bounce_time : float = 0.0
var bounce_height : float = 0.01

var speed = 4

func _ready() -> void:
	EntityManager.player = self
	hurtbox.invincibility_started.connect(_on_invinciblity_started)
	hurtbox.invincibility_ended.connect(_on_invinciblity_ended)
	stats.hp_depleted.connect(_on_stats_hp_depleted)

func _process(delta: float) -> void:
	bounce_time += delta
	if bounce_time >= bounce_interval:
		bounce_time = 0.0
	var bounce_amount = sin(PI * get_bounce_progress())
	position.y = bounce_height * bounce_amount

func get_bounce_progress() -> float:
	return bounce_time / bounce_interval

func take_damage(amount : float) -> void:
	stats.hp -= amount


# SIGNALS ----------------------------------------------------------------------
func _on_invinciblity_started() -> void:
	visibility_flasher.active = true
	collision.set_deferred("monitorable", false)
	
func _on_invinciblity_ended() -> void:
	visibility_flasher.active = false
	collision.set_deferred("monitorable", true)

func _on_stats_hp_depleted() -> void:
	died.emit()
