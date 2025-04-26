extends Node

signal chop_tree
signal open_upgrade
signal add_inventory_item(name)
signal tree_chopped_down


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
