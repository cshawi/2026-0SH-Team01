extends Control

#Cacher le UI du joueur 
var has_player = false;
var categoryIsHidden = true;



const base_path_to_ressource = "res://ressources/objects/";
const box_path = base_path_to_ressource + "Box";
const collectables_path = base_path_to_ressource + "Collectables";
const Mushrooms_path = base_path_to_ressource + "Mushrooms";
const Rocks_path = base_path_to_ressource + "Rocks";
const Specials_path = base_path_to_ressource + "Specials";


const full_motion_object = preload("res://scenes/Objects/Moveables/full_motion_object.tscn")
const horizontal_motion_object = preload("res://scenes/Objects/Moveables/horizontal_motion_object.tscn")
const moveable_object = preload("res://scenes/Objects/Moveables/moveable_object.tscn")
const verticale_object = preload("res://scenes/Objects/Moveables/vertical_motion_object.tscn")

var last_scene_used: PackedScene = null
var last_object_config = null

var all_items_with_category = [];

func _ready() -> void:
	load_all_ressources();
	$Category.hide();
	$ScrollContainer.hide();
	
var can_spawn := true
var creative_mode := true
var firstime_creative = true
var btn_is_click = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_viewport().gui_get_hovered_control() != null:
			btn_is_click = true
			return # clic sur UI, on ignore
	btn_is_click = false
	
func _process(delta: float) -> void:
	
	if creative_mode and not btn_is_click:
			if  GameMaster.magic_cursor.is_grabing and last_scene_used and can_spawn:
				#firstime if is not grabing
				spawn_instance_selected()
				setup_selected_item_icon();
				hide_sandBox_menu();
				can_spawn = false
				
			elif not GameMaster.magic_cursor.is_grabing:
				can_spawn = true
			

func setup_selected_item_icon():
	$HBSelectedItem/SelectedItem.set_button_icon(last_object_config.texture);
func hide_sandBox_menu():
		$Category.hide();
		$ScrollContainer.hide();
	

func sort_by_category(a, b):
	return a["category"] < b["category"]
	
func load_all_ressources():
	all_items_with_category = get_file_of_ressources_directory(box_path);
	all_items_with_category += get_file_of_ressources_directory(Mushrooms_path);
	all_items_with_category += get_file_of_ressources_directory(Rocks_path);
	all_items_with_category += get_file_of_ressources_directory(Specials_path);
	all_items_with_category.sort_custom(sort_by_category);	
	print(all_items_with_category);
	
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
	if(not $ScrollContainer.is_visible()):
		$ScrollContainer.show();
		
	
	var selected_category = all_items_with_category.filter(func(item):
		return item["category"] == category
	);
	
	for i in range(selected_category.size()):
		add_item(selected_category[i]["object"]);

func add_item(object):
	var item = Button.new()
	item.custom_minimum_size = Vector2(45, 39)
	item.set_button_icon(object.texture);
	
	item.icon_alignment = 1;
	item.expand_icon = true;
	item.pressed.connect(_on_item_pressed.bind(object))

	$ScrollContainer/ItemOfCategory.add_child(item);

func reset_item_in_item_of_category():
	for item in $ScrollContainer/ItemOfCategory.get_children():
		item.queue_free()

func on_category_pressed(category):
	reset_item_in_item_of_category()
	load_item_information_in_list_items(category);

func find_category_of_object(object):
	for item_data in all_items_with_category:
		if item_data["object"] == object:
			return item_data["category"]
	

func find_file_path_of_object(object):
	for item_data in all_items_with_category:
		if item_data["object"] == object:
			return item_data["object"]
			
func _on_item_pressed(object):
	var category = find_category_of_object(object);
	
	if category == "box":
		instansiate_scene_of_object_in_world(full_motion_object,object);
		
	elif category == "collectables":
		instansiate_scene_of_object_in_world(full_motion_object,object);
	
	elif category == "rocks":
		instansiate_scene_of_object_in_world(full_motion_object,object);
		
	elif category == "mushrooms":
		instansiate_scene_of_object_in_world(horizontal_motion_object,object);
	can_spawn = false;

func instansiate_scene_of_object_in_world(scene_to_spawn, object):
	last_scene_used = scene_to_spawn
	last_object_config = find_file_path_of_object(object)

func spawn_instance_selected():
	var current_scene = get_tree().current_scene

	if  last_scene_used:
		var instance = last_scene_used.instantiate()
		instance.global_position = GameMaster.magic_cursor.global_position
		instance.config = last_object_config
		current_scene.add_child(instance)

func _on_selected_item_pressed() -> void:
	if categoryIsHidden:
		$Category.show();
		categoryIsHidden = false;
	else:
		$Category.hide();
		$ScrollContainer.hide();
		categoryIsHidden = true;
	

func _on_box_category_pressed() -> void:
	on_category_pressed("box");

func _on_rock_category_pressed() -> void:
	on_category_pressed("rocks");

func _on_mushroom_category_pressed() -> void:
	on_category_pressed("mushrooms");

func _on_ice_category_pressed() -> void:
	on_category_pressed("ice");

func _on_all_category_pressed() -> void:
	reset_item_in_item_of_category()
	
func _on_creative_mode_pressed() -> void:
	var btn = $HBSelectedItem/CreativeMode
	btn_is_click =true
	if firstime_creative:
		btn.grab_focus()
		btn.toggle_mode = true
		creative_mode = true
		firstime_creative =false;
		return;
		
	if btn.has_focus():
		btn.release_focus()
		creative_mode = false
		firstime_creative =true
	
