extends Area3D

@export var value: int = 1

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Player detected!") # Check the Output console for this!
		GameManager.add_score(value)
		queue_free()

func _process(delta: float) -> void:
	# 90 degrees per second
	rotate_y(deg_to_rad(90) * delta)
