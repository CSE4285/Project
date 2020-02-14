extends KinematicBody

var g = -5
var timer = null
const MAX_SPEED = 6
const ACCEL= 3
const DEACCEL= 3
const MAX_SLOPE_ANGLE = 30

func on_menu_timeout():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var collision = move_and_collide(Vector3(0,delta * g,2) * 1)
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "on_menu_timeout")
	
	add_child(timer)
	
	timer.start()
	
	if collision:
		self.move_lock_x
		self.move_lock_y
		self.move_lock_z
