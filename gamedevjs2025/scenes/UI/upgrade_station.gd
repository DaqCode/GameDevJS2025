extends CanvasLayer

@onready var button_container := $Panel/UpgradeContainer

@onready var upgrade_1 := %Upgrade1
@onready var upgrade_2 := %Upgrade2
@onready var upgrade_3 := %Upgrade3
@onready var upgrade_4 := %Upgrade4
@onready var upgrade_5 := %Upgrade5

@onready var exit := %Exit

@onready var upgrade_description := %Description
@onready var upgrade_stat_upgrade := %StatDescription
@onready var ash_cost := %AshCost


var is_checking_stats : bool = false
var can_afford : bool = false

var current_ash_cost := GlobalPlayerScript.current_total_ashes

# Dictionary for costs for eeach upgrade3
var upgrade_cost_dict = {
	"upgrade_1": [25, 55, 80],
	"upgrade_2": [30, 70, 100],
	"upgrade_3": [45, 90, 165],
	"upgrade_4": [50, 100, 175,],
	"upgrade_5": [100, 250, 600]
}

var upgrade_var_map = {
	"upgrade_1": "lumb_mus_upgrade",
	"upgrade_2": "loc_eco_upgrade",
	"upgrade_3": "angry_mus_upgrade",
	"upgrade_4": "speed_leg_upgrade",
	"upgrade_5": "fur_fire_upgrade"
}

func _ready() -> void:
	# self.visible = false
	# Upgrade 1-5 exists
	for i in button_container.get_children():
		if i is Button:
			i.connect("pressed", Callable(self, ("_on_upgrade_pressed")).bind(i))
			i.connect("mouse_entered", Callable(self, "_on_upgrade_mouse_entered").bind(i))
			i.connect("mouse_exited", Callable(self, "_on_upgrade_mouse_exited").bind(i))
		else:
			print("You're not a button, ignored...")

	check_affordability()

func _process(_delta: float) -> void:
	check_affordability()

# stat_var: String, cost_var: String, button: Button
func _on_upgrade_pressed(button: Button) -> void:
	match button:
		upgrade_1:
			_handle_upgrade_press("lumb_mus_upgrade", %Upgrade1)
		upgrade_2:
			_handle_upgrade_press("loc_eco_upgrade", %Upgrade2)
		upgrade_3:
			_handle_upgrade_press("angry_mus_upgrade", %Upgrade3)
		upgrade_4:
			_handle_upgrade_press("speed_leg_upgrade", %Upgrade4)
		upgrade_5:
			_handle_upgrade_press("fur_fire_upgrade", %Upgrade5)

func _on_upgrade_mouse_entered(button: Button) -> void:
	is_checking_stats = true
	print_upgrade_for_debug()
	match button:
		upgrade_1:
			upgrade_description.text = "You can chop trees faster."
			match GlobalPlayerScript.lumb_mus_upgrade:
				0:
					upgrade_stat_upgrade.text = "3 Hits -> 2 Hits"
					ash_cost.text =  "Ash cost: 25"
				1:
					upgrade_stat_upgrade.text = "2 Hits -> 1 Hit"
					ash_cost.text = "Ash cost: 55"
				2:
					upgrade_stat_upgrade.text = "1 Hit -> 1 Hit + 2+ Extra planks"
					ash_cost.text = "Ash cost: 80"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_2:
			upgrade_description.text = "Trees grow faster."
			match GlobalPlayerScript.loc_eco_upgrade:
				0:
					upgrade_stat_upgrade.text = "0 Second Delay -> 2.5 Second Delay"
					ash_cost.text =  "Ash cost: 30"
				1:
					upgrade_stat_upgrade.text = "2.5 Second Delay -> 4 Second Delay"
					ash_cost.text = "Ash cost: 70"
				2:
					upgrade_stat_upgrade.text = "4 Second Delay -> 5 Second Delay"
					ash_cost.text = "Ash cost: 100"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_3:
			upgrade_description.text = "Become stronger against enemies that disturb your fire."
			match GlobalPlayerScript.angry_mus_upgrade:
				0:
					upgrade_stat_upgrade.text = "6 Hits to Kill -> 5 Hits to Kill"
					ash_cost.text =  "Ash cost: 45"
				1:
					upgrade_stat_upgrade.text = "5 Hits to Kill -> 3 Hits to Kill"
					ash_cost.text = "Ash cost: 90"
				2:
					upgrade_stat_upgrade.text = "3 Hits to Kill -> 2 Hits to Kill"
					ash_cost.text = "Ash cost: 165"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_4:
			upgrade_description.text = "You become faster by becoming featherweight."
			match GlobalPlayerScript.speed_leg_upgrade:
				0:
					# Speed to 75 -> 90
					upgrade_stat_upgrade.text = "0% speed increase -> 20% speed increase"
					ash_cost.text =  "Ash cost: 50"
				1:
					# Speed to 109
					upgrade_stat_upgrade.text = "20% speed increase -> 45% speed increase"
					ash_cost.text = "Ash cost: 100"
				2:
					# Speed to 131
					upgrade_stat_upgrade.text = "45% speed increase -> 75% speed increase"
					ash_cost.text = "Ash cost: 175"
				_:
					upgrade_stat_upgrade.text = "MAX"
					ash_cost.text = "———"
		upgrade_5:
			upgrade_description.text = "Increase light radius and burn time."
			match GlobalPlayerScript.fur_fire_upgrade:
				0:
					upgrade_stat_upgrade.text = "1:00 death -> 1:45 death"
					ash_cost.text =  "Ash cost: 100"
				1:
					upgrade_stat_upgrade.text = "1:45 death -> 2:15 death"
					ash_cost.text = "Ash cost: 250"
				2:
					upgrade_stat_upgrade.text = "2:15 death -> 2:30 death"
					ash_cost.text = "Ash cost: 600"
				_:
					upgrade_stat_upgrade.text = "You reached the end..."
					ash_cost.text = "———"
		

	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1,1.1), 0.15).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_upgrade_mouse_exited(button: Button) -> void:
	is_checking_stats = false
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	upgrade_description.text = "Hover over the upgrades to get a description"
	upgrade_stat_upgrade.text = "Hover to get stat upgrade"
	ash_cost.text = "Hover to get ash cost"

func _on_exit_pressed() -> void:
	self.visible = false

func get_upgrade_cost(upgrade_name: String, current_level: int) -> int:
	if upgrade_name in upgrade_cost_dict:
		var costs = upgrade_cost_dict[upgrade_name]
		if current_level <costs.size():
			return costs[current_level]
	return -1 # Only should realisticlly return if it's maxed out...

func check_affordability() -> void:
	var current_ash = GlobalPlayerScript.current_total_ashes
	for button in button_container.get_children():
		if button is Button:
			var upgrade_name = button.name.to_lower()
			var upgrade_id = upgrade_name.replace("upgrade", "upgrade_")
			# var level = get_player_upgrade_level(upgrade_id)
			# Need to write the function for getting player upgrade levels.
			
			var current_level = get_player_upgrade_level(upgrade_id)
			var next_cost = get_upgrade_cost(upgrade_id, current_level)
			button.disabled = next_cost == -1 or current_ash < next_cost



func get_player_upgrade_level(upgrade_id: String) -> int:
	if upgrade_id in upgrade_var_map:
		var var_name = upgrade_var_map[upgrade_id]
		return GlobalPlayerScript.get(var_name)
	return -1

func _handle_upgrade_press(upgrade_var_name: String, button: Button) -> void:
	if GlobalPlayerScript.get(upgrade_var_name) < 3:
		GlobalPlayerScript.current_total_ashes -= get_upgrade_cost(upgrade_var_name, GlobalPlayerScript.get(upgrade_var_name))
		Events.update_ash_count.emit()
		GlobalPlayerScript.set(upgrade_var_name, GlobalPlayerScript.get(upgrade_var_name)+1)
		_on_upgrade_mouse_entered(button)

		check_affordability()	

func print_upgrade_for_debug() -> void:
	for upgrades in upgrade_cost_dict:
		var current_upgrade = get_player_upgrade_level(upgrades)
		print ("--------------------------------")
		print( str(upgrades) + " | Level " + str(get_player_upgrade_level(upgrades))+ " | Next Cost: " + str(get_upgrade_cost(upgrades, current_upgrade)))
	print (" ----- ")
	print (" ----- ")
	print (" ----- ")
	print (" ----- ")
	print (" ----- ")
