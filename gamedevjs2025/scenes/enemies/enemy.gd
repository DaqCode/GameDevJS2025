extends Node2D

@export var speed := 15.0 # Pixels per second
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 

var player = null

func _ready():
	# Find the player node once when the enemy is ready.
	# Assumes the player is in the "player" group.
	player = get_tree().get_first_node_in_group("player")
	if not player:
		printerr("Enemy cannot find player node!")
		# Optionally disable processing if player not found
		# set_process(false) 

func _process(delta):
	# If player wasn't found initially or somehow disappeared, stop processing.
	if not is_instance_valid(player):
		return

	# 1. Calculate direction vector from enemy towards player
	var direction = (player.global_position - global_position).normalized()
	
	# 2. Move the enemy
	# Simple movement by directly changing position.
	# For physics interactions (collisions), you'd use CharacterBody2D and move_and_slide.
	global_position += direction * speed * delta

	if player.global_position.x < global_position.x:
		# Player is to the left, flip sprite to face left
		sprite.flip_h = true
	elif player.global_position.x > global_position.x:
		# Player is to the right, sprite faces right (default)
		sprite.flip_h = false
	
