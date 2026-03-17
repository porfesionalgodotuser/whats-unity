extends Control

var options := ["Play", "Quit"]
var selected_index := 0

@onready var label := $Label

func _ready():
	_update_label()

func _input(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
		selected_index = (selected_index + 1) % options.size()
		_update_label()
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
		selected_index = (selected_index - 1 + options.size()) % options.size()
		_update_label()
	elif event.is_action_pressed("ui_accept"):
		_select()
	elif event is InputEventJoypadButton and event.button_index == JOY_BUTTON_BACK and event.pressed:
		_start_game()

func _update_label():
	var text_lines := "Roll-A-Ball: Godot Edition\nInsert Coin\n\n"
	for i in options.size():
		if i == selected_index:
			text_lines += "> " + options[i] + " <\n"
		else:
			text_lines += "  " + options[i] + "\n"
	label.text = text_lines

func _select():
	if selected_index == 0:
		_start_game()
	else:
		get_tree().quit()

func _start_game():
	GameManager.start_game()
	get_tree().change_scene_to_file("res://node_3d.tscn")
