class_name BulletEffect
extends Node

enum EFFECT_TYPE {EXPLOSION, CHAINING}

var bullet_effect_resource : BulletEffectResource

func _init(bullet_effect_resource : BulletEffectResource):
	self.bullet_effect_resource = bullet_effect_resource.duplicate()
	
func apply_effect(bullet : Bullet, enemy : Enemy):
	match bullet_effect_resource.effect_type:
		EFFECT_TYPE.CHAINING:
			apply_chaining_effect(enemy)
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
	pass
	

func apply_explosion_effect(bullet : Bullet, enemy : Enemy):
	
	for enemy_in_range in bullet.enemies_in_range:
		enemy_in_range.take_damage(duplicate_bullet_resource(bullet.bullet_resource))
		
func duplicate_bullet_resource(bullet_resource : BulletResource):
	var new_bullet_resource = BulletResource.new()
	
	new_bullet_resource.attack_damage = bullet_resource.attack_damage
	new_bullet_resource.pierce = bullet_resource.pierce
	new_bullet_resource.source_tower = bullet_resource.source_tower
	new_bullet_resource.effects = bullet_resource.effects	#maybe remove
	new_bullet_resource.damage_type = bullet_resource.damage_type
	new_bullet_resource.ignores_damage_type_immunity = bullet_resource.ignores_damage_type_immunity
	
	return new_bullet_resource


func apply_chaining_effect(enemy : Enemy):
	call_deferred("deferred_apply_chaining_effect", enemy)
	
	
func deferred_apply_chaining_effect(enemy: Enemy):
	bullet_effect_resource.enemies_visited.append(enemy)
	
	#var area = Area2D.new()
	#var col_shape = CollisionShape2D.new()
	#var circle_shape = CircleShape2D.new()
	#
	#circle_shape.radius = bullet_effect_resource.radius
	#col_shape.shape = circle_shape
	#area.add_child(col_shape)
	#
	#enemy.get_parent().add_child(area)
	#area.global_position = enemy.global_position
	#bullet_effect_resource.area = area
	#bullet_effect_resource.enemy = enemy
	#
	#col_shape.disabled = true
	#col_shape.disabled = false
	#print(area.get_overlapping_areas())
	


