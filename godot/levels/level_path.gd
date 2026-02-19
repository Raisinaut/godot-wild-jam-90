extends Path3D

signal path_end_reached

@export var spawn_scene : PackedScene
@export var spawn_interval : float = 2.5

var followers : Array[PathFollow3D] = []

var max_interval = 5.0
var min_interval = 0.5

var move_duration : float = 7.5

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	add_follower()
	start_spawn_timer()
	path_end_reached.connect(_on_path_end_reached)

func start_spawn_timer() -> void:
	get_tree().create_timer(spawn_interval).timeout.connect(_on_spawn_timer_timeout)

func _process(_delta: float) -> void:
	for i in followers:
		# increment follower progresion
		#i.progress += move_speed * delta
		if i.progress_ratio >= 1.0:
			path_end_reached.emit()
			followers.erase(i)
			i.queue_free()

func add_follower() -> void:
	# create new path
	var follower = PathFollow3D.new()
	follower.rotation_mode = PathFollow3D.ROTATION_NONE
	follower.loop = false
	call_deferred_thread_group("add_child", follower)
	await follower.ready
	# attach instance to path
	var inst = spawn_scene.instantiate()
	follower.call_deferred("add_child", inst)
	inst.tree_exited.connect(_on_inst_tree_exited.bind(follower))
	followers.append(follower)
	start_follower_movement(follower)

func start_follower_movement(follower : PathFollow3D) -> void:
	var t = create_tween()
	t.tween_property(follower, "progress_ratio", 1.0, move_duration)

func get_leading_entity():
	if get_children().size() > 0:
		return followers[0].get_child(0)
	return null


# SIGNALS ----------------------------------------------------------------------
func _on_inst_tree_exited(follower) -> void:
	followers.erase(follower)

func _on_path_end_reached() -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	add_follower()
	start_spawn_timer()
