extends Node3D

@onready var game_camera = $GameCamera
@onready var cinematic_camera = $CinematicCamera
@onready var player_path = $Path3D/PathFollow3D
@onready var scene_animator = $SceneAnimator

func _ready() -> void:
	animate_intro()

func animate_intro() -> void:
	player_path.allow_input = false
	cinematic_camera.current = true
	# start zoomed in
	cinematic_camera.zoom_to(0, 0)
	# animate scene
	scene_animator.play("intro")
	await scene_animator.animation_finished
	# hold zoom level
	await cinematic_camera.zoom_to(0, 0.8).finished
	# reset zoom
	cinematic_camera.reset_zoom()
	# move to game camera
	await cinematic_camera.move_to(game_camera.global_position).finished
	# switch to game cameradad
	game_camera.current = true
	player_path.allow_input = true
