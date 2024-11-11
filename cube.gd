extends RigidBody3D

var inBeam: Node

func _physics_process(delta: float) -> void:
	$Cube.rotate_x(1.2*delta)
	$Cube.rotate_y(0.6*delta)
	$Cube.rotate_z(-0.8*delta)


func _on_area_3d_area_entered(area: Area3D) -> void:
	var attacker = area.get_parent()
	take_damage(attacker)


func _on_area_3d_area_exited(area: Area3D) -> void:
	var attacker = area.get_parent()
	if attacker == inBeam:
		inBeam = null


func take_damage(attacker: Node) -> void:
	print(attacker.damage)
	$Sprite3D.material_override.set_shader_parameter("intensity",1)
	$Cube.material_override.set_shading_mode(0)
	$FlashTime.start()
	if attacker.isBeam:
		inBeam = attacker
		$BeamCheck.start()


func _on_flash_time_timeout() -> void:
	$Sprite3D.material_override.set_shader_parameter("intensity",0)
	$Cube.material_override.set_shading_mode(1)


func _on_beam_check_timeout() -> void:
	if inBeam != null:
		take_damage(inBeam)
