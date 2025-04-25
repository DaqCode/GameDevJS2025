extends Node2D

@export var speed := 15.0 # Pixels per second
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if not player:
		printerr("Enemy cannot find player node!")


func _process(delta):
	if not is_instance_valid(player):
		return

	var direction = (player.global_position - global_position).normalized()
	
	global_position += direction * speed * delta

	if player.global_position.x < global_position.x:
		sprite.flip_h = true
	elif player.global_position.x > global_position.x:
		sprite.flip_h = false
	
