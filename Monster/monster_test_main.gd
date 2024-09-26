extends CharacterBody3D
enum States{
	patrol,
	chasing,
	hunting,
	waiting
	}
	

var player_in_sight: bool = false
var player_heard_close: bool = false

var currentState : States
var navigationAgent : NavigationAgent3D
@export var waypoints : Array
var waypointIndex : int

var speed
const base_speed = 2.5
const chase_speed = 5


@onready var animation_tree : AnimationTree = $AnimationTree
@onready var player = Node3D 
@onready var talking = $talking
@onready var IseeYou = $IseeYou

var AttackTimer : Timer
var patrolTimer : Timer
var chaseTimer : Timer


func _ready():
	currentState = States.patrol
	navigationAgent = $NavigationAgent3D
	waypoints = get_tree().get_nodes_in_group("EnemyWaypoint")
	navigationAgent.set_target_position(waypoints[0].global_position)
	patrolTimer = $PatrolTimer
	chaseTimer = $ChaseTimer
	AttackTimer = $AttackTimer
	collision_exception()
	
	pass
	
func _process(delta):
	
	match currentState:
		States.patrol:
			speed = base_speed
			if(navigationAgent.is_navigation_finished()):
				currentState = States.waiting
				patrolTimer.start()
				animation_tree["parameters/conditions/is_moving"] = false
				animation_tree["parameters/conditions/Idle"] = true
				return
			var targetPos = navigationAgent.get_next_path_position()
			var direction = global_position.direction_to(targetPos)
			faceDirection(delta, direction.normalized())
			velocity = direction * speed
			
			move_and_slide()
			animation_tree["parameters/conditions/is_moving"] = true
			animation_tree["parameters/conditions/Idle"] = false
			
			if player_in_sight or player_heard_close:
				currentState = States.chasing
			pass
		
		States.chasing:
			speed = chase_speed
			if player != null:
				var player_pos = player.global_transform.origin
				navigationAgent.set_target_position(player_pos)
				var direction = global_transform.origin.direction_to(player_pos)
				faceDirection(delta, direction.normalized())
				velocity = direction * speed
				
				move_and_slide()
				
				chaseTimer.start()
				
				if !player_in_sight or !player_heard_close or chaseTimer.time_left <= 0:
					currentState = States.patrol
				
				
		
		States.hunting:
			speed = base_speed
			if navigationAgent.is_navigation_finished():
				currentState = States.patrol
			else:
				var targetPos = navigationAgent.get_next_path_position()
				var direction = global_transform.origin.direction_to(targetPos)
				faceDirection(delta, direction.normalized())
				velocity = direction * speed
				move_and_slide()
				
				if player_in_sight or player_heard_close:
					currentState = States.chasing
				
			pass
		States.waiting:
			
			
			pass
	pass


func faceDirection(delta,direction : Vector3):
	if direction.length_squared() > 0:
		var targetRotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, targetRotation, delta * 10)

func _on_patrol_timer_timeout() -> void:
	currentState = States.patrol
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navigationAgent.set_target_position(waypoints[waypointIndex].global_position)
	pass # Replace with function body.





func _on_hearing_close_body_entered(body: Node3D) -> void:
	if body == player and not player.is_crouching: 
		player_heard_close = true
		IseeYou.play()
		if currentState == States.patrol:
			currentState = States.hunting
			print("player is close")
	


func _on_hearing_close_body_exited(body: Node3D) -> void:
	player = body
	player_heard_close = false
	if currentState == States.hunting:
		currentState = States.patrol


func _on_hearing_far_body_entered(body: Node3D) -> void:
	if body == player and not player.is_crouching: 
		player_in_sight = true
		if currentState == States.patrol:
			currentState = States.chasing
			print("Player is nearby")


func _on_hearing_far_body_exited(body: Node3D) -> void:
	player = body
	player_in_sight = false
	if currentState == States.chasing:
		currentState = States.patrol
	print("Player is not nearby")


func _on_sight_body_entered(body: Node3D) -> void:
	player = body
	player_in_sight = true
	if currentState == States.patrol:
		currentState = States.chasing
	print("Can see player")


func _on_sight_body_exited(body: Node3D) -> void:
	player = body
	player_in_sight = false
	if currentState == States.chasing:
		currentState = States.patrol
		

var teleport_location = Vector3(3, 1.438, 3)


func _on_touch_area_body_entered(body: Node3D) -> void:
		if body == player:
			if currentState == States.chasing or currentState == States.hunting:
				
				animation_tree["parameters/conditions/attack"] = true
				animation_tree["parameters/conditions/endAtk"] = false
				
				

				AttackTimer.start()
				navigationAgent.set_target_position(player.global_transform.origin)
		
		
		print("Player teleported AI reset")
		




func _on_attack_timer_timeout() -> void:
	if currentState == States.chasing or currentState == States.hunting:
		$"../Player".remove_object()
		player.global_transform.origin = teleport_location
		currentState = States.patrol
		waypointIndex = 0
		navigationAgent.set_target_position(waypoints[waypointIndex].global_position)
		player_in_sight = false
		player_heard_close = false
		animation_tree["parameters/conditions/attack"] = false
		animation_tree["parameters/conditions/endAtk"] = true
		
	

func collision_exception():
	var rigid_bodies = get_tree().get_nodes_in_group("rigidbodies")
	for body in rigid_bodies:
		if body is PhysicsBody3D:
			add_collision_exception_with(body)
