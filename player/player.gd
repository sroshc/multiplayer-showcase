extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var username_box: ColorRect = $Username_Box
@onready var username_label: Label = $Username

const SPEED: int = 100

var username: String = "sroshc"

enum DIRECTION{
	left,
	right,
	down,
	up
}

var facing: int = DIRECTION.down
var is_moving: bool = false

func _ready() -> void:
	update_username(username)

func _physics_process(delta: float) -> void:
	is_moving = false
	velocity = Vector2.ZERO
	
	if not (Input.is_action_pressed("left") and Input.is_action_pressed("right")):
		if Input.is_action_pressed("left"):
			velocity.x = -1
			is_moving = true
			facing = DIRECTION.left
		if Input.is_action_pressed("right"):
			velocity.x = 1
			is_moving = true	
			facing = DIRECTION.right
		
	if not (Input.is_action_pressed("up") and Input.is_action_pressed("down")):
		if Input.is_action_pressed("up"):
			velocity.y = -1
			is_moving = true
			facing = DIRECTION.up
		if Input.is_action_pressed("down"):
			velocity.y = 1
			is_moving = true
			facing = DIRECTION.down
		
	
	velocity = velocity.normalized() * SPEED
	
	play_animation()
	move_and_slide()
	

func play_animation() -> void:
	var start: String
	var end: String
	
	if(is_moving):
		start = "run"
	else:
		start = "idle"
	
	if facing == DIRECTION.up:
		end = "up"
	elif facing == DIRECTION.down:
		end = "down"
	elif facing == DIRECTION.left:
		end = "left"
	elif facing == DIRECTION.right:
		end = "right"
	
	animated_sprite_2d.play(start + "-" + end)

func update_username(new_usr: String) -> void:
	username_label.text = ""
	await get_tree().process_frame 
	
	
	username_label.text = new_usr
	await get_tree().process_frame
	username_label.position.x -= username_label.size.x/2
	
	username_box.size.x = username_label.size.x + 4
	username_box.position.x = username_label.position.x - 2
