extends Node3D
class_name ParticleEmitter;

const particlePrefab : PackedScene = preload("res://assets/particle/particle.tscn");
@export var emissionsPerSecond : float = 1.0;
@export var active : bool = false;
@export var followFactor : float = 1.0;
@onready var lastFramePosition : Vector3 = global_position;

@export var texture : Texture2D;
@export var textureFrames : int = 1;
@export var color : Color = Color.WHITE;
@export var maxLifetime : float = 2.0;
@export var velocity : Vector3;
@export var rotationCurve : Curve;
@export var scaleCurve : Curve;
@export var opacityCurve : Curve;

var emissionCounter : float = 0;
func _process(delta):
	if (!active || !visible): return;
	
	emissionCounter += emissionsPerSecond * delta;
	while (emissionCounter >= 1.0):
		emitParticle();
		emissionCounter -= 1.0;
		
	lastFramePosition = global_position;

func emitParticle():
	var particle : Particle = particlePrefab.instantiate();
	
	particle.setTexture(texture, textureFrames);
	particle.lifetimeRate = 1.0 / maxLifetime;
	particle.velocity = velocity;
	particle.fadeVelocity = (global_position - lastFramePosition) * followFactor;
	particle.color = color;
	particle.rotationCurve = rotationCurve;
	particle.scaleCurve = scaleCurve;
	particle.opacityCurve = opacityCurve;
	
	particle.updateProperties(0);
	
	get_tree().root.add_child(particle);
	particle.global_position = global_position;
