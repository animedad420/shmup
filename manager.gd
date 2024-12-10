extends Node3D
class_name Manager
var isGameStarted: bool = false
var player: Node
var playerLoad = preload("res://cathode.tscn")
var enemyLoad = preload("res://cube.tscn") #use this for enemy instancing
var lives = 3
class SpawnEvent:
	var enemyType: PackedScene
	var enemyMoveRes: CustomResource
	var timeSpawnNext: float
var spawnList: Array[int] = [0,0]
var spawnQueuePlace: int = 0
var introTimer: Timer
var spawnTimer: Timer
@export var enemyList: Array[PackedScene]
@export var resourceList: Array[CustomResource]
@export var timerList: Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	introTimer = Timer.new()
	introTimer.one_shot = true
	add_child(introTimer)
	introTimer.start(5)
	introTimer.timeout.connect(_on_intro_end)
	
	spawnTimer = Timer.new()
	spawnTimer.one_shot = true
	add_child(spawnTimer)
	spawnTimer.start(5)
	spawnTimer.timeout.connect(_on_spawn_timeout)
	
	var newPlayer = playerLoad.instantiate()
	get_tree().root.get_child(0).add_child(newPlayer)
	newPlayer.global_position = Vector3(0,-2,0)
	player = newPlayer
	
	#spawnList[0] = SpawnEvent.new()
	
	#var newEnemy = enemyLoad.instantiate()
	#get_tree().root.get_child(0).add_child(newEnemy)
	#newEnemy.global_position = Vector3.ZERO
	#newEnemy.global_position = Vector3(-1.247,1.194,0)
	#newEnemy.manager = self
	#newEnemy.movementQueue = {
		#1:{"IDLE":1.0},
		#2:{"MOVE":Vector3(3,0,1.2)},
		#3:{"IDLE":1.0},
		#4:{"MOVE":Vector3(-3,0,1.2)},
		#5:{"IDLE":2.0},
		#6:{"MOVE":Vector3(3,0,0.4)},
		#7:{"MOVE":Vector3(-1,-2,0.4)},
		#8:{"MOVE":Vector3(3,0,0.4)}
	#}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isGameStarted:
		pass
	if player == null and $PlayerGone.is_stopped():
		$PlayerGone.start()


func _on_player_gone_timeout() -> void:
	var newPlayer = playerLoad.instantiate()
	get_tree().root.get_child(0).add_child(newPlayer)
	newPlayer.global_position = Vector3(0,0,0)
	player = newPlayer


func _on_intro_end() -> void:
	print("spawning starting")
	isGameStarted = true
	#spawnList[0] = SpawnEvent.new()
	#spawnList[0].enemyType = enemyLoad
	#print(spawnList[0])
	#print(spawnList[0].enemyType)

func _on_spawn_timeout() -> void:
	var newEnemy = enemyList[spawnQueuePlace].instantiate()
	add_child(newEnemy)
	newEnemy.global_position = Vector3.ZERO
	#newEnemy.global_position = Vector3(-1.247,1.194,0)
	newEnemy.manager = self
	newEnemy.movementQueue = resourceList[spawnQueuePlace].testVar
	spawnTimer.start(timerList[spawnQueuePlace])
	spawnQueuePlace += 1
