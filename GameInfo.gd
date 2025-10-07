extends PanelContainer

@export var MAX_LINES_REMEMBERED: int = 30

var MAX_SCROLL_LENGTH: int = 0

# game response to player input
const RESPONSE = preload("res://input/Response.tscn")
# user input and game response in history container
const LOG = preload("res://input/Log.tscn")

@onready var scroll = $MarginContainer/HBoxContainer/History/MarginContainer/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()

@onready var logs = $MarginContainer/HBoxContainer/History/MarginContainer/ScrollContainer/Logs

@onready var image = $MarginContainer/HBoxContainer/View/MarginContainer/Image
@onready var npc = $MarginContainer/HBoxContainer/View/MarginContainer/NPC

@onready var event = $EventBoxMargin
@onready var event_preview = $EventBoxMargin/VBoxContainer/PreviewContainer/CenterContainer/Preview

@onready var info = $MarginContainer/HBoxContainer/Info

func _ready() -> void:
	scrollbar.changed.connect(_handle_scrollbar_changed)
	MAX_SCROLL_LENGTH = scrollbar.max_value

func create_response(response_text: String):
	var response = RESPONSE.instantiate()
	_add_log(response)
	response.set_text(response_text)

func create_response_with_input(response_text: String, input_text: String):
	var log = LOG.instantiate()
	_add_log(log)
	log.set_text(response_text, input_text)

func _handle_scrollbar_changed():
	if MAX_SCROLL_LENGTH != scrollbar.max_value:
		MAX_SCROLL_LENGTH = scrollbar.max_value
		scroll.scroll_vertical = MAX_SCROLL_LENGTH

func _delete_history_beyond_limit():
	if logs.get_child_count() > MAX_LINES_REMEMBERED:
		var logs_to_delete = logs.get_child_count() - MAX_LINES_REMEMBERED
		for i in range(logs_to_delete):
			logs.get_child(i).queue_free()

func _add_log(response: Control):
	logs.add_child(response)
	_delete_history_beyond_limit()
