extends Spatial

const COIN_SFX := preload("res://Audio/SFX/coin.wav")

export var velocity := Vector3.ZERO
export var lifetime := -1

var rotate_speed := 70.0
var collected := false
onready var gem: MeshInstance = $Position3D/Gem
onready var ring: MeshInstance = $Position3D/Ring
onready var position_3d: Position3D = $Position3D
onready var chime_loop: AudioStreamPlayer3D = $ChimeLoop
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var lifetime_timer: Timer = $Lifetime


func _ready() -> void:
	if lifetime != -1:
		lifetime_timer.start(lifetime)
	position_3d.scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(position_3d, "scale", Vector3.ONE, 0.5)


func _process(delta: float) -> void:
	if !collected:
		translation += velocity * delta
		gem.rotation_degrees.y += rotate_speed * delta
		ring.rotation_degrees.y -= rotate_speed * delta


func shrink() -> void:
	animation_player.play("shrink")


func _on_Hitbox_body_entered(body: Node) -> void:
	if !collected:
		collected = true
		chime_loop.playing = false
		animation_player.play("collected")
		SoundManager.play_ui_sound(COIN_SFX)
		EventBus.emit_signal("coin_collected")
		Globals.run_stats["coins_collected"] += 1


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()


func _on_Lifetime_timeout() -> void:
	shrink()
