extends Control

onready var animation_player: AnimationPlayer = $AnimationPlayer


func enable_effect(ability_num: int) -> void:
	match ability_num:
		Globals.ABILITIES.MEGA_JUMP:
			animation_player.play("mega_jump")
		Globals.ABILITIES.SUPER_SPEED:
			animation_player.play("super_speed")
		Globals.ABILITIES.SHIELD:
			animation_player.play("shield")


func disable_effect(ability_num: int) -> void:
	match ability_num:
		Globals.ABILITIES.MEGA_JUMP:
			$MegaJump.emitting = false
		Globals.ABILITIES.SUPER_SPEED:
			$SpeedLines.emitting = false
		Globals.ABILITIES.SHIELD:
			$PlasmaBottom.emitting = false
			$PlasmaTop.emitting = false


func fade_out() -> void:
	animation_player.play("fade_out")
