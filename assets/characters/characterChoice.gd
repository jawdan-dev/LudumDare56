extends Node

var allSprites : Array[Texture2D] = [
	preload("res://assets/characters/sprites/characters1.png"),
	preload("res://assets/characters/sprites/characters2.png"),
	preload("res://assets/characters/sprites/characters3.png"),
	preload("res://assets/characters/sprites/characters4.png"),
	preload("res://assets/characters/sprites/characters5.png"),
	preload("res://assets/characters/sprites/characters6.png"),
	preload("res://assets/characters/sprites/characters7.png"),
	preload("res://assets/characters/sprites/characters8.png"),
	preload("res://assets/characters/sprites/characters9.png")
]

var unlockedCharacters : Array[int] = [ 4 ];

var availableSprites : Array[int] = [];

var playerChoice : int = 0;

func _ready():
	resetSprites();

func resetSprites():
	availableSprites = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, ];

func takePlayerSprite() -> Texture2D:
	availableSprites.erase(playerChoice);
	return allSprites[playerChoice];

func takeCPUSprite() -> Texture2D:
	var spriteIndex : int = availableSprites.pick_random();
	if (spriteIndex == playerChoice): 
		return takeCPUSprite();
	availableSprites.erase(spriteIndex);
	return allSprites[spriteIndex];
