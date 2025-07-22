extends Node

var initial_scene = "explore"
var player : Node
var root
var paused = false
var current_scene : Node
var ui : Node


func _ready():
	root = get_tree().root
	load_scene("res://explore.tscn")
	print("scene loaded")
	find_player()
	find_ui()
	


func _process(delta):
	if Input.is_action_just_pressed("cancel"):
		pause_toggle()

func load_scene(path):
	var new_scene = get_node(path)
	if not current_scene:
		get_tree().current_scene = new_scene
	else:
		if current_scene != new_scene:
			get_tree().current_scene = new_scene
	current_scene = new_scene
	if player:
		player.new_scene = root.get_child(1)

func find_player():
	print(root.get_child(0))
	print(root.get_child(1))
	player = root.get_child(1).get_node_or_null("Player")
	print(player)

func find_ui():
	ui = root.get_child(1).get_node_or_null("UI")
	print(ui)

func pause_toggle():
	if paused:
		Engine.time_scale = 1
		paused = false
		ui.pause_toggle(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Engine.time_scale = 0
		paused = true
		ui.pause_toggle(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_player_ready():
	print("heard player is ready")
	print("CURRENT SCENE FROM GLOBAL " , root.get_child(1))
	player.new_scene = root.get_child(1).name
	player.start_fsm()
