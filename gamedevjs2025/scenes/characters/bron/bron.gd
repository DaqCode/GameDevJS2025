extends CharacterBody2D

@export var speed := 200
var default_speed := 200

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var axe_damage_area: Area2D = %AxeDamageArea
@onready var collision_shape_2d: CollisionShape2D = $Axe/AxeDamageArea/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var axe_sprite: Sprite2D = $Axe/AxeSprite
@onready var axe: Node2D = $Axe

var near_tree: Node = null
var chopping := false


func _input(input: InputEvent) -> void:
	if input.is_action_pressed("interact"):
		if not animation_player.is_playing():
			print("playing.....")
			chop_tree()
	
	if input.is_action_released("interact"):
		stop_chopping_tree()
		

func _physics_process(_delta: float) -> void:
	if chopping:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_direction := Vector2.ZERO

	if Input.is_action_pressed("right"):
		input_direction.x += 1
	if Input.is_action_pressed("left"):
		input_direction.x -= 1
	if Input.is_action_pressed("down"):
		input_direction.y += 1
	if Input.is_action_pressed("up"):
		input_direction.y -= 1
		

	input_direction = input_direction.normalized()
	velocity = input_direction * speed

	if input_direction.x > 0:
		animated_sprite_2d.flip_h = false
		axe.scale.x = 1
	elif input_direction.x < 0:
		animated_sprite_2d.flip_h = true
		axe.scale.x = -1
	
	if input_direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
	
	move_and_slide()


func chop_tree() -> void:
	animation_player.play("chop")


func stop_chopping_tree() -> void:
	animation_player.play("idle")


# This is called when leaving tree area
func _on_tree_done_chopping() -> void:
	near_tree = null	
	queue_free()


func tree_chopped() -> void:
	print("He started cutting, now i will wait for the timer to expire and then hit the queu free.")
	if near_tree:
		near_tree.tree_chopped()
		near_tree = null
	chopping = false


func _on_bron_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Tree"):
		print("Can trop tree now")


func _on_bron_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
