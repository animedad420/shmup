extends RigidBody3D

var manager: Manager
var inBeam: Node
var health: int = 20
signal health_depleted
var bullet = preload("res://enemybullet.tscn")
var myDirection: Vector3
var direction: Vector3
var chamber = 0
var speed = 2
var player: Node:
	get: return manager.player if manager else null
	
var movementQueue = {}
var movementOrder: int = 1
var movementActive: bool

func _ready() -> void:
	pass
	#movementQueue = {
		#1:{"IDLE":4.0},
		#2:{"MOVE":Vector3(3,0,1.2)},
		#3:{"IDLE":4.0},
		#4:{"MOVE":Vector3(-3,0,1.2)},
		#5:{"IDLE":0.5},
		#6:{"MOVE":Vector3(3,0,0.4)},
		#7:{"MOVE":Vector3(-1,-2,0.4)},
		#8:{"MOVE":Vector3(3,0,0.4)}
	#}

func _physics_process(delta: float) -> void:
	$Cube.rotate_x(1.2*delta)
	$Cube.rotate_y(0.6*delta)
	$Cube.rotate_z(-0.8*delta)
	set_axis_velocity(myDirection*speed)

func _process(delta: float) -> void:
	if !movementActive:
		if movementQueue.has(movementOrder):
			
			#IDLE - wait for next command
			if movementQueue[movementOrder].has("IDLE"):
				#print(movementQueue[movementOrder]["IDLE"])
				$IdleTime.start(movementQueue[movementOrder]["IDLE"])
			
			#MOVE - move to point in world (xy) in specified time (z)
			if movementQueue[movementOrder].has("MOVE"):
				var pos = $".".global_position
				pos.x += movementQueue[movementOrder]["MOVE"].x
				pos.y += movementQueue[movementOrder]["MOVE"].y
				$IdleTime.start(movementQueue[movementOrder]["MOVE"].z)
				#myDirection = (pos - $".".global_position).normalized()
				myDirection = $".".global_position.direction_to(pos)
				#print($".".global_position.distance_to(pos))
				speed = $".".global_position.distance_to(pos)/movementQueue[movementOrder]["MOVE"].z
				#print($".".global_position.x)
			
			#LERP - MOVE with linear interpolation
			#if movementQueue[movementOrder].has("LERP"):
			
			#LOOP - Return to specific point in movement order
			
			
			movementActive = true
		else: movementOrder = 1

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
		if player != null:
			direction = (player.global_position - $".".global_position).normalized()
		else: direction = Vector3(0,-1,0)
		
		newBullet.set_axis_velocity(direction*1.8)
		chamber -= 1
		$BulletLoad.start()

func update_player(node):
	player = node


func _on_idle_time_timeout() -> void:
	myDirection = Vector3.ZERO
	#print(myDirection)
	#print($".".global_position.x)
	linear_velocity = Vector3.ZERO
	movementOrder += 1
	movementActive = false
