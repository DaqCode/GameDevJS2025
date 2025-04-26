extends CanvasLayer

@onready var tree1_plank_count := %Tree1PlankAmount
@onready var tree1_acorn_count := %Tree1AcornAmount
@onready var tree2_plank_count := %Tree2PlankAmount
@onready var tree2_acorn_count := %Tree2AcornAmount
@onready var tree3_plank_count := %Tree3PlankAmount
@onready var tree3_acorn_count := %Tree3AcornAmount

func _ready() -> void:

	# reset each of the acorn and plank to 0
	# these should have a value to remember to 
	# emit as a text.
	GlobalPlayerScript.inventory["type 0 plank"] = 0
	GlobalPlayerScript.inventory["type 1 plank"] = 0
	GlobalPlayerScript.inventory["type 2 plank"] = 0

	GlobalPlayerScript.inventory["type 0 seed"] = 0
	GlobalPlayerScript.inventory["type 1 seed"] = 0
	GlobalPlayerScript.inventory["type 2 seed"] = 0

func _process(_delta: float) -> void:
	tree1_plank_count.text = str(GlobalPlayerScript.inventory["type 0 plank"])
	tree2_plank_count.text = str(GlobalPlayerScript.inventory["type 1 plank"])
	tree3_plank_count.text = str(GlobalPlayerScript.inventory["type 2 plank"])

	tree1_acorn_count.text = str(GlobalPlayerScript.inventory["type 0 seed"])
	tree2_acorn_count.text = str(GlobalPlayerScript.inventory["type 1 seed"])
	tree3_acorn_count.text = str(GlobalPlayerScript.inventory["type 2 seed"])
