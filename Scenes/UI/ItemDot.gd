extends TextureRect

onready var animation_player: AnimationPlayer = $AnimationPlayer
var hightlight_bar := false


func _ready() -> void:
	if hightlight_bar:
		highlight()


func highlight() -> void:
	animation_player.play("highlight")


func enable() -> void:
	animation_player.play("enable")
