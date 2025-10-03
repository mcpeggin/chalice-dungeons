extends VBoxContainer

@onready var input_label = $Input
@onready var response_label = $Response

func set_text(response: String, input: String = ""):
	if input == "":
		input_label.queue_free()
	else:
		input_label.text = "> " + input
		
	response_label.bbcode_text = response
