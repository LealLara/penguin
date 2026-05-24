extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 70.0
const JUMP_VELOCITY = -300.0
 
enum PlayerState{
	idle,
	walk,
	jump,
	duck
}
var direction = 0


var status: PlayerState 

func _ready() -> void: 
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.duck:
			duck_state()
			
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
func go_to_duck_state():
	status = PlayerState.duck
	anim.play("duck")

func idle_state():
	move()
	if velocity.x !=0:
		go_to_walk_state()
		return 
		
	if Input.is_action_just_pressed("jump"): 
		go_to_jump_state()
		return 
		
	if Input.is_action_pressed("duck"): 
		go_to_duck_state()
		return 
	 
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return 
		
	if Input.is_action_just_pressed("jump"): 
		go_to_jump_state()
		return 
	 
func jump_state():
	move()
	if is_on_floor():
		go_to_idle_state()
		return 
		
func duck_state():
	update_direction()
	if Input.is_action_just_released("duck"):
		go_to_idle_state()
		return
	 
func move():
	update_direction()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func update_direction():
	direction = Input.get_axis("left", "right")
	if is_on_floor():
		if direction > 0:
			anim.flip_h = false
			anim.play("walk")
		elif direction < 0:
			anim.flip_h = true
			anim.play("walk")
		else:
			anim.play("idle")
	else:
		if direction > 0:
			anim.flip_h = false
			anim.play("jump")
		elif direction < 0:
			anim.flip_h = true
			anim.play("jump")
			
	
