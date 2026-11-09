class_name Boxer

extends AnimatedSprite2D

@onready var idle_timer: Timer = $IdleTimer

@export var idle_min_timer: float
@export var idle_max_timer: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle_timer.timeout.connect(idle)
	animation_finished.connect(idle_wait)
	idle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func idle() -> void:
	play('idle')

func idle_wait() -> void:
	var wait_time := randf_range(idle_min_timer, idle_max_timer)
	idle_timer.start(wait_time)
