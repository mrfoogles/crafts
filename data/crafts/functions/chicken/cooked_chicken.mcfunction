execute as @e[name="Raw Chicken",scores={count=1..1000}] at @s if score @s count matches 1..1000 if block ~ ~-2 ~ #crafts:hot if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 1
execute as @e[name="Raw Chicken",scores={count=1..1000}] at @s if score @s count matches 1..1000 if block ~ ~-2 ~ #crafts:hot unless score @s ticksToProcess matches 1 run scoreboard players remove @s ticksToProcess 1
#On finish:
#Summon results
execute as @e[name="Raw Chicken",scores={count=1..1000}] if score @s ticksToProcess matches 1 at @s run summon item ~ ~ ~ {Item:{"id":"minecraft:cooked_chicken",Count:1,tag:{display:{Name:'{"text":"Cooked Chicken"}'}}}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[name="Raw Chicken",scores={count=1..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Raw Chicken",scores={count=1..1000},sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
execute at @e[name="Raw Chicken",scores={count=1..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Raw Chicken",scores={count=1..1000},sort=nearest,limit=1] run scoreboard players remove @s transfer_var 1
#Setting count to score.
execute at @e[name="Raw Chicken",scores={count=1..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Raw Chicken",scores={count=1..1000},sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
execute as @e[name="Raw Chicken",scores={count=1..1000}] if score @s ticksToProcess matches 1 run scoreboard players set @s ticksToProcess 1
