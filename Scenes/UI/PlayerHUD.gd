extends Control

var is_visible := true
onready var opaque_dur: Timer = $OpaqueDur
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "slide_out")
	EventBus.connect("hp_changed", self, "_on_hp_changed")
	EventBus.connect("ability_used", self, "_on_ability_used")


func slide_in() -> void:
	if !is_visible:
		is_visible = true
		animation_player.play("slide_in")


func slide_out() -> void:
	if is_visible:
		is_visible = false
		animation_player.play_backwards("slide_in")


func show_hud() -> void:
	modulate.a = 1.0
	if Config.transparent_hud:
		opaque_dur.start()


func fade_hud() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.2, 0.5)


func _on_hp_changed(new_hp: int) -> void:
	show_hud()

func _on_ability_used(ability_num: int) -> void:
	show_hud()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_in":
		show_hud()

func _on_OpaqueDur_timeout() -> void:
	fade_hud()

func _on_SpawnDelay_timeout() -> void:
	animation_player.play("slide_in")
