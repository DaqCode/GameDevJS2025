extends Node2D


@export var spawn_progress_bar: TextureProgressBar
@export var peace_time := 10.0
@export var num_enemies_to_spawn := 3

@onready var enemy := preload("res://scenes/enemies/enemy.tscn")
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer



func _ready() -> void:
	enemy_spawn_timer.wait_time = peace_time
	spawn_progress_bar.max_value = peace_time
	enemy_spawn_timer.timeout.connect(spawn_enemy)
	enemy_spawn_timer.start()


func _process(_dt: float) -> void:
	spawn_progress_bar.value = enemy_spawn_timer.time_left


func spawn_enemy():
	for i in range(num_enemies_to_spawn): 
		var temp_enemy = enemy.instantiate()
		get_parent().add_child(temp_enemy)
		temp_enemy.global_position = get_random_offscreen_position()


func get_random_offscreen_position():
	var margin := 100
	var viewport_size = get_viewport_rect().size
	var camera := get_tree().get_first_node_in_group("bron_camera")
	if not camera:
		printerr("Error: Camera node 'bron_camera' not found!")
		return Vector2.ZERO 
		
	var zoom = camera.zoom
	var half_size = (viewport_size / zoom) * 0.5
	var cam_pos = camera.global_position

	var x_min = cam_pos.x - half_size.x
	var x_max = cam_pos.x + half_size.x
	var y_min = cam_pos.y - half_size.y
	var y_max = cam_pos.y + half_size.y

	var side = randi() % 4
	var spawn_pos = Vector2()

	match side:
		0:  # Top
			spawn_pos.x = randf_range(x_min, x_max)
			spawn_pos.y = y_min - margin
		1:  # Bottom
			spawn_pos.x = randf_range(x_min, x_max)
			spawn_pos.y = y_max + margin
		2:  # Left
			spawn_pos.x = x_min - margin
			spawn_pos.y = randf_range(y_min, y_max)
		3:  # Right
			spawn_pos.x = x_max + margin
			spawn_pos.y = randf_range(y_min, y_max)

	return spawn_pos
