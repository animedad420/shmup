extends RigidBody3D

@export var damage: int
@export var speedY: float
var isBeam: bool = false



func _on_area_3d_area_entered(area: Area3D) -> void:
	call_deferred("queue_free")
