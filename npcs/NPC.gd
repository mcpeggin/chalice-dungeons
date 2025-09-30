extends Resource
class_name NPC

@export var name: String = "NPC Name"

@export_multiline var initial_dialog: String
@export_multiline var post_quest_dialog: String

@export var quest_item: Item

var is_quest_item_received: bool = false
