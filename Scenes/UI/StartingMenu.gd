extends Control

export var icon_scroll_spd := 50.0

signal begin_pressed
signal options_pressed
signal credits_pressed
signal exit_pressed

onready var scrolling_icons: TextureRect = $BG/ScrollingIcons
onready var selected_button: Label = $BG/NeonBar/SelectedButton
onready var begin: Button = $BG/Buttons/Begin
onready var options: Button = $BG/Buttons/Options
onready var credits: Button = $BG/Buttons/Credits
onready var exit: Button = $BG/Buttons/Exit


func change_label_text(string: String) -> void:
	selected_button.change_text(string)


func _process(delta: float) -> void:
	var tex := scrolling_icons.texture as AtlasTexture
	tex.region.position.y += icon_scroll_spd * delta
	if get_focus_owner() != null:
		return
	var xy_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.2)
	if xy_input.length() > 0:
		begin.grab_focus()


func _on_Begin_focus_entered() -> void:
	change_label_text("begin")

func _on_Begin_mouse_entered() -> void:
	change_label_text("begin")

func _on_Options_focus_entered() -> void:
	change_label_text("options")

func _on_Options_mouse_entered() -> void:
	change_label_text("options")

func _on_Credits_focus_entered() -> void:
	change_label_text("credits")

func _on_Credits_mouse_entered() -> void:
	change_label_text("credits")

func _on_Exit_focus_entered() -> void:
	change_label_text("exit")

func _on_Exit_mouse_entered() -> void:
	change_label_text("exit")

func _on_Twitter_focus_entered() -> void:
	change_label_text("twitter")

func _on_Twitter_mouse_entered() -> void:
	change_label_text("twitter")

func _on_Discord_focus_entered() -> void:
	change_label_text("discord")

func _on_Discord_mouse_entered() -> void:
	change_label_text("discord")



func _on_Begin_pressed() -> void:
	begin.release_focus()
	emit_signal("begin_pressed")

func _on_Options_pressed() -> void:
	options.release_focus()
	emit_signal("options_pressed")

func _on_Credits_pressed() -> void:
	credits.release_focus()
	emit_signal("credits_pressed")

func _on_Exit_pressed() -> void:
	exit.release_focus()
	emit_signal("exit_pressed")
