extends Panel

const TICK_ICON := preload("res://Assets/UI/tick_icon.png")
const SFX_POPUP := preload("res://Audio/SFX/info_box_popup.wav")
const SFX_DONE := preload("res://Audio/SFX/info_box_complete.wav")
export var text := "Text goes here yo!"

var is_visible := false
onready var label: Label = $MarginContainer/Contents/Label
onready var texture_rect: TextureRect = $MarginContainer/Contents/TextureRect
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	label.text = text


func slide_in(_text: String) -> void:
	label.text = _text
	animation_player.play("slide_in")
	SoundManager.play_ui_sound(SFX_POPUP)


func slide_out() -> void:
	animation_player.play_backwards("slide_in")


func complete() -> void:
	is_visible = false
	animation_player.play("complete")
	SoundManager.play_ui_sound(SFX_DONE)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_in":
		is_visible = true
