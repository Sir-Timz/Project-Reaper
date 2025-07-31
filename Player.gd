extends CharacterBody3D


const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hori_input := 0.0
var vert_input := 0.0
var dodge_dir
var initial_pos
var new_scene : String
var parry = false
var parry_success = false
var dodging = false
var hit = false
var parry_on = false
var playback
var current_tree_node
var parry_over = true


@export var current_state = State.IDLE
@export var speed := 5.0
@export var dodge_speed = 500
@export var sprint_speed := 8
@export var mouse_sensitivity := 0.001
@export var rotation_speed := 10.0
@export var health = 100

@onready var hori_pivot = $HoriPivot
@onready var vert_pivot = $HoriPivot/VertPivot
@onready var model = $MeshInstance3D
@onready var anim_player = $AnimationPlayer
@onready var camera = $HoriPivot/VertPivot/Camera3D
@onready var hurtbox_parent = $HurtboxParent
@onready var hurtbox = $HurtboxParent/Hurtbox
@onready var parry_box_parent = $ParryBoxParent
@onready var parry_box = $ParryBoxParent/ParryBox
@onready var explore_fsm = $ExploreStateMachine
@onready var combat_fsm = $CombatStateMachine
@onready var fsm_controller = $FSMController
@onready var combat_anim_tree = $CombatAnimTree

signal playerimready
signal hit_received

enum State {
	IDLE,
	WALK,
	SPRINT,
	COMBAT,
	JUMP,
	FALL,
	ATTACK,
	PARRY,
	DODGE,
	HIT,
	RECOVER
	}


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	connect("playerimready", Callable(GameManager, "on_player_ready"))
	emit_signal("playerimready", self)



func _disable_camera():
	camera.current = false
	
func _process(delta):
	hori_pivot.rotate_y(hori_input)
	vert_pivot.rotate_x(vert_input)
	vert_pivot.rotation.x = clamp(vert_pivot.rotation.x, -0.5, 0.1)
	hori_input = 0
	vert_input = 0
	#print(playback.get_current_node())
	
	#print("parry box monitorable: ", parry_box_parent.monitorable)
	#print("parry box monitoring: ", parry_box_parent.monitoring)
	#print("parry box enabled: ", !parry_box.disabled)
	

	if playback:
		current_tree_node = playback.get_current_node()
		#print(current_tree_node)
		
	



func _physics_process(delta):
	move_and_slide()
	if velocity.length() > 1.0:
		model.rotation.y - lerp_angle(model.rotation.y, hori_pivot.rotation.y, rotation_speed * delta)
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			hori_input = - event.relative.x * mouse_sensitivity
			vert_input = - event.relative.y * mouse_sensitivity
	



func _on_hurtbox_parent_area_entered(area):
	fsm_controller.force_switch("hit")
	print("hit")
	
func _on_parry_box_parent_area_entered(area):
	parry_over = false
	parry_success = true
	combat_anim_tree.set("parameters/StateMachine/current", "parry_success")
	disable_box("parry")
	#print("GET PARRIED, CASUAL")
	fsm_controller.force_switch("combat")

func start_fsm(fsm):
	print("NEW SCENE FROM PLAYER " , fsm)
	fsm_controller.initialise(fsm)

func change_fsm(fsm):
	fsm_controller.change_fsm()

func on_tree_ready(node):
	combat_anim_tree = node
	playback = combat_anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	print("PLAYBACK SET")

func disable_box(box):
	match box:
		"hurt":
			hurtbox_parent.monitoring = false
		"parry":
			add_child(parry_box_parent)
			remove_child(parry_box_parent)
			#print("disabling parry box")
			#print("parry box monitorable: ", parry_box_parent.monitorable)
			#print("parry box monitoring: ", parry_box_parent.monitoring)
			#print("parry box enabled: ", !parry_box.disabled)

func enable_box(box):
	match box:
		"hurt":
			hurtbox_parent.monitoring = true
		"parry":
			remove_child(parry_box_parent)
			add_child(parry_box_parent)
			parry_box_parent.monitoring = true
			parry_box_parent.monitorable = true
			parry_box.disabled = false
			#parry_on = true
			#print("parry box monitorable: ", parry_box_parent.monitorable)
			#print("parry box monitoring: ", parry_box_parent.monitoring)
			#print("parry box enabled: ", !parry_box.disabled)
			
func disable_parry_success():
	parry_success = false
	parry_over = true
	print("parry success ", parry_success)
