extends Node

func _ready() -> void:
	
	# room 
	# connect_func locked || unlocked 
	# ( default dir, exit location, alternative dir for exit)
	
	var houseNPC = load_npc("HouseNPC")
	$House.connect_exit_unlocked("east", $Forest, "forest")
	var medicine = load_item("Medicine")
	$House.add_item(medicine)
	$House.add_npc(houseNPC)
	
	var shedExit = $Forest.connect_exit_locked("north", $Shed, 'shed')
	
	$Forest.connect_exit_unlocked("west", $House, "house")
	$Forest.connect_exit_unlocked("south", $Graveyard, "graveyard")
	
	var graveyardNPC = load_npc("GraveyardNPC")
	$Graveyard.add_npc(graveyardNPC)
	$Graveyard.connect_exit_unlocked("north", $Forest, "forest")
	
	var shedKey = load_item("ShedKey")
	$Graveyard.add_item(shedKey)
	shedKey.use_value = shedExit

# helpers

func load_item(item_name: String):
	return load("res://items/" + item_name + ".tres")
	
func load_npc(npc_name: String):
	return load("res://npcs/" + npc_name + ".tres")
