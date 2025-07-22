extends State


func enter(dodge_dir = null, initial_pos = null):
	#print(self)
	if player == null:
		print("couldnt find player")
	player.velocity.y = player.JUMP_VELOCITY
	print(player.velocity.y)

func update(delta):
	print(player.velocity.y)

func physics_update(delta):
	if !player.is_on_floor():
		player.velocity.y -= player.gravity * delta
	if player.velocity.y >= 0:
		fsm.change_state(self, "fall")
