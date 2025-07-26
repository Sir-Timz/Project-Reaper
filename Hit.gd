extends State
var reset_pos
var anim_timer


func enter(dodge_dir = null, initial_pos = null):
	reset_pos = initial_pos
	anim_timer = Timer.new()
	add_child(anim_timer)
	anim_timer.one_shot = true
	anim_timer.wait_time = 0.4
	anim_timer.timeout.connect(Callable(self, "on_anim_timeout"))
	player.hit = true
	anim_timer.start()
	player.velocity = Vector3.ZERO
	if reset_pos:
		player.position.z = reset_pos.z
	

func update(delta):
	pass

func exit():
	player.hit = false

func on_anim_timeout():
	anim_timer.stop()
	fsm.change_state(self, "combat")
