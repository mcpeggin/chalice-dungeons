extends Node

signal response_generated(response_text)

const HELP = "Type 'help' anytime to see the available commands."

var current_room = null

func init(starting_room):
	change_room(starting_room)

func process_command(input: String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return 'Error: no words were parsed'
		
	var first_word = words[0].to_lower()
	var second_word = ""
	
	if words.size() > 1:
		second_word = words[1].to_lower()
	
	match first_word:
		"go":
			return go(second_word)
		"help":
			return help()
		_:
			return "Unrecognized command. Try again."

func go(second_word: String) -> String:
	if second_word == "":
		return "Go where?"
	
	# %s [] in case we use more
	return "You go %s" % second_word

func help() -> String:
	return "You can go [location]"

func change_room(new_room: Room):
	current_room = new_room
	emit_signal("response_generated", "You enter the " + new_room.room_name)
	emit_signal("response_generated", new_room.room_description)
	emit_signal("response_generated", HELP)
