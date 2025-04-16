extends Node

@onready var peace_timer := $PeaceTimer
@onready var enemy_timer := $EnemySpawnTimer

func _ready() -> void:
	print("successful began to start the peace timer")
	peace_timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
	print("enemy spawn done, peace time")
	peace_timer.start()
	enemy_timer.stop()
	GlobalPlayerScript.is_peace_time = true


func _on_peace_timer_timeout() -> void:
	print("Peace timer gone, enemy spawn begin")
	peace_timer.stop()
	enemy_timer.start()
	GlobalPlayerScript.is_peace_time = false

# The recommended thought I have for this is that we use signals and connec these to the actual environment. I'm still unsure how to utilize signals, so I could
# use the extra help with this. - Daq_Vid