extends Node3D

@onready var chunk_spawner = $ChunkSpawner
@onready var player_path = $Path3D/PathFollow3D
@onready var scene_animator = $SceneAnimator
@onready var title = $Title
@onready var hud = $HUD
# CAMERAS
@onready var cinematic_camera = $CinematicCamera
@onready var game_camera = $GameCamera

@export var skip_cinematic : bool = false

var speedup_rate : float = 0.02

func _ready() -> void:
	# safety enable cinematic in non-debug builds
	if OS.is_debug_build():
		skip_cinematic = false
	EntityManager.player.died.connect(_on_player_died)
	EntityManager.player.death_animation_finished.connect(_on_player_death_finished)
	title.finished_procession.connect(_on_title_finished_procession)
	chunk_spawner.mode = ChunkSpawner.Modes.EMPTY
	hud.current_prog_container.hide()
	start_intro_cinematic()

func start_intro_cinematic() -> void:
	switch_to_cinematic_camera()
	scene_animator.play("intro")
	if skip_cinematic:
		scene_animator.seek(scene_animator.get_animation("intro").length)
		title.proceeded = true # disable procession animation
		title.visible = false
		switch_to_game_camera()
		start_level()

func _process(delta: float) -> void:
	if chunk_spawner.mode == ChunkSpawner.Modes.EMPTY:
		return
	chunk_spawner.speed += speedup_rate * delta
	chunk_spawner.speed = min(8, chunk_spawner.speed) # cap the speed

# LEVEL CONTROLS ---------------------------------------------------------------
func start_level() -> void:
	chunk_spawner.mode = ChunkSpawner.Modes.EASY
	chunk_spawner.track_progress = true
	hud.current_prog_container.show()

func reload():
	SceneLoader.load_scene(scene_file_path)


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

func _on_player_died() -> void:
	player_path.allow_input = false
	var t = create_tween()
	t.tween_property(chunk_spawner, "speed", chunk_spawner.speed * 0.6, 0.8)
	t.tween_property(chunk_spawner, "speed", chunk_spawner.speed * 0.5, 0.4)
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(chunk_spawner, "speed", 0.0, 1.0)

func _on_player_death_finished() -> void:
	chunk_spawner.speed = 0
	await get_tree().create_timer(1.0).timeout
	reload()
