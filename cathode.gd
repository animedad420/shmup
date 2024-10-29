extends CharacterBody3D

var bullet = preload("res://bullet.tscn")
var chamber = 0

func _physics_process(delta: float) -> void:
	var directionX := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_down", "ui_up")
	
	#set_velocity(Vector3(directionX*400,directionY*400,0))
	if directionX:
		velocity.x = directionX * 3.0
	else:
		velocity.x = move_toward(velocity.x, 0, 3.0)
	if directionY:
		velocity.y = directionY * 3.0
	else:
		velocity.y = move_toward(velocity.y, 0, 3.0)
	
	move_and_slide()
	
	#var newBullet = bullet.instantiate()
	
	if Input.is_action_just_pressed("ui_accept"):
		chamber = 4
		if $BulletTime.time_left == 0:
			firebullet()
	#if Input.is_action_pressed("ui_accept"):
		#get_tree().root.get_child(0).add_child(newBullet)
		#newBullet.global_position = $".".global_position
		#newBullet.set_axis_velocity(Vector3(0,15,0))
		#chamber -= 1

func _process(delta: float) -> void:
	#$Rings/Inner.rotate(Vector3(1,0.5,0),0.1*delta)
	#print($Rings/Inner.rotation)
	#$Rings/Inner.set_rotation_degrees()
	$Rings/Outer.rotate_y(0.75*delta)
	$Rings/Inner.rotate_x(1.2*delta)
	$Rings/Inner.rotate_y(0.6*delta)
	$Rings/Inner.rotate_z(-0.8*delta)
	$Rings/Center.rotate_x(-0.3*delta)
	$Rings/Center.rotate_y(-2*delta)
	$Rings/Center.rotate_z(0.5*delta)

func firebullet() -> void:
	print(chamber)
	var newBullet = bullet.instantiate()
	get_tree().root.get_child(0).add_child(newBullet)
	newBullet.global_position = $BulletPoint.global_position
	newBullet.set_axis_velocity(Vector3(0,15,0))
	chamber -= 1
	if chamber > 0:
		$BulletTime.start()

func _on_bullet_time_timeout() -> void:
	firebullet()
