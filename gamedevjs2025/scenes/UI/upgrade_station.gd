extends CanvasLayer

@onready var button_container := $Panel/UpgradeContainer

@onready var upgrade_1 := %Upgrade1
@onready var upgrade_2 := %Upgrade2
@onready var upgrade_3 := %Upgrade3
@onready var upgrade_4 := %Upgrade4
@onready var upgrade_5 := %Upgrade5

@onready var upgrade_description := %Description
@onready var upgrade_stat_upgrade := %StatDescription
@onready var ash_cost := %AshCost


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
		upgrade_1:
			upgrade_description.text = "Embed with checkered shirts, you now chop trees faster."
			match GlobalPlayerScript.lumb_mus_upgrade:
				1:
					upgrade_stat_upgrade.text = "3 Hits -> 2 Hits"
					ash_cost.text =  "Ash cost: 25"
				2:
					upgrade_stat_upgrade.text = "2 Hits -> 1 Hit"
					ash_cost.text = "Ash cost: 55"
				3:
					upgrade_stat_upgrade.text = "1 Hit -> 1 Hit + 2+ Extra planks"
					ash_cost.text = "Ash cost: 80"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_2:
			upgrade_description.text = "You told the soil to grow up. Now the trees grow faster."
			match GlobalPlayerScript.loc_eco_upgrade:
				1:
					upgrade_stat_upgrade.text = "0 Second Delay -> 2.5 Second Delay"
					ash_cost.text =  "Ash cost: 30"
				2:
					upgrade_stat_upgrade.text = "2.5 Second Delay -> 4 Second Delay"
					ash_cost.text = "Ash cost: 70"
				3:
					upgrade_stat_upgrade.text = "4 Second Delay -> 5 Second Delay"
					ash_cost.text = "Ash cost: 100"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_3:
			upgrade_description.text = "Become stronger against enemies that disturb your fire."
			match GlobalPlayerScript.angry_mus_upgrade:
				1:
					upgrade_stat_upgrade.text = "6 Hits to Kill -> 5 Hits to Kill"
					ash_cost.text =  "Ash cost: 45"
				2:
					upgrade_stat_upgrade.text = "5 Hits to Kill -> 3 Hits to Kill"
					ash_cost.text = "Ash cost: 90"
				3:
					upgrade_stat_upgrade.text = "3 Hits to Kill -> 2 Hits to Kill"
					ash_cost.text = "Ash cost: 165"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_4:
			upgrade_description.text = "You become faster by becoming featherweight."
			match GlobalPlayerScript.speed_leg_upgrade:
				1:
					# Speed to 75 -> 90
					upgrade_stat_upgrade.text = "0% speed increase -> 20% speed increase"
					ash_cost.text =  "Ash cost: 50"
				2:
					# Speed to 109
					upgrade_stat_upgrade.text = "20% speed increase -> 45% speed increase"
					ash_cost.text = "Ash cost: 100"
				3:
					# Speed to 131
					upgrade_stat_upgrade.text = "45% speed increase -> 75% speed increase"
					ash_cost.text = "Ash cost: 175"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_5:
			upgrade_description.text = "Increase light radius, but reduce burn time. More light, more adventure."
			match GlobalPlayerScript.fur_fire_upgrade:
				1:
					upgrade_stat_upgrade.text = "3:00 death -> 2:30 death."
					ash_cost.text =  "Ash cost: 100"
				2:
					upgrade_stat_upgrade.text = "2:30 death -> 2:15 death"
					ash_cost.text = "Ash cost: 250"
				3:
					upgrade_stat_upgrade.text = "2:15 death -> 2:00 death"
					ash_cost.text = "Ash cost: 600"
				_:
					upgrade_stat_upgrade.text = "You reached the end..."
					ash_cost.text = "———"
		

	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1,1.1), 0.15).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_upgrade_mouse_exited(button: Button) -> void:
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
