extends CharacterBody3D

var bullet = preload("res://bullet.tscn")
var beam = preload("res://beam.tscn")
var activeBeam: Node
var chamber = 0
var spinMult = 1
var beamMult = 1

func _physics_process(delta: float) -> void:
	var directionX := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_down", "ui_up")
	
	#set_velocity(Vector3(directionX*400,directionY*400,0))
	if directionX:
		velocity.x = directionX * 4.0 * beamMult
	else:
		velocity.x = move_toward(velocity.x, 0, 4.0 * beamMult)
	if directionY:
		velocity.y = directionY * 4.0 * beamMult
	else:
		velocity.y = move_toward(velocity.y, 0, 4.0 * beamMult)
	
	move_and_slide()
	
	#var newBullet = bullet.instantiate()
	
	if Input.is_action_just_pressed("ui_accept"):
		chamber = 3
		spinMult = 3
		$BeamHold.start()
		if $BulletTime.time_left == 0:
			chamber += 1
			firebullet()
	#if Input.is_action_pressed("ui_accept"):
		#get_tree().root.get_child(0).add_child(newBullet)
		#newBullet.global_position = $".".global_position
		#newBullet.set_axis_velocity(Vector3(0,15,0))
		#chamber -= 1
	if Input.is_action_just_released("ui_accept") and activeBeam != null:
		activeBeam.call_deferred("queue_free")
		beamMult = 1

func _process(delta: float) -> void:
	#$Rings/Inner.rotate(Vector3(1,0.5,0),0.1*delta)
	#print($Rings/Inner.rotation)
	#$Rings/Inner.set_rotation_degrees()
	if spinMult > 1:
		spinMult -= 0.05
	$Rings/Outer.rotate_y(0.75*delta*spinMult)
	$Rings/Inner.rotate_x(1.2*delta*spinMult)
	$Rings/Inner.rotate_y(0.6*delta*spinMult)
	$Rings/Inner.rotate_z(-0.8*delta*spinMult)
	$Rings/Center.rotate_x(-0.3*delta*spinMult)
	$Rings/Center.rotate_y(-2*delta*spinMult)
	$Rings/Center.rotate_z(0.5*delta*spinMult)
	$Shine.rotation.z = -0.17 + randf_range(-delta,delta)
	$Shine.scale = Vector3(randf_range(0.4,1),randf_range(0.3,1),1)
	$Shine.modulate.a = randf_range(0.1,1.0)

func firebullet() -> void:
	print(chamber)
	var newBullet = bullet.instantiate()
	get_tree().root.get_child(0).add_child(newBullet)
	newBullet.global_position = $BulletPoint.global_position
	newBullet.set_axis_velocity(Vector3(0,newBullet.speedY,0))
	chamber -= 1
	if chamber > 0:
		$BulletTime.start()

func _on_bullet_time_timeout() -> void:
	firebullet()


func _on_beam_hold_timeout() -> void:
	if activeBeam == null and Input.is_action_pressed("ui_accept"):
		var newBeam = beam.instantiate()
		get_tree().root.get_child(0).add_child(newBeam)
		newBeam.global_position = $BulletPoint.global_position
		activeBeam = newBeam
		newBeam.bulletPoint = $BulletPoint
		beamMult = 0.5


func _on_area_3d_area_entered(area: Area3D) -> void:
	call_deferred("queue_free")
