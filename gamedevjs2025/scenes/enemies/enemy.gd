extends Node2D


# Health needs to be updated depending on the muscles upgrade for the 
# you got it bro!
# Player

@export var default_health = 4
var health = default_health
@export var speed := 15.0 # Pixels per second
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var audio : AudioStreamPlayer2D = $Audio
@onready var timer : Timer = $ZombieSoundCooldown

var player = null

var axe_enemy_hit_sfx =[
	preload("res://sounds/sfx/sword_hit_1.mp3"),
	preload("res://sounds/sfx/sword_hit_2.mp3"),
	preload("res://sounds/sfx/sword_hit_3.mp3")
]

var zombie_idle_sfx = [
	preload("res://sounds/sfx/zombie_sound_1.mp3"),
	preload("res://sounds/sfx/zombie_sound_2.mp3"),
	preload("res://sounds/sfx/zombie_sound_3.mp3")
]

func _ready():
	updateHp()
	timer.wait_time = randf_range(7, 16)
	timer.start()
	player = get_tree().get_first_node_in_group("player")
	if not player:
		printerr("Enemy cannot find player node!")
	
	Events.upgradeBought.connect(updateHp)

func updateHp():
	health = default_health - GlobalPlayerScript.enemyHpDebuff

func _process(delta):
	# Path finding
	if not is_instance_valid(player):
		return

	var direction = (player.global_position - global_position).normalized()
	
	global_position += direction * speed * delta

	if player.global_position.x < global_position.x:
		sprite.flip_h = true
	elif player.global_position.x > global_position.x:
		sprite.flip_h = false
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("axe"):
		health -= 1
		audio.stream = axe_enemy_hit_sfx[randi_range(0,2)]
		audio.play()

		if health <= 0:
			GlobalPlayerScript.current_total_ashes += randi_range(1,5)
			queue_free()

func _on_zombie_sound_cooldown_timeout() -> void:
	audio.stream = zombie_idle_sfx[randi_range(0,2)]
	audio.play()
	timer.wait_time = randf_range(7, 16)
	timer.start()
