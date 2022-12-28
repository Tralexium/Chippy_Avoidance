extends Control

onready var opaque_dur: Timer = $OpaqueDur


func _ready() -> void:
	EventBus.connect("hp_changed", self, "_on_hp_changed")
	Config.connect("ability_used", self, "_on_ability_used")


func show_hud() -> void:
	modulate.a = 1.0
	if Config.transparent_hud:
		opaque_dur.start()


func fade_hud() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.25, 0.5)


func _on_hp_changed(new_hp: int) -> void:
	show_hud()

func _on_ability_used(ability_num: int) -> void:
	show_hud()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_in":
		show_hud()

func _on_OpaqueDur_timeout() -> void:
	fade_hud()
