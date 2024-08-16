extends MeshInstance3D
@export var damaga_dealt := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().call_group("Player", "damage", damaga_dealt)
