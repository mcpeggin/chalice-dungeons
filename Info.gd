extends PanelContainer

@onready var room_info = $MarginContainer/Rows/RoomInfo

func on_change_room(new_room):
	room_info.text = new_room.get_full_description()

func on_update_room(current_room):
	on_change_room(current_room)
