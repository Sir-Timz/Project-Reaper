extends State


func enter(dodge_dir = null, initial_pos = null):
	player.parry = true
	player.velocity = Vector3.ZERO
	

func update(delta):
	if player.current_tree_node == "parry":
		print("WE PARRYING YEAH")
		if player.anim_player.animation_finished:
			print("PARRY ANIM FINISHED")
			fsm.change_state(self, "combat")
	
func physics_update(delta):
	pass

func exit():
	player.parry = false
