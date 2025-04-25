extends Node

# Peace timer for around 4 minutees
# Enemy timer for around 1 minute.
var peace_duration := 240.0 # 4 minutes
var enemy_duration := 60.0  # 1 minute

func _ready() -> void:
	var current_scene = get_tree().current_scene
	var expected_script = load("res://scenes/mainPlayArea/main_scene.gd")
	if current_scene.get_script() == expected_script:
		print(">>> Peace begins.")
		start_peace_timer()
	else:
		print("No, its not the main scene.")

func start_peace_timer() -> void:
	GlobalPlayerScript.is_peace_time = true
	print("Peace time active for 4 minutes.")
	var peace_timer := get_tree().create_timer(peace_duration)
	peace_timer.connect("timeout", Callable(self, "_on_peace_timer_timeout"))

func start_enemy_timer() -> void:
	GlobalPlayerScript.is_peace_time = false
	print("Combat phase active for 1 minute.")
	var enemy_timer := get_tree().create_timer(enemy_duration)
	enemy_timer.connect("timeout", Callable(self, "_on_enemy_timer_timeout"))


# The recommended thought I have for this is that we use signals and connec these to the actual environment. I'm still unsure how to utilize signals, so I could
# use the extra help with this. - Daq_Vid
