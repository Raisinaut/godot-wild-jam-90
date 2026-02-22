extends CanvasLayer

@onready var current_prog_container: PanelContainer = %CurrentProgContainer
@onready var progress_label = %Progress
@onready var best_progress_label = %BestProgress


func _ready() -> void:
	EntityManager.player.hp_changed.connect(_on_player_hp_changed)
	EntityManager.chunk_spawner.measured_progress_changed.connect(
		_on_measured_progress_changed)
	GameManager.best_progress_changed.connect(_on_best_progress_changed)
	# Initialize label text
	GameManager.best_progress = GameManager.best_progress
	progress_label.text = "0 m"

func _on_measured_progress_changed(value : float) -> void:
	var multiplier : float = 10
	value *= multiplier
	if value > GameManager.best_progress:
		GameManager.best_progress = value
	progress_label.text = convert_to_progress_text(value) + " m"

func _on_best_progress_changed(value : float) -> void:
	best_progress_label.text = "Best: " + convert_to_progress_text(value) + " m"

func _on_player_hp_changed(value : float) -> void:
	# TODO: make the damage counter update
	pass

func convert_to_progress_text(value : float) -> String:
	return String.num((value), 0)
