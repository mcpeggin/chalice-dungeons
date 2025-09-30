extends LineEdit

func _ready() -> void:
	grab_focus() # focus on input on launch

func _input(event):
	if event.is_action_pressed("end_session"):
		get_tree().quit() # terminate session

func _on_text_submitted(_new_text: String) -> void:
	clear() # clear input after 
	grab_focus()
