extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# states
var is_hit: bool = false
	
func _physics_process(delta: float) -> void:
	handle_input()


func handle_input() -> void:
	if animated_sprite_2d.is_playing() and animated_sprite_2d.animation.contains('punch'):
		return
		
	var animation := 'idle'
		
	if Input.is_action_just_pressed("punch_left") or Input.is_action_just_pressed("punch_right"):
		animation = "punch_low"
		if Input.is_action_pressed("up"):
			animation = "punch_high"
		if Input.is_action_just_pressed("punch_right"):
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false

	animated_sprite_2d.play(animation)


func _on_animated_sprite_2d_animation_finished() -> void:
#	reset sprite flip after animation is complete
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("idle")
