extends CanvasLayer

@onready var button_container := $Panel/UpgradeContainer

var this_is_dumb := 1

func _ready() -> void:
	# Upgrade 1-5 exists
	for i in button_container.get_children():
		if i is Button:
			i.connect("pressed", Callable(self, ("_on_upgrade_pressed_%d" %this_is_dumb)))
			i.connect("mouse_entered", Callable(self, "_on_upgrade_mouse_entered").bind(i))
			i.connect("mouse_exited", Callable(self, "_on_upgrade_mouse_exited").bind(i))
			this_is_dumb+=1  # Connect to speciifc... wait why didnt i just connect it from godot......
			
		else:
			print("You're not a button, ignored...")


func _on_upgrade_pressed_1() -> void:
	print("This is button 1 i swear to god dude.")	

func _on_upgrade_pressed_2() -> void:
	print("This is button 2 i swear to god dude.")

func _on_upgrade_pressed_3() -> void:
	print("This is button 3 i swear to god dude.")

func _on_upgrade_pressed_4() -> void:
	print("This is button 4 i swear to god dude.")

func _on_upgrade_pressed_5() -> void:
	print("This is button 5 i swear to god dude.")

func _on_upgrade_mouse_entered(button: Button) -> void:
	match button:
		%Upgrade1:
			print("ASBIUIDSUIFGIFSYGFIUYSGFYUSGFIUK")

	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1,1.1), 0.15).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_upgrade_mouse_exited(button: Button) -> void:
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
