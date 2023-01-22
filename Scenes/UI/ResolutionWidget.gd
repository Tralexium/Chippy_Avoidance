extends VBoxContainer

onready var option_button := $OptionButton


func find_and_select(resolution: Vector2) -> void:
	var string := str(resolution.x) + "x" + str(resolution.y)
	for i in option_button.get_item_count():
		if string == option_button.get_item_text(i):
			option_button.select(i)


func _on_OptionButton_item_selected(index: int) -> void:
	SoundManager.play_ui_sound(Globals.UI_OFF)
	var values : PoolRealArray = option_button.get_item_text(index).split_floats("x")
	Config.resolution = Vector2(values[0], values[1])


func _on_OptionButton_pressed() -> void:
	SoundManager.play_ui_sound(Globals.UI_BUTTON)
