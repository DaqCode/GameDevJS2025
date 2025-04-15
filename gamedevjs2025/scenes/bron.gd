extends CharacterBody2D

@export var speed := 200

func _physics_process(_delta: float) -> void:
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
	move_and_slide()
