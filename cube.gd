extends RigidBody3D

var inBeam: Node
var health: int = 20
signal health_depleted
var bullet = preload("res://enemybullet.tscn")
var direction: Vector3
var chamber = 0

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
	#print(attacker.damage)
	health -= attacker.damage
	if health <= 0:
		call_deferred("queue_free")
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


func _on_health_depleted() -> void:
	if health <= 0:
		call_deferred("queue_free")


func _on_bullet_wait_timeout() -> void:
	chamber = 3
	firebullet()


func _on_bullet_load_timeout() -> void:
	firebullet()


func firebullet():
	if chamber > 0:
		var newBullet = bullet.instantiate()
		get_tree().root.get_child(0).add_child(newBullet)
		newBullet.global_position = $".".global_position
		direction = (get_parent().get_node("Cathode").global_position - $".".global_position).normalized()
		
		newBullet.set_axis_velocity(direction*1.8)
		chamber -= 1
		$BulletLoad.start()
