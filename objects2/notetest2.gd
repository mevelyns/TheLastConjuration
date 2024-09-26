extends Interactable

var note_displayed = false
var viewport: Viewport = null

@export var note_text: String = "This is a note."

func _ready():
	hide_note()  # Ensure that the note is initially not visible
	viewport = get_tree().root.get_child(0) as Viewport

func interact():
	if note_displayed:
		hide_note()
	else:
		show_note()

func show_note():
	# Show the note UI
	$"../NoteReader".visible = true
	note_displayed = true
	if viewport:
		viewport.time_scale = 0.0 # Pause the game by setting viewport's time scale to 0
	set_process_input(true)

func hide_note():
	# Hide the note UI
	$"../NoteReader".visible = false
	note_displayed = false
	if viewport:
		viewport.time_scale = 1.0 # Resume the game by setting viewport's time scale to 1
	set_process_input(false)

func _input(event):
	# If the note is displayed and the interact key or another designated input is pressed, hide the note
	if note_displayed and (event.is_action_pressed("interact") or event.is_action_pressed("unpause")):
		hide_note()
