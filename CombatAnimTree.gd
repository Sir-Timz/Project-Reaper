extends AnimationTree

@onready var player = $".."
@onready var fsm_controller = $"../FSMController"

signal treeimready

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("treeimready", Callable(player, "on_tree_ready"))
	connect("treeimready", Callable(fsm_controller, "on_tree_ready"))
	emit_signal("treeimready", self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	param()

func param():
	if player.parry:
		set("parameters/conditions/parry", true)
	else:
		set("parameters/conditions/parry", false)
	if player.parry_success:
		set("parameters/conditions/parry_success", true)
	else:
		set("parameters/conditions/parry_success", false)
	if player.parry_over:
		pass
		set("parameters/conditions/parry_over", true)
	else:
		set("parameters/conditions/parry_over", false)
	if player.dodging:
		set("parameters/conditions/dodge", true)
	else:
		set("parameters/conditions/dodge", false)
	if player.hit:
		set("parameters/conditions/hit", true)
	else:
		set("parameters/conditions/hit", false)
