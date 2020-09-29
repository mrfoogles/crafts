execute as @e[name="Wheat Seeds",scores={count=1..1000}] at @s if score @s count matches 1..1000 if block ~ ~-1 ~ minecraft:dirt if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 20
execute as @e[name="Wheat Seeds",scores={count=1..1000}] at @s if score @s count matches 1..1000 if block ~ ~-1 ~ minecraft:dirt unless score @s ticksToProcess matches 1 run scoreboard players remove @s ticksToProcess 1
#Play processing sound
execute as @e[name="Wheat Seeds",scores={count=1..1000}] at @s if score @s count matches 1..1000 if block ~ ~-1 ~ minecraft:dirt run playsound minecraft:block.fire.ambient player @a ~ ~ ~
#On finish:
#Play finished sound
execute as @e[name="Wheat Seeds",scores={count=1..1000}] if score @s ticksToProcess matches 1 at @s run playsound minecraft:block.fire.extinguished player @a ~ ~ ~ 100
#Summon results
execute as @e[name="Wheat Seeds",scores={count=1..1000}] if score @s ticksToProcess matches 1 at @s run summon item ~ ~ ~ {Item:{"id":"minecraft:oak_sapling",Count:1,tag:{display:{Name:'{"text":"Oak Sapling"}'}}}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[name="Wheat Seeds",scores={count=1..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Wheat Seeds",scores={count=1..1000},sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
execute at @e[name="Wheat Seeds",scores={count=1..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Wheat Seeds",scores={count=1..1000},sort=nearest,limit=1] run scoreboard players remove @s transfer_var 1
#Setting count to score.
execute at @e[name="Wheat Seeds",scores={count=1..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Wheat Seeds",scores={count=1..1000},sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
execute as @e[name="Wheat Seeds",scores={count=1..1000}] if score @s ticksToProcess matches 1 run scoreboard players set @s ticksToProcess 20
