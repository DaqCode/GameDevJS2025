extends Control


func _ready() -> void:
	for i in %ButtonContainer.get_children():
		if i is Button:
			i.connect("pressed", Callable(self, "on_button_pressed"))
			i.connect("mouse_entered", Callable(self, "on_button_entered").bind(i))
			i.connect("mouse_exited", Callable(self, "on_button_exited").bind(i))


func on_button_pressed() -> void:
	pass

func on_button_entered(button: Button) -> void:
	button.pivot_offset = Vector2(194, 32)

	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1,1.1), 0.15).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


func on_button_exited(button: Button) -> void:
	b	utton.pivot_offset = Vector2(194, 32)
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	

#328, 64
# haalf is 194, 32
