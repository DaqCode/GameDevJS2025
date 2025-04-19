extends CanvasLayer

@onready var button_container := $Panel/UpgradeContainer

var this_is_dumb := 1

func _ready() -> void:
	# Upgrade 1-5 exists
	for i in button_container.get_children():
		i.connect("pressed", Callable(self, ("_on_upgrade_pressed_%d" %this_is_dumb)))
		this_is_dumb+=1  # Connect to speciifc... wait why didnt i just connect it from godot......


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
