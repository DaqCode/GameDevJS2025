extends StaticBody2D

func _on_campfire_interract_body_entered(body:Node2D) -> void:
	if body.name == "Bron":
		print("You can now interact player")

func _on_campfire_interract_body_exited(body: Node2D) -> void:
	if body.name == "Bron":
		print("You no longer can interact player")
