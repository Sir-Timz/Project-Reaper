extends State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	pass

func physics_update(delta):
	if Input.is_action_just_pressed("jump"):
		fsm.change_state(self, "jump")
	if Input.is_action_just_pressed("sprint_toggle"):
		fsm.change_state(self, "walk")
	var tempy = player.velocity.y
	player.velocity.y = 0
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, player.hori_pivot.rotation.y)
	player.velocity = lerp(player.velocity, direction * player.sprint_speed, delta)
	player.velocity.y = tempy
	if not direction:
		fsm.change_state(self, "idle")
