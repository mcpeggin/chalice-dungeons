@tool

extends PanelContainer

class_name Room

@export var room_name: String = "Room Name":
	set(name):
		room_name = name
		$MarginContainer/Rows/Name.text = name
		
@export_multiline var room_description: String = "This is the description of the room":
	set(description):
		room_description = description
		$MarginContainer/Rows/Description.text = description

@export var room_texture: Texture2D:
	set(texture):
		_room_texture = texture
		$Image.texture = texture
	get:
		return _room_texture

var _room_texture: Texture2D = null

@export var npc_texture: Texture2D:
	set(texture):
		_npc_texture = texture
		$NPC.texture = texture
	get:
		return _npc_texture

var _npc_texture: Texture2D = null


# keys of the dict are strings, values are rooms
var exits: Dictionary = {}
var npcs: Array = []
var items: Array = []

#override_dir: bool = false for non standard dirs

func get_full_description() -> String:
	var messages = [ 
		get_room_description()
	 ]
	
	var npc_descpription = get_npc_description()
	if npc_descpription != "":
		messages.append(npc_descpription)
		
	var item_description = get_item_description()
	if item_description != "":
		messages.append(item_description)
	
	messages.append(get_exit_description())
	
	var full_sescription = "\n\n".join(messages)
	
	return full_sescription

func get_room_description() -> String:
	return "You are now in: " + Types.color_text(room_name, Types.COLOR_LOCATION) + "\n\nIt is " + room_description
	
func get_item_description() -> String:
	
	if items.size() == 0:
		return ""
	
	var item_str = ""
	for item in items:
		item_str += item.name + " "
	
	return "Items: " + Types.color_text(item_str, Types.COLOR_ITEM)

func _is_direction(name: String) -> bool:
	var directions = ["north", "south", "east", "west", "path", "inside", "outside"]
	return directions.has(name.to_lower())

func get_exit_description() -> String:
	var colored_exits: Array = []
	for exit_name in exits.keys():
		if _is_direction(exit_name):
			colored_exits.append(Types.color_text(exit_name, Types.COLOR_DIRECTION))
		else:
			colored_exits.append(Types.color_text(exit_name, Types.COLOR_LOCATION))
	
	var joined = ", ".join(colored_exits)
	return "Exits: " + joined

func get_npc_description() -> String:
	
	if npcs.size() == 0:
		return ""
		
	var npcs_str = ""
	for npc in npcs:
		npcs_str += npc.name + " "
	
	return "NPCs to talk to: " + Types.color_text(npcs_str, Types.COLOR_NPC)

func add_item(item: Item):
	items.append(item)
	
func add_npc(npc: NPC):
	npcs.append(npc)

func remove_item(item: Item):
	items.erase(item)

func remove_npc(npc: NPC):
	items.erase(npc)

func connect_exit_unlocked(direction: String, room, room_2_override_name = 'null'):
	return _connect_exit(direction, room, false, room_2_override_name)

func connect_exit_locked(direction: String, room, room_2_override_name = 'null'):
	return _connect_exit(direction, room, true, room_2_override_name)

func _connect_exit(direction: String, room, is_locked: bool = false, room_2_override_name = 'null'):
	
	var exit = Exit.new()
	
	exit.room_1 = self
	exit.room_2 = room
	exit.is_locked = is_locked
	
	exits[direction] = exit
	
	if room_2_override_name != "null":
		exits[room_2_override_name] = exit
		
	match direction:
		"west":
			room.exits["east"] = exit
		"east":
			room.exits["west"] = exit
		"north":
			room.exits["south"] = exit
		"south":
			room.exits["north"] = exit
		"path":
			room.exits["path"] = exit
		"inside":
			room.exits["outside"] = exit
		"outside":
			room.exits["inside"] = exit
		_:
			print("error connect_exit", direction)
	return exit
