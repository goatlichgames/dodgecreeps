extends Node


@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	# new instance of MobScene
	var mob = mob_scene.instantiate()
	
	#choose starting location on MobPath
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set mob path perpendicular to path
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set mob to start position
	mob.position = mob_spawn_location.position
	
	# random direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#mob velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn mob
	add_child(mob)
