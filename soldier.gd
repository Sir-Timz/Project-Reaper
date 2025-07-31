extends CharacterBody3D

@onready var anim_player = $AnimationPlayer
@onready var sword = $Sword
@onready var sword_hitbox = $"Sword/Sword Hitbox"
@onready var sword_cast = $Sword/SwordCast


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var current_state = State.COMBAT
@export var posture = 100

var posture_refill = false
var posture_hit = false

enum State {
	COMBAT,
	ATTACKING,
	ACTIVE,
	HIT,
	RECOVERY
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass
	
func _process(delta):
		match current_state:
			State.COMBAT:
				if not anim_player.is_playing():
					anim_player.play("attack")
			State.ACTIVE:
				pass
			State.RECOVERY:
				pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	match current_state:
		State.COMBAT:
			pass
		State.ACTIVE:
			var collider
			await reset_shape_cast()
			if check_sword_collision() and !posture_hit:
				posture_hit = true
				posture -= 10
				print(posture)
				if posture <= 0:
					print("POSTURE BROKE")
					anim_player.play("posture_break")
		State.RECOVERY:
			sword_cast.enabled = false
			posture_hit = false
	

func reset_shape_cast():
	sword_cast.enabled = false
	await get_tree().physics_frame
	sword_cast.enabled = true
	sword_cast.force_shapecast_update()
	
func parried():
	pass

func check_sword_collision():
		if sword_cast.is_colliding():
			return true
		return false

func _change_state(state):
	match state:
		"combat":
			current_state = State.COMBAT
			if posture <= 0:
				posture = 100
			#print("combat")
			sword.monitoring = false
			sword.monitorable = false
			
		"attack":
			current_state = State.ATTACKING
			#print("attack")
		"active":
			current_state = State.ACTIVE
			sword_cast.enabled = true
			sword.monitoring = true
			sword.monitorable = true
			await get_tree().create_timer(0.01).timeout
			#print("active")
		"hit":
			current_state = State.HIT
			sword.monitoring = false
			sword.monitorable = false
			#print("hit")
		"recover":
			current_state = State.RECOVERY
			sword.monitoring = false
			sword.monitorable = false
			#print("recover")


