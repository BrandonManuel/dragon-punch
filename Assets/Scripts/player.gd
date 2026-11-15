extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var block_timer: Timer = $BlockTimer

@export var successful_block_time: float = 1.0

# globals
var queued_punch_animation = ''
var flip = false

# state
var blocking: bool = false

# signals
signal punch
signal dodge
signal blocked

func _ready() -> void:
	block_timer.timeout.connect(toggle_block_off)
	
func _process(delta: float) -> void:
	if blocking:
		return
		
	handle_input()


func handle_input() -> void:
	if animated_sprite_2d.is_playing() and (animated_sprite_2d.animation.contains('punch') or animated_sprite_2d.animation.contains('dodge') or animated_sprite_2d.animation.contains('hit')):
		return
		
	var animation := 'idle'
		
#	handle block
	if Input.is_action_pressed("down"):
		animated_sprite_2d.play('block')
		return
		
#	handle punch
	if Input.is_action_just_pressed("punch_left") or Input.is_action_just_pressed("punch_right"):
		animation = 'punch_windup'
		queued_punch_animation = "punch_low"
		if Input.is_action_pressed("up"):
			queued_punch_animation = "punch_high"
			
		if Input.is_action_just_pressed("punch_right"):
			flip = true
		else:
			flip = false
		
#	handle dodge
	if Input.is_action_just_pressed("dodge_left"):
		animation = "dodge_left"
	if Input.is_action_just_pressed("dodge_right"):
		animation = "dodge_right"
	
	animated_sprite_2d.play(animation)

func is_hit(flip: bool) -> void:
	var hit := false
	var animation := 'hit_right'
	if not animated_sprite_2d.is_playing():
		hit = true
	elif not animated_sprite_2d.animation.contains('block') and not animated_sprite_2d.animation.contains('dodge'):
		hit = true
	
	if animated_sprite_2d.animation.contains('block'):
		blocked.emit(successful_block_time)
		blocking = true
		block_timer.start(successful_block_time)
		
	if hit:
		if flip:
			animation = 'hit_left'
			
		animated_sprite_2d.play(animation)
	else:
		dodge.emit()

func toggle_block_off() -> void:
	blocking = false

func _on_animated_sprite_2d_animation_finished() -> void:
#	play appropriate punch after windup
	if animated_sprite_2d.animation == 'punch_windup':
		animated_sprite_2d.flip_h = flip
		animated_sprite_2d.play(queued_punch_animation)
#		cleanup
		flip = false
		queued_punch_animation = ''
	else:
	#	reset sprite flip after animation is complete
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("idle")


func _on_animated_sprite_2d_animation_changed() -> void:
	if animated_sprite_2d and animated_sprite_2d.animation.contains("punch") and animated_sprite_2d.animation != 'punch_windup':
		punch.emit(animated_sprite_2d.animation.contains("high"), animated_sprite_2d.flip_h)
