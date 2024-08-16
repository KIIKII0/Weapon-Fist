extends MeshInstance3D

var boost = 5
@onready var boost_timer = $Timer
# Called when the node enters the scene tree for the first time.

func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		pass
	

	
