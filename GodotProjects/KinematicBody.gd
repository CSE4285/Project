
extends KinematicBody

# Member variables
var g = -9.8
var vel: Vector3
var timer = null
var menu_timer = null
var can_press = true
var can_throw = true
onready var spear = preload("res://Spear.tscn")
const MAX_SPEED = 5
const JUMP_SPEED = 7
const ACCEL= 2
const DEACCEL= 4
const MAX_SLOPE_ANGLE = 30

func on_timeout_complete():
	can_throw = true
	
func on_menu_timeout():
	can_press = true

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_position"):
		translation = Vector3(0, 0, 0)
	var dir = Vector3() # Where does the player intend to walk to
	var cam_xform = $Target/Camera.get_global_transform()
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "on_timeout_complete")
	
	add_child(timer)
	
	menu_timer = Timer.new()
	menu_timer.set_one_shot(true)
	menu_timer.set_wait_time(.3)
	menu_timer.connect("timeout", self, "on_menu_timeout")
	
	add_child(menu_timer)
	
	get_parent().get_node("Menu").get_node("Control/Panel/Button").connect("pressed", self, "exit_game")

	if Input.is_action_pressed("move_forward"):
		dir += -cam_xform.basis[2]
	if Input.is_action_pressed("move_backwards"):
		dir += cam_xform.basis[2]
	if Input.is_action_pressed("move_left"):
		dir += -cam_xform.basis[0]
	if Input.is_action_pressed("move_right"):
		dir += cam_xform.basis[0]
	if Input.is_action_pressed("throw") and can_throw:
		var s = spear.instance()
		#s.start($Position3D.global_transform)
		add_child(s)
		can_throw = false
		timer.start()
		
	if Input.is_action_pressed("menu") and can_press:
		if get_parent().get_node("Menu").is_visible_in_tree():
			get_parent().get_node("Menu").hide()
			can_press = false
			menu_timer.start()
		else:
			get_parent().get_node("Menu").show()
			can_press = false
			menu_timer.start()

	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * g

	var hvel = vel
	hvel.y = 0

	var target = dir * MAX_SPEED
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)

	vel.x = hvel.x
	vel.z = hvel.z

	vel = move_and_slide(vel, Vector3.UP)

	if is_on_floor() and Input.is_action_pressed("jump"):
		vel.y = JUMP_SPEED
		
	if Input.is_action_pressed("take") and get_parent().get_node("PickupText").is_visible_in_tree():
		get_parent().get_node("Item").free()
		get_parent().get_node("PickupText").hide()

func _on_Area_body_entered(body):
	if body == self:
		get_parent().get_node("StartText").hide()
		get_parent().get_node("PickupText").show()


func _on_Area_body_exited(body):
	get_parent().get_node("PickupText").hide()

func exit_game():
	get_tree().quit()
