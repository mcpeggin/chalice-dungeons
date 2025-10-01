extends Node

var current_room = null
var player = null

func init(starting_room, player) -> String:
	self.player = player
	return change_room(starting_room)

func process_command(input: String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return 'Error: no words were parsed'
		
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
			return "Unrecognized command. Try again."

# TODO add go back

func go(second_word: String) -> String:
	if second_word == "":
		return "Go where?"
	
	if current_room.exits.keys().has(second_word):
		var exit = current_room.exits[second_word]
		if exit.is_locked:
			return "The way %s is currently locked." % second_word
		var response = change_room(exit.get_other_room(current_room))
		return "\n".join(["You go %s" % second_word, response])
	else:
		return "You can't go there."
	
	# %s [] in case we use more
	return "You go %s." % second_word

func pick(second_word: String) -> String:
	if second_word == "":
		return "Pick what?"
	
	for item in current_room.items:
		if second_word.to_lower() == item.name.to_lower():
			current_room.remove_item(item)
			player.pickup(item)
			return '%s is picked' % item.name
			
	return 'There is nothing to pick up'

func drop(second_word: String) -> String:
	if second_word == "":
		return "Pick what?"
	
	for item in player.inventory:
		if second_word.to_lower() == item.name.to_lower():
			current_room.add_item(item)
			player.drop_item(item)
			return '%s is dropped' % item.name
			
	return "You dont have such thing"

func inventory() -> String:
	return player.get_inventory_list()
	
func use(second_word: String) -> String:
	if second_word == "":
		return "Use what?"
	
	for item in player.inventory:
		if second_word.to_lower() == item.name.to_lower():
			match item.type:
				Types.items.KEY:
					for exit in current_room.exits.values():
						if exit == item.use_value:
							exit.is_locked = false
							player.drop_item(item)
							var keyDoorPair = [item.name, exit.get_other_room(current_room).room_name]
							return "You use a %s to unlock a way to %s" % keyDoorPair
					return "This item has no use here" 
				_:
					return "Error. Invalid Type."
	return "You dont have that item"

func talk(second_word: String) -> String:
	if second_word == "":
		return "Talk to who?"
	
	for npc in current_room.npcs:
		if npc.name.to_lower() == second_word:
			var dialog = npc.post_quest_dialog if npc.is_quest_item_received else npc.initial_dialog
			return npc.name + ": \"" + dialog + "\""
	
	return "Not present here. Talk to someone else."

func give(second_word: String) -> String:
	if second_word == "":
		return "Give what?"
		
	var has_item: bool = false
	
	for item in player.inventory:
		if second_word.to_lower() == item.name.to_lower():
			has_item = true
	
	if not has_item:
		return "You don't have that item."
	
	for npc in current_room.npcs:
		if npc.quest_item != null and second_word.to_lower() == npc.quest_item.name.to_lower():
			npc.is_quest_item_received = true
			if npc.quest_reward != null:
				player.pickup(npc.quest_reward)
			for item in player.inventory:
				if second_word.to_lower() == item.name.to_lower():
					player.drop_item(item)
			return "You give the %s to the %s" % [second_word, npc.name]
	
	return "That item belongs to no one here."

func help() -> String:
	var vailable_exits = current_room.exits.keys()
	return "You type these [commands].\nYou can go %s" % " ".join(vailable_exits)

func change_room(new_room: Room) -> String:
	current_room = new_room
	return new_room.get_full_description()
