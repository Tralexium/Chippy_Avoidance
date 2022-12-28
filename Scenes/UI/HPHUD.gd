extends Control

const BAR := preload("res://Scenes/UI/HPBar.tscn")
const DEAD_ICON := preload("res://Assets/Blender Renders/player_head_dead_b&w_small.png")

var shake_amnt := 0.0
var initial_pos := Vector2.ZERO
onready var health_bars: HBoxContainer = $HealthBars
onready var player_head_icon: TextureRect = $PlayerHeadIcon
onready var black_bar: Panel = $BlackBar
onready var blood_part: Particles2D = $BloodPart


func _ready() -> void:
	EventBus.connect("hp_changed", self, "eliminate_bar")
	for i in range(3):
		health_bars.add_child(BAR.instance())
	yield(get_tree(), "idle_frame")
	black_bar.rect_size.x = health_bars.rect_size.x + 5


func _process(delta: float) -> void:
	if shake_amnt > 0.0:
		rect_position.x = initial_pos.x + rand_range(-shake_amnt, shake_amnt)
		rect_position.y = initial_pos.y + rand_range(-shake_amnt, shake_amnt)


func eliminate_bar(new_hp: int) -> void:
	var bars_left := health_bars.get_child_count()
	if bars_left > 1:
		health_bars.get_child(bars_left-1).shrink()
		if bars_left == 2:
			player_head_icon.texture = DEAD_ICON
	blood_part.emitting = true
	shake_amnt = 15.0
	initial_pos = rect_position
	var tween = create_tween()
	tween.tween_property(self, "shake_amnt", 0.0, 0.3)
