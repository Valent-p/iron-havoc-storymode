extends Node
class_name MovementComponent

@export var player: CharacterBody3D
@export var model: Node3D

## To avoid it from rotation
@export var turret_pivot: Node3D

var direction: Vector3

func _physics_process(delta: float) -> void:
	# Save camera/turret/gun rotation so that it doesnt roate with body
	var turret_rotation = turret_pivot.global_rotation
	
	#gravity (Avoid modifying)
	var g = player.velocity.y
	
	var target_velocity = Vector3.ZERO
	
	# Rotate body
	if direction.length_squared() > 0.01:
		# 1. Calculate the Angle we WANT to face
		# atan2(x, z) gives the angle of the vector
		# added 180deg because foward is -z
		var target_angle = deg_to_rad(180) + atan2(direction.x, direction.z)
		
		# 2. Smoothly rotate the body to face that angle
		# We use rotate_toward or lerp_angle. lerp_angle is smoother.
		var current_rot = model.rotation.y
		model.rotation.y = lerp_angle(current_rot, target_angle, 5 * delta)
		
		# 3. Calculate Turn Penalty (The "Weight" of the tank)
		# If we are facing the wrong way, we move slower
		var angle_diff = abs(angle_difference(model.rotation.y, target_angle))
		
		# If angle is 0 (Perfect), penalty is 1.0. 
		# If angle is 90 deg (1.57 rad), penalty drops.
		var turn_penalty = clamp(1.0 - (angle_diff / 2.0), 0.0, 1.0)
		
		# 4. Apply Velocity
		target_velocity = direction * 10 * turn_penalty
	
	# Apply velocity
	player.velocity = target_velocity
	
	# Gravity
	if not player.is_on_floor():
		player.velocity.y = g
		player.velocity += player.get_gravity() * delta
	else:
		player.velocity.y = 0
	
	player.move_and_slide()
	
	# Restore
	turret_pivot.global_rotation = turret_rotation
	
