extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var username_label: Label = $Username

const SPEED: int = 100

@export var username: String = "sroshc"

enum DIRECTION{
	left,
	right,
	down,
	up
}

@export var network_id: int
@export var facing: int = DIRECTION.down
@export var is_moving: bool = false
@export var is_typing: bool = false

func _ready() -> void:
	if(not is_multiplayer_authority()):
		$Camera2D.queue_free()
	else:
		username = NetworkInfo.username

func _physics_process(delta: float) -> void:
	play_animation()
	update_username(username)
	
	if not is_multiplayer_authority():
		return
	
	
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
	username_label.text = new_usr


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
