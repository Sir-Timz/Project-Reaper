extends State


func update(delta):
	pass

func physics_update(delta):
	var move_dir = Input.get_axis("move_left", "move_right")
	var dodge_dir = Input.get_axis("move_forward", "move_back")
	player.velocity.x = move_dir * player.speed
	if Input.is_action_just_pressed("parry"):
		player.velocity.x = 0
		player.anim_player.play("parry")
	if Input.is_action_just_pressed("dodge"):
		if dodge_dir:
			fsm.change_state(self, "dodge", dodge_dir)
