extends State
var dodge_dir
var initial_pos

func enter(dir = null, initial_pos = null):
	player.dodging = true
	dodge_dir = dir


func update(delta):
	if player.current_tree_node == "dodge":
		print("WE DODGING YEAH")
		if player.anim_player.animation_finished:
			print("DODGE ANIM FINISHED")
			fsm.change_state(self, "recover", null, initial_pos)


func physics_update(delta):
	initial_pos = player.position
	if abs(player.position.z - initial_pos.z) < 1:
		player.velocity.z = dodge_dir * player.dodge_speed * delta
	else:
		player.velocity.z = 0

func exit():
	player.dodging = false
