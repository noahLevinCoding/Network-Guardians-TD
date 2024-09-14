extends Node

#Game
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

signal request_wave_is_active
signal response_wave_is_active(wave_is_active : bool)

#UI
signal health_changed(health : int)
signal money_changed(money : float)
signal temperature_changed(temperature : float)
signal power_changed(power : int)
signal max_power_changed(max_power : int)
signal selected_tower_damage_dealt_changed
signal selected_tower_money_generated_changed
signal wave_index_changed(wave_index : int)

signal wiki_shop_button
signal wiki_tower_button(wiki_tower_index : int)
signal wiki_mechanics_button() 

signal enter_wiki
signal enter_wiki_tower(wiki_tower_index : int)
signal enter_wiki_mechanics


#Save and load
signal load_wave_index(wave_index : int)

#Audio
signal on_button_hover
signal on_button_click
signal on_button_dip_click
signal on_button_wave_start_click
signal on_enemy_take_damage
signal on_select_shop
signal on_deselect_shop
signal on_select_prio_type
signal on_open_prio_type
signal on_upgrade_button_click
signal on_tower_sell
signal on_volume_slider_changed
signal on_shop_hover








