extends RigidBody2D

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var max_speed = 1000.0
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
