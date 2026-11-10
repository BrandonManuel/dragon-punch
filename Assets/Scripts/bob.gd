extends Boxer
	
func _on_player_punch(high: bool, flip:  bool) -> void:
	if is_vulnerable:
		position_tween = create_tween()
		position_tween.tween_property(self, "position", starting_position + Vector2(0, -5), .1)
		
		if high:
			if flip:
				play('hit_high_right')
			else:
				play('hit_high_left')
		else:
			play('hit_low')

func _process(delta: float) -> void:
	pass
