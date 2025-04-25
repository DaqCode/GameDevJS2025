extends StaticBody2D

@onready var tree_texture := $TreeTexture
@onready var tree_area_collision : Area2D = $TreeSpacingArea
@onready var regrow_time: Timer = %RegrowTime
@onready var interact_button: TextureRect = $InteractButton
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var dropped_plank_preload = preload("res://scenes/droppedPlank/dropped_plank.tscn")
@onready var dropped_seed_preload = preload("res://scenes/droppedSeed/dropped_seeds.tscn")
@onready var tree_col_shape = $TreeCollisionShape

signal ready_to_chop
signal begin_waiting_until_chop
signal done_chopping


enum TreeTypes{
	TREE_1,
	TREE_2,
	TREE_3
}

 
var rng := RandomNumberGenerator.new()
var tree_type := TreeTypes.TREE_1

var can_be_chopped := false
var tree_already_chopped := false

var current_stage := 1
var tree_health := 3

var drop_range = 5

var tree_data = {

	TreeTypes.TREE_1: {
		"tree_sprite": preload("res://art/tree/tree1/stage-1-tree.png"),
		"seed_drops": [0.15,0.85],
		"seed_value": [0,1],
		"plank_drops": [0.35,0.35,0.30],
		"plank_value": [3,4,5],
		"regrow_min": 15,
		"regrow_max": 20
	},

	TreeTypes.TREE_2: {
		"tree_sprite": preload("res://art/tree/tree2/stage-2-tree.png"),
		"seed_drops": [0.10,0.90],
		"seed_value": [1,2],
		"plank_drops": [0.40, 0.50,0.10],
		"plank_value": [3,5,8],
		"regrow_min": 20,
		"regrow_max": 30

	},

	TreeTypes.TREE_3: {
		"tree_sprite": preload("res://art/tree/tree3/stage-3-tree.png"),
		"seed_drops": [0.50, 0.35, 0.15],
		"seed_value": [3, 2, 1],
		"plank_drops": [1.0],
		"plank_value": [7],
		"regrow_min": 30,
		"regrow_max": 60
	},
}

var tree_sprite_offset := {
	"stage_1": Rect2(0, 0, 64, 64),
	"stage_2": Rect2(64, 0, 64, 64),
	"stage_3": Rect2(128, 0, 64, 64),
	"stage_4": Rect2(192, 0, 64, 64),
	"chopped": Rect2(256, 0, 64, 64)
}

func _ready() -> void:	
	regrow_time.wait_time = randf_range(1.0, 5.0)
	regrow_time.start()
	rng.randomize()
	var roll = rng.randf()
	if roll < 0.6:
		tree_type = TreeTypes.TREE_1
		
	elif roll < 0.9:
		tree_type = TreeTypes.TREE_2
	else:
		tree_type = TreeTypes.TREE_3
	
	_update_health_bar()

	# Set the modulated crops.
	tree_texture.texture = tree_data[tree_type]["tree_sprite"]
	tree_texture.region_rect = tree_sprite_offset["stage_1"]

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
	if tree_already_chopped or not can_be_chopped:
		return
		
	if tree_health > 1:
		tree_health -= 1
		_update_health_bar()
		return
		
	var data = tree_data[tree_type]

	# SEEDS
	var seed_roll = rng.randf()
	var seed_amount = 0
	var seed_probs = data["seed_drops"]
	for i in range(seed_probs.size()):
		seed_roll -= seed_probs[i]
		if seed_roll <= 0:
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

	var seed_value = data["seed_value"][seed_amount]
	var plank_value = data["plank_value"][plank_amount]

	print("CHOPPING: %s" % get_tree_name(tree_type))
	print("Dropped Seeds: %d, Planks: %d" % [seed_value, plank_value])
	
	# loop to spawn in the dropped planksas
	dropItems(dropped_plank_preload,plank_value,"plank")
	dropItems(dropped_seed_preload,seed_value,"seed")

	emit_signal("begin_waiting_until_chop")
	interact_button.visible = false
	health_bar.visible = false
	can_be_chopped = false
	tree_already_chopped = true
	tree_texture.region_rect = tree_sprite_offset["chopped"]


func _update_health_bar() -> void:
	health_bar.value = tree_health

func dropItems(itemPreload,count,type):
	for i in range(count):
		var dropped_item = itemPreload.instantiate()
		dropped_item.tree_type = tree_type
		dropped_item.item_type = type
		dropped_item.position = tree_col_shape.global_position + Vector2(randf_range(-drop_range,drop_range),randf_range(-drop_range,drop_range)) # get rand pos to drop
		
		# Removed the get_tree().current_scene.add_child(dropped_item)
		# Recommended to use Call_defered due to physics blowing up...
		call_deferred("drop_item", dropped_item)

func _on_tree_interaction_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not tree_already_chopped and can_be_chopped:
			interact_button.visible = true
			health_bar.visible = true
		emit_signal("ready_to_chop", self)


func _on_tree_interaction_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_button.visible = false
		health_bar.visible = false

func tree_chopped() -> void:
	queue_free()


func _on_tree_interaction_area_entered(area: Area2D) -> void:
	if area.is_in_group("axe"):
		chop_tree()


func _on_regrow_time_timeout() -> void:
	if tree_already_chopped or current_stage >= 4:
		return
	
	current_stage += 1
	
	if current_stage == 4:
		can_be_chopped = true
	
	tree_texture.region_rect = tree_sprite_offset["stage_%s" % current_stage]

func drop_item(item: Node) -> void:
	get_tree().current_scene.add_child(item)