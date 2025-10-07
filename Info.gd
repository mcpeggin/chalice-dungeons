extends PanelContainer

@onready var room_info = $MarginContainer/Rows/RoomInfo
@onready var help_label = $MarginContainer/Rows/HelpLabel

func _ready():
	var HELP = "Type 'help' anytime to see the available commands."
	var colored_help = Types.color_text(HELP, Types.COLOR_SYSTEM)
	
	help_label.text = colored_help

func on_change_room(new_room):
	room_info.text = new_room.get_full_description()

func on_update_room(current_room):
	on_change_room(current_room)
