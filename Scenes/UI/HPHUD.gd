extends Control

const BAR := preload("res://Scenes/UI/HPBar.tscn")
const DEAD_ICON := preload("res://Assets/Blender Renders/player_head_dead_b&w_small.png")
const LIVE_ICON := preload("res://Assets/Blender Renders/player_head_small.png")

var shake_amnt := 0.0
var initial_pos := Vector2.ZERO
var hp_bars := 0
var previous_hp := 0
onready var health_bars: HBoxContainer = $HealthBars
onready var player_head_icon: TextureRect = $PlayerHeadIcon
onready var black_bar: Panel = $BlackBar
onready var blood_part: Particles2D = $BloodPart


func _ready() -> void:
	EventBus.connect("hp_changed", self, "eliminate_bar")
	set_bars(Config.player_max_hp)


func set_bars(bars: int) -> void:
	if health_bars.get_child_count() > 0:
		for bar in health_bars.get_children():
			if bar.name != "IconSpacing":
				bar.queue_free()
	player_head_icon.texture = LIVE_ICON
	for i in range(bars):
		health_bars.add_child(BAR.instance())
	hp_bars = bars
	previous_hp = bars
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
