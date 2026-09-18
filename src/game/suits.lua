local Suits = {}
local Suit = require("src.game.suit")
local Hand = require("src.game.hand")
local Effect = require("src.game.effect")
local Modifier = require("src.game.modifier")

local standardRanks = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }

function Diamonds()
    local diamonds = Suit.new("Diamonds", "♦", "Provides extra cash when dealer busts.", standardRanks, "red")
    local effect = Effect.new(
        "dealer_bust",
        function(context)
            print("Diamonds effect triggered: Player receives extra chips for dealer bust.")
            context.game.addChips(love.math.random(1, 3))
        end
    )

    Suit.addEffect(diamonds, effect)

    return diamonds
end

function Clubs()
    local clubs = Suit.new("Clubs", "♣", "Blackjacks give extra cash if it contains a face card.", standardRanks, "black")
    local effect = Effect.new(
        "blackjack",
        function(context)
            if Hand.containsAnyRank(context.playerHand, { "J", "Q", "K" }) then
                context.game.addChips(5)
                print("Clubs effect triggered: Player receives extra chips for blackjack with a face card.")
            else
                print("Clubs effect triggered: Player receives extra cash for blackjack.")
            end
        end
    )

    Suit.addEffect(clubs, effect)

    return clubs
end

function Spades()
    local ranks = { "A", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }

    local spades = Suit.new("Spades", "♠", "Adds an extra Ace to the deck", ranks, "black")


    return spades
end

function Hearts()
    local hearts = Suit.new("Hearts", "♥", "If you win a hand with purely red cards, gain extra cash.", standardRanks,
        "red")
    local effect = Effect.new(
        "player_wins",
        function(context)
            local allRed = true
            for _, card in ipairs(context.playerHand) do
                if card.color ~= "red" then
                    allRed = false
                    break
                end
            end

            if allRed then
                context.game.addChips(10)
                print("Hearts effect triggered: Player receives extra cash for winning with purely red cards.")
            end
        end
    )
    table.insert(hearts.effects, effect)

    return hearts
end

function Stars()
    local stars = Suit.new(
        "Stars",
        "★",
        "All 5s are treated as having a value of 10.",
        standardRanks,
        "yellow"
    )

    local modifier = Modifier.new(
        "value",
        function(card, value)
            if card.rank == "5" then
                return 10
            end

            return value
        end
    )

    table.insert(stars.modifiers, modifier)

    return stars
end

function Bones()
    local bones = Suit.new("Bones", "💀", "Face cards are treated as 1s", standardRanks, "white")
    local modifier = Modifier.new(
        "value",
        function(card, value)
            if card.rank == "J" or card.rank == "Q" or card.rank == "K" then
                return 1
            end

            return value
        end
    )
    table.insert(bones.modifiers, modifier)

    return bones
end

function Crowns()
    local ranks = { "K", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }
    local crowns = Suit.new("Crowns", "👑",
        "Face cards will give extra chips when winning a hand, also recieve an extra face card", ranks, "yellow")
    local effect = Effect.new(
        "player_wins",
        function(context)
            if Hand.containsAnyRank(context.playerHand, { "J", "Q", "K" }) then
                context.game.addChips(5)
                print("Crowns effect triggered: Player receives extra chips for winning with a face card.")
            end
        end
    )
    Suit.addEffect(crowns, effect)
    return crowns
end

function Pentacles()
    local pentacles = Suit.new("Pentacles", "🪙", "Recieve chips based on your hand value.", standardRanks, "yellow")
    local effect = Effect.new(
        "player_wins",
        function(context)
            local handValue = Hand.getValue(context.playerHand, context.activeSuits)
            if handValue > 0 then
                context.game.addChips(handValue)
                print("Pentacles effect triggered: Player receives chips based on hand value.")
            end
        end
    )
    Suit.addEffect(pentacles, effect)
    return pentacles
end

function Feathers()
    local feathers = Suit.new("Feathers", "🪶", "If you win a hand with purely white cards, gain extra chips.",
        standardRanks, "white")
    local effect = Effect.new(
        "player_wins",
        function(context)
            local allWhite = true
            for _, card in ipairs(context.playerHand) do
                if card.color ~= "white" then
                    allWhite = false
                    break
                end
            end

            if allWhite then
                context.game.addChips(5)
                print("Feathers effect triggered: Player receives extra cash for winning with purely white cards.")
            end
        end
    )
    Suit.addEffect(feathers, effect)
    return feathers
end

function Bells()
    local bells = Suit.new("Bells", "🔔", "Even rank cards give extra chips on win.", standardRanks, "yellow")
    local effect = Effect.new(
        "player_wins",
        function(context)
            local evenRankCount = 0
            for _, card in ipairs(context.playerHand) do
                local rank = tonumber(card.rank)

                if rank and rank % 2 == 0 then
                    evenRankCount = evenRankCount + 1
                end
            end

            if evenRankCount > 0 then
                context.game.addChips(evenRankCount * 5)
                print("Bells effect triggered: Player receives extra cash for winning with even rank cards.")
            end
        end
    )
    Suit.addEffect(bells, effect)
    return bells
end

return {
    Diamonds = Diamonds(),
    Clubs = Clubs(),
    Spades = Spades(),
    Hearts = Hearts(),
    Stars = Stars(),
    Bones = Bones(),
    Crowns = Crowns(),
    Pentacles = Pentacles(),
    Feathers = Feathers(),
    Bells = Bells(),

}
