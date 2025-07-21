extends State



func update(delta):
	pass

func physics_update(delta):
	player.velocity = Vector3.ZERO
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, player.hori_pivot.rotation.y)
	if direction:
		fsm.change_state(self, "walk")
	if Input.is_action_just_pressed("jump"):
		fsm.change_state(self, "jump")
