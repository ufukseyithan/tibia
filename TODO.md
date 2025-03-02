# Refactor
* Ground item save
* Reverse equipment array slots (from Head to rest)
* Commands
- NPCs (Make them Entity)
- Entity parent class (Monster and NPC will inherit from it)
- Menu for stats
- HP, XP bar

# Features
- Add character slots
- Add stats
    - primary (lv. up yields 3 stat points)
        - vit: increase max health
        - int: increase max mana & damage
        - str: increase damage
        - dex: increase damage
    - secondary
        - crit. chance
        - block chance
- Add health, mana & xp bars
- Add classes (Warrior, Rogue, Mage, Priest)
- Box entity, which will drop from monsters and be private to the player's drop pool, upon interaction menu will be shown to pick up items if any
- Abilities
    - Class skills
        - So far in my mind: hava kilici, kutsama, ejderha yardimi, sprint, swift, stealth, poison arrow, heal, explosions at mouse pos, etc.
        - Class skills will be upgraded using books, soul stones and level points (with level points, you can upgrade the class skill from 1-10, once it reaches 11, it is now a Master skill (M1-M10, upgradeable by skill book), once it reaches M11, it is now Grand Master skill (G1-G10) which is upgradeable using Soul Stones, once it reaches G11, it is now considered a Perfect skill (P) and no more upgradeable
    - Passive abilities (mining, fishing, riding, etc.)
        - Most of the passive abilities will be upgraded by reading books
        - For player to learn riding first, they will need to acquire a Horse Medallion and do the quest line acquired from Stable NPC
- Add subclass skill trees
- Damage done on hudtext center
- Item upgrade (from +1 to +10 tiers), starting from +7 the equipment will shine with another image on top of the original image which has higher gamma (the shine image will change its opacity from 0 to 1 using tween_imagecolor back and so forth)
    - Item upgrade will happen on the blacksmith NPC which will require rupees and different upgrade materials
