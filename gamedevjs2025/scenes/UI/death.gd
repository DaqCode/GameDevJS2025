extends Control

@onready var button_container: = $GameOverScreen/ButtonRetry

func _ready() -> void:
	$GameOverScreen/TotalAshes.text = "Total ashes: %d" %GlobalPlayerScript.total_ashes_throughout

	if 0 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 70:
		$GameOverScreen/PersonalWords.text = "Are you serious..? How? Or is it the newbie's fault..."
	elif 71 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 150:
		$GameOverScreen/PersonalWords.text = "You're getting there. There can be more done, but keep going!"
	elif 151 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout  < 300:
		$GameOverScreen/PersonalWords.text = "Damn. Lived longer than we would have when the newbie tried to debug."
	elif 301 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 500:
		$GameOverScreen/PersonalWords.text = "You lived a lot longer than the previous longer than we would have thought. Well done flamer."
	elif 501 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 600:
		$GameOverScreen/PersonalWords.text = "Almost. You just had to last a little bit more longer, and you'll be the new flame-ster."
	elif GlobalPlayerScript.total_ashes_throughout > 600:
		$GameOverScreen/PersonalWords.text = "Wow. How did you get this far..? Eh, we don't have much else to say. Congradulations on your promotion."
	else:
		$GameOverScreen/PersonalWords.text = "Bro what.  get back to coding..."
	
	for container in button_container.get_children():
		for child in container.get_children():
			if child is Button:
				child.connect("pressed", Callable(self, ("_pressed")).bind(child))
				child.connect("mouse_entered", Callable(self, "_mouse_entered").bind(child))
				child.connect("mouse_exited", Callable(self, "_mouse_exited").bind(child))
				print(child)
			else:
				print("One of them didnt connect")

func _pressed(button: Button) -> void:
	if button == %RetryGame:
		get_tree().change_scene_to_file("res://scenes/UI/main_scene.tscn")
	elif button == %BackToMenu:
		get_tree().change_scene_to_file("res://scenes/UI/menu/menu.tscn")

func _mouse_entered(button: Button) -> void:
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0,1.0), 0.15).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


func _mouse_exited(button: Button) -> void:
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
