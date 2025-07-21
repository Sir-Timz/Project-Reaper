extends Node
class_name FiniteStateMachine

var states : Dictionary = {}
@export var initial_state : State
var current_state : State
@export var player : Node


func _ready():
	for child in get_children():
		if child is State:
			child.fsm = self
			child.player = player
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func change_state(old_state : State, new_state_name : String):
	if old_state != current_state:
		print("Trying to change from " + old_state.name + " but currently in " + current_state.name)
		return
	
	var new_state = states.get(new_state_name.to_lower())
	print(new_state_name.to_lower())
	if !new_state:
		print("no new state")
		return
		
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	
func _process(delta):
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
