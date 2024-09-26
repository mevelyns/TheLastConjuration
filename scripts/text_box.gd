extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256
var text = ""
var letter_index = 0

signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	
	
