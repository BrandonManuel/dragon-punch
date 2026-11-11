extends Boxer

@onready var attack_timer: Timer = $AttackTimer
	
func _ready() -> void:
	attack_timer.timeout.connect(attack)
	animation_finished.connect(reset)
	
	print('Bob ready')
	super()
	
func _on_player_punch(high: bool, flip:  bool) -> void:
	if is_vulnerable:
		can_attack = false
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
	if can_attack and attack_timer.time_left == 0:
		var time := randf_range(attack_min_timer, attack_max_timer)
		attack_timer.start(time)

func attack() -> void:
	can_attack = false
	position_tween = create_tween()
	position_tween.tween_property(self, "position", starting_position + Vector2(0, 20), .1)
	play('punch_low_left')
	
func reset() -> void:
	can_attack = true
	var time := randf_range(attack_min_timer, attack_max_timer)
	attack_timer.start(time)
	super()
