extends CheckButton

func _toggled(toggled_on: bool) -> void:
	TickManager._debug_show_boxes = toggled_on
