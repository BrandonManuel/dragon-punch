class_name Boxer

extends AnimatedSprite2D

@onready var idle_timer: Timer = $IdleTimer
@onready var was_dodged_timer: Timer = $WasDodgedTimer

@export var idle_min_timer: float
@export var idle_max_timer: float

@export var attack_min_timer: float
@export var attack_max_timer: float

@export var was_dodged_wait_time: float

var starting_position: Vector2

# tween
var position_tween: Tween

# states
var is_vulnerable: bool = true
var can_attack: bool = true
var missed: bool = false

# signals
signal punch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position = position
	idle_timer.timeout.connect(idle)
	was_dodged_timer.timeout.connect(reset_dodged_flag)
	animation_finished.connect(idle_wait)
	
	idle()
	
	print('Boxer ready')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if missed and is_vulnerable and is_playing(): 
		pause()
		was_dodged_timer.start(was_dodged_wait_time)


func idle() -> void:
	if not is_playing() and not missed:
		play('idle')

func idle_wait() -> void:
	var wait_time := 0.0
	if animation.contains('hit') or animation.contains('punch') or animation.contains('block'):
		reset()
		play('idle')
		idle_timer.start(wait_time)
		return
		
	wait_time = randf_range(idle_min_timer, idle_max_timer)
	idle_timer.start(wait_time)

func reset() -> void:
	flip_h = false
	missed = false
	position_tween = create_tween()
	position_tween.tween_property(self, "position", starting_position, .05)
	
	if not is_playing() and animation != 'idle':
		idle()

func was_dodged() -> void:
	missed = true
	
func reset_dodged_flag() -> void:
	missed = false
	play()

func _on_animation_finished() -> void:
	flip_h = false
