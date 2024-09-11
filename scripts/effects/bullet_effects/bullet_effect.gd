class_name BulletEffect
extends Node

enum EFFECT_TYPE {EXPLOSION, CHAINING}

var bullet_effect_resource : BulletEffectResource

func _init(_bullet_effect_resource : BulletEffectResource):
	self.bullet_effect_resource = _bullet_effect_resource.duplicate()
	
func apply_effect(bullet : Bullet, enemy : Enemy):
	match bullet_effect_resource.effect_type:
		EFFECT_TYPE.CHAINING:
			apply_chaining_effect(bullet, enemy)
		EFFECT_TYPE.EXPLOSION:
			apply_explosion_effect(bullet, enemy)
	
func init_effect(bullet : Bullet):
	match bullet_effect_resource.effect_type:
		EFFECT_TYPE.CHAINING:
			init_chaining_effect(bullet)
		EFFECT_TYPE.EXPLOSION:
			init_explosion_effect(bullet)
		
func end_effect(bullet : Bullet):
	match bullet_effect_resource.effect_type:
		EFFECT_TYPE.CHAINING:
			end_chaining_effect(bullet)
		EFFECT_TYPE.EXPLOSION:
			end_explosion_effect(bullet)

func end_chaining_effect(_bullet : Bullet):
	bullet_effect_resource.line_1.queue_free()
	bullet_effect_resource.line_2.queue_free()
	bullet_effect_resource.line_3.queue_free()
	bullet_effect_resource.line_4.queue_free()
	bullet_effect_resource.line_5.queue_free()
	bullet_effect_resource.line_6.queue_free()
	
func end_explosion_effect(_bullet : Bullet):
	bullet_effect_resource.polygon.queue_free()
	bullet_effect_resource.color_rect.queue_free()

func init_explosion_effect(bullet : Bullet):
	bullet.effect_col_shape.shape.radius = bullet_effect_resource.radius
	bullet_effect_resource.polygon = Polygon2D.new()
	bullet_effect_resource.color_rect = ColorRect.new()

func init_chaining_effect(bullet : Bullet):
	bullet.effect_col_shape.shape.radius = bullet_effect_resource.radius
	bullet_effect_resource.line_1 = Line2D.new()
	bullet_effect_resource.line_1.width = 6
	bullet_effect_resource.line_1.default_color = Color(57.0/256, 170.0/256, 225.0/256, 1)
	bullet_effect_resource.line_1.z_index = 3
	bullet.get_tree().get_root().add_child(bullet_effect_resource.line_1)
	
	bullet_effect_resource.line_2 = Line2D.new()
	bullet_effect_resource.line_2.width = 2
	bullet_effect_resource.line_2.default_color = Color(1,1,1,1)
	bullet_effect_resource.line_2.z_index = 4
	bullet.get_tree().get_root().add_child(bullet_effect_resource.line_2)
	
	bullet_effect_resource.line_3 = Line2D.new()
	bullet_effect_resource.line_3.width = 6
	bullet_effect_resource.line_3.default_color = Color(32.0/256, 74.0/256, 153.0/256, 1)
	bullet_effect_resource.line_3.z_index = 3
	bullet.get_tree().get_root().add_child(bullet_effect_resource.line_3)
	
	bullet_effect_resource.line_4 = Line2D.new()
	bullet_effect_resource.line_4.width = 2
	bullet_effect_resource.line_4.default_color = Color(1,1,1,1)
	bullet_effect_resource.line_4.z_index = 4
	bullet.get_tree().get_root().add_child(bullet_effect_resource.line_4)
	
	bullet_effect_resource.line_5 = Line2D.new()
	bullet_effect_resource.line_5.width = 6
	bullet_effect_resource.line_5.default_color = Color(0,0,0,1)
	bullet_effect_resource.line_5.z_index = 3
	bullet.get_tree().get_root().add_child(bullet_effect_resource.line_5)
	
	bullet_effect_resource.line_6 = Line2D.new()
	bullet_effect_resource.line_6.width = 2
	bullet_effect_resource.line_6.default_color = Color(1,1,1,1)
	bullet_effect_resource.line_6.z_index = 4
	bullet.get_tree().get_root().add_child(bullet_effect_resource.line_6)
	

func apply_explosion_effect(bullet : Bullet, enemy : Enemy):
	var polygon = bullet_effect_resource.polygon
	
	var radius = bullet_effect_resource.radius
	var segments = 64
	var points : Array = []
	var polygons : Array = []
	var uv : Array = []
	var vertex_colors : PackedColorArray = PackedColorArray()
	#var colors : PackedColorArray = PackedColorArray()
		
	#points.append(Vector2(-100, -50))
	#points.append(Vector2(100, -50))
	#points.append(Vector2(100, 50))
	#points.append(Vector2(-100, 50))
	#
	#polygons.append([])
	#polygons.back().append(0)
	#polygons.back().append(1)
	#polygons.back().append(2)
	#
	#polygons.append([])
	#polygons.back().append(0)
	#polygons.back().append(2)
	#polygons.back().append(3)
	#
	#uv.append(Vector2(0,0))
	#uv.append(Vector2(1,0))
	#uv.append(Vector2(1,1))
	#uv.append(Vector2(0,1))
		
	#points.append(Vector2(0.0,0.0))
	#uv.append(Vector2(0.5,0.5))
	#vertex_colors.append(Color(0.0, 0.0, 0.0, 1.0))
	#polygon.color = Color(1.0, 1.0, 1.0, 1.0)
	
		
	#uzh  

			
	#polygon.material = ShaderMaterial.new()
	#polygon.material.shader = preload("res://shader/bullet_explosion.gdshader")
	
	#polygon.texture = preload("res://assets/shader/circle.png")
	#polygon.texture_repeat = 2
	#polygon.texture_scale = Vector2(radius/100.0, radius/100.0)
	var color_rect = bullet_effect_resource.color_rect	
	color_rect.material = ShaderMaterial.new()
	color_rect.material.shader = preload("res://shader/bullet_explosion.gdshader")
	color_rect.material.set_shader_parameter("radius", bullet_effect_resource.radius)
	color_rect.material.set_shader_parameter("position", bullet.global_position)
	
	enemy.get_parent().add_child(color_rect)
	color_rect.size = Vector2(1920, 1080)
	color_rect.global_position = Vector2(0,0)
	color_rect.visible = true
	
	
	enemy.get_parent().add_child(polygon)
	polygon.global_position = bullet.global_position
	polygon.visible = true
		
	for area_in_range in bullet.effect_area.get_overlapping_areas():
		if area_in_range.owner is Enemy and area_in_range.owner != enemy:
			area_in_range.owner.take_damage(duplicate_bullet_resource(bullet.bullet_resource))
		
	await enemy.get_tree().create_timer(0.2).timeout
	
	polygon.queue_free()
	color_rect.queue_free()
		
#Godot 4.2.1 still has bugs at duplicating nested resources
func duplicate_bullet_resource(bullet_resource : BulletResource):
	
	var new_bullet_resource = BulletResource.new()
	
	new_bullet_resource.attack_damage = bullet_resource.attack_damage
	new_bullet_resource.pierce = bullet_resource.pierce
	new_bullet_resource.source_tower = bullet_resource.source_tower
	new_bullet_resource.effects = bullet_resource.effects	#maybe remove
	new_bullet_resource.bullet_effect = bullet_resource.bullet_effect
	new_bullet_resource.damage_type = bullet_resource.damage_type
	new_bullet_resource.ignores_damage_type_immunity = bullet_resource.ignores_damage_type_immunity
	
	return new_bullet_resource


func apply_chaining_effect(bullet : Bullet, enemy : Enemy):
	bullet_effect_resource.enemies_visited.append(enemy)
	var offset = vec_randf_range(-30, 30)
	
	#first target without lightning offset
	if bullet_effect_resource.enemies_visited.size() == 1:
		offset = vec_randf_range(-2, 2)
	
		bullet_effect_resource.line_1.add_point(enemy.global_position + offset)
		bullet_effect_resource.line_2.add_point(enemy.global_position + offset)
		
	else:
		var last_position : Vector2  = bullet_effect_resource.line_1.get_point_position(bullet_effect_resource.line_1.get_point_count()-1)
		var new_position : Vector2 = enemy.global_position
		
		var middle_position = last_position.lerp(new_position, 0.5)
		
		bullet_effect_resource.line_1.add_point(middle_position + offset)
		bullet_effect_resource.line_2.add_point(middle_position + offset)
		
		bullet_effect_resource.line_1.add_point(new_position)
		bullet_effect_resource.line_2.add_point(new_position)
	
	
	offset = vec_randf_range(-30, 30)
	
	if bullet_effect_resource.enemies_visited.size() == 1:
		offset = vec_randf_range(-2, 2)
	
		bullet_effect_resource.line_3.add_point(enemy.global_position + offset)
		bullet_effect_resource.line_4.add_point(enemy.global_position + offset)
		
	else:
		var last_position : Vector2  = bullet_effect_resource.line_3.get_point_position(bullet_effect_resource.line_3.get_point_count()-1)
		var new_position : Vector2 = enemy.global_position
		
		var middle_position = last_position.lerp(new_position, 0.5)
		
		bullet_effect_resource.line_3.add_point(middle_position + offset)
		bullet_effect_resource.line_4.add_point(middle_position + offset)
		
		bullet_effect_resource.line_3.add_point(new_position)
		bullet_effect_resource.line_4.add_point(new_position)
	
	offset = vec_randf_range(-30, 30)
	
	if bullet_effect_resource.enemies_visited.size() == 1:
		offset = vec_randf_range(-2, 2)
	
		bullet_effect_resource.line_5.add_point(enemy.global_position + offset)
		bullet_effect_resource.line_6.add_point(enemy.global_position + offset)
		
	else:
		var last_position : Vector2  = bullet_effect_resource.line_5.get_point_position(bullet_effect_resource.line_5.get_point_count()-1)
		var new_position : Vector2 = enemy.global_position
		
		var middle_position = last_position.lerp(new_position, 0.5)
		
		bullet_effect_resource.line_5.add_point(middle_position + offset)
		bullet_effect_resource.line_6.add_point(middle_position + offset)
		
		bullet_effect_resource.line_5.add_point(new_position)
		bullet_effect_resource.line_6.add_point(new_position)
	
	#when max targets reached
	if bullet_effect_resource.enemies_visited.size() >= bullet_effect_resource.number_of_targets:
		await enemy.get_tree().create_timer(0.05).timeout
		bullet_effect_resource.line_1.queue_free()
		bullet_effect_resource.line_2.queue_free()
		bullet_effect_resource.line_3.queue_free()
		bullet_effect_resource.line_4.queue_free()
		bullet_effect_resource.line_5.queue_free()
		bullet_effect_resource.line_6.queue_free()
		
		return
	
	
	var closest_enemy = null
	var closest_enemy_distance : float = bullet_effect_resource.radius + 1
	
	#just jump to enemies, which are behind and have not been visited yet
	for area_in_range in bullet.effect_area.get_overlapping_areas():
		if area_in_range.owner is Enemy and not area_in_range.owner in bullet_effect_resource.enemies_visited:
			var distance_to_enemy = enemy.progress  - area_in_range.owner.progress
			if distance_to_enemy >= 0  and distance_to_enemy < closest_enemy_distance:
				closest_enemy_distance = distance_to_enemy
				closest_enemy = area_in_range.owner
	
	
	
	if closest_enemy != null:
		
		bullet.bullet_resource.target = closest_enemy	
		
	else:
		await enemy.get_tree().create_timer(0.05).timeout
		bullet_effect_resource.line_1.queue_free()
		bullet_effect_resource.line_2.queue_free()
		bullet_effect_resource.line_3.queue_free()
		bullet_effect_resource.line_4.queue_free()
		bullet_effect_resource.line_5.queue_free()
		bullet_effect_resource.line_6.queue_free()

func vec_randf_range(min_val: float, max_val: float) -> Vector2:
	
	var rand_x = randf() * (max_val - min_val) + min_val
	var rand_y = randf() * (max_val - min_val) + min_val
	
	return Vector2(rand_x, rand_y)
