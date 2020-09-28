#Flour
#Ingredients:
# - 1 Wheat
# - 1 Bowl
#Results:
# - 1 Bowl Of Flour
# - 1 Wheat Seeds
#Made in Grindstone
#Set score if not set, decrease score, play sound.
execute as @e[name="Bowl"] at @s if block ~ ~-1 ~ grindstone if entity @e[name="Wheat",limit=1,sort=nearest,distance=..1] if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 21
execute as @e[name="Bowl"] at @s if block ~ ~-1 ~ grindstone if entity @e[name="Wheat",limit=1,sort=nearest,distance=..1] unless score @s ticksToProcess matches 1 run scoreboard players remove @s ticksToProcess 1
#Play processing sound
execute as @e[name="Bowl"] at @s if block ~ ~-1 ~ grindstone if entity @e[name="Wheat",limit=1,sort=nearest,distance=..1] run playsound minecraft:block.bamboo_sapling.break player @a ~ ~-1 ~
#On finish:
#Play finished sound
execute as @e[name="Bowl",scores={ticksToProcess=1}] at @s run playsound minecraft:block.ladder.break player @a ~ ~-1 ~ 100
#Summon results
#Carrot on a stick 1 = bowl_of_flour.
execute as @e[name="Bowl",scores={ticksToProcess=1}] at @s run summon item ~ ~ ~ {Item:{id:"carrot_on_a_stick",Count:1b,tag:{display:{Name:'{"text":"Bowl Of Flour"}'},CustomModelData:1}}}
execute as @e[name="Bowl",scores={ticksToProcess=1}] at @s run summon item ~ ~ ~ {Item:{id:"wheat_seeds",Count:1b}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[name="Bowl",scores={ticksToProcess=1}] as @e[name="Wheat",sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
scoreboard players remove @e[name="Wheat"] transfer_var 1
#Setting count to score.
execute at @e[name="Bowl",scores={ticksToProcess=1}] as @e[name="Wheat",sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[name="Bowl",scores={ticksToProcess=1}] as @e[name="Bowl",sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
scoreboard players remove @e[name="Bowl"] transfer_var 1
#Setting count to score.
execute at @e[name="Bowl",scores={ticksToProcess=1}] as @e[name="Bowl",sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
scoreboard players set @e[name="Bowl",scores={ticksToProcess=1}] ticksToProcess 21
