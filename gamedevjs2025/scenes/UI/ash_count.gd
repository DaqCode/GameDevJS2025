extends CanvasLayer

@onready var amount_of_ashes := $Panel/AmountOfAshes
@onready var ash_timer := $AshCountTimer

func _ready() -> void:
	ash_timer.start()

func _process(_delta):
	$Panel.position = Vector2(randf_range(819.25, 820.75), randf_range(14.25,15.75))
	amount_of_ashes.text = str(GlobalPlayerScript.current_total_ashes)
