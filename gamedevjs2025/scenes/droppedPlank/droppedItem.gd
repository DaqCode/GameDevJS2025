extends Area2D

@export var spritePath : NodePath
var sprite : Node

@export var treeTypeTextures : Array[Texture2D]
# load this up with the images that correspond to tree type

var tree_type
var plank_type
var item_type # this is either gonna be a plank or a seed
var pickupTime = 0.2

func _enter_tree() -> void:
	# on spawn set a random roation for visuals 
	rotation = randf_range(0,2*PI)

func _ready() -> void:
	# at the start loop through all the thing that are already in area and call needed func. 
	# this is for if the player is already in the area, where body_entered wont work
	sprite = get_node(spritePath)
	sprite.texture = treeTypeTextures[tree_type]
	for bod in get_overlapping_bodies():
		checkBodys(bod)

func _on_body_entered(body: Node2D) -> void:
	checkBodys(body)

func checkBodys(body: Node2D):
	if body.is_in_group("player"):
		#tween to move to player
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",body.position,pickupTime)
		tween.tween_property(self,"modulate",Color8(255,255,255,0),pickupTime)
		await tween.finished # when done...
		
		# THIS IS TEMP DM ME WHEN WRITING INVENTORY CODE AND WE CAN TALK
		# this is kinda bad code below
		var itemName = "type " + str(tree_type) + " " + item_type
		Events.add_inventory_item.emit(itemName) #this will be somthing like: "type 1 planks"EASE_IN
		#print("picked up " + itemName)
		queue_free()
