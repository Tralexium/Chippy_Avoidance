tool
extends Spatial

export var number := 0 setget set_number
var is_ready := false
onready var symbol_panel: Sprite3D = $Position3D/SymbolPanel
onready var letter_panel: Sprite3D = $Position3D/LetterPanel
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	is_ready = true
	set_number(number)


func set_number(new_num: int) -> void:
	number = new_num
	if is_ready and new_num >= 0 and new_num < 9:
		symbol_panel.frame = new_num
		letter_panel.frame = new_num


func reveal() -> void:
	animation_player.play("reveal")
