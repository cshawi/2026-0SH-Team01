extends Control

#Cacher le UI du joueur 
var has_player = false;
var categoryIsHidden = true;

const base_path_to_ressource = "res://ressources/objects/";
const box_path = base_path_to_ressource + "Box";
const collectables_path = base_path_to_ressource + "Collectables";
const Doors_path = base_path_to_ressource + "Doors";
const Mushrooms_path = base_path_to_ressource + "Mushrooms";
const Rocks_path = base_path_to_ressource + "Rocks";
const Specials_path = base_path_to_ressource + "Specials";



var all_items_with_category = [];

func _ready() -> void:
	load_all_ressources();
	$Category.hide();
	$ItemOfCategory.hide();
	
func sort_by_category(a, b):
	return a["category"] < b["category"]
	
func load_all_ressources():
	all_items_with_category = get_file_of_ressources_directory(box_path);
	all_items_with_category += get_file_of_ressources_directory(Doors_path);
	all_items_with_category += get_file_of_ressources_directory(Mushrooms_path);
	all_items_with_category += get_file_of_ressources_directory(Rocks_path);
	all_items_with_category += get_file_of_ressources_directory(Specials_path);
	all_items_with_category.sort_custom(sort_by_category)
	for item in all_items_with_category : 
		print(item);
	
func get_file_of_ressources_directory(path_to_ressource):
	var category = path_to_ressource.replace(base_path_to_ressource, "");
	var directory_ressources = DirAccess.open(path_to_ressource);
	var file_of_directory: Array = [];
	if directory_ressources:
		directory_ressources.list_dir_begin()
		var file_name = directory_ressources.get_next()
		while file_name != "":
			if not directory_ressources.current_is_dir():
				file_of_directory.append({
					"category": category.to_lower(),
					"object": load(path_to_ressource+"/"+file_name),
					"full_path": path_to_ressource+"/"+file_name
					});
			file_name = directory_ressources.get_next()
		return file_of_directory;

func load_item_information_in_list_items(category):
	if(not $ItemOfCategory.is_visible()):
		$ItemOfCategory.show();
	
	for i in range(all_items_with_category.size()):
		add_item(all_items_with_category[i]["object"])

func add_item(object):
	var item  = TextureButton.new();
	#print(object.name);	
	#print(object.Texture);
	#item.set_texture_normal()
	$ItemOfCategory.add_child(item);

	

func _on_selected_item_pressed() -> void:
	if categoryIsHidden:
		$Category.show();
		categoryIsHidden = false;
	else:
		$Category.hide();
		categoryIsHidden = true;
	pass # Replace with function body.



func _on_box_category_pressed() -> void:
	load_item_information_in_list_items("box");
	pass # Replace with function body.


func _on_rock_category_pressed() -> void:
	pass # Replace with function body.


func _on_mushroom_category_pressed() -> void:
	pass # Replace with function body.


func _on_ice_category_pressed() -> void:
	pass # Replace with function body.


func _on_all_category_pressed() -> void:
	pass # Replace with function body.
