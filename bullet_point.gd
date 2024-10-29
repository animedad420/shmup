extends Node2D
var bullet = preload("res://bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var newBullet = bullet.instantiate()
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().root.get_child(0).add_child(newBullet)
		print(newBullet.global_position)
		print($".".global_position)
		newBullet.global_position = $".".global_position
		print(newBullet.global_position)
