extends HBoxContainer

signal new_best

const NO_RANK_TEX := preload("res://Assets/UI/no_rank.png")

onready var no_rank_icon: TextureRect = $NoRankIcon
onready var time_bonus_count: Label = $MarginContainer/VBoxContainer/TimeBonus/Count
onready var coin_bonus_count: Label = $MarginContainer/VBoxContainer/CoinBonus/Count
onready var damage_penalty_count: Label = $MarginContainer/VBoxContainer/DamagePenalty/Count
onready var ability_penalty_count: Label = $MarginContainer/VBoxContainer/AbilityPenalty/Count
onready var final_score: Label = $MarginContainer/VBoxContainer/FinalScore

var score := 0.0
var target_score := 0.0


func _ready() -> void:
	var time_score : float = Config.MAX_TIME_SCORE * Globals.run_stats["unit_survival_time"]
	var coin_score : float = Config.COIN_SCORE * Globals.run_stats["coins_collected"]
	var damage_penalty : float = Config.DMG_PENALTY * Globals.run_stats["damage_taken"]
	var ability_penalty : float = Config.ITEM_PENALTY * Globals.run_stats["items_used"]
	time_bonus_count.text = str(round(time_score))
	coin_bonus_count.text = str(round(coin_score))
	damage_penalty_count.text = "-"+str(round(damage_penalty))
	ability_penalty_count.text = "-"+str(round(ability_penalty))
	target_score = max(time_score-damage_penalty-ability_penalty, 0.0)
	if Globals.run_stats["beaten"]:
		no_rank_icon.texture = NO_RANK_TEX
	if target_score > Config.previous_best:
		Config.previous_best = target_score
		emit_signal("new_best")


func start() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "score", target_score, 0.5)
	if Globals.run_stats["beaten"]:
		tween.tween_callback(no_rank_icon, "appear", [target_score])


func _process(delta: float) -> void:
	final_score.text = "Score: "+str(round(score))
