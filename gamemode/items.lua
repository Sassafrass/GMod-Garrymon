
local function Item( name, type, hp )
    return {
        name = name,
        type = type
    }
end
 
ITEM_TYPE_POTION = 1
ITEM_TYPE_BALL = 2

POTION_TYPE_HEALTH = 1
POTION_TYPE_HEALTH_PERCENT = 2
POTION_TYPE_GP = 3
 
local function PotionItem( name, healAmount, potionType )
    local item = Item( name, ITEM_TYPE_POTION )
    item.healAmount = healAmount
    item.potionType = potionType
    return item
end
 
GM.items = {
    BallGarry = Item( "Garryball", ITEM_TYPE_BALL ),
    BallFast = Item( "Fastball", ITEM_TYPE_BALL ),
    BallSuper = Item( "Superball", ITEM_TYPE_BALL ),
    BallSecure = Item( "Secureball", ITEM_TYPE_BALL ),
    BallBest = Item( "Bestball", ITEM_TYPE_BALL ),
    PotionHealing = PotionItem( "Healing Potion", 20, POTION_TYPE_HEALTH ),
    PotionRevive = PotionItem( "Revive",  50, POTION_TYPE_HEALTH_PERCENT ),
    PotionSuper = PotionItem( "Super Potion", 100, POTION_TYPE_HEALTH ),
    PotionHyper = PotionItem( "Hyper Potion", 200, POTION_TYPE_HEALTH ),
    PotionMax = PotionItem( "Max Potion", 100, POTION_TYPE_HEALTH_PERCENT ),
    PotionElixir = PotionItem( "Elixir", 10, POTION_TYPE_GP )
}
for k, v in pairs( GM.items ) do
    v.key = k
end