extends Node

signal chop_tree
signal open_upgrade
signal tree_chopped_down
signal add_inventory_item(name)
# HI! heres how my signal works. This is emitted every time the player picks up and item
# the name value:
#	- if the item is a plank name will just be "plank"
#	- if the item is a ssed name will bee "type <number> seed" EX: "type 1 seed"
#
# Connect to this anywhere you want via:
#	Events.add_inventory_item.connect(func)
#	where func is a function that has a string perameter for the name
#
# then in the funcion you connect it to should add the items to the inventory basied on what the peram value is 

signal upgradeBought
# used when an upgrade is bought, connects to tree type script to update their stats if needed
# like for example when a upgrade for tree grow time is bought we need to apply to change to all living trees and to do that
#	we need to call a func on the treee script

signal spawnTrees
