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
var playback
var current_tree_node


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

	if playback:
		current_tree_node = playback.get_current_node()
		#print(current_tree_node)
		
	

	
	match current_state:
		State.IDLE:
			pass
		State.WALK:
			pass
		State.SPRINT:
			pass
		State.JUMP:
			pass
		State.FALL:
			pass
		State.ATTACK:
			pass
		State.PARRY:
			pass
		State.DODGE:
			pass
		State.HIT:
			pass
		State.RECOVER:
			pass


func _physics_process(delta):
	move_and_slide()
	if velocity.length() > 1.0:
		model.rotation.y - lerp_angle(model.rotation.y, hori_pivot.rotation.y, rotation_speed * delta)
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			hori_input = - event.relative.x * mouse_sensitivity
			vert_input = - event.relative.y * mouse_sensitivity
	

func change_state(state):
	match state:
		"idle":
			current_state = State.IDLE
			#print("idle")
		"walk":
			current_state = State.WALK
			#print("walking")
		"sprint":
			current_state = State.SPRINT
			#print("sprinting")
		"combat":
			current_state = State.COMBAT
			velocity.z = 0
			if initial_pos and position != initial_pos:
				position = initial_pos
			camera.current = false
			parry_box_parent.monitoring = false
			parry_box_parent.monitorable = false
			parry_box.disabled = true
			#print("combat")
		"jump":
			current_state = State.JUMP
			#print("jumping")
		"fall":
			current_state = State.FALL
			#print("falling")
		"attack":
			current_state = State.ATTACK
			parry_box_parent.monitoring = false
			parry_box_parent.monitorable = false
			parry_box.disabled = true
			#print("attacking")
		"parry":
			current_state = State.PARRY
			hurtbox.monitoring = false
			parry_box_parent.monitoring = true
			parry_box_parent.monitorable = true
			parry_box.disabled = false
			#print("parrying")
		"dodge":
			current_state = State.DODGE
			#print("dodging")
		"hit":
			if initial_pos:
				position = initial_pos
			current_state = State.HIT
			health -= 10
			parry_box_parent.monitoring = false
			parry_box_parent.monitorable = false
			parry_box.disabled = true
			#print("hit")
		"recover":
			current_state = State.RECOVER
			hurtbox.monitoring = true
			parry_box_parent.monitoring = false
			parry_box_parent.monitorable = false
			parry_box.disabled = true
			print(position.y)
			#print("recovering")
		

func _on_hurtbox_parent_area_entered(area):
	fsm_controller.force_switch("hit")
	print("hit")
	
func _on_parry_box_parent_area_entered(area):
	parry_success = true
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
			hurtbox_parent.collision_mask = 0
			print("HURTBOX DISABLED")
		"parry":
			parry_box_parent.collision_layer = 0
			parry_box_parent.collision_mask = 0

func enable_box(box):
	match box:
		"hurt":
			hurtbox_parent.collision_mask = 3
		"parry":
			parry_box_parent.collision_layer = 4
			parry_box_parent.collision_mask = 3
