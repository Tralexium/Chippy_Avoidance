extends HBoxContainer

onready var time_bonus_count: Label = $MarginContainer/VBoxContainer/TimeBonus/Count
onready var damage_penalty_count: Label = $MarginContainer/VBoxContainer/DamagePenalty/Count
onready var ability_penalty_count: Label = $MarginContainer/VBoxContainer/AbilityPenalty/Count
onready var final_score: Label = $MarginContainer/VBoxContainer/FinalScore

var score := 0.0
var target_score := 0.0


func _ready() -> void:
	var time_score := Config
	time_bonus_count.text = 


func start() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "score", gems_gained, 0.5)

func _process(delta: float) -> void:
	label.text = "+"+str(round(label_num))
