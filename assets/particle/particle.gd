extends Node3D
class_name Particle;

var velocity : Vector3;
var fadeVelocity : Vector3;
var color : Color;

var rotationCurve : Curve;
var scaleCurve : Curve;
var opacityCurve : Curve;

var lifetimeRate : float = 1.0;
var lifetimeProgress : float = 0.0;

func _process(delta):
	lifetimeProgress += lifetimeRate * delta;
	if (lifetimeProgress >= 1.0):
		queue_free();
	else:
		updateProperties(delta);
	
func updateProperties(delta):
	position += velocity * delta;
	position += fadeVelocity * (1.0 - lifetimeProgress) * delta;
	
	scale = Vector3.ONE * getCurve(scaleCurve);
	rotation.z = getCurve(rotationCurve) * TAU;
	
	$Sprite.modulate.r = color.r;
	$Sprite.modulate.g = color.g;
	$Sprite.modulate.b = color.b;
	$Sprite.modulate.a = getCurve(opacityCurve) * color.a;
	
func getCurve(curve : Curve):
	if (!curve): return 1.0;
	return curve.sample_baked(lifetimeProgress);	
	
func setTexture(texture : Texture2D, textureFrames : int = 1):
	$Sprite.texture = texture;
	$Sprite.hframes = textureFrames;
	$Sprite.frame = randi_range(0, textureFrames - 1);
