class_name MultiplayerMap

extends Node3D


@export var player_scene : PackedScene
@export var PLAYERS: Node

var enet_peer = ENetMultiplayerPeer.new()
const PORT: int = 9999

func startHost():
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	PLAYERS.add_child(player)
	if player.is_multiplayer_authority():
		player.playerColorChanged.connect(changePlayerColors)
		
	for i in PLAYERS.get_children():
		if i.is_multiplayer_authority():
			changePlayerColors(i.DEFAULTPLAYERCOLOR)
	#if player.is_multiplayer_authority():
		#player.healthChanged.connect(update_health_bar)

func remove_player(peer_id):
	var player = PLAYERS.get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func startJoinLocal():
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func start_join_remote(address: String):
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer

func upnp_setup():
	var upnp = UPNP.new()


	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())

func changePlayerColors(color: GlobalItems.playerColors):
	print(str(color) + " changed")
	for i in PLAYERS.get_children():
		i.changeColor(color)

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.playerColorChanged.connect(changePlayerColors)
		changePlayerColors(node.DEFAULTPLAYERCOLOR)
