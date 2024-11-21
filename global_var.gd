extends Node

var player_Selected: String
var player_Name: String
var changue_Scene: String
var next_Level: bool = false
var gameOver: bool = false
var is_online : bool = false
var is_host : bool = false
var peer = ENetMultiplayerPeer.new()
var port = 1330
var max_players = 4
var players = {}
var localAuth: String
var life_apples = 3
