extends RayCast

export var hidden := true

enum STATE {SOLID, HAZARD, NONE}
var current_state : int = STATE.NONE
var old_state : int = STATE.NONE
var tween : SceneTreeTween
onready var shadow: Sprite3D = $Shadow
onready var hazard_scanner: RayCast = $HazardScanner


func _ready() -> void:
	shadow.modulate = Color.transparent


func _process(delta: float) -> void:
	if global_translation.y < 0.0:
		set_state(STATE.NONE)
		return
	if is_colliding() and !hidden:
		shadow.global_translation = get_collision_point()
		shadow.global_translation.y = max(shadow.global_translation.y, 0.1)
		if hazard_scanner.is_colliding():
			set_state(STATE.HAZARD)
		else:
			set_state(STATE.SOLID)
	else:
		shadow.global_translation.y = 0.0
		if global_translation.y < 0.0 or hidden:
			set_state(STATE.NONE)


func set_state(state: int) -> void:
	current_state = state
	if current_state != old_state:
		old_state = current_state
		var col := Color.transparent
		if tween != null and tween.is_running():
			tween.kill()
		match current_state:
			STATE.SOLID:
				col = Color.yellow
			STATE.HAZARD:
				shadow.modulate = Color.red
				return
		tween = create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property(shadow, "modulate", col, 0.15)
