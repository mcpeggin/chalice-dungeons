extends Node

var inventory: Array = []

func pickup(item: Item):
	inventory.append(item)

func drop_item(item: Item):
	inventory.erase(item)

func get_inventory_list() -> String:
	if inventory.size() == 0:
		return "You carry nothing of value"
	
	var item_str = ""
	for item in inventory:   
		item_str += item.name + " "
	return "Inventory: " + item_str
