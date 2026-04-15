extends Control

var categoryIsHidden = true;

func _ready() -> void:
	$Category.hide();
	$ItemOfCategory.hide();
	
	pass	


func _on_selected_item_pressed() -> void:
	if categoryIsHidden:
		$Category.show();
		categoryIsHidden = false;
	else:
		$Category.hide();
		categoryIsHidden = true;
	pass # Replace with function body.
