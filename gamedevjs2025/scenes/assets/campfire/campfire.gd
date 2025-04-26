extends StaticBody2D

# The fire duration and their radius should
# change according to the upgrades...

@onready var progress_bar := %ProgressBar
@onready var label := %LiveTimer
@onready var timer:= $CampfireDeathTimer/FireburnTimer

var fire_duration : float = 60.0 # this is effected by upgrades
var fire_remaining : float = 60.0

var can_interact : bool = false

# might be better to do this system as an array but this works and its a jam
var plankBurnTimes = { # plank type : burn time (seconds)
	"type 0 plank": 1,
	"type 2 plank": 2,
	"type 1 plank": 3
}

var minEnergy = 0.5
var maxEnergy = 0.5

@onready var pointLight = $PointLight2D

func _ready() -> void:
	pointLight.texture_scale = GlobalPlayerScript.fireRaduiusBuff
	fire_duration = GlobalPlayerScript.fireMaxTimeBuff
	progress_bar.max_value = fire_duration
	timer.start()
	
	# to update values when an upgrade is bought. 
	Events.upgradeBought.connect(updateAfterUpgrade) 

func updateAfterUpgrade():
	fire_duration = GlobalPlayerScript.fireMaxTimeBuff
	progress_bar.max_value = fire_duration
	pointLight.texture_scale = GlobalPlayerScript.fireRaduiusBuff

func _process(_delta) -> void:
	pass
	# The middle is 25
	# The middle of the scale is Vector2(18.0, 13.59)
	#pointLight.energy = randf_range(minEnergy, maxEnergy)
	#pointLight.texture_scale = GlobalPlayerScript.fireRaduiusBuff
	
	if Input.is_action_just_pressed("interact") and can_interact:
		Events.emit_signal("open_upgrade")
	
	if fire_remaining > 0:
		fire_remaining -= _delta
		fire_remaining = max(fire_remaining, 0.0)
	elif fire_remaining<=0:
		get_tree().change_scene_to_file("res://scenes/UI/death.tscn")
	
	progress_bar.value = fire_remaining
	label.text = "%d:%02d / %d:%02d" % [
		int(fire_remaining) / 60,
		int(fire_remaining) % 60,
		int(fire_duration) / 60,
		int(fire_duration) % 60
	]
	
	# adding planks
	if can_interact and Input.is_action_just_pressed("equip_inventory_item_2"):
		tryAddPlnaks("type 0 plank")
	elif can_interact and Input.is_action_just_pressed("equip_inventory_item_3"):
		tryAddPlnaks("type 1 plank")
	elif can_interact and Input.is_action_just_pressed("equip_inventory_item_4"):
		tryAddPlnaks("type 2 plank")

func tryAddPlnaks(type):
	if GlobalPlayerScript.inventory[type] <= 0:
		return 
	GlobalPlayerScript.inventory[type] -= 1
	fire_remaining += plankBurnTimes[type]
	fire_remaining = min(fire_remaining,fire_duration)
	$WoodBurn.emitting = true

func _on_campfire_interract_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = true
		$InteractButton.visible = true

func _on_campfire_interract_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = false
		$InteractButton.visible = false

# THE UPGRADE FOR THE FURIOUS FIRE NEED TO UPDATE THE TIMER 
# IN THIS SCRIPT ESPECIALLY.
