extends CanvasLayer

signal faded_in

@onready var color_rect = $ColorRect

var fade_tween : Tween = null

func _ready() -> void:
	color_rect.color.a = 0
	await fade_to(1).finished
	faded_in	.emit()

func fade_to(value : float, duration = 1.0) -> Tween:
	if fade_tween: fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(color_rect, "color:a", value, duration)
	return fade_tween


# SIGNALS ----------------------------------------------------------------------
func _on_progress_changed(_new_value : float) -> void:
	pass

func _on_load_finished() -> void:
	await fade_to(0).finished
	queue_free()
