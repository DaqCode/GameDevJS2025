extends CanvasLayer

@onready var amount_of_ashes := $Panel/AmountOfAshes
@onready var ash_timer := $AshCountTimer

var ash_count := 0

func _ready() -> void:
	ash_timer.start()
	Events.update_ash_count.connect(update_counter)

func _process(_delta):
	#820.0, 15.0
	$Panel.position = Vector2(randf_range(819.25, 820.75), randf_range(14.25,15.75))
	GlobalPlayerScript.current_total_ashes = ash_count
	amount_of_ashes.text = str(ash_count)

func _on_ash_count_timeout() -> void:
	ash_count+=1
	amount_of_ashes.text = str(ash_count)
	ash_timer.start()

func update_counter() -> void:
	GlobalPlayerScript.current_total_ashes = ash_count
	amount_of_ashes.text = str(ash_count)