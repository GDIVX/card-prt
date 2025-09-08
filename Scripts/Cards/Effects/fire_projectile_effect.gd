class_name FireProjectileEffect extends CardEffect

@export var projectile_scene : PackedScene
@export var damage : Damage
@export var projectile_material : ProjectileMaterial
## Knockback force magnitude
@export var knockback : float
@export_flags_2d_physics var collision_mask : int

func apply(card: Card, targets: Array) -> void:
	print(targets)
	for target in targets:
		var emitter := card.context.unit.projectile_emitter
		var projectile :Projectile = projectile_scene.instantiate()

		projectile.projectile_material = projectile_material

		if projectile.has_node("HitBox"):
			var hit_box : HitBox = projectile.get_node("HitBox")
			hit_box.damage = damage
			hit_box.collision_mask = collision_mask

			hit_box.connect("area_entered" , func (hurt_box : HurtBox) :
				var owner : Node2D = hurt_box.owner
				handle_knockback(owner , projectile)
				)


		var to :Vector2 = target.global_position
		emitter.fire(projectile , to)


func handle_knockback(target : Node2D, from : Node2D) -> void:
	if target == null : return
	if knockback <= 0: return
	if not target.has_node("KnockbackReceiver"): return

	var receiver : KnockbackReceiver = target.get_node("KnockbackReceiver")

	var direction = from.global_position.direction_to(target.global_position)
	var force = direction * knockback
	receiver.force = force



func describe(_context: CardContext) -> DescriptionSpec:
	var spec := DescriptionSpec.new()
	spec.add(DescriptionSpec.text("Deal "))
	spec.add(DescriptionSpec.param("damage", func(_ctx): return damage.damage_value))
	var type_text := ""
	match damage.damage_type:
		Damage.DamageType.NORMAL:
			type_text = ""
		Damage.DamageType.PIERCE:
			type_text = " piercing"
		Damage.DamageType.SUNDER:
			type_text = " sundering"
		Damage.DamageType.BLUNT:
			type_text = " blunt"
		Damage.DamageType.SLASH:
			type_text = " slashing"
		_:
			type_text = ""
	if type_text != "":
		spec.add(DescriptionSpec.text(type_text))
	spec.add(DescriptionSpec.text(" damage"))
	if knockback > 0.0:
		spec.add(DescriptionSpec.text(" and apply knockback"))
	spec.add(DescriptionSpec.text("."))
	return spec
