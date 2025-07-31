extends Node

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.current = true
	#player.change_state("combat")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
