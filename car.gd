extends RigidBody3D

@onready var boost_bar = $CanvasLayer/ProgressBar
@onready var camera = $SpringArm3D/Camera3D

@export var suspension_rest_distance = 0.5
@export var spring_strength = 200
@export var spring_damper = 20
@export var wheel_radius = 0.33

@export var engine_power = 50.0

@export var steering_angle : float = 15.0
@export var front_tire_grip : float = 0.5
@export var rear_tire_grip : float = 0.3
@onready var textbar = $CanvasLayer/TextureProgressBar


@onready var fast_particles = $GPUParticles3D

var boost : float = 100.0
var accel_input 
var dir_input

func _input(event):
	accel_input = Input.get_axis("ui_down","ui_up")
	dir_input = Input.get_axis("ui_left","ui_right")
	

	
# Called when the node enters the scene tree for the first time.
func _ready():
	fast_particles.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		boost -= 0.5
		if boost <= 5:
			engine_power = lerp(engine_power,50.0,0.2)
			camera.fov = lerp(camera.fov,70.0,0.05)
			fast_particles.emitting = false
		else:
			engine_power=lerp(engine_power,55.0,0.3)
			camera.fov = lerp(camera.fov,100.0,0.01)
			fast_particles.emitting = true
	else:
		boost += 0.1
		engine_power =lerp(engine_power,50.0,0.5)
		camera.fov = lerp(camera.fov,70.0,0.05)
		fast_particles.emitting = false
	boost =clamp(boost,0,100)
	boost_bar.value = boost
	textbar.value = boost
	
	var steer_rotation = steering_angle * -dir_input
	
	var fr_wheel = $Wheels/FR
	var fl_wheel = $Wheels/FL
	
	
	if steer_rotation != 0 :
		var angle = clamp(fl_wheel.rotation.y + steer_rotation,-steering_angle,steering_angle)
		var new_rotation = angle * delta
		
		fl_wheel.rotation.y =lerp(fl_wheel.rotation.y,new_rotation,0.3)
		fr_wheel.rotation.y =lerp(fr_wheel.rotation.y,new_rotation,0.3)
	else:
		fl_wheel.rotation.y = move_toward(fl_wheel.rotation.y,0,0.2)
		fr_wheel.rotation.y = move_toward(fr_wheel.rotation.y,0,0.2)
