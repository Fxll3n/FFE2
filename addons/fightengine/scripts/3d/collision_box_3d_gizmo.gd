## Helper script to create a gizmo since 3D won't show them by default.
## Atleast the docs were easy to follow.
@tool
extends EditorNode3DGizmoPlugin

const HIT_BOX_COLOR := Color(1.0, 0.606, 0.552, 0.22)
const HURT_BOX_COLOR := Color(0.0, 0.881, 0.127, 0.22)


func _init() -> void:
	add_material("hit_box", _create_material(HIT_BOX_COLOR))
	add_material("hurt_box", _create_material(HURT_BOX_COLOR))


func _create_material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	return material


func _has_gizmo(for_node_3d: Node3D) -> bool:
	return for_node_3d is CollisionBox3D


func _get_gizmo_name() -> String:
	return "CollisionBox3D"

# Not sure how often this redraws, might get laggy on populated scenes
func _redraw(gizmo: EditorNode3DGizmo) -> void:
	gizmo.clear()
	
	var box := gizmo.get_node_3d() as CollisionBox3D
	if box == null or box.shape == null:
		return
	
	var mesh := box.shape.get_debug_mesh()
	if mesh == null:
		return
	
	var material_name := "collision_shape"
	
	if box is HitBox3D:
		material_name = "hit_box"
	elif box is HurtBox3D:
		material_name = "hurt_box"
	
	var shape_transform := Transform3D.IDENTITY
	
	if is_instance_valid(box.collider):
		shape_transform = box.global_transform.affine_inverse() * box.collider.global_transform

	gizmo.add_mesh(mesh, get_material(material_name, gizmo), shape_transform)
