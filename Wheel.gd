extends RayCast3D

@onready var car = get_parent().get_parent()

@onready var label1 = $Label3D
@onready var label2 = $"../FL/Label3D2"
@onready var label3 = $"../BR/Label3D3"
@onready var label4 = $"../BL/Label3D4"

@export var is_frontwheel : bool

var previous_spring_length  =  0.0 
# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_colliding():
		#direction
		var susp_dir = global_basis.y
		
		#variables and distance
		var raycast_origin = global_position
		var raycast_destination = get_collision_point()
		var distance = raycast_destination.distance_to(raycast_origin)
		
		acceleration(raycast_destination)
		steering(raycast_destination,delta)
		apply_z_force(raycast_destination)
		
		
		var contact = get_collision_point() - car.global_position
		
		var spring_length = clamp(distance-car.wheel_radius,0,car.suspension_rest_distance)
		
		var spring_force = car.spring_strength * ( car.suspension_rest_distance - spring_length)
		
		var spring_velocity = (previous_spring_length - spring_length)/delta
		
		var damping_force = car.spring_damper * spring_velocity
		
		var suspension_force = basis.y * (spring_force + damping_force)
		
		previous_spring_length = spring_length
		
		var point = Vector3(raycast_destination.x,raycast_destination.y + car.wheel_radius,raycast_destination.z)
		
		car.apply_force(susp_dir * suspension_force,point - car.global_position)
		
		DebugDraw3D.draw_sphere(point,0.1,Color.ORANGE)
		#label1.text = str(suspension_force)
		label2.text = str(suspension_force)
		label3.text = str(suspension_force)
		label4.text = str(suspension_force)

var snop
func acceleration(collision_point):
	var accel_dir = -global_basis.z
	
	var torque = car.accel_input * car.engine_power
	
	var point = Vector3(collision_point.x,collision_point.y + car.wheel_radius,collision_point.z)
	
	DebugDraw3D.draw_sphere(point-car.global_position,0.1,Color.BLUE)
	
	car.apply_force(accel_dir * torque,point-car.global_position)
	
	
func steering(collision_point,delta):
	var steer_dir = global_basis.x
	var tire_world_vel = get_velocity_at_point(global_position)
	var lateral_force = steer_dir.dot(tire_world_vel)
	
	var grip = car.rear_tire_grip
	
	if is_frontwheel:
		grip = car.front_tire_grip
	
	var desired_vel_change = -lateral_force * grip
	var x_force = desired_vel_change/delta
	
	car.apply_force(steer_dir*x_force,collision_point - car.global_position)
	

func get_velocity_at_point(point:Vector3)-> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)

func apply_z_force(collision_point):
	var dir = global_basis.z
	var tire_world_vel = get_velocity_at_point(global_position)
	var z_force = dir.dot(tire_world_vel) * car.mass / 10 
	
	car.apply_force(-dir * z_force, collision_point -car.global_position)
