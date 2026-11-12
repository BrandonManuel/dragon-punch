extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var bob: Boxer = $Bob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bob.punch.connect(player.is_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
