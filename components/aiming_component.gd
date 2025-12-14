extends Node

@export var turret_pivot: Node3D
@export var gun_pivot: Node3D

var min_pitch = 0
var max_pitch = 45

const MOUSE_SENSITIVITY := 0.005

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# The turret (left/right)
		turret_pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY )
		
		# The gun (UP/DOWN)
		gun_pivot.rotate_x(-event.relative.y * (MOUSE_SENSITIVITY * 0.2) )
		
		# Clamp to have limits
		gun_pivot.rotation.x = clamp(gun_pivot.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	
