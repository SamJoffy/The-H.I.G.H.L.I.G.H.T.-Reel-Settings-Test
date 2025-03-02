extends Node

signal playerDied(playerID: int)
signal playerKill(playerID: int)
signal scoreBoardUpdated(playerID: int, numKills: int, numDeaths: int)
signal addPlayer(playerName: int)
signal removePlayer(playerName: int)
