extends Spatial

export var start_delay := 0.0

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var start_delay_timer: Timer = $StartDelay


func _ready() -> void:
	start_delay_timer.start(start_delay)


func _on_StartDelay_timeout() -> void:
	animation_player.play("wiggle_loop")
