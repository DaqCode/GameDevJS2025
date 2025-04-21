extends StaticBody2D

var can_interact : bool = false

func _process(_delta) -> void:
	# The middle is 25
	# The middle of the scale is Vector2(18.0, 13.59)
	$PointLight2D.energy = randf_range(24.9, 25.1)
	$PointLight2D.scale = Vector2(randf_range(17.5, 18.5), randf_range(13.40, 14))

	if Input.is_action_just_pressed("interact") and can_interact:
		Events.emit_signal("open_upgrade")


func _on_campfire_interract_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = true
		$InteractButton.visible = true

func _on_campfire_interract_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = false
		$InteractButton.visible = false
