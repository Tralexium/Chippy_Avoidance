extends Sprite3D

export var action_name := ""
var is_shrinking := false

func _ready() -> void:
	scale = Vector3.ZERO
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ONE, 0.7)
	var icon_texture : StreamTexture
	var current_device := InputHelper.guess_device_name()
	if current_device == InputHelper.DEVICE_KEYBOARD:
		var key := InputHelper.get_action_key(action_name)
		icon_texture = load("res://Assets/Controller & Key Prompts/Keyboard/" + key + "_Key_Light.png")
	else:
		var button := InputHelper.get_action_button(action_name)
		icon_texture = InputHelper.SONY_GAMEPAD_TEXTURES[button]
	texture = icon_texture


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(action_name):
		shrink()


func shrink() -> void:
	if is_shrinking:
		return
	is_shrinking = true
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.3)
	tween.tween_callback(self, "queue_free").set_delay(0.3)
