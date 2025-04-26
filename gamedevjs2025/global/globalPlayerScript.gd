extends Node

var is_peace_time : bool = true

var lumb_mus_upgrade : int = 0
# Lvl 0: 3 hits
# Lvl 1: 2 hits
# Lvl 2: 1 hits
# Lvl 3: 1 hits  + 1 plankn

var loc_eco_upgrade : int = 0
# Lvl 0: 0 second Delay
# Lvl 1: 2.5 second Delay
# Lvl 2: 4 second Delay
# Lvl 3: 5 second Delay

var fur_fire_upgrade : int = 0
# Lvl 0: 1:00 death, text scale = 9.0
# Lvl 1: 1:45 death, text scale = 14.0
# Lvl 2: 2:15 death, text scale = 20.0
# Lvl 3: 2:30 death, text scale = 40.0


var angry_mus_upgrade : int = 0
# Lvl 0: 4 Hits to kill
# Lvl 1: 3 Hits to kill
# Lvl 2: 2 Hits to kill
# Lvl 3: 1 Hits to kill

var speed_leg_upgrade : int = 0
# Lvl 0: 75 speed
# Lvl 1: 90 speed
# Lvl 2: 109 speed
# Lvl 3: 131 speed

# could change this later to also inclde seeds?
var inventory = {
	"type 0 plank": 0,
	"type 1 plank": 0,
	"type 2 plank": 0,
	
	"type 0 acorn": 0,
	"type 1 acorn": 0,
	"type 2 acorn": 0
}


@export var current_total_ashes: int = 0
@export var total_ashes_throughout: int = 0

func _ready() -> void:
	Events.add_inventory_item.connect(addInventoryItem)

# connected to drop item signal emited by the dropped item scene 
func addInventoryItem(name):
	# if items not a type in the invetory dict return
	if !inventory.keys().has(name):
		return
	inventory[name] += 1
