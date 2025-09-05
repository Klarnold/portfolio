extends CharacterBody3D


@export var speed: float = 300.0
@export var steering_factor: float = 2.0


@onready var _anchor_node: Node3D = %AnchorNode
@onready var _gobot_skin_3d: GobotSkin3D = %GobotSkin3D


var gravity: float = - ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	#check input
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#find dedicated direction
	var direction: Vector3 = Vector3(input_direction.x, 0, input_direction.y).normalized()
	var desired_velocity: Vector3
	
	#define desired_velocity
	if is_zero_approx((input_direction.length())):
		desired_velocity = Vector3.ZERO
	else:
		desired_velocity = direction * speed * delta - velocity
	#calculate steerin_amoun
	var steering_amount: float = min(steering_factor * delta, 1.0)
	desired_velocity.y = 0.0
	#increase character's velocity according desired velocity
	velocity += desired_velocity * steering_amount
	
	print(is_on_floor())
	if not is_on_floor():
		velocity += Vector3.DOWN * 40 * delta
	
	if is_on_floor() and is_zero_approx((input_direction.length() as float)):
		_gobot_skin_3d.run()
	else:
		_gobot_skin_3d.idle()
	
	move_and_slide()
