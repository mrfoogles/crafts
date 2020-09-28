#Ground Sugar Cane
#Ingredients:
# - 1 Sugar Cane
#Results:
# - 1 Lime Concrete Powder
# - 1 Sugar
#Made in Stonecutter
#Set score if not set, decrease score, play sound.
execute as @e[name="Sugar Cane"] at @s if block ~ ~ ~ stonecutter if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 21
execute as @e[name="Sugar Cane"] at @s if block ~ ~ ~ stonecutter run scoreboard players remove @s ticksToProcess 1
#Play processing sound
execute as @e[name="Sugar Cane"] at @s if block ~ ~ ~ stonecutter run playsound minecraft:block.bamboo.hit player @a ~ ~ ~
#On finish:
#Play finished sound
execute as @e[name="Sugar Cane",scores={ticksToProcess=1}] at @s run playsound minecraft:block.bamboo.break player @a ~ ~ ~ 100
#Summon results
execute as @e[name="Sugar Cane",scores={ticksToProcess=1}] at @s run summon item ~ ~ ~ {Item:{id:"lime_concrete_powder",Count:1b}}
#Removing the required amount from each ingredient.
execute as @e[name="Sugar Cane",scores={ticksToProcess=1}] at @s run summon item ~ ~ ~ {Item:{id:"sugar",Count:1b}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[name="Sugar Cane",scores={ticksToProcess=1}] as @e[name="Sugar Cane",sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
scoreboard players remove @e[name="Sugar Cane"] transfer_var 1
#Setting count to score.
execute at @e[name="Sugar Cane",scores={ticksToProcess=1}] as @e[name="Sugar Cane",sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
scoreboard players set @e[name="Sugar Cane",scores={ticksToProcess=1}] ticksToProcess 21
