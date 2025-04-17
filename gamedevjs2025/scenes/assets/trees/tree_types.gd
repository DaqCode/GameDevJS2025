extends StaticBody2D

signal ready_to_chop
signal done_chopping

enum TreeTypes{
	TREE_1,
	TREE_2,
	TREE_3
}

var rng := RandomNumberGenerator.new()
var tree_type := TreeTypes.TREE_1

var can_be_chopped := true

var tree_data = {

	TreeTypes.TREE_1: {
		"seed_drops": [0.15,0.85],
		"seed_value": [0,1],
		"plank_drops": [0.35,0.35,0.30],
		"plank_value": [3,4,5],
		"regrow_min": 15,
		"regrow_max": 20
	},

	TreeTypes.TREE_2: {
		"seed_drops": [0.10,0.90],
		"seed_value": [1,2],
		"plank_drops": [0.40, 0.50,0.10],
		"plank_value": [3,5,8],
		"regrow_min": 20,
		"regrow_max": 30

	},

	TreeTypes.TREE_3: {
		"seed_drops": [0.50, 0.35, 0.15],
		"seed_value": [3, 2, 1],
		"plank_drops": [1.0],
		"plank_value": [7],
		"regrow_min": 30,
		"regrow_max": 60
	},
}

func _ready() -> void:	
	rng.randomize()
	var roll = rng.randf()
	if roll < 0.6:
		tree_type = TreeTypes.TREE_1
	elif roll < 0.9:
		tree_type = TreeTypes.TREE_2
	else:
		tree_type = TreeTypes.TREE_3

func get_tree_name(tree_enum: int) -> String:
	match tree_enum:
		TreeTypes.TREE_1:
			return "Tree Type 1"
		TreeTypes.TREE_2:
			return "Tree Type 2"
		TreeTypes.TREE_3:
			return "Tree Type 3"
		_:
			return "What the heck is this"

func chop_tree() -> void:
	var data = tree_data[tree_type]

	# SEEDS
	var seed_roll = rng.randf()
	var seed_amount = 0
	var seed_probs = data["seed_drops"]
	for i in range(seed_probs.size()):
		seed_roll -= seed_probs[i]
		if seed_roll <=0:
			seed_amount = i
			break

	# PLANKS
	var plank_roll = rng.randf()
	var plank_amount = 0
	var plank_prob = data["plank_drops"]
	for i in range(plank_prob.size()):
		plank_roll -= plank_prob[i]
		if plank_roll <= 0:
			plank_amount = i
			break

	# FOR DEBUGGING PURPOSES
	var seed_value = data["seed_value"][seed_amount]
	var plank_value = data["plank_value"][plank_amount]

	print("CHOPPING: %s" % get_tree_name(tree_type))
	print("Dropped Seeds: %d, Planks: %d" % [seed_value, plank_value])
# 	var wait_time = rng.randf_range(data["regrow_min"], data["regrow_max"])


func _on_tree_interraction_body_entered(body:Node2D) -> void:
	if body.name == "Bron":
		if can_be_chopped:
			chop_tree()
			emit_signal("ready_to_chop", self)
		print("Assume tree progress got killed, unless it is chopped down and queue_free is called...")

func _on_tree_interraction_body_exited(body:Node2D) -> void:
	if body.name == "Bron":
		emit_signal("done_chopping", self)
