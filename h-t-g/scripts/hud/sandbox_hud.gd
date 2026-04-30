extends Control

@onready var selected_item: Button = $HBSelectedItem/SelectedItem
@onready var edit: Button = $HBSelectedItem/Edit
@onready var eraser: Button = $HBSelectedItem/Eraser
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var item_of_category: VBoxContainer = $ScrollContainer/ItemOfCategory
@onready var category: ScrollContainer = $Category
@onready var all_category: Button = $Category/VBoxContainer/AllCategory


const BASE_RESOURCE_PATH := "res://ressources/objects/"

const CATEGORY_PATHS := [
	BASE_RESOURCE_PATH + "Box",
	BASE_RESOURCE_PATH + "Mushrooms",
	BASE_RESOURCE_PATH + "Rocks",
	BASE_RESOURCE_PATH + "Specials",
]

const FULL_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/full_motion_object.tscn")
const HORIZONTAL_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/horizontal_motion_object.tscn")
const MOVEABLE_OBJECT := preload("res://scenes/Objects/Moveables/moveable_object.tscn")
const VERTICAL_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/vertical_motion_object.tscn")
const SPRING_MOTION_OBJECT := preload("res://scenes/Objects/Moveables/spring_object.tscn")
const CORPSE_OBJECT := preload("res://scenes/Objects/Moveables/corpse.tscn")

const TOOL_ON_COLOR := Color(0.15, 0.75, 0.25, 1.0)
const TOOL_OFF_COLOR := Color(0.75, 0.15, 0.15, 1.0)
const TOOL_HOVER_COLOR := Color(0.95, 0.95, 0.95, 1.0)


enum ToolMode {
	NONE,
	SPAWN,
	ERASE
}

var current_tool := ToolMode.NONE

var was_hand_pinching_ui := false
var hovered_hand_button: Button = null

var has_enemy := false
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
	selected_item.grab_focus()
	
	edit.flat = false
	eraser.flat = false
	update_tool_buttons_visuals()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_viewport().gui_get_hovered_control() != null:
			btn_is_click = true
			return

		btn_is_click = false
	else:
		btn_is_click = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Focus"):
		keep_focus_alive()


func _process(_delta: float) -> void:
	handle_hand_ui_buttons()
	
	if current_tool == ToolMode.NONE:
		return
	if current_tool == ToolMode.ERASE:
		handle_erase_mode()
		return
	if current_tool == ToolMode.SPAWN:
		handle_spawn_mode()
		


func handle_spawn_mode() -> void:
	if hovered_hand_button != null:
		return
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
	var scene_to_spawn := get_scene_for_category(category_name, object)

	if scene_to_spawn == null:
		return

	set_selected_object(scene_to_spawn, object)
	can_spawn = false



func get_scene_for_category(category_name: String, object) -> PackedScene:
	match category_name:
		"box", "collectables", "rocks":
			return FULL_MOTION_OBJECT
		"mushrooms":
			return HORIZONTAL_MOTION_OBJECT
		"specials":
			if object.name.to_lower().contains("corpse"):
				return CORPSE_OBJECT

			if object.name.to_lower().contains("spring"):
				return SPRING_MOTION_OBJECT

			return null
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
		all_category.grab_focus()


func _on_box_category_pressed() -> void:
	on_category_pressed("box")


func _on_rock_category_pressed() -> void:
	on_category_pressed("rocks")


func _on_mushroom_category_pressed() -> void:
	on_category_pressed("mushrooms")


func _on_special_category_pressed() -> void:
	on_category_pressed("specials")


func _on_all_category_pressed() -> void:
	reset_item_in_item_of_category()

	if not scroll_container.is_visible():
		scroll_container.show()

	for item_data in all_items_with_category:
		add_item(item_data["object"])


func _on_edit_pressed() -> void:
	btn_is_click = true

	if current_tool == ToolMode.SPAWN:
		current_tool = ToolMode.NONE
		creative_mode = false
		edit.release_focus()
		update_tool_buttons_visuals()
		return

	current_tool = ToolMode.SPAWN
	creative_mode = true

	edit.grab_focus()
	eraser.release_focus()
	update_tool_buttons_visuals()


	
func _on_eraser_pressed() -> void:
	btn_is_click = true

	if current_tool == ToolMode.ERASE:
		current_tool = ToolMode.NONE
		eraser.release_focus()
		update_tool_buttons_visuals()
		return

	current_tool = ToolMode.ERASE
	creative_mode = false

	eraser.grab_focus()
	edit.release_focus()
	update_tool_buttons_visuals()



func handle_erase_mode() -> void:
	if hovered_hand_button != null:
		return
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

	var object_to_delete = find_sandbox_root(object)

	if object_to_delete == null:
		return

	GameMaster.magic_cursor.is_holding = false
	GameMaster.magic_cursor.closest_object = null

	object_to_delete.queue_free()

func find_sandbox_root(node: Node) -> Node:
	var current := node

	while current != null:
		if current.is_in_group("SandBoxObjects"):
			return current

		current = current.get_parent()

	return null


func handle_hand_ui_buttons() -> void:
	if GameMaster.mouse_mode:
		return

	var cursor := GameMaster.magic_cursor
	if cursor == null:
		return

	var button := get_button_under_hand(cursor.global_position)

	if hovered_hand_button != button:
		hovered_hand_button = button

		if hovered_hand_button:
			hovered_hand_button.grab_focus()

	var is_pinching := Udp.is_pinching

	if is_pinching and not was_hand_pinching_ui and button:
		btn_is_click = true
		button.emit_signal("pressed")

	was_hand_pinching_ui = is_pinching


func get_button_under_hand(_world_position: Vector2) -> Button:
	var cursor := GameMaster.magic_cursor
	if cursor == null:
		return null

	var screen_position := get_viewport().get_canvas_transform() * cursor.global_position
	return find_button_at_position(self, screen_position)




func find_button_at_position(node: Node, screen_position: Vector2) -> Button:
	if node is Control and not node.is_visible_in_tree():
		return null

	for child in node.get_children():
		var found := find_button_at_position(child, screen_position)
		if found:
			return found

	if node is Button and not node.disabled:
		if node.get_global_rect().has_point(screen_position):
			return node

	return null
	
func keep_focus_alive() -> void:
	if get_viewport().gui_get_focus_owner() != null:
		return

	if current_tool == ToolMode.SPAWN:
		edit.grab_focus()
	elif current_tool == ToolMode.ERASE:
		eraser.grab_focus()
	else:
		selected_item.grab_focus()

func make_tool_button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(6)
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style


func update_tool_buttons_visuals() -> void:
	var edit_is_on := current_tool == ToolMode.SPAWN
	var erase_is_on := current_tool == ToolMode.ERASE

	edit.add_theme_stylebox_override("normal", make_tool_button_style(TOOL_ON_COLOR if edit_is_on else TOOL_OFF_COLOR))
	edit.add_theme_stylebox_override("hover", make_tool_button_style(TOOL_ON_COLOR.lightened(0.15) if edit_is_on else TOOL_OFF_COLOR.lightened(0.15)))
	edit.add_theme_stylebox_override("pressed", make_tool_button_style(TOOL_ON_COLOR.darkened(0.15) if edit_is_on else TOOL_OFF_COLOR.darkened(0.15)))

	eraser.add_theme_stylebox_override("normal", make_tool_button_style(TOOL_ON_COLOR if erase_is_on else TOOL_OFF_COLOR))
	eraser.add_theme_stylebox_override("hover", make_tool_button_style(TOOL_ON_COLOR.lightened(0.15) if erase_is_on else TOOL_OFF_COLOR.lightened(0.15)))
	eraser.add_theme_stylebox_override("pressed", make_tool_button_style(TOOL_ON_COLOR.darkened(0.15) if erase_is_on else TOOL_OFF_COLOR.darkened(0.15)))
