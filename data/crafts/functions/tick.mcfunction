#Setting all unset ticksToProcess scores to 0, so you can tell if it's unset.
scoreboard players add @e[type=item] ticksToProcess 0

#Updating 'count' score for easy access.
execute as @e[type=item] store result score @s count run data get entity @s Item.Count

#Updating CustomModelData for easy access.
execute as @e[type=item] store result score @s CustomModelData run data get entity @s Item.tag.CustomModelData

function crafts:update_recipes
