extends StaticBody2D

func _process(delta) -> void:
	# The middle is 25
	$PointLight2D.energy = randf_range(24.9, 25.1)


func _on_campfire_interract_body_entered(body:Node2D) -> void:
	if body.name == "Bron":
		print("You can now interact player")

func _on_campfire_interract_body_exited(body: Node2D) -> void:
	if body.name == "Bron":
		print("You no longer can interact player")
