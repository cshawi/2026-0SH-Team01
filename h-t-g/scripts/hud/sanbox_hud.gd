extends Control

#Cacher le UI du joueur 
var has_player = false;
var categoryIsHidden = true;

const base_path_to_ressource = "res://ressources/objects/";
const box_path = base_path_to_ressource + "Box";
var items_of_box_category = [];



func _ready() -> void:
	$Category.hide();
	$ItemOfCategory.hide();
	items_of_box_category = get_file_of_ressources_directory(box_path);
	for item in items_of_box_category : 
		print(item);
	
	

func get_file_of_ressources_directory(path_to_box_ressource):
	
	var directory_ressources = DirAccess.open(path_to_box_ressource);
	var file_of_directory: Array = [];
	if directory_ressources:
		directory_ressources.list_dir_begin()
		var file_name = directory_ressources.get_next()
		while file_name != "":
			if not directory_ressources.current_is_dir():
				file_of_directory.append(file_name);
			file_name = directory_ressources.get_next()
		return file_of_directory;


func _on_selected_item_pressed() -> void:
	if categoryIsHidden:
		$Category.show();
		categoryIsHidden = false;
	else:
		$Category.hide();
		categoryIsHidden = true;
	pass # Replace with function body.
