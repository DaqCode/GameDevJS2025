extends CharacterBody2D

@export var speed := 200
var default_speed := 200

@onready var chopping_tree_timer := $AxeChopping
var near_tree: Node = null
var chopping := false

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

	if Input.is_action_just_pressed("interact") and near_tree != null:
		chopping = true
		near_tree.chop_tree()
		chopping_tree_timer.start()

	input_direction = input_direction.normalized()
	velocity = input_direction * speed	
	move_and_slide()

# This is called when entering tree area
func _on_tree_ready_to_chop(tree: Node) -> void:
	near_tree = tree
	if not tree.is_connected("begin_waiting_until_chop", Callable(self, "tree_chopped")):
		tree.connect("begin_waiting_until_chop", Callable(self, "tree_chopped"))


# This is called when leaving tree area
func _on_tree_done_chopping() -> void:
	near_tree = null	
	queue_free()


func _on_axe_chopping_timeout() -> void:
	chopping = false

func tree_chopped() -> void:
	print("He started cutting, now i will wait for the timer to expire and then hit the queu free.")
	await chopping_tree_timer.timeout
	if near_tree:
		near_tree.tree_chopped()
		near_tree = null
	chopping = false
