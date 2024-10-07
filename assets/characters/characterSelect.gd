extends Control

func _ready():
	CharacterChoice.resetSprites();
	for i : int in range(0, $ItemList.item_count):
		$ItemList.set_item_disabled(i, !CharacterChoice.unlockedCharacters.has(i));

func onSelect(index : int):
	CharacterChoice.playerChoice = index;
	$Button.disabled = false;
	# TODO: Player sounds here.	
	
	
func onStart():
	get_tree().change_scene_to_file("res://scenes/grayBox.tscn");
