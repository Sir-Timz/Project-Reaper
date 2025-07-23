extends State


func enter(dodge_dir = null, initial_pos = null):
	player.hit = true
	player.velocity = Vector3.ZERO
	

func update(delta):
	if player.combat_anim_tree.animation_finished:
		fsm.change_state(self, "combat")
func exit():
	player.hit = false
