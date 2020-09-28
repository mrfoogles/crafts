#Dough
#Ingredients:
# - 1 Egg
# - 1 Sugar
# - 1 Bowl Of Flour
#Results:
# - 1 Dough
#Made with blocks:
# - ~ ~ ~ cauldron
#Set score if not set, decrease score, play sound.
execute as @e[scores={CustomModelData=1}] at @s if block ~ ~ ~ cauldron if entity @e[name="Egg",limit=1,sort=nearest,distance=..1] if entity @e[name="Sugar",limit=1,sort=nearest,distance=..1] if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 21
execute as @e[scores={CustomModelData=1}] at @s if block ~ ~ ~ cauldron if entity @e[name="Egg",limit=1,sort=nearest,distance=..1] if entity @e[name="Sugar",limit=1,sort=nearest,distance=..1] unless score @s ticksToProcess matches 1 run scoreboard players remove @s ticksToProcess 1
#Play processing sound
execute as @e[scores={CustomModelData=1}] at @s if block ~ ~ ~ cauldron if entity @e[name="Egg",limit=1,sort=nearest,distance=..1] if entity @e[name="Sugar",limit=1,sort=nearest,distance=..1] run playsound minecraft:block.bamboo.break player @a ~ ~ ~
#On finish:
#Play finished sound
execute as @e[scores={CustomModelData=1}] if score @s ticksToProcess matches 1 at @s run playsound minecraft:entity.slime.squish player @a ~ ~ ~ 100
#Summon results
execute as @e[scores={CustomModelData=1}] if score @s ticksToProcess matches 1 at @s run summon item ~ ~ ~ {Item:{"id":"minecraft:carrot_on_a_stick",Count:1,tag:{display:{Name:'{"text":"Dough"}'},CustomModelData:2}}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Egg",sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Egg",sort=nearest,limit=1] run scoreboard players remove @s transfer_var 1
#Setting count to score.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Egg",sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Sugar",sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Sugar",sort=nearest,limit=1] run scoreboard players remove @s transfer_var 1
#Setting count to score.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[name="Sugar",sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[scores={CustomModelData=1},sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[scores={CustomModelData=1},sort=nearest,limit=1] run scoreboard players remove @s transfer_var 1
#Setting count to score.
execute at @e[scores={CustomModelData=1}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[scores={CustomModelData=1},sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
execute as @e[scores={CustomModelData=1}] if score @s ticksToProcess matches 1 run scoreboard players set @s ticksToProcess 21
