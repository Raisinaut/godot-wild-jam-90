extends CanvasLayer

signal finished_procession

@onready var backdrop = %Backdrop
@onready var title_container = %TitleContainer
@onready var key_prompt = %KeyPrompt

var proceeded : bool = false

func _process(_delta: float) -> void:
	if proceeded:
		return
	if Input.is_anything_pressed():
		proceeded = true
		animate_procession()

func animate_procession() -> void:
	# Accentuate flash
	key_prompt.interval /= 7
	key_prompt.min_opacity = 0.0
	await get_tree().create_timer(0.5).timeout
	await fade_element(key_prompt, 0, 0.2).finished
	# Fade elements
	fade_element(backdrop, 0, 0.3)
	await fade_element(title_container, 0, 0.3).finished
	finished_procession.emit()

func fade_element(node : Control, end_value : float, duration := 0.5) -> Tween:
	var t = create_tween()
	t.tween_property(node, "modulate:a", end_value, duration)
	return t
