#{"ingredients": [{"id": "stick", "CustomModelData": 2, "name": "Stick", "count": 3}], "results": [{"id": "bread", "name": "Bread", "count": 1}], "blocks": [{"block": "#crafts:hot", "position": "~ ~-2 ~"}], "processingSound": "minecraft:block.furnace.fire_crackle", "processingTime": 21, "finishedSound": "minecraft:entity.blaze.shoot"}
#Bread/bread
#Ingredients:
# - 3 Stick
#Results:
# - 1 Bread
#Made with blocks:
# - ~ ~-2 ~ #crafts:hot
#Set score if not set, decrease score, play sound.
execute as @e[scores={CustomModelData=2,count=3..1000}] at @s if score @s count matches 3..1000 if block ~ ~-2 ~ #crafts:hot if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess 21
execute as @e[scores={CustomModelData=2,count=3..1000}] at @s if score @s count matches 3..1000 if block ~ ~-2 ~ #crafts:hot unless score @s ticksToProcess matches 1 run scoreboard players remove @s ticksToProcess 1
#Play processing sound
execute as @e[scores={CustomModelData=2,count=3..1000}] at @s if score @s count matches 3..1000 if block ~ ~-2 ~ #crafts:hot run playsound minecraft:block.furnace.fire_crackle player @a ~ ~ ~
#On finish:
#Play finished sound
execute as @e[scores={CustomModelData=2,count=3..1000}] if score @s ticksToProcess matches 1 at @s run playsound minecraft:entity.blaze.shoot player @a ~ ~ ~ 100
#Summon results
execute as @e[scores={CustomModelData=2,count=3..1000}] if score @s ticksToProcess matches 1 at @s run summon item ~ ~ ~ {Item:{"id":"minecraft:bread",Count:1,tag:{display:{Name:'{"text":"Bread"}'}}}}
#Removing the required amount from each ingredient.
#Decrease the count by the number required by:
#Setting score to count.
execute at @e[scores={CustomModelData=2,count=3..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[scores={CustomModelData=2,count=3..1000},sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1
#Decreasing score.
execute at @e[scores={CustomModelData=2,count=3..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[scores={CustomModelData=2,count=3..1000},sort=nearest,limit=1] run scoreboard players remove @s transfer_var 3
#Setting count to score.
execute at @e[scores={CustomModelData=2,count=3..1000}] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[scores={CustomModelData=2,count=3..1000},sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var
#Also, resetting processing time!
execute as @e[scores={CustomModelData=2,count=3..1000}] if score @s ticksToProcess matches 1 run scoreboard players set @s ticksToProcess 21
