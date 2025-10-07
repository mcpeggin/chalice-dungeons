extends Node

enum items {
	KEY,
	QUEST_ITEM
}

const COLOR_NPC = Color.ORANGE        		# Hex: #FFA500
const COLOR_ITEM = Color.PURPLE       		# Hex: #800080
const COLOR_LOCATION = Color.VIOLET   		# Hex: #EE82EE
const COLOR_DIRECTION = Color.ROYAL_BLUE  	# Hex: #4169E1
const COLOR_SPEECH = Color.ANTIQUE_WHITE  	# Hex: #FAEBD7
const COLOR_SYSTEM = Color.GOLD       		# Hex: #FFD700


func color_text(text: String, color: Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(), text]
