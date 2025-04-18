extends Node2D

@onready var player = $Bron
var TreeScene = preload("res://scenes/assets/trees/tree_types.tscn")


var placed_positions: Array = []
const MIN_TREE_SEPARATION := 60

# Spawn with following conditions
# - in the global position between : 428.0, 156.0  and 892.0, 406.0.
# - Never in the global position between: 631.0, 265.0    and 719.0 322.0
# - Each of these trees need to be instantiated, and connected to a signal for the player to chop down.

func _ready() -> void:
	for i in range(randi_range(3, 7)):
		var tree = TreeScene.instantiate()
		add_child(tree)

		while true:
			var pos = Vector2(randf_range(428, 892), randf_range(156, 406))
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
		# print("Tree %d at %s" % [i, tree.pos])


func is_in_campfire_zone(pos: Vector2) -> bool:
	return pos.x >= 631.0 and pos.x <= 719.0 and pos.y >= 265.0 and pos.y <= 322.0
