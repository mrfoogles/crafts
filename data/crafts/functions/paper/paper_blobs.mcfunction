#Paper Blobs
#Ingredients:
# - 1 Lime Concrete Powder
#Results:
# - 1 Green Concrete Powder
#Made in Water
#Set score if not set, decrease score, play sound.
execute as @e[name="Lime Concrete Powder"] at @s if block ~ ~ ~ water if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 31
execute as @e[name="Lime Concrete Powder"] at @s if block ~ ~ ~ water run scoreboard players remove @s ticksToProcess 1
#On finish:
#Play finished sound
execute as @e[name="Lime Concrete Powder",scores={ticksToProcess=1}] at @s run playsound minecraft:block.bubble_column.bubble_pop player @a ~ ~ ~ 10
#Summon results
execute as @e[name="Lime Concrete Powder",scores={ticksToProcess=1}] at @s run summon item ~ ~ ~ {Item:{id:"green_concrete_powder",Count:1b}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[name="Lime Concrete Powder",scores={ticksToProcess=1}] as @e[name="Lime Concrete Powder",sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
scoreboard players remove @e[name="Lime Concrete Powder"] transfer_var 1
#Setting count to score.
execute at @e[name="Lime Concrete Powder",scores={ticksToProcess=1}] as @e[name="Lime Concrete Powder",sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
scoreboard players set @e[name="Lime Concrete Powder",scores={ticksToProcess=1}] ticksToProcess 1
