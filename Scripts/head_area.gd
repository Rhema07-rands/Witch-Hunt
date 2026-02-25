extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(30)
		print ("player hit -30")
		#body.take_damage(-20)
		
		# Calculate knockback direction and strength
		var direction = (body.global_position - global_position).normalized()
		var knockback_force = direction * 400  # You can adjust the strength

		# Apply knockback
		if "velocity" in body:
			body.velocity += knockback_force
		
		print("Player hit with knockback")
