extends RayCast3D

@onready var boss = get_parent().get_parent()

@export var dampness = 0.1
@export var stiffness = 1
@export var relaxedlength = -1

@onready var fr = $"."
@onready var fl = $"../FL"
@onready var br = $"../BR"
@onready var bl = $"../BL"



@onready var label1 = $Label3D
@onready var label2 = $"../FL/Label3D2"
@onready var label3 = $"../BR/Label3D3"
@onready var label4 = $"../BL/Label3D4"

var Helo : String = "Hello"
var prev_compression = 0
var y_force = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(boss)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var dir = self.global_basis.y
		var dest = get_collision_point()
		var dist = global_position.distance_to(dest)
		var compression = 1 - dist
		
		var norm = get_collision_normal()
		
		y_force = stiffness * compression * abs(relaxedlength)
		y_force += dampness * (compression - prev_compression) / delta
		
		#label1.text = str(y_force)
		label2.text = str("%.2f" %y_force)
		label3.text = str("%.2f" %y_force)
		label4.text = str("%.2f" %y_force)
		
		prev_compression = compression
		
		boss.apply_force(y_force * norm,global_position)
		
		DebugDraw3D.draw_arrow(global_position,to_global(Vector3(0, (y_force)/2,0)),Color.BLUE,0.1,true)
	else :
		prev_compression = 0
