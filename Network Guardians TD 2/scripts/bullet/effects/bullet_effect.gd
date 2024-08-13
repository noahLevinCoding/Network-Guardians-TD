class_name BulletEffect
extends Node

enum EFFECT_TYPE {EXPLOSION, CHAINING}

var bullet_effect_resource : BulletEffectResource

func _init(bullet_effect_resource : BulletEffectResource):
	self.bullet_effect_resource = bullet_effect_resource.duplicate()
	
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
		

func init_explosion_effect(bullet : Bullet):
	bullet.effect_col_shape.shape.radius = bullet_effect_resource.radius

func init_chaining_effect(bullet : Bullet):
	bullet.effect_col_shape.shape.radius = bullet_effect_resource.radius
	bullet_effect_resource.line = Line2D.new()
	bullet_effect_resource.line.width = 4
	bullet_effect_resource.line.default_color = Color(1,0,0,1)
	bullet_effect_resource.line.z_index = 3
	

func apply_explosion_effect(bullet : Bullet, enemy : Enemy):
	var polygon = Polygon2D.new()
	
	var radius = bullet_effect_resource.radius
	var segments = 64
	var points = []
		
	for i in range(segments):
		var angle = 2 * PI * i / segments
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
			
	polygon.polygon = points
	polygon.color = Color(0,0,0,0.2)
	
	
	enemy.get_parent().add_child(polygon)
	polygon.global_position = bullet.global_position
	polygon.visible = true
		
	for area_in_range in bullet.effect_area.get_overlapping_areas():
		if area_in_range.owner is Enemy:
			area_in_range.owner.take_damage(duplicate_bullet_resource(bullet.bullet_resource))
		
	await enemy.get_tree().create_timer(0.1).timeout
	
	polygon.queue_free()
		
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
	
	if bullet_effect_resource.enemies_visited.size() >= bullet_effect_resource.number_of_targets:
		return
	
	
	var closest_enemy = null
	var closest_enemy_distance : float = bullet_effect_resource.radius + 1
	
	for area_in_range in bullet.effect_area.get_overlapping_areas():
		if area_in_range.owner is Enemy and not area_in_range.owner in bullet_effect_resource.enemies_visited:
			var distance_to_enemy = enemy.progress  - area_in_range.owner.progress
			if distance_to_enemy >= 0  and distance_to_enemy < closest_enemy_distance:
				closest_enemy_distance = distance_to_enemy
				closest_enemy = area_in_range.owner
	
	
	
	if closest_enemy != null:
		
		bullet.bullet_resource.target = closest_enemy
		
		#bullet_effect_resource.line.add_point(enemy.global_position)
		#bullet_effect_resource.line.add_point(closest_enemy.global_position)
		
		
	else:
		pass
		#enemy.get_parent().add_child(bullet_effect_resource.line)

