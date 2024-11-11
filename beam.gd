extends Node3D

@export var damage: int
@export var growFactor: float = 55
@export var bulletPoint: Node
var isBeam: bool = true

func _physics_process(delta: float) -> void:
	if bulletPoint != null:
		global_position = bulletPoint.global_position
	
	$BeamMid.scale.y += growFactor
	$BeamMid.position.y = 0.5+($BeamMid.scale.y/200)
	$Area3D/CollisionBeamMid.shape.size.y += growFactor*0.01
	$Area3D/CollisionBeamMid.position.y = 0.5+($BeamMid.scale.y/200)
	print($BeamMid.position)
	print($BeamMid.scale.y)
	print($Area3D/CollisionBeamMid.shape.size.y)
