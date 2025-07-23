extends State
var dodge_dir
var initial_pos

func enter(dir = null, init = null):
	player.velocity = Vector3.ZERO
	dodge_dir = dir
	initial_pos = init

func update(delta):
	pass

func physics_update(delta):
	if initial_pos:
		if player.position.z != initial_pos.z:
			player.velocity.z = -(dodge_dir * player.dodge_speed * delta)
