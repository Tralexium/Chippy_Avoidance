extends HBoxContainer

signal new_best

onready var time_bonus_count: Label = $MarginContainer/VBoxContainer/TimeBonus/Count
onready var damage_penalty_count: Label = $MarginContainer/VBoxContainer/DamagePenalty/Count
onready var ability_penalty_count: Label = $MarginContainer/VBoxContainer/AbilityPenalty/Count
onready var final_score: Label = $MarginContainer/VBoxContainer/FinalScore

var score := 0.0
var target_score := 0.0


func _ready() -> void:
	var time_score : float = Config.MAX_SCORE * Globals.run_stats["unit_survival_time"]
	var damage_penalty : float = Config.DMG_PENALTY * Globals.run_stats["damage_taken"]
	var ability_penalty : float = Config.ITEM_PENALTY * Globals.run_stats["items_used"]
	time_bonus_count.text = str(round(time_score))
	damage_penalty_count.text = "-"+str(round(damage_penalty))
	ability_penalty_count.text = "-"+str(round(ability_penalty))
	target_score = max(time_score-damage_penalty-ability_penalty, 0.0)
	if target_score > Config.previous_best:
		Config.previous_best = target_score
		Config.save_data()
		emit_signal("new_best")


func start() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "score", target_score, 0.5)

func _process(delta: float) -> void:
	final_score.text = "Score: "+str(round(score))
