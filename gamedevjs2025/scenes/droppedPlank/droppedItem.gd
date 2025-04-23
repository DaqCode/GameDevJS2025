extends Area2D

@onready var plank_texture := %PlankSprite
@onready var seed_texture := %SeedSprite

var tree_type
var plank_type
var item_type # this is either gonna be a plank or a seed
var pickupTime = 0.2

var plank_texture_texture = {
	0: preload("res://art/tree/tree1/plank.png"),
	1: preload("res://art/tree/tree1/plank.png"),
	2: preload("res://art/tree/tree3/blue-plank.png")
}

var seed_texture_texture = {
	0: preload("res://art/tree/tree1/acorn.png"),
	1: preload("res://art/tree/tree2/grey-acorn.png"),
	2: preload("res://art/tree/tree3/blue-acorn.png")
}

func _enter_tree() -> void:
	# on spawn set a random roation for visuals 
	rotation = randf_range(0,2*PI)

func _ready() -> void:
	if item_type == "plank":
		plank_texture.visible = true
		seed_texture.visible = false
		plank_texture.texture = plank_texture_texture.get(tree_type, preload("res://art/tree/tree1/acorn.png"))
	elif item_type == "seed":
		seed_texture.visible = true
		plank_texture.visible = false
		seed_texture.texture = seed_texture_texture.get(tree_type, preload("res://art/tree/tree1/acorn.png"))
	# at the start loop through all the thing that are already in area and call needed func. 
	# this is for if the player is already in the area, where body_entered wont work
	for bod in get_overlapping_bodies():
		checkBodys(bod)

	plank_texture.texture = plank_texture_texture.get(tree_type, preload("res://art/tree/tree1/plank.png"))

func _on_body_entered(body: Node2D) -> void:
	checkBodys(body)


func checkBodys(body: Node2D):
	if body.is_in_group("player"):
		#tween to move to player
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",body.position,pickupTime)
		tween.tween_property(self,"modulate",Color8(255,255,255,0),pickupTime)
		await tween.finished # when done...
		# this is kinda bad code below
		var itemName = item_type
		if item_type == "seed": # this is to give the item the right name
			itemName = "type " + str(tree_type) + " " + item_type
		Events.add_inventory_item.emit(itemName) #this will be somthing like: "type 1 planks"EASE_IN
		print("picked up " + itemName)
		queue_free()
