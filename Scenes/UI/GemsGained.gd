extends VBoxContainer

var label_num := 0.0
onready var gems_gained : float = Config.MAX_GEMS * Globals.run_stats["unit_survival_time"]
onready var label: Label = $Label


func start() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "label_num", gems_gained, 0.5)

func _process(delta: float) -> void:
	label.text = "+"+str(round(label_num))
