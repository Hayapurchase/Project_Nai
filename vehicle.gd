extends RigidBody3D

@onready var fr = $Wheels/FR
@onready var fl = $Wheels/FL
@onready var br = $Wheels/BR
@onready var bl = $Wheels/BL

@onready var engine_force = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fwd_axis = Input.get_axis("ui_up","ui_down")
	var dir_axis = Input.get_axis("left","right")
	var fwd = basis.z
	apply_central_force(engine_force * fwd_axis * fwd)
