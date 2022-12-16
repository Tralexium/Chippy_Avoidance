extends Spatial

const PILLAR := preload("res://Scenes/Terrain/FallingPillar.tscn")

export var active := false setget set_active
export var pillar_rows := 5
export var pillar_columns := 5
export var pillar_offset := 6.3

var is_ready := false
var pillars := []
var fallen_pillars := []
onready var pillars_start_pos: Position3D = $Pillars


func _ready() -> void:
	is_ready = true
	spawn_pillars()
	hide_pillars()


func set_active(value: bool) -> void:
	active = value
	if !is_ready:
		return
	if active:
		show_pillars()
		fallen_pillars.clear()
	else:
		hide_pillars()
	


func spawn_pillars() -> void:
	var offset := Vector3.ZERO
	pillars_start_pos.translate(Vector3((-pillar_offset*pillar_columns)/2 + pillar_offset/2, 0.0, (-pillar_offset*pillar_rows)/2 + pillar_offset/2))
	for row in pillar_rows:
		for column in pillar_columns:
			var pillar_inst := PILLAR.instance()
			pillar_inst.translate(offset)
			pillars.push_back(pillar_inst)
			pillars_start_pos.add_child(pillar_inst)
			offset.z += pillar_offset
		offset.z = 0.0
		offset.x += pillar_offset


func show_pillars() -> void:
	for pillar in pillars:
		pillar.show()
		pillar.find_node("CollisionShape").disabled = false
		pillar.animation_player.play("RESET")


func hide_pillars() -> void:
	for pillar in pillars:
		pillar.hide()
		pillar.find_node("CollisionShape").disabled = true


func pulse_pillars_down(starting_pos: Vector2, ripple_speed: float = 10.0) -> void:
	for pillar in pillars:
		var pillar_xz = Vector2(pillar.global_translation.x, pillar.global_translation.z)
		var delay = starting_pos.distance_to(pillar_xz) / (pillar_offset*ripple_speed)
		pillar.bounce_down(delay, 1.5)


func pulse_pillars_down_at_player(ripple_speed: float = 10.0) -> void:
	var player_pos : Vector3 = get_tree().get_nodes_in_group("player")[0].global_translation
	var starting_pos := Vector2(player_pos.x, player_pos.z)
	for pillar in pillars:
		var pillar_xz = Vector2(pillar.global_translation.x, pillar.global_translation.z)
		var delay = starting_pos.distance_to(pillar_xz) / (pillar_offset*ripple_speed)
		pillar.bounce_down_hard(delay, 1.5)

func pulse_pillars_up(starting_pos: Vector2, ripple_speed: float = 10.0) -> void:
	for pillar in pillars:
		var pillar_xz = Vector2(pillar.global_translation.x, pillar.global_translation.z)
		var delay = starting_pos.distance_to(pillar_xz) / (pillar_offset*ripple_speed)
		pillar.bounce_up(delay, 1.5)


func knock_random_pillar() -> void:
	if fallen_pillars.size() == pillars.size():
		return
	while true:
		var rand_num := randi() % pillars.size()
		if not pillars[rand_num].has_fallen:
			pillars[rand_num].fall()
			fallen_pillars.push_back(pillars[rand_num])
			break


func restore_fallen_pillars() -> void:
	for pillar in fallen_pillars:
		pillar.rise()

