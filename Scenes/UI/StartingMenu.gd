extends Control

export var icon_scroll_spd := 50.0

onready var scrolling_icons: TextureRect = $BG/ScrollingIcons
onready var begin: Button = $BG/Buttons/Begin


func _process(delta: float) -> void:
	var tex := scrolling_icons.texture as AtlasTexture
	tex.region.position.y += icon_scroll_spd * delta
	if get_focus_owner() != null:
		return
	var xy_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.2)
	if xy_input.length() > 0:
		begin.grab_focus()
