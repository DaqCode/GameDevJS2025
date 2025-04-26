extends Node2D

@onready var player = $Bron
var TreeScene = preload("res://scenes/assets/trees/tree_types.tscn")


var placed_positions: Array = []
const MIN_TREE_SEPARATION := 60

# Spawn with following conditions
# - in the global position between : 428.0, 156.0  and 892.0, 406.0.
# - Never in the global position between: 631.0, 265.0    and 719.0 322.0
# - Each of these trees need to be instantiated, and connected to a signal for the player to chop down.

var minTrees = 50
var maxTrees = 100

func _ready() -> void:
	Events.tree_chopped_down.connect(spawn_tree)
	reset_game()
	$AshCountForLater.start()
	spawn_trees()
	#Events.spawnTrees.connect(spawn_trees)

func spawn_trees():
	for i in range(randi_range(minTrees, maxTrees)):
		spawn_tree()
		# print("Tree %d at %s" % [i, tree.pos])

func spawn_tree() -> void:
	print("Another Tree Spawned")
	var tree = TreeScene.instantiate()
	
	# ----------------------------------------------------------
	# TODO 
	# E 0:00:11:904   main_scene.gd:28 @ spawn_tree(): 
	# Can't change this state while flushing queries. Use call_deferred() 
	# or set_deferred() to change monitoring state instead.
	# ----------------------------------------------------------


	add_child(tree)
	var imCrashingOUt = 1
	while true:
		var xRange = 892*imCrashingOUt
		var yRange = 406*imCrashingOUt
		var xOffset = randf_range(-xRange,xRange)
		var yOffset = randf_range(-yRange,yRange)
		var pos = Vector2(position.x + xOffset,position.y + yOffset)
		if is_in_campfire_zone(pos):
			continue

		var safe := true
		for other_pos in placed_positions:
			if pos.distance_to(other_pos) < MIN_TREE_SEPARATION:
				safe = false
				break
		if not safe:
			# too close, pick again
			continue  

		placed_positions.append(pos)
		tree.global_position = pos
		break


func is_in_campfire_zone(pos: Vector2) -> bool:
	return pos.x >= 631.0 and pos.x <= 719.0 and pos.y >= 265.0 and pos.y <= 322.0

func _on_ash_count_for_later_timeout() -> void:
	GlobalPlayerScript.total_ashes_throughout += 1
	GlobalPlayerScript.current_total_ashes += 1


func reset_game() -> void:
	GlobalPlayerScript.lumb_mus_upgrade = 0
	GlobalPlayerScript.loc_eco_upgrade = 0
	GlobalPlayerScript.fur_fire_upgrade = 0
	GlobalPlayerScript.angry_mus_upgrade  = 0
	GlobalPlayerScript.speed_leg_upgrade = 0

	GlobalPlayerScript.current_total_ashes = 0
	GlobalPlayerScript.total_ashes_throughout = 0
	GlobalPlayerScript.is_peace_time = true


	GlobalEnemySpawnerTimer.peace_duration = 240.0
	GlobalEnemySpawnerTimer.enemy_duration = 60.0
	GlobalEnemySpawnerTimer._ready()
	
