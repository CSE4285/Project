extends KinematicBody


onready var anim = get_node("AnimationPlayer")

var speed = 50
var acc = 50
var grav = -60
var maxGrav = -150
var velo = Vector3()

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

func _ready():
	pass
	
	
func on_timeout_complete():
	can_throw = true

func _process(delta):
	
	
	menu_timer = Timer.new()
	menu_timer.set_one_shot(true)
	menu_timer.set_wait_time(.3)
	menu_timer.connect("timeout", self, "on_menu_timeout")
	
	add_child(menu_timer)
	
	get_parent().get_node("Menu").get_node("Control/Panel/Button").connect("pressed", self, "exit_game")
	
	if Input.is_action_pressed("escape") and can_press:
		
		if get_parent().get_node("Menu").is_visible_in_tree():
			
			#get_parent().get_node("KinematicBody/Armature/Skeleton/Cube/Camera").enabled = false
			#get_parent().get_node("KinematicBody/Armature/Skeleton/Cube/Camera").mouse_mode = 0
			
	
			
			get_parent().get_node("Menu").hide()
			can_press = false
			menu_timer.start()
		else:
			#get_parent().get_node("KinematicBody/Armature/Skeleton/Cube/Camera").enabled = false
			#get_parent().get_node("KinematicBody/Armature/Skeleton/Cube/Camera").mouse_mode = 2
			get_parent().get_node("Menu").show()
			can_press = false
			menu_timer.start()
	
	
	if Input.is_action_pressed("take") and get_parent().get_node("PickupText").is_visible_in_tree():
		get_parent().get_node("Item").free()
		get_parent().get_node("PickupText").hide()
	
	
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "on_timeout_complete")
	
	add_child(timer)

	
	
	if Input.is_action_pressed("fire") and can_throw:
		
		var musicNode = $"Audio/AudioStreamPlayer3D"
		musicNode.play()
		
		
		
		var s = spear.instance()
		#s.start($Position3D.global_transform)
		add_child(s)
		can_throw = false
		timer.start()

	
	

	
	
	
	
	var targetDirection = Vector2(0,0)
	
	if Input.is_action_pressed("forward"):
		targetDirection.y += 1
	if Input.is_action_pressed("backward"):
		targetDirection.y -= 1
	if Input.is_action_pressed("left"):
		targetDirection.x += 1
	if Input.is_action_pressed("right"):
		targetDirection.x -= 1
		
	set_anim(targetDirection)
	
	targetDirection = targetDirection.normalized()
	
	velo.x = lerp(vel.x, targetDirection.x * speed, acc * delta)
	velo.z = lerp(vel.x, targetDirection.y * speed, acc * delta)
	
	velo.y += grav * delta
	if velo.y < maxGrav:
		velo.y = maxGrav
		
	velo = move_and_slide(velo, Vector3(0,1,0))
	
	if is_on_floor() and velo.y < 0:
		velo.y = 0
		





func set_anim(dir):
	
	#if dir == Vector2(0,0):
		#anim.play("default")
	
	if dir == Vector2(0,1):
		anim.play("default")
	elif dir == Vector2(0,1):
		anim.play("default")
	elif dir == Vector2(1,1):
		anim.play("default")
	elif dir == Vector2(-1,1):
		anim.play("default")
	elif dir == Vector2(1,0):
		anim.play("default")
	elif dir == Vector2(0,-1):
		anim.play("default")
	elif dir == Vector2(1,-1):
		anim.play("default")
	elif dir == Vector2(-1,1):
		anim.play("default")
	
	
		

func _on_Area_body_entered(body):
	
	get_parent().get_node("PickupText").show()
	
	
	
	


func _on_Area_body_exited(body):

	get_parent().get_node("PickupText").hide()
