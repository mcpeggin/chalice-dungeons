extends Node

enum items {
	KEY,
	QUEST_ITEM
}

const COLOR_NPC = Color.ORANGE
const COLOR_ITEM = Color.PURPLE
const COLOR_LOCATION = Color.VIOLET
const COLOR_SPEECH = Color.GREEN
const COLOR_SYSTEM = Color.YELLOW

func color_text(text: String, color: Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(), text]
