class_name ChunkSpawner
extends Node3D

@onready var path = $Path

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


func update_spawn_scene() -> void:
	var scene : PackedScene
	match mode:
		Modes.EMPTY:
			scene = chunks["empty"]
		Modes.EASY:
			scene = chunks["easy_1"]
		Modes.MEDIUM:
			pass
		Modes.HARD:
			pass
	# Set spawn scene
	path.spawn_scene = scene


# SETTERS ----------------------------------------------------------------------
func set_mode(state) -> void:
	mode = state
	update_spawn_scene()
	print("Spawn mode: ", Modes.keys()[mode])
