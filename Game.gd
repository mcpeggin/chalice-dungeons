extends Control

# game response to player input
const Response = preload("res://Response.tscn")
# user input and game response in history container
const Log = preload("res://Log.tscn")

@onready var command_manager = $CommandManager
@onready var room_manager = $RoomManager
@onready var logs = $Background/MarginContainer/Rows/GameInfo/MarginContainer/HBoxContainer/History/MarginContainer/ScrollContainer/Logs
@onready var scroll = $Background/MarginContainer/Rows/GameInfo/MarginContainer/HBoxContainer/History/MarginContainer/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()

func _ready() -> void:
	get_window().grab_focus()
	
	# sync the data and room
	command_manager.connect("response_generated", Callable(self, "handle_response_generated"))
	command_manager.init(room_manager.get_child(0))

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var log = Log.instantiate()
	var response = command_manager.process_command(new_text)
	
	log.set_text(new_text, response)
	add_log(log)
	
	# auto-scroll to the last message
	
	await get_tree().process_frame
	scroll.scroll_vertical = scrollbar.max_value

func handle_response_generated(response_text):
	var response = Response.instantiate()
	response.text = response_text
	add_log(response)

func add_log(response: Control):
	logs.add_child(response)

func clear_history():
	logs.queue_free()
