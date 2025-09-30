extends Control

# game response to player input
const Response = preload("res://input/Response.tscn")
# user input and game response in history container
const Log = preload("res://input/Log.tscn")

const HELP = "Type 'help' anytime to see the available commands."

@onready var command_manager = $CommandManager
@onready var room_manager = $RoomManager
@onready var player = $Player
@onready var logs = $Background/MarginContainer/Rows/GameInfo/MarginContainer/HBoxContainer/History/MarginContainer/ScrollContainer/Logs
@onready var scroll = $Background/MarginContainer/Rows/GameInfo/MarginContainer/HBoxContainer/History/MarginContainer/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()

@onready var image = $Background/MarginContainer/Rows/GameInfo/MarginContainer/HBoxContainer/View/MarginContainer/Image
@onready var npc = $Background/MarginContainer/Rows/GameInfo/MarginContainer/HBoxContainer/View/MarginContainer/NPC

@onready var event = $Background/MarginContainer/Rows/GameInfo/EventBoxMargin
@onready var event_preview = $Background/MarginContainer/Rows/GameInfo/EventBoxMargin/VBoxContainer/PreviewContainer/CenterContainer/Preview

func _ready() -> void:
	get_window().grab_focus()
	
	# first message on launch
	create_response('Welcome!\n\n' + HELP)
	
	var starting_room = room_manager.get_child(0)
	var starting_room_response = command_manager.init(starting_room, player)
	
	image.texture = starting_room.room_texture
	npc.texture = starting_room.npc_texture
	
	create_response(starting_room_response)

#func _process(delta: float) -> void:
	#if command_manager.current_room.room_name == 'Graveyard':
		#await get_tree().create_timer(2.0).timeout
		#event.show()
		#event_preview.play("default")
	#elif command_manager.current_room.room_name != 'Graveyard':
		#event.hide()
	#else:
		#event.hide()
		

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var log = Log.instantiate()
	var response = command_manager.process_command(new_text)
	
	log.set_text(new_text, response)
	add_log(log)
	
	image.texture = command_manager.current_room.room_texture
	npc.texture = command_manager.current_room.npc_texture
	
	# auto-scroll to the last message
	
	await get_tree().process_frame
	scroll.scroll_vertical = scrollbar.max_value

func create_response(response_text: String):
	var response = Response.instantiate()
	response.text = response_text
	add_log(response)

func add_log(response: Control):
	logs.add_child(response)

func clear_history():
	for child in logs.get_children():
		child.queue_free()
