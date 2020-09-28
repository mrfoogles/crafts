#Creates a recipe file, to be run every tick, and adds the function to the crafts:tick category.
#Adds the file to the current directory.
#Put this in your functions folder.

import os
import sys
import json

UPDATE_FUNCTION = "tick.mcfunction"


def idToItemName(idToChange):
    #Turns 'grass_block' to 'Grass Block'
    itemName = ''
    for index in range(0,len(idToChange)):
        if index == 0:
            itemName += idToChange[0].upper()
            continue

        if idToChange[index] == '_':
            itemName += ' '
        elif itemName[index-1] == ' ':
            itemName += idToChange[index].upper()
        else:
            itemName += idToChange[index]

    return(itemName)

def process_items(dictionary):
    processed = {}
    
    for item_id in dictionary:
        custom = None
        name = None
        count = dictionary[item_id]["count"]
        
        if "custom" in dictionary[item_id]:
            custom = dictionary[item_id]["custom"]
        if "name" in dictionary[item_id]:
            name = dictionary[item_id]["name"]
        
        processed[Item(item_id=item_id,name=name,CustomModelData=custom)] = count
        
    return(processed)
        
def add_from_json(rel_path): 

    with open(rel_path) as json_file:
        json_dict = json.loads(json_file.read())
        
    function_path = rel_path.replace(".r.json",".mcfunction")
    
    ingredients = process_items(json_dict["ingredients"])
    results = process_items(json_dict["results"])   
    processing_blocks = json_dict["workstation_blocks"]
    time = json_dict["time"]

    processing_sound = None
    finished_sound = None

    if "sounds" in json_dict:
        if "processing" in json_dict["sounds"]:
            processing_sound = json_dict["sounds"]["processing"]
        if "finished" in json_dict["sounds"]:
            finished_sound = json_dict["sounds"]["finished"]

    group = None
    if "group" in json_dict:
        group = json_dict["group"]

    
    function = get_recipe_function(ingredients,results,processing_blocks,time,processing_sound,finished_sound)
    update = get_update_command(ingredients,rel_path)


    with open(UPDATE_FUNCTION,"r") as f:
        if update not in f:
            with open(UPDATE_FUNCTION,"w") as f_writable:
                f_writable.write(f.read() + update)

    try:
        with open(function_path,mode="w") as f:
            f.write(function)
    except:
        with open(function_path,mode="x") as f:
            f.write(function)
            
    return(function_path)
        
def get_recipe_function(ingredientDict,
                        resultDict,
                        processingBlockDict,
                        processingTime,
                        processingSound=None,
                        finishedSound=None):
    #Dict syntax:
    # {"item_id":number}
    #processingBlock accepts block id (grass_block) and tag (#grass_blocks)

    text = ''

    for key in ingredientDict:
        ingredientForPos = key
        break
    
    #Start of execute, execute at the item.
    goingToAdd = 'execute as @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] at @s if score @s count matches ' + str(ingredientDict[ingredientForPos]) + '..1000 '
    for block in processingBlockDict:
        goingToAdd += 'if block ' + processingBlockDict[block] + ' ' + block

    #Other ingredient detection.
    for otherIngredient in ingredientDict:
        if otherIngredient != ingredientForPos:
            goingToAdd +=  ' if entity @e[' + otherIngredient.getDetectBy(ingredientDict[otherIngredient]) + ',limit=1,sort=nearest,distance=..1]'

    #Other detections, then action.
    text += goingToAdd + ' if score @s ticksToProcess matches 0 run scoreboard players set @s ticksToProcess ' + str(processingTime) + '\n'

    goingToAdd = 'execute as @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] at @s if score @s count matches ' + str(ingredientDict[ingredientForPos]) + '..1000 '
    for block in processingBlockDict:
        goingToAdd += 'if block ' + processingBlockDict[block] + ' ' + block
    for otherIngredient in ingredientDict:
        if otherIngredient != ingredientForPos:
            goingToAdd +=  ' if entity @e[' + otherIngredient.getDetectBy(ingredientDict[otherIngredient]) + ',limit=1,sort=nearest,distance=..1]'
    text += goingToAdd + ' unless score @s ticksToProcess matches 1 run scoreboard players remove @s ticksToProcess 1' + '\n'

    if processingSound != None:
        text += '#Play processing sound' + '\n'
        goingToAdd = 'execute as @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] at @s if score @s count matches ' + str(ingredientDict[ingredientForPos]) + '..1000 '
        for block in processingBlockDict:
            goingToAdd += 'if block ' + processingBlockDict[block] + ' ' + block
        for otherIngredient in ingredientDict:
            if otherIngredient != ingredientForPos:
                goingToAdd +=  ' if entity @e[' + otherIngredient.getDetectBy(ingredientDict[otherIngredient]) + ',limit=1,sort=nearest,distance=..1]'
        text += goingToAdd + ' run playsound ' + processingSound + ' player @a ~ ~ ~' + '\n'
    text += '#On finish:' + '\n'
    if finishedSound != None:
        text += '#Play finished sound' + '\n'
        text += 'execute as @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] if score @s ticksToProcess matches 1 at @s run playsound ' + finishedSound + ' player @a ~ ~ ~ 100' + '\n'
    text += '#Summon results' + '\n'
    for result in resultDict:
        text += 'execute as @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] if score @s ticksToProcess matches 1 at @s run ' + result.getSummonCommand('~ ~ ~',resultDict[result]) + '\n'
    for ingredient in ingredientDict:
        text += '#Removing the required amount from each ingredient.' + '\n'
        text += '#Decrease the count by the number required by:' + '\n'
        text += '#Setting score to count.' + '\n'
        text += 'execute at @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[' + ingredient.getDetectBy(ingredientDict[ingredient]) + ',sort=nearest,limit=1] store result score @s transfer_var run data get entity @s Item.Count 1' + '\n'
        text += '#Decreasing score.' + '\n'
        text += 'execute at @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[' + ingredient.getDetectBy(ingredientDict[ingredient]) + ',sort=nearest,limit=1] run scoreboard players remove @s transfer_var ' + str(ingredientDict[ingredient]) + '\n'
        text += '#Setting count to score.' + '\n'
        text += 'execute at @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] if score @e[limit=1,sort=nearest] ticksToProcess matches 1 as @e[' + ingredient.getDetectBy(ingredientDict[ingredient]) + ',sort=nearest,limit=1] store result entity @s Item.Count int 1 run scoreboard players get @s transfer_var' + '\n'
    text += '#Also, resetting processing time!' + '\n'
    text += 'execute as @e[' + ingredientForPos.getDetectBy(ingredientDict[ingredientForPos]) + '] if score @s ticksToProcess matches 1 run scoreboard players set @s ticksToProcess ' + str(processingTime) + '\n'

    return(text)

def get_update_command(ingredient_dict,
                       rel_path):
    for key in ingredient_dict:
        ingredient_for_pos = key
        break
    
    return 'execute as @e[limit=1,' + ingredient_for_pos.getDetectBy(ingredient_dict[ingredient_for_pos]) + '] run function crafts:' + rel_path + '\n'


#Note: if you want them to all mix together quickly after an amount of time, set the time it gets reset to to 1 in the file.
#Also remember: using carrot_on_a_stick for new items.
#CustomModelData is the nbt tag, use it to detect special items with:
#if entity @e[limit=1,name="stick",distance=..1,nbt={CustomModelData:<number>}]
#Or to summon the item with:
#/summmon item ~ ~ ~ {Item:{"id":"minecraft:stick",Count:<count>,tag:{CustomModelData:<number>}}}
#You may also want to add a name, with:
#/summmon item ~ ~ ~ {Item:{"id":"minecraft:stick",Count:<count>,display:{Name:'{"tex":"<name>"}'}}}

class Item(object):
    #A class holding the info for an item.

    def __init__(self,item_id,CustomModelData=None,name=None):
        #Declares variables, that's all the class does.
        if name == None:
            self.name = idToItemName(item_id)
        else:
            self.name = name
        self.itemId = item_id
        self.CustomModelData = CustomModelData

    def getItemDict(self,count):
        itemDict = {}
        itemDict["id"] = self.itemId
        if self.CustomModelData != None:
            itemDict["CustomModelData"] = self.CustomModelData
        itemDict["name"] = self.name
        itemDict["count"] = count
        return(itemDict)

    def getSummonCommand(self,coords,count):
        #Returns the command to summon a number of it at set coords.
        #Not 5 items, but one with Count of 5.
        command = 'summon item ' + coords + ' {Item:{"id":"minecraft:' + self.itemId + '",' + 'Count:' + str(count) + ',' + '''tag:{display:{Name:'{"text":"''' + self.name + '''"}'}'''

        if self.CustomModelData != None:
            command += ',CustomModelData:' + str(self.CustomModelData)

        command += '}}}'
        return(command)

    def getDetectBy(self,countRequired=1):
        #Returns the detectby command with a certain number required at the least.
        #Detectby: A string as an argument for @e[] that will execute only at this type of item.
        if self.CustomModelData == None:
            detectBy = 'name="' + self.name + '",scores={count='+str(countRequired)+'..1000}'
        else:
            detectBy = 'scores={CustomModelData=' + str(self.CustomModelData) + ',count=' + str(countRequired) + '..1000}'
        return(detectBy)
                
if __name__ == '__main__':
    path = sys.argv[1]
    
    if path.startswith("/"):
        raise Exception("Path must be relative!")
    
    add_from_json(path)

