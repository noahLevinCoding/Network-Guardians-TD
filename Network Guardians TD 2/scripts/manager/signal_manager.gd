extends Node

signal start_next_wave
signal on_start_next_wave
signal on_wave_finished
signal defeat
signal pause_game
signal init_game
signal reset_game

signal select_attack_tower_on_board(tower : Tower)
signal select_resource_tower_on_board(tower : Tower)
signal select_support_tower_on_board(tower : Tower)
signal deselect_tower_on_board
signal select_cooler
signal select_power_supply

signal health_changed(health : int)
signal money_changed(money : int)
signal temperature_changed(temperature : float)
signal power_changed(power : int)
signal max_power_changed(max_power : int)
signal selected_tower_damage_dealt_changed
signal selected_tower_money_generated_changed

signal wave_index_changed(wave_index : int)

