extends CharacterBody3D

#vars 
@export var max_health: float = 100
var health: float = max_health
var SPEED: float
var normal_speed = Globvar.normal_speed
var sprint_speed = Globvar.sprint_speed
var crouch_speed = Globvar.crouch_speed
var JUMP_VELOCITY = Globvar.jump_velocity

#all usful stuff
var sensitivity = 0.12
var gravity = Globvar.gravity
var num_of_jumps = 0
var sprinting = false

#weapon spawn for futere projects
var weapon_to_spawn_left 
var weapon_to_spawn_right

enum movement {
	Walking,
	Sprinting,
	}

var cuurent_state: movement = movement.Walking

#the callbacks to the elements to the player
@onready var head := $Head
@onready var Camera := $Head/Camera3D
@onready var Reach := $Head/Camera3D/RayCast3D
@onready var right_arm := $Head/Camera3D/arms/right_arm
@onready var left_arm :=$Head/Camera3D/arms/left_arm
@onready var player_colision := $CollisionShape3D
@onready var health_bar := $UI/essential_container/Health_Bar
@onready var speedometer := $UI/essential_container/speedometer
@onready var grapple_reach := $Head/Camera3D/grapple_reach
#function that are responsible for update damage, knockback etc.
func damage(hit_points):
	update_health_bar()
	if hit_points < health:
		health -= hit_points
		update_health_bar()
	else:
		health = 0
	if health == 0:
		update_health_bar()
		die()
#updating healthbar
func update_health_bar():
	var health_percentage = (health / max_health) * 100
	health_bar.text = str(round(health_percentage)) + "% "
	
func update_speedometer():
	var cuurent_speed = velocity.length() * 5
	speedometer.text = str(round(cuurent_speed)) + "KM/H"

func die():
	pass

func _ready():
	update_health_bar()
	
#rotation of the camera with the mouse
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad((-event.relative.x * sensitivity)))
		head.rotate_x(deg_to_rad((-event.relative.y * sensitivity)))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90),deg_to_rad(90))
	
#handle and check what are player looking for
func what_coliding():
	if Reach.get_collider() and Reach.get_collider().is_in_group("Weapons"):
		var weapon_name = Reach.get_collider().get_name()
		var weapon_name_right = weapon_name + "handright"
		var weapon_name_left = weapon_name + "handleft"
		weapon_to_spawn_right = Globvar.get(weapon_name_right).instantiate()
		weapon_to_spawn_left = Globvar.get(weapon_name_left).instantiate()
	else:
		weapon_to_spawn_right = null
		weapon_to_spawn_left = null

#handle speed and number or jumps and also gravity
func _physics_process(delta):
	update_speedometer()
	print(velocity.length())
	print(cuurent_state)
	match cuurent_state:
		movement.Walking:
			SPEED = lerp(SPEED, normal_speed, delta * 3)
		movement.Sprinting:
			SPEED = lerp(SPEED,sprint_speed,delta * 5)
	
	if is_on_floor():
		num_of_jumps = 2
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump and double jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if num_of_jumps == 2:
			num_of_jumps -= 1
			velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if num_of_jumps == 1:
			num_of_jumps -= 1
			velocity.y = JUMP_VELOCITY
			
	#Sprinting
	if Input.is_action_just_pressed("Sprint"):
		if cuurent_state == movement.Walking:
			cuurent_state = movement.Sprinting
		elif cuurent_state == movement.Sprinting:
			cuurent_state = movement.Walking
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		#the simulate realistic slow effecct when running
		else: 
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 6.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 6.0)
	#for making the speed
	else: 
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2.2)
		
	#adding weapon to left arm
	if Input.is_action_just_pressed("left_hand_pickup"):
		what_coliding()
		if weapon_to_spawn_left != null:
			if left_arm.get_child(0) != null:
				left_arm.get_child(0).queue_free()
			left_arm.add_child(weapon_to_spawn_left)
	else:
		pass
		
	#adding weapon to right hand
	if Input.is_action_just_pressed("right_hand_pickup"):
		what_coliding()
		if weapon_to_spawn_right != null:
			if right_arm.get_child(0) != null:
				right_arm.get_child(0).queue_free()
			right_arm.add_child(weapon_to_spawn_right)
	else:
		pass
	move_and_slide()
