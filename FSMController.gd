extends Node

var machines : Dictionary = {}
var initial_fsm : FiniteStateMachine
var current_fsm : FiniteStateMachine
@onready var player : Node = $".."




func initialise(scene):
	player.connect("hit_received", Callable(self, "player_hit"))
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
		on_tree_ready(null)
		current_fsm.update(delta)

func _physics_process(delta):
	if current_fsm:
		current_fsm.physics_update(delta)

func change_fsm():
	if current_fsm:
		if current_fsm == machines["combatstatemachine"]:
			current_fsm.exit()
			current_fsm = machines["explorestatemachine"]
		elif current_fsm == machines["explorestatemachine"]:
			current_fsm.exit()
			current_fsm = machines["combatstatemachine"]
		

func force_switch(state):
	match state:
		"hit":
			print("player hit")
			if current_fsm == machines["combatstatemachine"]:
				current_fsm.force_switch("hit")
		"combat":
			if current_fsm == machines["combatstatemachine"]:
				current_fsm.force_switch("combat")
	

func on_tree_ready(node):
	if current_fsm:
		if current_fsm == machines["combatstatemachine"]:
			player.combat_anim_tree.active = true
		elif current_fsm == machines["explorestatemachine"]:
			player.combat_anim_tree.active = false
