extends CharacterBody3D

var speed
const WALK_SPEED = 3.5
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.009
const CROUCH_SPEED = 1.8
# Get the gravity from the project settings to be synced with RigidBody nodes.


const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

var gravity = 9.8

var picked_object
var pull_power = 5

var rotation_power = 0.05
var locked = false 

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var hand = $Head/Camera3D/hand
@onready var interaction = $Head/Camera3D/RayCast3D
@onready var joint = $Head/Camera3D/Generic6DOFJoint3D
@onready var staticbody = $Head/Camera3D/StaticBody3D
@onready var footstep_audio = $FOOTSTEPS



var isPlayer: bool = true
var is_crouching: bool = false
const CROUCH_HEIGHT = 0.001
const STAND_HEIGHT = 0.4

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60)) 
		
		
		
	if Input.is_action_just_pressed("interact"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			remove_object()
		
	if Input.is_action_just_pressed("crouch"):
		is_crouching = not is_crouching
		if is_crouching:
			head.transform.origin.y  = CROUCH_HEIGHT
		else:
			head.transform.origin.y = STAND_HEIGHT

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.removed
	if is_crouching:
		speed = CROUCH_SPEED
	elif Input.is_action_pressed("sprint") and picked_object == null:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		
		var pitch = speed / WALK_SPEED 
		if is_on_floor():
			footstep_audio.pitch_scale = pitch
			if not footstep_audio.playing:
				footstep_audio.play()
		
		
		
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
		

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()
	
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*pull_power)



func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos




func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		joint.set_node_b(picked_object.get_path())

func remove_object():
	if picked_object != null:
		picked_object = null
		joint.set_node_b(joint.get_path())

func play_foot_audio():
	if is_on_floor():
		footstep_audio.play()



