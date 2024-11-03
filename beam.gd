extends Node3D

func _process(delta: float) -> void:
	global_position = get_node("/root/Node3D/Cathode/BulletPoint").global_position
	
	$BeamMid.scale.y += 55
	$BeamMid.position.y = 0.499+($BeamMid.scale.y/200)
	print($BeamMid.position)
	print($BeamMid.scale.y)
