extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var username_box: ColorRect = $Username_Box
@onready var username: Label = $Username

const SPEED: int = 100

var user_name = "miku_miku"

enum DIRECTION{
	left,
	right,
	down,
	up
}

var facing: int = DIRECTION.down
var is_moving: bool = false

func _ready() -> void:
	username.text = user_name
	await get_tree().process_frame
	username.position.x -= username.size.x/2
	
	username_box.size.x = username.size.x + 4
	username_box.position.x = username.position.x - 2

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
