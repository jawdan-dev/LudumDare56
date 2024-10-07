extends Area3D

@export var target : Kart;
@export var speed : float = 3.5;
@export var rotationSpeed : float = 0.2;
@export var damage : float = 1.0;
@export var lifeTime : float = 60.0;

@onready var forward : Vector3 = Vector3(
	cos(global_rotation.x) * -sin(global_rotation.y), 
	sin(global_rotation.x), 
	cos(global_rotation.x) * -cos(global_rotation.y)
);

func _physics_process(delta):
	lifeTime -= delta;
	if (lifeTime <= 0.0):
		queue_free();
		return;
	
	if (is_instance_valid(target)):
		var targetDirection : Vector3 = (target.global_position - global_position).normalized()
		forward = forward.move_toward(targetDirection, rotationSpeed * speed * delta * TAU).normalized();
	
	var angleX : float = asin(forward.y);
	var angleTan2 : float = (0.25 * TAU) - atan2(forward.z / -cos(angleX), forward.x / -cos(angleX))
	global_rotation.y = angleTan2;
	global_rotation.x = angleX;
	global_position += forward * speed * delta;


func onBodyHit(body):
	var kart : Kart = body as Kart;
	if (!kart): return;
	
	if (kart == target || !is_instance_valid(target)):
		lifeTime = 0;
		kart.takeDamage(damage);
