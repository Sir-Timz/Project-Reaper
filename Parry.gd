extends State
var anim_timer
var active_timer
var recover


func enter(dodge_dir = null, initial_pos = null):
	anim_timer = Timer.new()
	add_child(anim_timer)
	anim_timer.one_shot = true
	anim_timer.wait_time = 0.5
	anim_timer.timeout.connect(Callable(self, "on_anim_timeout"))
	anim_timer.start()
	player.parry = true
	player.velocity = Vector3.ZERO
	

func update(delta):
	if player.current_tree_node == "parry":
		#print("WE PARRYING YEAH")
		pass
	
func physics_update(delta):
	pass

func exit():
	anim_timer.stop()
	player.parry = false

func on_anim_timeout():
	print("PARRY ANIM FINISHED")
	fsm.change_state(self, "combat")
