local Player = {}
local Suits = require("src.game.suits")

Player.ownedSuits = {Suits.Hearts, Suits.Diamonds, Suits.Clubs, Suits.Spades}

return Player