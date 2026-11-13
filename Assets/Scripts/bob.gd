extends Boxer

@onready var attack_timer: Timer = $AttackTimer
	
func _ready() -> void:
	attack_timer.timeout.connect(attack)
	animation_finished.connect(handle_animation_finished)
	
	print('Bob ready')
	super()
	
func _on_player_punch(high: bool, flip: bool) -> void:
	if is_vulnerable:
		can_attack = false
		position = starting_position
		position_tween = create_tween()
		position_tween.tween_property(self, "position", starting_position + Vector2(0, -5), .1)
		
		if high:
			if flip:
				if flip_h:
					play('hit_high_left')
				else:
					play('hit_high_right')
			else:
				if flip_h:
					play('hit_high_right')
				else:
					play('hit_high_left')
		else:
			play('hit_low')
			
		if not hit_stun_timer.time_left:
			hit_stun_timer.start(hit_stun_time)
	elif not animation.contains('punch'):
		can_attack = false
		attack_timer.paused = true
		position_tween = create_tween()
		position_tween.tween_property(self, "position", starting_position + Vector2(0, -2.5), .1)
		
		if high:
			play('block_high')
		else:
			play('block_low')

func _process(delta: float) -> void:
	if can_attack and attack_timer.time_left == 0:
		var time := randf_range(attack_min_timer, attack_max_timer)
		attack_timer.start(time)
		
	if animation.contains('punch'):
		if frame == sprite_frames.get_frame_count(animation) - 1:
			is_vulnerable = true
		elif frame == sprite_frames.get_frame_count(animation) - 2:
			punch.emit(flip_h)
	elif animation.contains('stun') or hit_stun_timer.time_left:
		is_vulnerable = true
	else:
		is_vulnerable = false
		
	super(delta)

func attack() -> void:
	can_attack = false
	position_tween = create_tween()
	position_tween.tween_property(self, "position", starting_position + Vector2(0, 20), .1)
#	50/50 to flip punch
	if randi_range(0, 1):
		flip_h = true
		
	play('punch_hook_left')	

func was_dodged() -> void:
	super()
	
func handle_animation_finished() -> void:
	if hit_stun_timer.time_left or animation.contains('stun'):
		play('hit_stun')
	else:
		reset()
	
func reset() -> void:
	can_attack = true
	if not attack_timer.time_left:
		var time := randf_range(attack_min_timer, attack_max_timer)
		attack_timer.start(time)
		
	attack_timer.paused = false
	super()
