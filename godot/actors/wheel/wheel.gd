extends Node3D

signal hp_changed
signal died
signal death_animation_finished

@onready var visibility_flasher = $VisibilityFlasher
@onready var hurtbox = $HurtBox3D
@onready var collision = $Collision
@onready var stats = $Stats
@onready var animator = $AnimationPlayer

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
	bounce(delta)

func bounce(delta) -> void:
	if is_dead():
		position.y = 0
	else:
		bounce_time += delta
		if bounce_time >= bounce_interval:
			bounce_time = 0.0
		var bounce_amount = sin(PI * get_bounce_progress())
		position.y = bounce_height * bounce_amount

func get_bounce_progress() -> float:
	return bounce_time / bounce_interval

func take_damage(amount : float) -> void:
	stats.hp -= amount
	hp_changed.emit(stats.hp)

func die() -> void:
	set_collision_active(false)
	died.emit()
	animator.play("death")
	await animator.animation_finished
	death_animation_finished.emit()

func set_collision_active(state) -> void:
	collision.set_deferred("monitorable", state)

func is_dead() -> bool:
	return stats.hp <= 0

# SIGNALS ----------------------------------------------------------------------
func _on_invinciblity_started() -> void:
	if is_dead():
		return
	# only activate when alive
	visibility_flasher.active = true
	set_collision_active(false)

func _on_invinciblity_ended() -> void:
	visibility_flasher.active = false
	set_collision_active(true)

func _on_stats_hp_depleted() -> void:
	die()
