extends Resource

class_name Exit

var room_1: Room = null
var room_2: Room = null
var is_locked: bool = false

func get_other_room(current_room: Room):
	if current_room == room_1:
		return room_2
	elif current_room == room_2:
		return room_1
	else:
		print('error get_exit: Exit')
		return null
