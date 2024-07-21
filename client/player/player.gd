extends CharacterBody3D

@export var gear: PackedScene

const SPEED = 8.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gearActor:Node3D

@onready var camera_system: Node3D = $CameraSystem

const MOUSE_SENSITIVITY := 0.25


func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.y += -_event.relative.x * MOUSE_SENSITIVITY


func  _ready():
	gearActor = gear.instantiate()
	add_child(gearActor)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var cam_dir := {
			"x" : self.transform.basis.x,
			"z" : self.transform.basis.z,#camera_system.global_transform.basis.z,
		}
	var direction: Vector3 = (cam_dir.z * input_dir.y) + (cam_dir.x * input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	#self.transform.
