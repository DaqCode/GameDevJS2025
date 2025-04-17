extends Node2D

@onready var player = $Bron
var TreeScene = preload("res://scenes/assets/trees/tree_types.tscn")

# Spawn with following conditions
# - in the global position between : 428.0, 156.0  and 892.0, 406.0.
# - Never in the global position between: 631.0, 265.0    and 719.0 322.0
# - Each of these trees need to be instantiated, and connected to a signal for the player to chop down.

func _ready() -> void:
	for i in range(randi_range(5, 8)):
		var tree = TreeScene.instantiate()
		add_child(tree)

		var pos = generate_valid_tree_position()
		tree.global_position = pos

		tree.connect("ready_to_chop", player._on_tree_ready_to_chop)
		tree.connect("done_chopping", player._on_tree_done_chopping)
		print (str(tree.global_position) + " is tree " + str(i) + " position....")

func generate_valid_tree_position() -> Vector2:
	while true:
		var pos = Vector2(randf_range(428.0, 892.0), randf_range(156.0, 406.0))
		if not is_in_campfire_zone(pos):
			return pos

	return Vector2.ZERO
	

func is_in_campfire_zone(pos: Vector2) -> bool:
	return pos.x >= 631.0 and pos.x <= 719.0 and pos.y >= 265.0 and pos.y <= 322.0
