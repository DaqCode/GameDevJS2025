extends Node

var is_peace_time : bool = true

# HI so I did a lot of camel case by habbit, im just gonna leave it becasue im lazy and its late lol

var lumb_mus_upgrade : int = 0 :
	set(val): # if you dont know david, this is a set func, it will be called whenever this var is set (like when you do lumb_mus_upgrade = 2)
		var hpDebuffs = [0,1,2,2]
		var plankBounses = [0,0,0,1] # values of bouns across upgrades 
		treeHpDebuff = hpDebuffs[val]
		plankBonus = plankBounses[val]
		lumb_mus_upgrade = val # have to do this in a set func to update the vale
		Events.upgradeBought.emit() # emit our singal, I know calling this evey time is slightly ineffecent but its a jam game :D
# makes trees fall faster 
# Lvl 0: 3 hits, Lvl 1: 2 hits, Lvl 2: 1 hits, Lvl 3: 1 hits  + 1 plankn

# both used to buff players choping, used in tree_type script
var treeHpDebuff = 0
var plankBonus = 0

var loc_eco_upgrade : int = 0 :
	set(val):
		var growBuffs = [0,1,2,3.5] # changed this a bit becasue if felt OP
		treeGrowBonus = growBuffs[val]
		loc_eco_upgrade = val
		Events.upgradeBought.emit()
# makes trees grow faster
# OG: Lvl 0: 0 second Delay, Lvl 1: 2.5 second Delay, Lvl 2: 4 second Delay, Lvl 3: 5 second Delay
# Ford: 0:0, 1:1, 2:2, 3:3.5

# used in tree_type script to modify grow speeds
var treeGrowBonus = 0

var fur_fire_upgrade : int = 0 : 
	set(val):
		var fireMaxTimeBuffs = [60,105,135,150] # in seconds added to the fire_duration var in campfire]
		var varfireRaduiusBuffs = [13,18,23,50]
		fireMaxTimeBuff = fireMaxTimeBuffs[val]
		fireRaduiusBuff = fireMaxTimeBuffs[val]
		fur_fire_upgrade = val
		Events.upgradeBought.emit()
# for light radious and burn time
# Lvl 0: 1:00 death, scale = 9.0, Lvl 1: 1:45 death, scale = 14.0,
#Lvl 2: 2:15 death, scale = 20.0, Lvl 3: 2:30 death, scale = 40.0

# for use in campfire script to change the death time and scale
var fireMaxTimeBuff = 60
var fireRaduiusBuff = 13


var angry_mus_upgrade : int = 0 :
	set(val):
		var enemyHpDebuffs = [0,1,2,3]
		enemyHpDebuff = enemyHpDebuffs[val]
		angry_mus_upgrade = val
		Events.upgradeBought.emit()
# increases damage to enimes
# Lvl 0: 4 Hits to kill, Lvl 1: 3 Hits to kill, Lvl 2: 2 Hits to kill, Lvl 3: 1 Hits to kill
var enemyHpDebuff = 0

var speed_leg_upgrade : int = 0 :
	set(val):
		var speeds = [0,40,70,110]
		speedBuff = speeds[val]
		speed_leg_upgrade = val
		Events.upgradeBought.emit()

# upgrades player speed
# Lvl 0: 75 speed, Lvl 1: 90 speed, Lvl 2: 109 speed, Lvl 3: 131 speed

# used in bron script to update speed
var speedBuff = 0

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
