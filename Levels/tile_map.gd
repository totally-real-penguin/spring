extends TileMapLayer

@export var level: Level

@export var character_scene: PackedScene
@export var box_scene: PackedScene
@export var flag_scene: PackedScene
@export var ladder_top_scene: PackedScene
@export var door_scene: PackedScene
@export var bouncer_scene: PackedScene
@export var ladder_scene: PackedScene
@export var key_scene: PackedScene
@export var recharge_jump_crystal_scene: PackedScene
@export var bubble_scene: PackedScene
@export var pink_switch_block_scene: PackedScene
@export var blue_switch_block_scene: PackedScene
@export var one_way_scene: PackedScene


func _ready() -> void:
	for block in self.get_used_cells_by_id(2):
		var selected_block: Node2D
		match self.get_cell_atlas_coords(block):
			Vector2i(0,0):  selected_block = character_scene.instantiate()
			
			Vector2i(6,1):  selected_block = flag_scene.instantiate()
			
			Vector2i(0,2):  selected_block = box_scene.instantiate()
			
			Vector2i(7,2):  selected_block = bouncer_scene.instantiate()
			
			Vector2i(10,1): selected_block = ladder_scene.instantiate()
			Vector2i(10,0): selected_block = ladder_top_scene.instantiate()
			
			Vector2i(11,0): selected_block = door_scene.instantiate()
			Vector2i(11,1): selected_block = key_scene.instantiate()
			
			Vector2i(0,7):  selected_block = recharge_jump_crystal_scene.instantiate()
			
			Vector2i(8,2):  selected_block = bubble_scene.instantiate()
			
			Vector2i(0,8):  selected_block = pink_switch_block_scene.instantiate()
			Vector2i(0,9):  selected_block = blue_switch_block_scene.instantiate()
			
			Vector2i(10,7): 
				selected_block = one_way_scene.instantiate()
			Vector2i(11,7):
				selected_block = one_way_scene.instantiate()
				selected_block.get_node("Sprite").rotation = TAU * 0.75
				selected_block.get_node("Collision").rotation = TAU * 0.75
			Vector2i(10,8):
				selected_block = one_way_scene.instantiate()
				selected_block.get_node("Sprite").rotation = PI / 2
				selected_block.get_node("Collision").rotation = PI / 2
			Vector2i(11,8):
				selected_block = one_way_scene.instantiate()
				selected_block.get_node("Sprite").rotation = PI
				selected_block.get_node("Collision").rotation = PI
			_: pass
		if selected_block != null:
			selected_block.position = (block * 16)
			if level != null:
				selected_block.level = level
				level.add_child.call_deferred(selected_block)
			else:
				self.add_child.call_deferred(selected_block)
			erase_cell(block)
