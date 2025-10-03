extends Node

enum items {
	KEY,
	QUEST_ITEM
}

const COLOR_NPC = Color.ORANGE
const COLOR_ITEM = Color.PURPLE
const COLOR_LOCATION = Color.BLUE
const COLOR_SPEECH = Color.GREEN
const COLOR_SYSTEM = Color.YELLOW

func color_text(text: String, color: Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(), text]

#func wrap_npc_text(text: String) -> String:
	#return "[color=#%s]%s[/color]" % [COLOR_NPC.to_html(), text]
#
#func wrap_item_text(text: String) -> String:
	#return "[color=#%s]%s[/color]" % [COLOR_ITEM.to_html(), text]
#
#func wrap_location_text(text: String) -> String:
	#return "[color=#%s]%s[/color]" % [COLOR_LOCATION.to_html(), text]
#
#func wrap_speech_text(text: String) -> String:
	#return "[color=#%s]%s[/color]" % [COLOR_SPEECH.to_html(), text]
#
#func wrap_system_text(text: String) -> String:
	#return "[color=#%s]%s[/color]" % [COLOR_SYSTEM.to_html(), text]
