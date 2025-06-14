extends CharacterBody2D

@export var default_speed := 60 # dropped this for balence - Ford
var speed = default_speed

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var axe_damage_area: Area2D = %AxeDamageArea
@onready var collision_shape_2d: CollisionShape2D = $AnimatedSprite2D/Axe/AxeDamageArea/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var axe_sprite: Sprite2D = $AnimatedSprite2D/Axe/AxeSprite
@onready var axe: Node2D = $AnimatedSprite2D/Axe


@onready var audio: AudioStreamPlayer2D = $Audio

@onready var treePrealod = preload("res://scenes/assets/trees/tree_types.tscn")

var walk_sfx = [
	preload("res://sounds/sfx/foot_step_1.mp3"),
	preload("res://sounds/sfx/foot_step_2.mp3"),
	preload("res://sounds/sfx/foot_step_3.mp3")
]

var inFire = false

var near_tree: Node = null
var chopping := false
var facing_right = true
func _ready() -> void:

	Events.connect("open_upgrade", Callable(self, "_open_upgrade_menu"))
	
	Events.upgradeBought.connect(updateSpeed)

func updateSpeed():
	print("=========================================================")
	speed = default_speed + GlobalPlayerScript.speedBuff

func _input(input: InputEvent) -> void:
	if input.is_action_pressed("interact"):
		chop_tree()
	
	if input.is_action_released("interact"):
		print("STOP!!!!")
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

	if audio.is_playing() == false and input_direction != Vector2.ZERO:
		audio.stream = walk_sfx[randi_range(0,2)]
		audio.play()

	input_direction = input_direction.normalized()
	velocity = input_direction * speed

	if input_direction.x > 0:
		#animated_sprite_2d.flip_h = false
		animated_sprite_2d.scale.x = 2.5
	elif input_direction.x < 0:
		#animated_sprite_2d.flip_h = true
		animated_sprite_2d.scale.x = -2.5
	
	if input_direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
	
	move_and_slide()

func _process(delta: float) -> void:
	if !inFire and Input.is_action_just_pressed("equip_inventory_item_2"):
		tryPlantTree(0,"type 0 seed")
	elif !inFire and Input.is_action_just_pressed("equip_inventory_item_3"):
		tryPlantTree(1,"type 1 seed")
	elif !inFire and Input.is_action_just_pressed("equip_inventory_item_4"):
		tryPlantTree(2,"type 2 seed")

func tryPlantTree(type,typeName):
	if GlobalPlayerScript.inventory[typeName] <= 0:
		return
	GlobalPlayerScript.inventory[typeName] -= 1
	var tree = treePrealod.instantiate()
	tree.global_position = global_position
	tree.forceType = type
	add_sibling(tree)

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
	print("Shouldn't be important, leave it as it is")
	# Not sure why this was put, but i suppose this shoould be put in for now.	

func _open_upgrade_menu() -> void:
	$UpgradeStation.visible = true
