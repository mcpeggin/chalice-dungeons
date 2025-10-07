extends Node

signal room_changed(new_room)
signal room_updated(current_room)

var current_room = null
var player = null

func init(starting_room, player) -> String:
	self.player = player
	return change_room(starting_room)

func process_command(input: String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return Types.color_text('Error: no words were parsed', Types.COLOR_LOCATION) 
		
	var first_word = words[0].to_lower()
	var second_word = ""
	
	if words.size() > 1:
		second_word = words[1].to_lower()
	
	match first_word:
		"go", "move", "enter", "go to":
			return go(second_word)
		"pick", "p", "pick up", "pickup", "take":
			return pick(second_word)
		"drop":
			return drop(second_word)
		"use", "u":
			return use(second_word)
		"talk", "talk to", "talkto":
			return talk(second_word)
		"give":
			return give(second_word)
		"inventory", "i":
			return inventory()
		"help", "h":
			return help()
		_:
			return Types.color_text("Unrecognized command. Try again.", Types.COLOR_SYSTEM)

# TODO add go back

func go(second_word: String) -> String:
	if second_word == "":
		return Types.color_text("Go where?", Types.COLOR_SYSTEM)
	
	if current_room.exits.keys().has(second_word):
		var exit = current_room.exits[second_word]
		if exit.is_locked:
			return (
				"The way " 
				+ Types.color_text(second_word, Types.COLOR_LOCATION) 
				+ " is currently" 
				+ Types.color_text(" locked", Types.COLOR_ITEM)
				+ "."
			)
		var response = change_room(exit.get_other_room(current_room))
		return "\n".join(["You go %s" % second_word, response])
	else:
		return Types.color_text("You can't go there.", Types.COLOR_SYSTEM)
	
	# %s [] in case we use more
	return "You go %s." % second_word

func pick(second_word: String) -> String:
	if second_word == "":
		return Types.color_text("Pick what?", Types.COLOR_SYSTEM)
	
	for item in current_room.items:
		if second_word.to_lower() == item.name.to_lower():
			current_room.remove_item(item)
			player.pickup(item)
			emit_signal("room_updated", current_room)
			return '%s is picked' % Types.color_text(item.name, Types.COLOR_ITEM)
			
	return Types.color_text("There is nothing to pick up.", Types.COLOR_SYSTEM)

func drop(second_word: String) -> String:
	if second_word == "":
		return Types.color_text("Drop what?", Types.COLOR_SYSTEM)
	
	for item in player.inventory:
		if second_word.to_lower() == item.name.to_lower():
			current_room.add_item(item)
			player.drop_item(item)
			emit_signal("room_updated", current_room)
			return '%s is dropped' % Types.color_text(item.name, Types.COLOR_ITEM)
			
	return Types.color_text("You dont have such thing.", Types.COLOR_SYSTEM)

func inventory() -> String:
	return player.get_inventory_list()
	
func use(second_word: String) -> String:
	if second_word == "":
		return Types.color_text("Use what?", Types.COLOR_SYSTEM)
	
	for item in player.inventory:
		if second_word.to_lower() == item.name.to_lower():
			match item.type:
				Types.items.KEY:
					for exit in current_room.exits.values():
						if exit == item.use_value:
							exit.is_locked = false
							player.drop_item(item)
							var keyDoorPair = [
									Types.color_text(item.name, Types.COLOR_ITEM),
									Types.color_text(exit.get_other_room(current_room).room_name, Types.COLOR_LOCATION),
								]
							return "You use a %s to unlock a way to %s" % keyDoorPair
					return Types.color_text("This item has no use here.", Types.COLOR_SYSTEM)
				_:
					return Types.color_text("Error. Invalid Type.", Types.COLOR_SYSTEM)
	return Types.color_text("You dont have that item.", Types.COLOR_SYSTEM)

func talk(second_word: String) -> String:
	if second_word == "":
		return Types.color_text("Talk to who?", Types.COLOR_SYSTEM)
	
	for npc in current_room.npcs:
		if npc.name.to_lower() == second_word:
			var dialog = npc.post_quest_dialog if npc.is_quest_item_received else npc.initial_dialog
			return npc.name + ": \"" + dialog + "\""
	
	return Types.color_text("Not present here. Talk to someone else.", Types.COLOR_SYSTEM)

func give(second_word: String) -> String:
	if second_word == "":
		return Types.color_text("Give what?", Types.COLOR_SYSTEM)
		
	var has_item: bool = false
	
	for item in player.inventory:
		if second_word.to_lower() == item.name.to_lower():
			has_item = true
	
	if not has_item:
		return Types.color_text("You don't have that item.", Types.COLOR_SYSTEM)
	
	for npc in current_room.npcs:
		if npc.quest_item != null and second_word.to_lower() == npc.quest_item.name.to_lower():
			npc.is_quest_item_received = true
			if npc.quest_reward != null:
				player.pickup(npc.quest_reward)
			for item in player.inventory:
				if second_word.to_lower() == item.name.to_lower():
					player.drop_item(item)
			return Types.color_text(
				"You give the " 
				+ Types.color_text(second_word, Types.COLOR_ITEM)
				+ " to the " 
				+ Types.color_text(npc.name, Types.COLOR_NPC),
				Types.COLOR_SYSTEM)
	
	return Types.color_text("That item belongs to no one here.", Types.COLOR_SYSTEM)

func help() -> String:
	var help_lines = [
		"You can use these commands:",
		"go " 		+ 	Types.color_text("[direction]", Types.COLOR_LOCATION),
		"take " 	+ 	Types.color_text("[item]", Types.COLOR_ITEM),
		"drop " 	+ 	Types.color_text("[item]", Types.COLOR_ITEM),
		"use " 		+ 	Types.color_text("[item]", Types.COLOR_ITEM),
		"talk " 	+ 	Types.color_text("[npc]", Types.COLOR_NPC),
		"give " 	+ 	Types.color_text("[item]", Types.COLOR_ITEM),
		"inventory " + 	Types.color_text("[item]", Types.COLOR_SYSTEM),
		"help " 		+ 	Types.color_text("[item]", Types.COLOR_SYSTEM)
	]
	return "\n".join(help_lines)

func change_room(new_room: Room) -> String:
	current_room = new_room
	emit_signal("room_changed", new_room)
	return new_room.get_full_description()
