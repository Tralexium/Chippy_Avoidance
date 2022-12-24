extends TextureButton

export var social_link := ""
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_SocialMediaButton_pressed() -> void:
	OS.shell_open(social_link)


func _on_SocialMediaButton_focus_entered() -> void:
	animation_player.play("hover")


func _on_SocialMediaButton_focus_exited() -> void:
	animation_player.play_backwards("hover")


func _on_SocialMediaButton_mouse_entered() -> void:
	animation_player.play("hover")


func _on_SocialMediaButton_mouse_exited() -> void:
	animation_player.play_backwards("hover")
