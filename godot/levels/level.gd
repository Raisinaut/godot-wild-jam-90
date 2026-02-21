extends Node3D

@onready var chunk_spawner = $ChunkSpawner
@onready var ground = $Ground
@onready var player_path = $Path3D/PathFollow3D
@onready var scene_animator = $SceneAnimator
@onready var title = $Title
# CAMERAS
@onready var cinematic_camera = $CinematicCamera
@onready var game_camera = $GameCamera

@export var skip_cinematic : bool = false

func _ready() -> void:
	# safety enable cinematic in non-debug builds
	if OS.is_debug_build():
		skip_cinematic = false
	title.finished_procession.connect(_on_title_finished_procession)
	chunk_spawner.mode = ChunkSpawner.Modes.EMPTY
	start_cinematic()

func start_cinematic() -> void:
	switch_to_cinematic_camera()
	scene_animator.play("intro")
	if skip_cinematic:
		scene_animator.seek(scene_animator.get_animation("intro").length)
		title.proceeded = true # disable procession animation
		title.visible = false
		switch_to_game_camera()
		start_level()

# LEVEL CONTROLS ---------------------------------------------------------------
func start_level() -> void:
	chunk_spawner.mode = ChunkSpawner.Modes.EASY


# CAMERA MANAGEMENT ------------------------------------------------------------
func switch_to_cinematic_camera() -> void:
	player_path.allow_input = false
	cinematic_camera.current = true
	# start zoomed in
	cinematic_camera.zoom_to(0, 0)

func switch_to_game_camera() -> void:
	game_camera.current = true
	player_path.allow_input = true

func transition_to_game_camera() -> void:
	cinematic_camera.reset_zoom()
	# move to game camera
	await cinematic_camera.move_to(game_camera.global_position).finished
	switch_to_game_camera()


# SIGNALS ----------------------------------------------------------------------
func _on_title_finished_procession() -> void:
	await transition_to_game_camera()
	start_level()
