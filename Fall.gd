extends State

func physics_update(delta):
	player.velocity.y -= player.gravity * delta
	if player.is_on_floor():
		fsm.change_state(self, "idle")
