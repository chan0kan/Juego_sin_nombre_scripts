extends Node

@onready var player : Player = self.owner
@onready var timer_combo_refresh = $"Timer"

enum STATE{
	IDLE,
	RIGHT,
	LEFT,
	UP,
	DOWN,
	P,
	DEFENSE,
	DOWN_DEFENSE,
	HITTED
}

var combinations : Dictionary = {

	"P":[STATE.P],
	"low_P":[STATE.DOWN, STATE.P]

}

var comnbinations_machine : Array = []

func _on_player_control_add_current_state(current_state):
	
	comnbinations_machine.append(current_state)
			
	check_combination()
	timer_combo_refresh.start()
	print(comnbinations_machine)
	
func _on_timer_timeout():
	
	clear_current_combination()
		
func clear_current_combination():

	if comnbinations_machine.size() > 0:
		comnbinations_machine.clear()
		print("combination cleared")

func check_combination():

	if comnbinations_machine.size() > 0:

		for combination in combinations.values():
			if comnbinations_machine == combination:
				#player.anim_player.play()
				print(combinations.find_key("P"))
				print("combo accedido")
				print(combination)
	
	player_dash()

func player_dash():

	if comnbinations_machine == [STATE.RIGHT, STATE.RIGHT]:
		player.player_controls.current_state = 
		player.anim_player.play("dash")
		comnbinations_machine.clear()
		player.velocity.x += 200

	elif comnbinations_machine == [STATE.LEFT, STATE.LEFT]:
		player.anim_player.play("dash")
		comnbinations_machine.clear()
		player.velocity.x -= 200
