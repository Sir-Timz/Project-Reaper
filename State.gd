extends Node
class_name State
var fsm : FiniteStateMachine
var player : Node = null

signal state_transition

func enter():
	#print(self)
	if player == null:
		print("couldnt find player")

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	pass
