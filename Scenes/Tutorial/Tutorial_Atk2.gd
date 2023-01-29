extends Spatial

var PROJECTILE := preload("res://Scenes/Universal/BasicProjectile.tscn")

export var speed := Vector3(12.0, 0.0, 0.0)
export var lifetime := 2.0
export var padding := 2.25
export var amount := 5
export var gap := 3

onready var timer: Timer = $Timer


func _ready() -> void:
	timer.start(lifetime)
	var gap_starting_pos := floor(rand_range(0, amount+1 - gap))
	var pos := translation
	for i in range(amount):
		var projectile_inst := PROJECTILE.instance()
		projectile_inst.disabled = true if (i >= gap_starting_pos and i < gap_starting_pos + gap) else false
		projectile_inst.translation = pos
		projectile_inst.appear_animation = true
		pos.y += padding
		add_child(projectile_inst)


func _process(delta: float) -> void:
	translation += speed * delta


func shrink() -> void:
	for projectile in get_children():
		if not projectile is Timer:
			projectile.shrink()
	var tween := create_tween()
	tween.tween_callback(self, "queue_free").set_delay(1.0)


func _on_Timer_timeout() -> void:
	shrink()
