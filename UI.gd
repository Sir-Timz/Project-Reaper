extends Node

@onready var pause_menu = $PauseMenu

signal uiimready
signal enterCombat



# Called when the node enters the scene tree for the first time.
func _ready():
	connect("uiimready", Callable(GameManager, "on_ui_ready"))
	emit_signal("uiimready", self)
	connect("enterCombat", Callable(GameManager, "load_scene").bind("res://combat.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pause_toggle(paused):
	if paused:
		pause_menu.hide()
	else:
		pause_menu.show()


func _on_combat_button_pressed():
	emit_signal("enterCombat")
