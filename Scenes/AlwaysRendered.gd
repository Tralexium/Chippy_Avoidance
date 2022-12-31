extends CanvasLayer

const SLOMO_FX := preload("res://Scenes/UI/SlomoEffect.tscn")


func _ready() -> void:
	EventBus.connect("ability_used", self, "_on_ability_used")


func _on_ability_used(ability_num: int) -> void:
	if ability_num == Config.ABILITIES.SLO_MO:
		add_child_below_node($FX, SLOMO_FX.instance())
