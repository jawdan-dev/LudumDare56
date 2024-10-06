extends CharacterBody3D

@export var movementSpeed : float = 4.0;
@export var turningSpeed : float = 2.0;
var forwardAngle : float = 0.0; 

func _physics_process(delta):
	print_debug(getGroundType());
	
	var turningInput : float = Input.get_axis("player_right", "player_left");
	forwardAngle += turningInput * delta * turningSpeed;
	while (forwardAngle >= TAU): forwardAngle -= TAU;
	while (forwardAngle < 0.0): forwardAngle += TAU;
	
	var forwardMotion : Vector3 = Vector3(
		-sin(forwardAngle),
		0,
		-cos(forwardAngle),
	) * Input.get_axis("player_backward", "player_forward")
	
	rotation.y = forwardAngle;
	
	if (turningInput != 0):
		$Sprite3D.frame = 1;
		$Sprite3D.flip_h = turningInput >= 0;
	else:
		$Sprite3D.frame = 0;
		$Sprite3D.flip_h = false;
	
	velocity = forwardMotion * movementSpeed * getSpeedMultiplier();
	move_and_slide();

@export var trackSprite : Sprite3D;
func getSpeedMultiplier():
	if (getGroundType() != Color("ffaa77")): return 0.3;
	return 1.0;
	
func getGroundType():
	if (!trackSprite): return;
	
	var trackSize : Vector2 = trackSprite.texture.get_size() * trackSprite.pixel_size;
	
	var topLeft : Vector3 = Vector3(trackSize.x, 0, trackSize.y) * -0.5;
	var relativePosition : Vector3 = Vector3(position.x - trackSprite.position.x, 0, position.z - trackSprite.position.z) - topLeft;
	
	var pixelLocation : Vector3i = relativePosition / trackSprite.pixel_size;
	if (pixelLocation.x < 0 || pixelLocation.x >= trackSprite.texture.get_width() || 
		pixelLocation.z < 0 || pixelLocation.z >= trackSprite.texture.get_height()):
		return null;
		
	return trackSprite.texture.get_image().get_pixel(pixelLocation.x, pixelLocation.z);
