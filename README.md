# Svenska Spel Trisslott System

Ett komplett Trisslott-system för FiveM (Qbox/QBCore) inspirerat av Svenska Spels Triss.

## Installation

1. Ladda ner/klona repot till din `resources` mapp.
2. Lägg till `ensure slrn_scratchcard` i din `server.cfg`.
3. Lägg till itemet `trisslott` i ditt inventory system.

### Ox Inventory Setup
Lägg till följande i `ox_inventory/data/items.lua`:

```lua
['trisslott'] = {
    label = 'Trisslott',
    weight = 10,
    stack = true,
    close = true,
    description = 'Plötsligt händer det!',
    client = {
        export = 'slrn_scratchcard.scratcher'
    }
},
```

## Konfiguration
Du kan ändra vinstchanser, symboler och belopp i `config/server.lua`.

* **Vinstchanser:** Ändra `winChance` (procent).
* **Vinstnivåer:** Justera listan `Config.PrizeAmounts`.
* **Kylning:** Ändra `Config.Cooldown` för att förhindra spam-skrapande.

## Funktioner
* **Svensk Design:** Blått och gult tema med Triss-logo.
* **Realistiskt Skrapande:** Använd musen för att skrapa fram vinsterna på ett interaktivt sätt.
* **Säkerhet:** Alla vinstberäkningar och utbetalningar sker på serversidan för att förhindra fusk.
* **Ljud & Animationer:** Kan konfigureras i inställningarna.

## Support
Skapat av SwisserAI för din FiveM-server.
https://ai.swisser.dev
