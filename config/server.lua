Config = {}

Config.Debug = false -- Aktivera debug-kommandon
Config.Cooldown = 3000 -- Tid mellan skrapningar i ms

-- Svenska Triss-symboler (Font Awesome ikoner)
Config.PrizeIcons = {
    { icon = "clover", label = "Klöver" },
    { icon = "crown", label = "Krona" },
    { icon = "star", label = "Stjärna" },
    { icon = "diamond", label = "Diamant" },
    { icon = "horse-shoe", label = "Hästsko" },
    { icon = "coins", label = "Mynt" }
}

-- Svenska vinstnivåer
Config.PrizeAmounts = {
    30,
    60,
    90,
    120,
    300,
    1000,
    10000,
    100000,
    1000000
}

Config.Settings = {
    itemName = "trisslott", -- Namnet på item i inventory
    isInventoryItem = true, -- Om det ska kräva ett item
    winChance = 25, -- Chans att vinna (procent)
    loseChance = 75, -- Chans att förlora (procent)
    animation = {
        dict = "amb@world_human_seat_wall_eating@pizzabox@male@base",
        anim = "base",
        prop = "p_amb_pizzabox_01" -- Exempel, du kan byta till en lott-prop om du har
    }
}

Config.CardArray = {
    triss = {
        label = "Trisslott",
        gridSizeX = 3,
        gridSizeY = 3,
        winChance = 25,
        minWinSymbol = 3,
        cardBgColor = "#ffcc00", -- Gul färg för Triss
        stripeColor = "#005596" -- Blå färg för Triss
    }
}
