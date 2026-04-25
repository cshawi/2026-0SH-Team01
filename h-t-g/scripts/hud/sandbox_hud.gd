#extends Control
#
#
#@onready var selected_item: Button = $HBSelectedItem/SelectedItem
#@onready var edit: Button = $HBSelectedItem/Edit
#@onready var eraser: Button = $HBSelectedItem/Eraser
#@onready var scroll_container: ScrollContainer = $ScrollContainer
#@onready var item_of_category: VBoxContainer = $ScrollContainer/ItemOfCategory
#@onready var category: ScrollContainer = $Category
#
#
##Cacher le UI du joueur 
#var has_player = false;
#var categoryIsHidden = true;
#
#
#
#const base_path_to_ressource = "res://ressources/objects/";
#const box_path = base_path_to_ressource + "Box";
#const collectables_path = base_path_to_ressource + "Collectables";
#const Mushrooms_path = base_path_to_ressource + "Mushrooms";
#const Rocks_path = base_path_to_ressource + "Rocks";
#const Specials_path = base_path_to_ressource + "Specials";
#
#
#const full_motion_object = preload("res://scenes/Objects/Moveables/full_motion_object.tscn")
#const horizontal_motion_object = preload("res://scenes/Objects/Moveables/horizontal_motion_object.tscn")
#const moveable_object = preload("res://scenes/Objects/Moveables/moveable_object.tscn")
#const verticale_object = preload("res://scenes/Objects/Moveables/vertical_motion_object.tscn")
#
#var last_scene_used: PackedScene = null
#var last_object_config = null
#
#var all_items_with_category = [];
#
#func _ready() -> void:
	#load_all_ressources();
	#category.hide();
	#scroll_container.hide();
	#
#var can_spawn := true
#var creative_mode := true
#var firstime_creative := true
#var first_time_erase := true
#var btn_is_click = true
#
#func _input(event):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#if get_viewport().gui_get_hovered_control() != null:
			#btn_is_click = true
			#return # clic sur UI, on ignore
	#btn_is_click = false
	#
#func _process(delta: float) -> void:
	#
	#if creative_mode and not btn_is_click:
			#if  GameMaster.magic_cursor.is_grabing and last_scene_used and can_spawn:
				##firstime if is not grabing
				#spawn_instance_selected()
				#setup_selected_item_icon();
				#hide_sandBox_menu();
				#can_spawn = false
				#
			#elif not GameMaster.magic_cursor.is_grabing:
				#can_spawn = true
			#
#
#func setup_selected_item_icon():
	#selected_item.set_button_icon(last_object_config.texture);
#
#func hide_sandBox_menu():
		#category.hide();
		#scroll_container.hide();
#
#
#func sort_by_category(a, b):
	#return a["category"] < b["category"]
	#
#func load_all_ressources():
	#all_items_with_category = get_file_of_ressources_directory(box_path);
	#all_items_with_category += get_file_of_ressources_directory(Mushrooms_path);
	#all_items_with_category += get_file_of_ressources_directory(Rocks_path);
	#all_items_with_category += get_file_of_ressources_directory(Specials_path);
	#all_items_with_category.sort_custom(sort_by_category);
	#
#func get_file_of_ressources_directory(path_to_ressource):
	#var category = path_to_ressource.replace(base_path_to_ressource, "");
	#var directory_ressources = DirAccess.open(path_to_ressource);
	#var file_of_directory: Array = [];
	#if directory_ressources:
		#directory_ressources.list_dir_begin()
		#var file_name = directory_ressources.get_next()
		#while file_name != "":
			#if not directory_ressources.current_is_dir():
				#file_of_directory.append({
					#"category": category.to_lower(),
					#"object": load(path_to_ressource+"/"+file_name),
					#"full_path": path_to_ressource+"/"+file_name
					#});
			#file_name = directory_ressources.get_next()
		#return file_of_directory;
#
#func load_item_information_in_list_items(category):
	#if(not scroll_container.is_visible()):
		#scroll_container.show();
		#
	#
	#var selected_category = all_items_with_category.filter(func(item):
		#return item["category"] == category
	#);
	#
	#for i in range(selected_category.size()):
		#add_item(selected_category[i]["object"]);
#
#func add_item(object):
	#var item = Button.new()
	#item.custom_minimum_size = Vector2(45, 39)
	#item.set_button_icon(object.texture);
	#
	#item.icon_alignment = 1;
	#item.expand_icon = true;
	#item.pressed.connect(_on_item_pressed.bind(object))
#
	#item_of_category.add_child(item);
#
#func reset_item_in_item_of_category():
	#for item in item_of_category.get_children():
		#item.queue_free()
#
#func on_category_pressed(category):
	#reset_item_in_item_of_category()
	#load_item_information_in_list_items(category);
#
#func find_category_of_object(object):
	#for item_data in all_items_with_category:
		#if item_data["object"] == object:
			#return item_data["category"]
	#
#
#func find_file_path_of_object(object):
	#for item_data in all_items_with_category:
		#if item_data["object"] == object:
			#return item_data["object"]
			#
#func _on_item_pressed(object):
	#var category = find_category_of_object(object);
	#
	#if category == "box":
		#instansiate_scene_of_object_in_world(full_motion_object,object);
		#
	#elif category == "collectables":
		#instansiate_scene_of_object_in_world(full_motion_object,object);
	#
	#elif category == "rocks":
		#instansiate_scene_of_object_in_world(full_motion_object,object);
		#
	#elif category == "mushrooms":
		#instansiate_scene_of_object_in_world(horizontal_motion_object,object);
	#can_spawn = false;
#
#func instansiate_scene_of_object_in_world(scene_to_spawn, object):
	#last_scene_used = scene_to_spawn
	#last_object_config = find_file_path_of_object(object)
#
#func spawn_instance_selected():
	#var current_scene = get_tree().current_scene
#
	#if  last_scene_used:
		#var instance = last_scene_used.instantiate()
		#instance.global_position = GameMaster.magic_cursor.global_position
		#instance.config = last_object_config
		#current_scene.add_child(instance)
#
#func _on_selected_item_pressed() -> void:
	#if categoryIsHidden:
		#category.show();
		#categoryIsHidden = false;
	#else:
		#category.hide();
		#scroll_container.hide();
		#categoryIsHidden = true;
	#
#
#func _on_box_category_pressed() -> void:
	#on_category_pressed("box");
#
#func _on_rock_category_pressed() -> void:
	#on_category_pressed("rocks");
#
#func _on_mushroom_category_pressed() -> void:
	#on_category_pressed("mushrooms");
#
#func _on_ice_category_pressed() -> void:
	#on_category_pressed("ice");
#
#func _on_all_category_pressed() -> void:
	#reset_item_in_item_of_category()
	#
#func _on_edit_pressed() -> void:
	#var btn = edit
	#btn_is_click =true
	#if firstime_creative:
		#btn.grab_focus()
		#btn.toggle_mode = true
		#creative_mode = true
		#firstime_creative =false;
		#return;
		#
	#if btn.has_focus():
		#btn.release_focus()
		#creative_mode = false
		#firstime_creative =true
	#
	#
##func _on_eraser_pressed() -> void:
	##var btn = eraser
	##if first_time_erase:
		##btn.grab_focus()
		##btn.toggle_mode = true
		##creative_mode = true
		##first_time_erase = false
		##return


extends Control

@onready var selected_item: Button = $HBSelectedItem/SelectedItem
@onready var edit: Button = $HBSelectedItem/Edit
@onready var eraser: Button = $HBSelectedItem/Eraser
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var item_of_category: VBoxContainer = $ScrollContainer/ItemOfCategory
@onready var category: ScrollContainer = $Category

const BASE_RESOURCE_PATH := "res://ressources/objects/"

const CATEGORY_PATHS := [
	BASE_RESOURCE_PATH + "Box",
	BASE_RESOURCE_PATH + "Collectables",
	BASE_RESOURCE_PATH + "Mushrooms",
	BASE_RESOURCE_PATH + "Rocks",
	BASE_RESOURCE_PATH + "Specials",
]

const FULL_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/full_motion_object.tscn")
const HORIZONTAL_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/horizontal_motion_object.tscn")
const MOVEABLE_OBJECT := preload("res://scenes/Objects/Moveables/moveable_object.tscn")
const VERTICAL_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/vertical_motion_object.tscn")

enum ToolMode {
	NONE,
	SPAWN,
	ERASE
}

var current_tool := ToolMode.NONE

var has_player := false
var category_is_hidden := true

var can_spawn := true
var creative_mode := true
var first_time_creative := true
var first_time_erase := true
var btn_is_click := true

var last_scene_used: PackedScene = null
var last_object_config = null

var all_items_with_category: Array = []


func _ready() -> void:
	load_all_resources()
	hide_sandbox_menu()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_viewport().gui_get_hovered_control() != null:
			btn_is_click = true
			return

		btn_is_click = false
	else:
		btn_is_click = false


func _process(_delta: float) -> void:
	if current_tool == ToolMode.NONE:
		return

	if current_tool == ToolMode.ERASE:
		handle_erase_mode()
		return

	if current_tool == ToolMode.SPAWN:
		handle_spawn_mode()


func handle_spawn_mode() -> void:
	if not creative_mode:
		return

	if btn_is_click:
		return

	if not last_scene_used:
		return

	if GameMaster.magic_cursor.is_grabing and can_spawn:
		spawn_instance_selected()
		setup_selected_item_icon()
		hide_sandbox_menu()
		can_spawn = false
	elif not GameMaster.magic_cursor.is_grabing:
		can_spawn = true

func load_all_resources() -> void:
	all_items_with_category.clear()

	for path in CATEGORY_PATHS:
		all_items_with_category += get_files_from_resource_directory(path)

	all_items_with_category.sort_custom(sort_by_category)


func get_files_from_resource_directory(path_to_resource: String) -> Array:
	var directory := DirAccess.open(path_to_resource)
	var files: Array = []

	if directory == null:
		return files

	var category_name := path_to_resource.replace(BASE_RESOURCE_PATH, "").to_lower()

	directory.list_dir_begin()
	var file_name := directory.get_next()

	while file_name != "":
		if not directory.current_is_dir():
			var full_path := path_to_resource + "/" + file_name

			files.append({
				"category": category_name,
				"object": load(full_path),
				"full_path": full_path
			})

		file_name = directory.get_next()

	return files


func sort_by_category(a, b) -> bool:
	return a["category"] < b["category"]


func load_item_information_in_list_items(category_name: String) -> void:
	if not scroll_container.is_visible():
		scroll_container.show()

	var selected_category := all_items_with_category.filter(func(item):
		return item["category"] == category_name
	)

	for item_data in selected_category:
		add_item(item_data["object"])


func add_item(object) -> void:
	var item := Button.new()

	item.custom_minimum_size = Vector2(45, 39)
	item.set_button_icon(object.texture)
	item.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.expand_icon = true
	item.pressed.connect(_on_item_pressed.bind(object))

	item_of_category.add_child(item)


func reset_item_in_item_of_category() -> void:
	for item in item_of_category.get_children():
		item.queue_free()


func on_category_pressed(category_name: String) -> void:
	reset_item_in_item_of_category()
	load_item_information_in_list_items(category_name)


func find_category_of_object(object):
	for item_data in all_items_with_category:
		if item_data["object"] == object:
			return item_data["category"]

	return null


func find_config_of_object(object):
	for item_data in all_items_with_category:
		if item_data["object"] == object:
			return item_data["object"]

	return null


func _on_item_pressed(object) -> void:
	var category_name = find_category_of_object(object)
	var scene_to_spawn := get_scene_for_category(category_name)

	if scene_to_spawn == null:
		return

	set_selected_object(scene_to_spawn, object)
	can_spawn = false


func get_scene_for_category(category_name: String) -> PackedScene:
	match category_name:
		"box", "collectables", "rocks":
			return FULL_MOTION_OBJECT
		"mushrooms":
			return HORIZONTAL_MOTION_OBJECT
		_:
			return null


func set_selected_object(scene_to_spawn: PackedScene, object) -> void:
	last_scene_used = scene_to_spawn
	last_object_config = find_config_of_object(object)


func setup_selected_item_icon() -> void:
	if last_object_config:
		selected_item.set_button_icon(last_object_config.texture)


func hide_sandbox_menu() -> void:
	category.hide()
	scroll_container.hide()


func spawn_instance_selected() -> void:
	if not last_scene_used:
		return

	var instance = last_scene_used.instantiate()

	instance.global_position = GameMaster.magic_cursor.global_position
	instance.config = last_object_config
	instance.add_to_group("SandBoxObjects")

	get_tree().current_scene.add_child(instance)


func _on_selected_item_pressed() -> void:
	category_is_hidden = not category_is_hidden

	if category_is_hidden:
		hide_sandbox_menu()
	else:
		category.show()


func _on_box_category_pressed() -> void:
	on_category_pressed("box")


func _on_rock_category_pressed() -> void:
	on_category_pressed("rocks")


func _on_mushroom_category_pressed() -> void:
	on_category_pressed("mushrooms")


func _on_ice_category_pressed() -> void:
	on_category_pressed("ice")


func _on_all_category_pressed() -> void:
	reset_item_in_item_of_category()


func _on_edit_pressed() -> void:
	btn_is_click = true

	if current_tool == ToolMode.SPAWN:
		current_tool = ToolMode.NONE
		creative_mode = false
		edit.release_focus()
		return

	current_tool = ToolMode.SPAWN
	creative_mode = true

	edit.grab_focus()
	eraser.release_focus()
	
func _on_eraser_pressed() -> void:
	btn_is_click = true

	if current_tool == ToolMode.ERASE:
		current_tool = ToolMode.NONE
		eraser.release_focus()
		return

	current_tool = ToolMode.ERASE
	creative_mode = false

	eraser.grab_focus()
	edit.release_focus()

func handle_erase_mode() -> void:
	if btn_is_click:
		return

	if GameMaster.magic_cursor.is_grabing and can_spawn:
		erase_selected_object()
		can_spawn = false
	elif not GameMaster.magic_cursor.is_grabing:
		can_spawn = true

func erase_selected_object() -> void:
	var object = GameMaster.magic_cursor.closest_object

	if object == null:
		return

	if not object.is_in_group("SandBoxObjects"):
		return

	GameMaster.magic_cursor.is_holding = false
	GameMaster.magic_cursor.closest_object = null

	object.queue_free()
