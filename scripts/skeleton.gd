extends CharacterBody2D

enum SkeletonState{
	walk,
	hurt
}
@onready var colli : CollisionShape2D = $CollisionShape2D 

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector

 
const SPEED = 10.0
const JUMP_VELOCITY = -400.0
var direction = 1
var status: SkeletonState

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
 
	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.hurt:
			hurt_state(delta)

	move_and_slide()

func go_to_walk_state(): 
	status = SkeletonState.walk
	anim.play("walk")
	
func go_to_hurt_state():
	status = SkeletonState.hurt
	anim.play("hurt") 
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	

func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
func hurt_state(_delta):
	pass
	
func take_damage():
	go_to_hurt_state() 
 
