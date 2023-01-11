extends Control

const BAR := preload("res://Scenes/UI/HPBar.tscn")
const DEAD_ICON := preload("res://Assets/Blender Renders/player_head_dead_b&w_small.png")

var shake_amnt := 0.0
var initial_pos := Vector2.ZERO
onready var hp_bars := Config.player_max_hp
onready var previous_hp := Config.player_max_hp
onready var health_bars: HBoxContainer = $HealthBars
onready var player_head_icon: TextureRect = $PlayerHeadIcon
onready var black_bar: Panel = $BlackBar
onready var blood_part: Particles2D = $BloodPart


func _ready() -> void:
	EventBus.connect("hp_changed", self, "eliminate_bar")
	for i in range(hp_bars):
		health_bars.add_child(BAR.instance())
	yield(get_tree(), "idle_frame")
	black_bar.rect_size.x = health_bars.rect_size.x + 5


func _process(delta: float) -> void:
	if shake_amnt > 0.0:
		rect_position.x = initial_pos.x + rand_range(-shake_amnt, shake_amnt)
		rect_position.y = initial_pos.y + rand_range(-shake_amnt, shake_amnt)


func eliminate_bar(new_hp: int) -> void:
	var loops := abs(new_hp - previous_hp)
	previous_hp = new_hp
	
	for i in range(loops):
		if hp_bars > 0 and not Config.infinite_hp:
			health_bars.get_child(hp_bars).shrink()
			if hp_bars == 1:
				player_head_icon.texture = DEAD_ICON
		hp_bars -= 1
	
	blood_part.emitting = true
	shake_amnt = 15.0
	initial_pos = rect_position
	var tween = create_tween()
	tween.tween_property(self, "shake_amnt", 0.0, 0.3)
