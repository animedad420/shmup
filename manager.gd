extends Node3D
class_name Manager
var player: Node
var playerLoad = preload("res://cathode.tscn")
var enemyLoad = preload("res://cube.tscn")
var lives = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var newPlayer = playerLoad.instantiate()
	get_tree().root.get_child(0).add_child(newPlayer)
	newPlayer.global_position = Vector3(0,-2,0)
	player = newPlayer
	var newEnemy = enemyLoad.instantiate()
	get_tree().root.get_child(0).add_child(newEnemy)
	newEnemy.global_position = Vector3.ZERO
	#newEnemy.global_position = Vector3(-1.247,1.194,0)
	newEnemy.manager = self
	newEnemy.movementQueue = {
		1:{"IDLE":1.0},
		2:{"MOVE":Vector3(3,0,1.2)},
		3:{"IDLE":1.0},
		4:{"MOVE":Vector3(-3,0,1.2)},
		5:{"IDLE":2.0},
		6:{"MOVE":Vector3(3,0,0.4)},
		7:{"MOVE":Vector3(-1,-2,0.4)},
		8:{"MOVE":Vector3(3,0,0.4)}
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null and $PlayerGone.is_stopped():
		$PlayerGone.start()


func _on_player_gone_timeout() -> void:
	var newPlayer = playerLoad.instantiate()
	get_tree().root.get_child(0).add_child(newPlayer)
	newPlayer.global_position = Vector3(0,0,0)
	player = newPlayer
