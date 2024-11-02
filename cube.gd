extends RigidBody3D

func _process(delta: float) -> void:
	$Cube.rotate_x(1.2*delta)
	$Cube.rotate_y(0.6*delta)
	$Cube.rotate_z(-0.8*delta)
