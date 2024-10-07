extends Sprite3D

var mainCamera : Camera3D;

func _ready():
	mainCamera = get_viewport().get_camera_3d();

func _process(_delta):
	var rotationTo : float = rad_to_deg(getAngleChange(global_rotation.y, mainCamera.global_rotation.y));
	
	var flipped : bool = false;
	if (rotationTo < 0.0):	
		flipped = true;

	var absRotation : float = abs(rotationTo);
	var frameTarget = getTurnFrame(absRotation);
	
	if (frameTarget == 0 || frameTarget == angleThresholds.size()):
		flipped = false;
	flip_h = flipped;
	
	frame = frameTarget;

const angleThresholds : Array[float] = [ 15, 50, 85, 150 ];
func getTurnFrame(frameRotation):
	for index : int in range(0, angleThresholds.size()):
		if (frameRotation < angleThresholds[index]):
			return index;
	return angleThresholds.size();
	

func getAngleChange(a : float, b : float) -> float:
	var atb = b - (TAU + a);
	var bat = b - (a - TAU);
	var ba = b - a;

	if (abs(atb) <= abs(bat)):
		if (abs(atb) <= abs(ba)):
			return atb;
	elif (abs(bat) <= abs(ba)):
		return bat;
	return ba;
