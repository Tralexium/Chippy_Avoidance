extends TextureRect

export var mute := false
export var automatic := false
export var rank_min_scores := [
	10000,
	8500,
	5000,
	0,
]

const RANK_TEXTURES := [
	preload("res://Assets/UI/rank_S.png"),
	preload("res://Assets/UI/rank_A.png"),
	preload("res://Assets/UI/rank_B.png"),
	preload("res://Assets/UI/rank_C.png"),
]

const SFX := [
	preload("res://Audio/SFX/rank_S.wav"),
	preload("res://Audio/SFX/rank_A.wav"),
	preload("res://Audio/SFX/rank_B.wav"),
	preload("res://Audio/SFX/rank_C.wav"),
]

const RANK_COLOR := [
	Color("ffde05"),
	Color("ff275a"),
	Color("00ffc9"),
	Color("00dcff"),
]

onready var circle: TextureRect = $Circle
onready var spark: TextureRect = $Spark
onready var backdrop_light: TextureRect = $BackdropLight


func _ready() -> void:
	if automatic:
		if Config.game_beaten:
			appear(Config.previous_best)
			backdrop_light.modulate.a = 0.0
		else:
			modulate.a = 0.0


func appear(score: int) -> void:
	var i := 0
	for min_score in rank_min_scores:
		if score >= min_score:
			texture = RANK_TEXTURES[i]
			modulate = RANK_COLOR[i]
			if !mute:
				SoundManager.play_ui_sound(SFX[i])
			break
		i += 1
	rect_scale = Vector2.ONE * 2.0
	modulate.a = 0.0
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(self, "rect_scale", Vector2.ONE, 0.3)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(circle, "self_modulate:a", 0.0, 2.0)
	tween.tween_property(circle, "rect_scale", Vector2.ONE * 3.0, 1.5)
	tween.tween_property(spark, "self_modulate:a", 0.0, 2.0)
	tween.tween_property(spark, "rect_scale", Vector2(3.0, 0.0), 1.5)
