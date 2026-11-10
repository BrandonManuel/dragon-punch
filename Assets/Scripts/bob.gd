extends Boxer
	
func _on_player_punch() -> void:
	if is_vulnerable:
		position_tween = create_tween()
		position_tween.tween_property(self, "position", starting_position + Vector2(0, -5), .1)
				
		play('hit_low')

func _process(delta: float) -> void:
	pass
