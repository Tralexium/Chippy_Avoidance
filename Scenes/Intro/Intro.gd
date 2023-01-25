extends Spatial

signal finished

var finished_events := 0
var revealed_squares := 0
onready var squares: Position3D = $Squares
onready var square_count := squares.get_child_count()
onready var reveal_gap: Timer = $RevealGap
onready var fade_rect: CanvasLayer = $FadeRect
onready var made_by: Sprite3D = $MadeBy
onready var godot_logo: Sprite = $"2D/GodotLogo"
onready var gamepad_disclaimer: VBoxContainer = $"2D/GamepadDisclaimer"


func _ready() -> void:
	fade_rect.fade()


func reveal_square() -> void:
	if revealed_squares < square_count:
		squares.get_child(revealed_squares).reveal()
		revealed_squares += 1
		reveal_gap.start()
	else:
		reveal_gap.stop()
		yield(get_tree().create_timer(1.5), "timeout")
		fade_rect.fade()


func _on_FadeRect_faded_in() -> void:
	finished_events += 1
	match finished_events:
		1:
			godot_logo.hide()
			made_by.show()
			squares.show()
			fade_rect.fade()
		2:
			made_by.hide()
			squares.hide()
			gamepad_disclaimer.show()
			fade_rect.fade()
		3:
			gamepad_disclaimer.hide()
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("finished")
			AlwaysRendered.show_debug()
			get_tree().change_scene_to(Globals.MAIN_MENU)


func _on_FadeRect_faded_out() -> void:
	match finished_events:
		0:
			yield(get_tree().create_timer(1.5), "timeout")
			fade_rect.fade()
		1:
			yield(get_tree().create_timer(0.3), "timeout")
			reveal_gap.start()
		2:
			yield(get_tree().create_timer(1.5), "timeout")
			fade_rect.fade()


func _on_RevealGap_timeout() -> void:
	reveal_square()
