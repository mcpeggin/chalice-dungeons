extends Control

@onready var command_manager = $CommandManager
@onready var room_manager = $RoomManager
@onready var player = $Player

@onready var game_info = $Background/MarginContainer/Rows/GameInfo

func _ready() -> void:
	get_window().grab_focus()
	
	var welcome_text = "Welcome!\n\nGo to the " + Types.color_text("shed ", Types.COLOR_LOCATION) + Types.color_text("north ", Types.COLOR_DIRECTION) + "of here."
	
	game_info.create_response(welcome_text)
	
	var starting_room = room_manager.get_child(1)
	
	command_manager.connect("room_changed", Callable(game_info.info, "on_change_room"))
	command_manager.connect("room_updated", Callable(game_info.info, "on_update_room"))
	
	var starting_room_response = command_manager.init(starting_room, player)
	
	game_info.image.texture = starting_room.room_texture
	game_info.npc.texture = starting_room.npc_texture
	
	# game_info.create_response(starting_room_response)

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var response = command_manager.process_command(new_text)
	game_info.create_response_with_input(response, new_text)
	
	game_info.image.texture = command_manager.current_room.room_texture
	game_info.npc.texture = command_manager.current_room.npc_texture
