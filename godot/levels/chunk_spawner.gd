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
