extends Control

export (PackedScene) var light_prefab
export (PackedScene) var sphere_prefab
export (PackedScene) var cube_prefab
export (PackedScene) var plane_prefab

onready var global = get_node("/root/Global")

onready var move_arrows1 : Spatial = get_node("../../../MoveArrows")

onready var light_sources : Spatial = get_node("../../../Lights")
onready var spheres : Spatial = get_node("../../../Spheres")
onready var cubes : Spatial = get_node("../../../Boxes")
onready var planes : Spatial = get_node("../../../Planes")

var WIDTH : int = 800
var HEIGHT : int = 600
var AA_LEVEL : int = 1
var SAVE_PATH : String = "user://"

var spheresID : int = 1
var cubesID : int = 1
var planesID : int = 1
var lightsID : int = 1

onready var objects_tree : Tree = $LeftPanel/Elements/Tree

onready var save_scene_dialog : FileDialog = $Dialogs/SaveSceneDialog
onready var load_scene_dialog : FileDialog = $Dialogs/LoadSceneDialog
onready var load_model_dialog : FileDialog = $Dialogs/LoadModelDialog
onready var save_path_dialog : FileDialog = $Dialogs/SavePictureDialog
onready var create_scene_accept : ConfirmationDialog = $Dialogs/CreateSceneAccept
onready var delete_object_accept : ConfirmationDialog = $Dialogs/DeleteObjectAccept

onready var sphere_edit : Control = $RightPanel/MenusContainer/Properties/Sphere
onready var sphere_edit_name : LineEdit = $RightPanel/MenusContainer/Properties/Sphere/Elements/NameEdit
onready var sphere_edit_radius : SpinBox = $RightPanel/MenusContainer/Properties/Sphere/Elements/RadiusEdit
onready var sphere_edit_coord_x : SpinBox = $RightPanel/MenusContainer/Properties/Sphere/Elements/CoordinatesEdit/X
onready var sphere_edit_coord_y : SpinBox = $RightPanel/MenusContainer/Properties/Sphere/Elements/CoordinatesEdit/Y
onready var sphere_edit_coord_z : SpinBox = $RightPanel/MenusContainer/Properties/Sphere/Elements/CoordinatesEdit/Z
onready var sphere_edit_color : ColorRect = $RightPanel/MenusContainer/Properties/Sphere/Elements/ColorEdit
onready var sphere_edit_is_reflective : CheckBox = $RightPanel/MenusContainer/Properties/Sphere/Elements/IsReflectiveCh/CheckBox

onready var cube_edit : Control = $RightPanel/MenusContainer/Properties/Cube
onready var cube_edit_name : LineEdit = $RightPanel/MenusContainer/Properties/Cube/Elements/NameEdit
onready var cube_edit_width_lenght : SpinBox = $RightPanel/MenusContainer/Properties/Cube/Elements/WidthLenghtEdit
onready var cube_edit_height_lenght : SpinBox = $RightPanel/MenusContainer/Properties/Cube/Elements/HeightLenghtEdit
onready var cube_edit_depth_lenght : SpinBox = $RightPanel/MenusContainer/Properties/Cube/Elements/DepthLenghtEdit
onready var cube_edit_coord_x : SpinBox = $RightPanel/MenusContainer/Properties/Cube/Elements/CoordinatesEdit/X
onready var cube_edit_coord_y : SpinBox = $RightPanel/MenusContainer/Properties/Cube/Elements/CoordinatesEdit/Y
onready var cube_edit_coord_z : SpinBox = $RightPanel/MenusContainer/Properties/Cube/Elements/CoordinatesEdit/Z
onready var cube_edit_color : ColorRect = $RightPanel/MenusContainer/Properties/Cube/Elements/ColorEdit
onready var cube_edit_is_reflective : CheckBox = $RightPanel/MenusContainer/Properties/Cube/Elements/IsReflectiveCh/CheckBox

onready var light_edit : Control = $RightPanel/MenusContainer/Properties/Light
onready var light_edit_name : LineEdit = $RightPanel/MenusContainer/Properties/Light/Elements/NameEdit
onready var light_edit_coord_x : SpinBox = $RightPanel/MenusContainer/Properties/Light/Elements/CoordinatesEdit/X
onready var light_edit_coord_y : SpinBox = $RightPanel/MenusContainer/Properties/Light/Elements/CoordinatesEdit/Y
onready var light_edit_coord_z : SpinBox = $RightPanel/MenusContainer/Properties/Light/Elements/CoordinatesEdit/Z
onready var light_edit_color : ColorRect = $RightPanel/MenusContainer/Properties/Light/Elements/ColorEdit

onready var plane_edit : Control = $RightPanel/MenusContainer/Properties/Plane
onready var plane_edit_name : LineEdit = $RightPanel/MenusContainer/Properties/Plane/Elements/NameEdit
onready var plane_edit_axis : OptionButton = $RightPanel/MenusContainer/Properties/Plane/Elements/AxisList
onready var plane_edit_distance : SpinBox = $RightPanel/MenusContainer/Properties/Plane/Elements/Distance
onready var plane_edit_color : ColorRect = $RightPanel/MenusContainer/Properties/Plane/Elements/ColorEdit
onready var plane_edit_is_reflective : CheckBox = $RightPanel/MenusContainer/Properties/Plane/Elements/IsReflectiveCh/CheckBox
onready var plane_edit_is_chess : CheckBox = $RightPanel/MenusContainer/Properties/Plane/Elements/IsChessCh/CCheckBox

onready var color_picker_window : Control = $ClearColorPicker
onready var color_picker : ColorPicker = $ClearColorPicker/ColorPicker

onready var render_window : Control = $RenderWindow
onready var render_window_height : SpinBox = $RenderWindow/BG/Elements/Size/Height/HSpinBox
onready var render_window_width : SpinBox = $RenderWindow/BG/Elements/Size/Width/WSpinBox
onready var render_window_AA : SpinBox = $RenderWindow/BG/Elements/AASpinBox
onready var render_window_path : LineEdit = $RenderWindow/BG/Elements/PathLineEdit

onready var shield : ColorRect = $Shield

var SelectedObjectType : int = -1
var SelectedSphere : CSGSphere
var SelectedCube : CSGBox
var SelectedPlane : CSGBox
var SelectedLight : OmniLight
var TreeItemSelected : bool = false

func _ready():
	plane_edit_axis.add_item("X")
	plane_edit_axis.add_item("Y")
	plane_edit_axis.add_item("Z")
	check_objects()

#func _process(delta):
#	match (SelectedObjectType):
#		0:
#			move_arrows.visible = true
#			move_arrows.transform.origin.x = SelectedLight.transform.origin.x
#			move_arrows.transform.origin.y = SelectedLight.transform.origin.y
#			move_arrows.transform.origin.z = SelectedLight.transform.origin.z
#			calc_arrows_scale(SelectedLight)
#		1:
#			move_arrows.visible = true
#			move_arrows.transform.origin.x = SelectedSphere.transform.origin.x
#			move_arrows.transform.origin.y = SelectedSphere.transform.origin.y
#			move_arrows.transform.origin.z = SelectedSphere.transform.origin.z
#			calc_arrows_scale(SelectedSphere)
#		2:
#			move_arrows.visible = true
#			move_arrows.transform.origin.x = SelectedCube.transform.origin.x
#			move_arrows.transform.origin.y = SelectedCube.transform.origin.y
#			move_arrows.transform.origin.z = SelectedCube.transform.origin.z
#			calc_arrows_scale(SelectedCube)
#		3:
#			move_arrows.visible = true
#			move_arrows.transform.origin.x = SelectedModel.transform.origin.x
#			move_arrows.transform.origin.y = SelectedModel.transform.origin.y
#			move_arrows.transform.origin.z = SelectedModel.transform.origin.z
#			calc_arrows_scale(SelectedModel)
#		_:
#			move_arrows.visible = false

#func calc_arrows_scale(object : Spatial):
#	var camera : Camera = get_parent()
#	var distance = sqrt(pow(camera.transform.origin.x - object.transform.origin.x, 2) + pow(camera.transform.origin.y - object.transform.origin.y, 2) + pow(camera.transform.origin.z - object.transform.origin.z, 2))
#	move_arrows.scale.x = 0.1 * distance
#	move_arrows.scale.y = 0.1 * distance
#	move_arrows.scale.z = 0.1 * distance

func check_objects():
	var root = objects_tree.create_item()
	var lights_tree = objects_tree.create_item(root)
	lights_tree.set_text(0, light_sources.name)
	var spheres_tree = objects_tree.create_item(root)
	spheres_tree.set_text(0, spheres.name)
	var cubes_tree = objects_tree.create_item(root)
	cubes_tree.set_text(0, cubes.name)
	var planes_tree = objects_tree.create_item(root)
	planes_tree.set_text(0, planes.name)
	for i in range(0, light_sources.get_child_count()):
		var light = objects_tree.create_item(lights_tree)
		light.set_text(0, light_sources.get_child(i).name)
		var light_object : OmniLight = light_sources.get_child(i)
		var light_sprite : Sprite3D = light_object.get_child(0)
		light_sprite.modulate = light_object.light_color
	for i in range(0, spheres.get_child_count()):
		var sphere = objects_tree.create_item(spheres_tree)
		sphere.set_text(0, spheres.get_child(i).name)
	for i in range(0, cubes.get_child_count()):
		var cube = objects_tree.create_item(cubes_tree)
		cube.set_text(0, cubes.get_child(i).name)
	for i in range(0, planes.get_child_count()):
		var model = objects_tree.create_item(planes_tree)
		model.set_text(0, planes.get_child(i).name)

func _on_ChangeClearColorB_pressed():
	color_picker_window.visible = true
	SelectedObjectType = -1
	shield.visible = true

func _on_CreateSceneB_pressed():
	create_scene_accept.popup()

func _on_LoadSceneB_pressed():
	load_scene_dialog.popup()

func _on_SaveSceneB_pressed():
	save_scene_dialog.popup()

func _on_CreateLightSourceB_pressed():
	var new_light = light_prefab.instance()
	new_light.name = "Light" + str(lightsID)
	lightsID = lightsID + 1
	light_sources.add_child(new_light)
	objects_tree.clear()
	check_objects()

func _on_LoadModelB_pressed():
	var new_plane = cube_prefab.instance()
	new_plane.name = "Plane" + str(planesID)
	planesID = planesID + 1
	new_plane.width = 10000
	new_plane.height = 0.01
	new_plane.depth = 10000
	var material : SpatialMaterial = SpatialMaterial.new()
	new_plane.material = material
	planes.add_child(new_plane)
	objects_tree.clear()
	check_objects()

func _on_RenderB_pressed():
	render_window_width.value = WIDTH
	render_window_height.value = HEIGHT
	render_window_AA.value = AA_LEVEL
	render_window_path.text = SAVE_PATH
	render_window.visible = true
	shield.visible = true

func _on_CreateSceneAccept_confirmed():
	SelectedObjectType = -1
	SelectedLight = null
	SelectedSphere = null
	SelectedCube = null
	SelectedPlane = null
	while light_sources.get_child_count() > 0:
		light_sources.get_child(0).free()
	while spheres.get_child_count() > 0:
		spheres.get_child(0).free()
	while cubes.get_child_count() > 0:
		cubes.get_child(0).free()
	while planes.get_child_count() > 0:
		planes.get_child(0).free()
	spheresID = 0
	cubesID = 0
	lightsID = 0
	planesID = 0
	var camera : Camera = get_parent()
	camera.environment.background_color.r = 0.4
	camera.environment.background_color.g = 0.4
	camera.environment.background_color.b = 0.4
	objects_tree.clear()
	check_objects()

func _input(event):
	if (Input.is_action_pressed("MouseMove")):
		var current_focus_control = get_focus_owner()
		if current_focus_control:
			current_focus_control.release_focus()

func _on_Tree_item_selected():
	var object : TreeItem = objects_tree.get_selected()
	var found = false
	if SelectedLight != null:
		#SelectedLight.light_energy = 1
		var light_sprite : Sprite3D = SelectedLight.get_child(0)
		light_sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
	if SelectedSphere != null:
		var material : SpatialMaterial = SelectedSphere.material
		material.albedo_color.a = 1
		material.flags_unshaded = false
		material.flags_no_depth_test = false
		SelectedSphere.material = material
	if SelectedCube != null:
		var material : SpatialMaterial = SelectedCube.material
		material.albedo_color.a = 1
		material.flags_unshaded = false
		material.flags_no_depth_test = false
		SelectedCube.material = material
	if SelectedPlane != null:
		var material : SpatialMaterial = SelectedPlane.material
		material.albedo_color.a = 1
		material.flags_unshaded = false
		SelectedPlane.material = material
	for i in range(0, light_sources.get_child_count()):
		if object.get_text(0) == light_sources.get_child(i).name:
			SelectedLight = light_sources.get_child(i)
			SelectedObjectType = 0
			found = true
			break
	for i in range(0, spheres.get_child_count()):
		if object.get_text(0) == spheres.get_child(i).name:
			SelectedSphere = spheres.get_child(i)
			SelectedObjectType = 1
			found = true
			break
	for i in range(0, cubes.get_child_count()):
		if object.get_text(0) == cubes.get_child(i).name:
			SelectedCube = cubes.get_child(i)
			SelectedObjectType = 2
			found = true
			break
	for i in range(0, planes.get_child_count()):
		if object.get_text(0) == planes.get_child(i).name:
			SelectedPlane = planes.get_child(i)
			SelectedObjectType = 3
			found = true
			break
	if found:
		TreeItemSelected = true
		print_debug(object.get_text(0))
		match(SelectedObjectType):
			0:
				#SelectedLight.light_energy = 1.2
				var light_sprite : Sprite3D = SelectedLight.get_child(0)
				light_sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
				sphere_edit.visible = false
				cube_edit.visible = false
				light_edit.visible = true
				plane_edit.visible = false
				light_edit_name.text = SelectedLight.name
				light_edit_coord_x.value = SelectedLight.transform.origin.x
				light_edit_coord_y.value = SelectedLight.transform.origin.y
				light_edit_coord_z.value = SelectedLight.transform.origin.z
				light_edit_color.color = SelectedLight.light_color
			1:
				var material : SpatialMaterial = SelectedSphere.material
				material.albedo_color.a = 0.8
				material.flags_unshaded = true
				material.flags_no_depth_test = true
				SelectedSphere.material = material
				sphere_edit.visible = true
				cube_edit.visible = false
				light_edit.visible = false
				plane_edit.visible = false
				sphere_edit_name.text = SelectedSphere.name
				sphere_edit_radius.value = SelectedSphere.radius
				sphere_edit_coord_x.value = SelectedSphere.transform.origin.x
				sphere_edit_coord_y.value = SelectedSphere.transform.origin.y
				sphere_edit_coord_z.value = SelectedSphere.transform.origin.z
				sphere_edit_color.color = material.albedo_color
				sphere_edit_is_reflective.pressed = material.normal_enabled
			2:
				var material : SpatialMaterial = SelectedCube.material
				material.albedo_color.a = 0.8
				material.flags_unshaded = true
				material.flags_no_depth_test = true
				SelectedCube.material = material
				sphere_edit.visible = false
				cube_edit.visible = true
				light_edit.visible = false
				plane_edit.visible = false
				cube_edit_name.text = SelectedCube.name
				cube_edit_width_lenght.value = SelectedCube.width
				cube_edit_height_lenght.value = SelectedCube.height
				cube_edit_depth_lenght.value = SelectedCube.depth
				cube_edit_coord_x.value = SelectedCube.transform.origin.x
				cube_edit_coord_y.value = SelectedCube.transform.origin.y
				cube_edit_coord_z.value = SelectedCube.transform.origin.z
				cube_edit_color.color = material.albedo_color
				cube_edit_is_reflective.pressed = material.normal_enabled
			3:
				var material : SpatialMaterial = SelectedPlane.material
				material.albedo_color.a = 0.8
				material.flags_unshaded = true
				SelectedPlane.material = material
				sphere_edit.visible = false
				cube_edit.visible = false
				light_edit.visible = false
				plane_edit.visible = true
				plane_edit_name.text = SelectedPlane.name
				if (SelectedPlane.width < 1):
					plane_edit_axis.select(0)
				elif (SelectedPlane.height < 1):
					plane_edit_axis.select(1)
				elif SelectedPlane.depth < 1:
					plane_edit_axis.select(2)
				plane_edit_distance.value = material.uv2_offset.x
				plane_edit_color.color = material.albedo_color
				plane_edit_is_reflective.pressed = material.normal_enabled
				plane_edit_is_chess.pressed = material.emission_enabled
	else:
		SelectedObjectType = -1
		sphere_edit.visible = false
		cube_edit.visible = false
		light_edit.visible = false
		plane_edit.visible = false

func _on_Tree_item_activated():
	if TreeItemSelected:
		if SelectedLight != null:
			SelectedLight.light_energy = 1
			var light_sprite : Sprite3D = SelectedLight.get_child(0)
			light_sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
		if SelectedSphere != null:
			var material : SpatialMaterial = SelectedSphere.material
			material.albedo_color.a = 1
			material.flags_unshaded = false
			material.flags_no_depth_test = false
			SelectedSphere.material = material
		if SelectedCube != null:
			var material : SpatialMaterial = SelectedCube.material
			material.albedo_color.a = 1
			material.flags_unshaded = false
			material.flags_no_depth_test = false
			SelectedCube.material = material
		if SelectedPlane != null:
			var material : SpatialMaterial = SelectedPlane.material
			material.albedo_color.a = 1
			material.flags_unshaded = false
			SelectedPlane.material = material
			TreeItemSelected = false
		sphere_edit.visible = false
		cube_edit.visible = false
		light_edit.visible = false
		plane_edit.visible = false
		SelectedObjectType = -1
	elif !TreeItemSelected and objects_tree.get_selected() != null:
		_on_Tree_item_selected()

func _on_NameEdit_text_changed(new_text):
	match(SelectedObjectType):
		0:
			SelectedLight.name = light_edit_name.text
			print_debug(SelectedLight.name)
		1:
			SelectedSphere.name = sphere_edit_name.text
			print_debug(SelectedSphere.name)
		2:
			SelectedCube.name = cube_edit_name.text
			print_debug(SelectedCube.name)
		3:
			SelectedPlane.name = plane_edit_name.text
			print_debug(SelectedPlane.name)
	objects_tree.clear()
	check_objects()

func _on_RadiusEdit_value_changed(value):
	if SelectedObjectType == 1:
		SelectedSphere.radius = sphere_edit_radius.value

func _on_X_value_changed(value):
	match(SelectedObjectType):
		0:
			SelectedLight.transform.origin.x = light_edit_coord_x.value
		1:
			SelectedSphere.transform.origin.x = sphere_edit_coord_x.value
		2:
			SelectedCube.transform.origin.x = cube_edit_coord_x.value
		3:
			var material : SpatialMaterial = SelectedPlane.material
			material.uv2_offset.x = plane_edit_distance.value
			SelectedPlane.material = material
			if (SelectedPlane.width < 1):
				SelectedPlane.transform.origin.x = plane_edit_distance.value
				SelectedPlane.transform.origin.y = 0
				SelectedPlane.transform.origin.z = 0
			elif (SelectedPlane.height < 1):
				SelectedPlane.transform.origin.x = 0
				SelectedPlane.transform.origin.y = plane_edit_distance.value
				SelectedPlane.transform.origin.z = 0
			elif (SelectedPlane.depth < 1):
				SelectedPlane.transform.origin.x = 0
				SelectedPlane.transform.origin.y = 0
				SelectedPlane.transform.origin.z = plane_edit_distance.value

func _on_Y_value_changed(value):
	match(SelectedObjectType):
		0:
			SelectedLight.transform.origin.y = light_edit_coord_y.value
		1:
			SelectedSphere.transform.origin.y = sphere_edit_coord_y.value
		2:
			SelectedCube.transform.origin.y = cube_edit_coord_y.value
		3:
			var material : SpatialMaterial = SelectedPlane.material
			material.uv2_offset.x = plane_edit_distance.value
			SelectedPlane.material = material
			if (SelectedPlane.width < 1):
				SelectedPlane.transform.origin.x = plane_edit_distance.value
				SelectedPlane.transform.origin.y = 0
				SelectedPlane.transform.origin.z = 0
			elif (SelectedPlane.height < 1):
				SelectedPlane.transform.origin.x = 0
				SelectedPlane.transform.origin.y = plane_edit_distance.value
				SelectedPlane.transform.origin.z = 0
			elif (SelectedPlane.depth < 1):
				SelectedPlane.transform.origin.x = 0
				SelectedPlane.transform.origin.y = 0
				SelectedPlane.transform.origin.z = plane_edit_distance.value

func _on_Z_value_changed(value):
	match(SelectedObjectType):
		0:
			SelectedLight.transform.origin.z = light_edit_coord_z.value
		1:
			SelectedSphere.transform.origin.z = sphere_edit_coord_z.value
		2:
			SelectedCube.transform.origin.z = cube_edit_coord_z.value
		3:
			var material : SpatialMaterial = SelectedPlane.material
			material.uv2_offset.x = plane_edit_distance.value
			SelectedPlane.material = material
			if (SelectedPlane.width < 1):
				SelectedPlane.transform.origin.x = plane_edit_distance.value
				SelectedPlane.transform.origin.y = 0
				SelectedPlane.transform.origin.z = 0
			elif (SelectedPlane.height < 1):
				SelectedPlane.transform.origin.x = 0
				SelectedPlane.transform.origin.y = plane_edit_distance.value
				SelectedPlane.transform.origin.z = 0
			elif (SelectedPlane.depth < 1):
				SelectedPlane.transform.origin.x = 0
				SelectedPlane.transform.origin.y = 0
				SelectedPlane.transform.origin.z = plane_edit_distance.value

func _on_CheckBox_toggled(button_pressed):
	var material : SpatialMaterial
	match(SelectedObjectType):
		1:
			material = SelectedSphere.material
			material.normal_enabled = sphere_edit_is_reflective.pressed
			if sphere_edit_is_reflective.pressed:
				material.metallic = 0.8
			else:
				material.metallic = 0
			SelectedSphere.material = material
		2:
			material = SelectedCube.material
			material.normal_enabled = cube_edit_is_reflective.pressed
			if cube_edit_is_reflective.pressed:
				material.metallic = 0.8
			else:
				material.metallic = 0
			SelectedCube.material = material
		3:
			material = SelectedPlane.material
			material.normal_enabled = plane_edit_is_reflective.pressed
			if plane_edit_is_reflective.pressed:
				material.emission_enabled = false
				plane_edit_is_chess.pressed = false
			if plane_edit_is_reflective.pressed:
				material.metallic = 0.8
			else:
				material.metallic = 0
			SelectedPlane.material = material

func _on_DeleteB_pressed():
	delete_object_accept.popup()

func _on_EdgeLenghtEdit_value_changed(value):
	if SelectedObjectType == 2:
		#SelectedCube.width = cube_edit_width_lenght.value
		#SelectedCube.height = cube_edit_height_lenght.value
		#SelectedCube.depth = cube_edit_depth_lenght.value
		pass

func _on_DeleteObjectAccept_confirmed():
	match(SelectedObjectType):
		0:
			SelectedLight.free()
			SelectedLight = null
		1:
			SelectedSphere.free()
			SelectedSphere = null
		2:
			SelectedCube.free()
			SelectedCube = null
		3:
			SelectedPlane.free()
			SelectedPlane = null
	SelectedObjectType = -1
	objects_tree.clear()
	check_objects()

func _on_TextureButton_pressed():
	color_picker_window.visible = true
	shield.visible = true

func _on_ApplyB_pressed():
	match(SelectedObjectType):
		0:
			SelectedLight.light_color.r = color_picker.color.r
			SelectedLight.light_color.g = color_picker.color.g
			SelectedLight.light_color.b = color_picker.color.b
			light_edit_color.color.r = color_picker.color.r
			light_edit_color.color.g = color_picker.color.g
			light_edit_color.color.b = color_picker.color.b
			var light_sprite : Sprite3D = SelectedLight.get_child(0)
			light_sprite.modulate.r = color_picker.color.r
			light_sprite.modulate.g = color_picker.color.g
			light_sprite.modulate.b = color_picker.color.b
		1:
			var material : SpatialMaterial = SelectedSphere.material
			material.albedo_color.r = color_picker.color.r
			material.albedo_color.g = color_picker.color.g
			material.albedo_color.b = color_picker.color.b
			SelectedSphere.material = material
			sphere_edit_color.color.r = color_picker.color.r
			sphere_edit_color.color.g = color_picker.color.g
			sphere_edit_color.color.b = color_picker.color.b
		2:
			var material : SpatialMaterial = SelectedCube.material
			material.albedo_color.r = color_picker.color.r
			material.albedo_color.g = color_picker.color.g
			material.albedo_color.b = color_picker.color.b
			SelectedCube.material = material
			cube_edit_color.color.r = color_picker.color.r
			cube_edit_color.color.g = color_picker.color.g
			cube_edit_color.color.b = color_picker.color.b
		3:
			var material : SpatialMaterial = SelectedPlane.material
			material.albedo_color.r = color_picker.color.r
			material.albedo_color.g = color_picker.color.g
			material.albedo_color.b = color_picker.color.b
			SelectedPlane.material = material
			plane_edit_color.color.r = color_picker.color.r
			plane_edit_color.color.g = color_picker.color.g
			plane_edit_color.color.b = color_picker.color.b
		-1:
			var camera : Camera = get_parent()
			camera.environment.background_color.r = color_picker.color.r
			camera.environment.background_color.g = color_picker.color.g
			camera.environment.background_color.b = color_picker.color.b

func _on_CloseB_pressed():
	color_picker_window.visible = false
	shield.visible = false

func _on_CreateSphere_pressed():
	var new_sphere = sphere_prefab.instance()
	new_sphere.name = "Sphere" + str(spheresID)
	var material : SpatialMaterial = SpatialMaterial.new()
	new_sphere.material = material
	spheresID = spheresID + 1
	spheres.add_child(new_sphere)
	objects_tree.clear()
	check_objects()

func _on_CreateCube_pressed():
	var new_cube = cube_prefab.instance()
	new_cube.name = "Box" + str(cubesID)
	var material : SpatialMaterial = SpatialMaterial.new()
	new_cube.material = material
	cubesID = cubesID + 1
	cubes.add_child(new_cube)
	objects_tree.clear()
	check_objects()

func _on_CancelB_pressed():
	render_window.visible = false
	shield.visible = false

func _on_PathButton_pressed():
	save_path_dialog.popup()

func _on_RenderStartB_pressed():
	write_scene("to_render.rtscene")
	OS.execute("RayTrace.exe", [], false)

func write_scene(dir : String):
	var savePath = dir
	var Scene : File = File.new()
	Scene.open(savePath, File.WRITE)
	var content = ""
	var camera : Camera = get_parent()
	content += str(camera.environment.background_color.r) + " "
	content += str(camera.environment.background_color.g) + " "
	content += str(camera.environment.background_color.b) + "\n\n"
	content += str(camera.transform.origin.x) + " "
	content += str(camera.transform.origin.y) + " "
	content += str(camera.transform.origin.z) + "\n"
	content += str(camera.transform.basis.z.x) + " "
	content += str(camera.transform.basis.z.y) + " "
	content += str(camera.transform.basis.z.z) + "\n\n"
	content += str(WIDTH) + "\n"
	content += str(HEIGHT) + "\n"
	content += str(AA_LEVEL) + "\n"
	content += SAVE_PATH + "\n\n"
	content += str(spheres.get_child_count()) + "\n"
	for i in spheres.get_child_count():
		var Sphere : CSGSphere = spheres.get_child(i)
		content += str(Sphere.name) + "\n"
		content += str(Sphere.transform.origin.x) + " "
		content += str(Sphere.transform.origin.y) + " "
		content += str(Sphere.transform.origin.z) + " "
		content += str(Sphere.radius) + " "
		var material : SpatialMaterial = Sphere.material
		content += str(material.albedo_color.r) + " "
		content += str(material.albedo_color.g) + " "
		content += str(material.albedo_color.b) + " "
		if material.normal_enabled:
			content += "1\n"
		else:
			content += "0\n"
	content += "\n"
	content += str(cubes.get_child_count()) + "\n"
	for i in cubes.get_child_count():
		var Cube : CSGBox = cubes.get_child(i)
		content += str(Cube.name) + "\n"
		content += str(Cube.transform.origin.x) + " "
		content += str(Cube.transform.origin.y) + " "
		content += str(Cube.transform.origin.z) + " "
		content += str(Cube.width) + " "
		content += str(Cube.height) + " "
		content += str(Cube.depth) + " "
		var material : SpatialMaterial = Cube.material
		content += str(material.albedo_color.r) + " "
		content += str(material.albedo_color.g) + " "
		content += str(material.albedo_color.b) + " "
		if material.normal_enabled:
			content += "1\n"
		else:
			content += "0\n"
	content += "\n"
	content += str(light_sources.get_child_count()) + "\n"
	for i in light_sources.get_child_count():
		var Light_source : OmniLight = light_sources.get_child(i)
		content += str(Light_source.name) + "\n"
		content += str(Light_source.transform.origin.x) + " "
		content += str(Light_source.transform.origin.y) + " "
		content += str(Light_source.transform.origin.z) + " "
		content += str(Light_source.light_color.r) + " "
		content += str(Light_source.light_color.g) + " "
		content += str(Light_source.light_color.b) + "\n"
	content += "\n"
	content += str(planes.get_child_count()) + "\n"
	for i in planes.get_child_count():
		var plane : CSGBox = planes.get_child(i)
		content += str(plane.name) + "\n"
		if plane.width < 1:
			content += "X "
		elif plane.height < 1:
			content += "Y "
		elif plane.depth < 1:
			content += "Z "
		var material : SpatialMaterial = plane.material
		content += str(material.uv2_offset.x) + " "
		content += str(material.albedo_color.r) + " "
		content += str(material.albedo_color.g) + " "
		content += str(material.albedo_color.b) + " "
		if (material.normal_enabled):
			content += "1\n"
		elif (material.emission_enabled):
			content += "2\n"
		else:
			content += "0\n"
	Scene.store_string(content)
	Scene.close()

func load_scene(dir : String):
	var loadPath = dir
	var Scene = File.new()
	Scene.open(loadPath, File.READ)
	var clear_clr = Scene.get_line().split(" ", false)
	var camera : Camera = get_parent()
	camera.environment.background_color.r = float(clear_clr[0])
	camera.environment.background_color.g = float(clear_clr[1])
	camera.environment.background_color.b = float(clear_clr[2])
	Scene.get_line()
	Scene.get_line()
	Scene.get_line()
	Scene.get_line()
	WIDTH = int(Scene.get_line())
	HEIGHT = int(Scene.get_line())
	AA_LEVEL = int(Scene.get_line())
	SAVE_PATH = Scene.get_line()
	Scene.get_line()
	var spheres_count = int(Scene.get_line())
	for i in range(spheres_count):
		var new_sphere : CSGSphere = sphere_prefab.instance()
		new_sphere.name = Scene.get_line()
		var material : SpatialMaterial = SpatialMaterial.new()
		var properties = Scene.get_line().split(" ", false)
		new_sphere.transform.origin.x = float(properties[0])
		new_sphere.transform.origin.y = float(properties[1])
		new_sphere.transform.origin.z = float(properties[2])
		new_sphere.radius = float(properties[3])
		material.albedo_color.r = float(properties[4])
		material.albedo_color.g = float(properties[5])
		material.albedo_color.b = float(properties[6])
		if properties[7] == "1":
			material.normal_enabled = true
		else:
			material.normal_enabled = false
		new_sphere.material = material
		spheresID = spheresID + 1
		spheres.add_child(new_sphere)
	Scene.get_line()
	var cubes_count = int(Scene.get_line())
	for i in range(cubes_count):
		var new_cube : CSGBox = cube_prefab.instance()
		new_cube.name = Scene.get_line()
		var material : SpatialMaterial = SpatialMaterial.new()
		var properties = Scene.get_line().split(" ", false)
		new_cube.transform.origin.x = float(properties[0])
		new_cube.transform.origin.y = float(properties[1])
		new_cube.transform.origin.z = float(properties[2])
		new_cube.width = float(properties[3])
		new_cube.height = float(properties[4])
		new_cube.depth = float(properties[5])
		material.albedo_color.r = float(properties[6])
		material.albedo_color.g = float(properties[7])
		material.albedo_color.b = float(properties[8])
		if properties[9] == "1":
			material.normal_enabled = true
		else:
			material.normal_enabled = false
		new_cube.material = material
		cubesID = cubesID + 1
		cubes.add_child(new_cube)
	Scene.get_line()
	var light_sources_count = int(Scene.get_line())
	for i in range(light_sources_count):
		var new_light : OmniLight = light_prefab.instance()
		new_light.name = Scene.get_line()
		var properties = Scene.get_line().split(" ", false)
		new_light.transform.origin.x = float(properties[0])
		new_light.transform.origin.y = float(properties[1])
		new_light.transform.origin.z = float(properties[2])
		new_light.light_color.r = float(properties[3])
		new_light.light_color.g = float(properties[4])
		new_light.light_color.b = float(properties[5])
		lightsID = lightsID + 1
		light_sources.add_child(new_light)
	Scene.get_line()
	var planes_count = int(Scene.get_line())
	for i in range(planes_count):
		var new_plane : CSGBox = cube_prefab.instance()
		new_plane.name = Scene.get_line()
		var material : SpatialMaterial = SpatialMaterial.new()
		var properties = Scene.get_line().split(" ", false)
		material.uv2_offset.x = float(properties[1])
		match (properties[0]):
			"X":
				new_plane.width = 0.01
				new_plane.height = 10000
				new_plane.depth = 10000
				new_plane.transform.origin.x = material.uv2_offset.x
			"Y":
				new_plane.width = 10000
				new_plane.height = 0.01
				new_plane.depth = 10000
				new_plane.transform.origin.y = material.uv2_offset.x
			"Z":
				new_plane.width = 10000
				new_plane.height = 10000
				new_plane.depth = 0.01
				new_plane.transform.origin.z = material.uv2_offset.x
		material.albedo_color.r = float(properties[2])
		material.albedo_color.g = float(properties[3])
		material.albedo_color.b = float(properties[4])
		if properties[5] == "1":
			material.normal_enabled = true
			material.emission_enabled = false
		elif properties[5] == "2":
			material.normal_enabled = false
			material.emission_enabled = true
		else:
			material.normal_enabled = false
			material.emission_enabled = false
		new_plane.material = material
		planesID = planesID + 1
		planes.add_child(new_plane)
	objects_tree.clear()
	check_objects()
	Scene.close()

func _on_SaveSceneDialog_file_selected(path):
	write_scene(path)

func _on_LoadSceneDialog_file_selected(path):
	_on_CreateSceneAccept_confirmed()
	load_scene(path)

func _on_CameraViewport_gui_input(event):
	pass # Replace with function body.

func _on_AxisList_item_selected(index):
	var material : SpatialMaterial = SelectedPlane.material
	match (index):
		0:
			SelectedPlane.width = 0.01
			SelectedPlane.height = 10000
			SelectedPlane.depth = 10000
			SelectedPlane.transform.origin = Vector3.ZERO
			SelectedPlane.transform.origin.x = material.uv2_offset.x
		1:
			SelectedPlane.width = 10000
			SelectedPlane.height = 0.01
			SelectedPlane.depth = 10000
			SelectedPlane.transform.origin = Vector3.ZERO
			SelectedPlane.transform.origin.y = material.uv2_offset.x
		2:
			SelectedPlane.width = 10000
			SelectedPlane.height = 10000
			SelectedPlane.depth = 0.01
			SelectedPlane.transform.origin = Vector3.ZERO
			SelectedPlane.transform.origin.z = material.uv2_offset.x

func _on_SavePictureDialog_file_selected(path):
	SAVE_PATH = path
	render_window_path.text = path

func _on_WSpinBox_value_changed(value):
	WIDTH = value

func _on_HSpinBox_value_changed(value):
	HEIGHT = value

func _on_AASpinBox_value_changed(value):
	AA_LEVEL = value

func _on_CCheckBox_toggled(button_pressed):
	var material : SpatialMaterial = SelectedPlane.material
	material.emission_enabled = plane_edit_is_chess.pressed
	if plane_edit_is_chess.pressed:
		material.normal_enabled = false
		plane_edit_is_reflective.pressed = false
	SelectedPlane.material = material

func _on_WidthLenghtEdit_value_changed(value):
	SelectedCube.width = cube_edit_width_lenght.value

func _on_HeightLenghtEdit_value_changed(value):
	SelectedCube.height = cube_edit_height_lenght.value

func _on_DepthLenghtEdit_value_changed(value):
	SelectedCube.depth = cube_edit_depth_lenght.value
