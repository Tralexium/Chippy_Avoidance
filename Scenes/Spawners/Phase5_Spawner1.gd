extends Spatial

const PROJECTILE := preload("res://Scenes/Projectiles/Phase5_Atk1.tscn")

export var enabled := true setget set_enabled
export var projectile_rows := 15
export var projectiles_per_row := 2
export var initial_y := 70.0
export var projectile_y_gap := 10.0
export var projectile_x_rand := 28.0

var is_ready := false


func _ready() -> void:
	is_ready = true


func set_enabled(value: bool) -> void:
	enabled = value
	if not is_ready:
		return
	if enabled:
		spawn_projectiles()
	else:
		destroy_projectiles()


func spawn_projectiles() -> void:
	var y_offset := initial_y
	for i in range(projectile_rows):
		for j in range(projectiles_per_row):
			var proj_inst := PROJECTILE.instance()
			var x_offset := rand_range(-projectile_x_rand, projectile_x_rand)
			proj_inst.translate(Vector3(x_offset, y_offset, 0.0))
			add_child(proj_inst)
		y_offset += projectile_y_gap


func destroy_projectiles() -> void:
	for proj in get_children():
		proj.queue_free()


func move_projectiles() -> void:
	for proj in get_children():
		proj.move_to_rand_pos()
