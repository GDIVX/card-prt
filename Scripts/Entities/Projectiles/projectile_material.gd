class_name ProjectileMaterial extends Resource

@export var speed_curve: Curve

@export_range(0,360) var spread : float ##The range of randomness to the rotation in degrees. 
@export var spread_curve : Curve