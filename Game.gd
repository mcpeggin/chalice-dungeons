extends Control

const HELP = "Type 'help' anytime to see the available commands."

@onready var command_manager = $CommandManager
@onready var room_manager = $RoomManager
@onready var player = $Player

@onready var game_info = $Background/MarginContainer/Rows/GameInfo

func _ready() -> void:
	get_window().grab_focus()
	
	# first message on launch
	game_info.create_response('Welcome!\n\n' + HELP)
	
	var starting_room = room_manager.get_child(1)
	var starting_room_response = command_manager.init(starting_room, player)
	
	game_info.image.texture = starting_room.room_texture
	game_info.npc.texture = starting_room.npc_texture
	
	game_info.create_response(starting_room_response)

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var response = command_manager.process_command(new_text)
	game_info.create_response_with_input(response, new_text)
	
	game_info.image.texture = command_manager.current_room.room_texture
	game_info.npc.texture = command_manager.current_room.npc_texture
