class_name Boxer

extends AnimatedSprite2D

@onready var idle_timer: Timer = $IdleTimer

@export var idle_min_timer: float
@export var idle_max_timer: float

var starting_position: Vector2

# tween
var position_tween: Tween

# states
var is_vulnerable: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position = position
	idle_timer.timeout.connect(idle)
	animation_finished.connect(idle_wait)
	idle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func idle() -> void:
	if not is_playing():
		play('idle')

func idle_wait() -> void:
	var wait_time := 0.0
	if animation.contains('hit'):
		reset_position()
		play('idle')
		idle_timer.start(wait_time)
		return
		
	wait_time = randf_range(idle_min_timer, idle_max_timer)
	idle_timer.start(wait_time)

func reset_position() -> void:
	position_tween = create_tween()
	position_tween.tween_property(self, "position", starting_position, .05)
