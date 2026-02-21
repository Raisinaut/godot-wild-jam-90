extends Path3D

signal path_end_reached

@export var spawn_scene: PackedScene

var followers: Array[PathFollow3D] = []
var move_speed: float = 4.0

func _ready() -> void:
	populate_path()

func populate_path() -> void:
	await add_follower(1.0).ready
	var last_follower = followers[-1]
	var chunk_length = LevelChunk.placement_area_length
	while last_follower.progress >= chunk_length:
		var gap = last_follower.progress - chunk_length
		var path_length = curve.get_baked_length()
		var progress_makeup = gap / path_length
		await add_follower(progress_makeup).ready
		last_follower = followers[-1]

func _process(delta: float) -> void:
	# Increment follower progressions
	for i in followers:
		i.progress += move_speed * delta
		if is_equal_approx(i.progress_ratio, 1.0):
			path_end_reached.emit()
			followers.erase(i) 
			i.queue_free()
	# Add a new follower if there is enough space for another chunk
	if not followers.is_empty():
		var last_follower = followers[-1]
		var chunk_length = LevelChunk.placement_area_length
		if last_follower.progress >= chunk_length:
			var gap = last_follower.progress - chunk_length
			var path_length = curve.get_baked_length()
			var progress_makeup = gap / path_length
			add_follower(progress_makeup)

func add_follower(starting_progress : float = 0) -> PathFollow3D:
	if not spawn_scene:
		return
	var follower = PathFollow3D.new()
	follower.rotation_mode = PathFollow3D.ROTATION_NONE
	follower.loop = false
	call_deferred_thread_group("add_child", follower)
	follower.ready.connect(_on_follower_ready.bind(follower, starting_progress))
	return follower

func get_follower_child(idx : int) -> Node:
	if followers.size() > 0:
		return followers[idx].get_child(0)
	return null

# SIGNALS ----------------------------------------------------------------------
func _on_inst_tree_exited(follower) -> void:
	followers.erase(follower)

func _on_follower_ready(follower : PathFollow3D, starting_progress : float) -> void:
	var inst = spawn_scene.instantiate()
	follower.progress_ratio = starting_progress
	follower.call_deferred("add_child", inst)
	inst.tree_exited.connect(_on_inst_tree_exited.bind(follower))
	followers.append(follower)
