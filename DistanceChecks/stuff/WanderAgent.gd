extends KinematicBody


var move_speed = 3
var move_vec : Vector3

enum DIST_CHECK_TYPES {BASIC, AREA_PROCESS, AREA_SIGNAL, HASH_TABLE}
export(DIST_CHECK_TYPES) var dist_check_type

var dist_check_radius = 4


func _ready():
	$BasicDistanceCheck.dist_in_range = dist_check_radius
	$AreaDistanceCheck/CollisionShape.shape.radius = dist_check_radius
	$HashTableDistanceCheck.dist_check_radius = dist_check_radius
	
	if dist_check_type == DIST_CHECK_TYPES.BASIC:
		remove_child($HashTableDistanceCheck)
		remove_child($AreaDistanceCheck)
	elif dist_check_type == DIST_CHECK_TYPES.AREA_PROCESS:
		remove_child($HashTableDistanceCheck)
		$BasicDistanceCheck.disable()
		$AreaDistanceCheck.use_signals = false
	elif dist_check_type == DIST_CHECK_TYPES.AREA_SIGNAL:
		$BasicDistanceCheck.disable()
		remove_child($HashTableDistanceCheck)
		$AreaDistanceCheck.use_signals = true
	else:
		remove_child($AreaDistanceCheck)
		$BasicDistanceCheck.disable()
	
	move_vec = Vector3.RIGHT.rotated(Vector3.UP, rand_range(0.0, TAU))
	move_vec.y = 0

func _physics_process(delta):
	var coll = move_and_collide(move_speed * delta * move_vec)
	if coll:
		var d = move_vec
		var n = coll.normal
		var r = d - 2 * d.dot(n) * n
		move_vec = r
		move_vec.y = 0
