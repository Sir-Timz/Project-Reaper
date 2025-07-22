extends State
var dodge_dir
var initial_pos

func enter(dir = null, init = null):
	dodge_dir = dir
	initial_pos = init

func update(delta):
	pass

func physics_update(delta):
	player.velocity = Vector3.ZERO
	if player.position.z != initial_pos.z:
		player.velocity.z = -(dodge_dir * player.dodge_speed * delta)
