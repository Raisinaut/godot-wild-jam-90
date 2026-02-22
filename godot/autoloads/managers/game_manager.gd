extends Node

signal best_progress_changed

var best_progress : float = 0 : set = set_best_progress

func set_best_progress(value : float) -> void:
	best_progress = value
	best_progress_changed.emit(value)
