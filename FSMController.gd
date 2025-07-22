extends Node

var machines : Dictionary = {}
var initial_fsm : FiniteStateMachine
var current_fsm : FiniteStateMachine
@onready var player : Node = $".."




func initialise(scene):

	print(player)
	for child in get_children():
		if child is FiniteStateMachine:
			print("child " , child)
			child.controller = self
			child.player = player
			machines[child.name.to_lower()] = child
			child.fsm_transition.connect(change_fsm)
	match scene:
		"Explore":
			initial_fsm = machines["explorestatemachine"]
		"Combat":
			initial_fsm = machines["combatstatemachine"]
	if initial_fsm:
		initial_fsm.enter()
		current_fsm = initial_fsm

func _process(delta):
	if current_fsm:
		current_fsm.update(delta)

func _physics_process(delta):
	if current_fsm:
		current_fsm.physics_update(delta)

func change_fsm():
	pass
