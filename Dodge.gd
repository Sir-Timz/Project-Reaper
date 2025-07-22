extends State
var dodge_dir

func enter(dir = null, initial_pos = null):
	dodge_dir = dir


func update(delta):
	pass

func physics_update(delta):
	var initial_pos = player.position
	if abs(player.position.z - initial_pos.z) < 1:
		player.velocity.z = dodge_dir * player.dodge_speed * delta
	else:
		player.velocity.z = 0
		fsm.change_state(self, "recover", null, initial_pos)
