extends Node
class_name InputComponent

@export var movement_component: MovementComponent
@export var turret_pivot: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3.ZERO
	
	if input_vector != Vector2.ZERO:
		# Convert 2D input to 3D
		var raw_direction = Vector3(input_vector.x, 0, input_vector.y)
		
		# Get Camera Rotation (Basis)
		var camera_basis = turret_pivot.global_transform.basis
		
		# Rotate input by Camera angle
		direction = camera_basis * raw_direction
		
		# Flatten Y (So looking up doesn't make us fly)
		direction.y = 0
		direction = direction.normalized()
	
	# 3. Send to Engine
	movement_component.direction = direction
