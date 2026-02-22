class_name ChunkSpawner
extends Node3D

signal measured_progress_changed(value)

@onready var path = $Path
@onready var ground = $Ground

var chunks : Dictionary = {
	"empty" : preload("res://levels/level_chunk/chunks/chunk_0_empty.tscn"),
	"easy_1" : preload("res://levels/level_chunk/chunks/chunk_cactus_a.tscn")
}

enum Modes {
	EMPTY,
	EASY,
	MEDIUM,
	HARD
}

var mode := Modes.EMPTY : set = set_mode
var speed = 1.0 : set = set_speed
var track_progress : bool = false
var measured_progress : float = 0.0 : set = set_measured_progress


func _ready() -> void:
	EntityManager.chunk_spawner = self

func _process(delta: float) -> void:
	if track_progress:
		measured_progress += speed * delta


# SETTERS ----------------------------------------------------------------------
func set_mode(state) -> void:
	mode = state
	match mode:
		Modes.EMPTY:
			path.spawn_scene = chunks["empty"]
		Modes.EASY:
			path.spawn_scene = chunks["easy_1"]
		Modes.MEDIUM:
			pass
		Modes.HARD:
			pass
	print("Spawn mode: ", Modes.keys()[mode])

func set_speed(value : float) -> void:
	speed = value
	ground.speed_scale = speed
	path.move_speed = speed * 4

func set_measured_progress(value : float) -> void:
	measured_progress = value
	measured_progress_changed.emit(value)
