extends State
var dodge_dir
var initial_pos
var recover
var active_timer
var anim_timer



func enter(dir = null, init_pos = null):
	recover = false
	anim_timer = Timer.new()
	add_child(anim_timer)
	player.dodging = true
	dodge_dir = dir
	initial_pos = player.position
	anim_timer.wait_time = 0.2833
	anim_timer.one_shot = true
	anim_timer.timeout.connect(Callable(self, "on_anim_timeout"))
	anim_timer.start()
	active_timer = Timer.new()
	add_child(active_timer)
	active_timer.wait_time = 0.2167
	active_timer.one_shot = true
	active_timer.timeout.connect(Callable(self, "on_active_timeout"))
	


func update(delta):
	if player.current_tree_node == "dodge":
		#print("WE DODGING YEAH")
		pass


func physics_update(delta):
	if recover == false:
		if abs(player.position.z - initial_pos.z) < 0.7:
			player.velocity.z = dodge_dir * player.dodge_speed * delta
		else:
			player.velocity.z = 0
	else:
		if abs(player.position.z - initial_pos.z) > 0.4:
			if player.position.z - initial_pos.z < 0:
				player.velocity.z += (player.dodge_speed * delta)
			else:
				player.velocity.z -= (player.dodge_speed * delta)
		else:
			player.position.z = initial_pos.z
			player.velocity.z = 0


func on_anim_timeout():
	recover = true
	active_timer.start()
	

func on_active_timeout():
	print("DODGE ANIM FINISHED")
	fsm.change_state(self, "combat", null, initial_pos)

func exit():
	anim_timer.stop()
	active_timer.stop()
	print("WE OUT OF DODGE")
	player.dodging = false
