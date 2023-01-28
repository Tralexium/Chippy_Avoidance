extends TextureRect

const THREE := preload("res://Assets/UI/perspective_icon_3d.png")
const TWO := preload("res://Assets/UI/perspective_icon_2d.png")

export var is_3d := true
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.connect("switched_projection", self, "switch")


func switch() -> void:
	is_3d = !is_3d
	if is_3d:
		texture = THREE
	else:
		texture = TWO
	animation_player.play("switch")
