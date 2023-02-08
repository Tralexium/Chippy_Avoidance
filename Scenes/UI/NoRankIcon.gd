extends TextureRect

onready var rank_icon: TextureRect = $RankIcon


func appear(score: int) -> void:
	rank_icon.appear(score)
	create_tween().tween_property(self, "self_modulate:a", 0.0, 0.2)
