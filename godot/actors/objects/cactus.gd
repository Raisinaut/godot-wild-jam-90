extends Node3D

@onready var detection = $Detection


func _ready() -> void:
	detection.area_entered.connect(_on_detection_area_entered)

func _on_detection_area_entered(area : Area3D) -> void:
	top_level = true
	var duration = 4
	var impact_direction = area.global_position.direction_to(detection.global_position)
	var lift := Vector3(0, 1, 0)
	var displacement : Vector3 = (impact_direction + lift) * 80
	var end_pos = global_position + displacement
	
	var t = create_tween()
	t.tween_property(self, "global_position", end_pos + lift, duration)
	t.parallel().tween_property(self, "rotation", impact_direction * 50, duration)
	detection.call_deferred("set_monitoring", false)
