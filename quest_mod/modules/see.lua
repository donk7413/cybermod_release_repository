debugPrint(3,"CyberMod: see module loaded")
questMod.module = questMod.module +1


function checkTrigger(trigger)
	
	local status, result = pcall(scriptcheckTrigger,trigger)
	
	
	
	if status == false then
		
		
		print('CyberMod Trigger error: ' .. result.." Trigger : "..tostring(JSON:encode_pretty(trigger)))
		spdlog.error('CyberMod Trigger error: ' .. result.." Trigger : "..tostring(JSON:encode_pretty(trigger)))
		--Game.GetPlayer():SetWarningMessage("CyberMod Trigger error, check the log for more detail")
		return false
		else
		return result
		
	end
	
	
	
end

--Check trigger core function
function scriptcheckTrigger(trigger)
	local result = false
	if trigger ~= nil then 
		
		local entityregion = true
		local groupregion = true
		local vehiculeregion = true
		local scoreregion = true
		local houseregion = true
		local gangregion = true
		local miscregion = true
		local relationregion = true
		local questregion = true
		local noderegion = true
		local soundregion = true
		local logicregion = true
		local uiregion = true
		local avregion = true
		local customnpcregion = true
		local multiregion = true
		local frameworkregion = true
		local playerregion = true
		
		if entityregion then
			if(trigger.name == "npc") then
				if(trigger.way == "phone") then
					if currentNPC ~= nil then
						if(currentNPC.Names == (trigger.value))then
							result = true
						end
					end
				end
				if(trigger.way == "speak") then
					if currentStar ~= nil then
						if(currentStar.Names == (trigger.value))then
							result = true
						end
					end
				end
				if(trigger.way == "fixer") then
					if currentfixer ~= nil then
						if(currentfixer.Tag == trigger.value)then
							result = true
						end
					end
				end
			end
			if(trigger.name == "entity_is_spawn") then
				local obj = getEntityFromManager(trigger.tag)
				if(obj.id ~= nil) then
					local enti = Game.FindEntityByID(obj.id)	
					if(enti ~= nil) then
						----debugPrint(1,"entity is active"..tostring(enti:IsAttached()))
						if (enti:IsAttached() == true)then
							----debugPrint(1,"entity is actived"..tostring(enti:IsAttached()))
							return true
						end
					end
				end
			end
			if(trigger.name == "look_at_object") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					if(tarName ~= nil and appName ~= nil)then
						if(string.match(tarName, trigger.value) or string.match(appName, trigger.value) or string.match(dipName, trigger.value))then 
							return true
						end
					end
				end
			end
			if(trigger.name == "look_at_entity") then
				if objLook ~= nil then
					local obj = getEntityFromManager(trigger.tag)
					if(obj.id ~= nil) then
						local enti = Game.FindEntityByID(obj.id)	
						if(enti ~= nil) then
							if(enti:GetEntityID().hash == objLook:GetEntityID().hash)then 
								return true
							end
						end
					end
				end
			end
			if(trigger.name == "killed_entity") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				if(enti ~= nil) then
					--debugPrint(1,"entity is active"..tostring(enti:IsActive()))
					if (enti:IsDead() == true or enti:IsActive() == false)then
						return true
					end
				end
			end
			if(trigger.name == "entity_looked_is_follower") then
				local isFollower = false
				if objLook ~= nil then
					tarbName =  objLook:ToString()
				end
				if objLook ~= nil and (string.match(tarbName, "NPCPuppet"))then 
					local aicontrol =  nil
					pcall(function()
						aicontrol  =  objLook:GetAIControllerComponent()
					end)
					if(aicontrol ~= nil) then
						local currentRole =aicontrol:GetAIRole()
						isFollower = (currentRole and (currentRole:IsA('AIFollowerRole')) )
						if(isFollower == nil) then
							isFollower = false
						end
					end
				end
				result = isFollower
			end
			if(trigger.name == "entity_looked_is_registered") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					local entid = objLook:GetEntityID()
					local entity = getEntityFromManagerById(entid)
					if(entity.id ~= nil) then
						result = true
					end
				end
			end
			if(trigger.name == "entity_looked_is_registered_as_companion") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					local entity = getEntityFromManagerById(objLook:GetEntityID())
					if(entity ~= nil and entity.id ~= nil) then
						debugPrint(1,"iscompanion ".. tostring(entity.iscompanion))
						if string.match(entity.tag, "companion_") then
							return true
						end
					end
				end
			end
			if(trigger.name == "entity_at_position") then
				local obj = getEntityFromManager(trigger.tag)
				--debugPrint(1,obj.tag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local targetPosition = enti:GetWorldPosition()
					if check3DPos(targetPosition, trigger.x, trigger.y, trigger.z,trigger.range) then
						result = true
						else
						result = false
					end
					else
					--debugPrint(1,"entity not found : "..trigger.tag)
				end
			end
			if(trigger.name == "entity_at_relative_position") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				local index = getIndexFromManager(trigger.tag)
				if(enti ~= nil) then
					local entityposition = enti:GetWorldPosition()
					if questMod.EntityManager[index].targetedPostion == nil then
						questMod.EntityManager[index].targetedPostion = {}
						questMod.EntityManager[index].targetedPostion.x = entityposition.x + trigger.x
						questMod.EntityManager[index].targetedPostion.y = entityposition.y + trigger.y
						questMod.EntityManager[index].targetedPostion.z = entityposition.z + trigger.z
					end
					local targetedPostions = questMod.EntityManager[index].targetedPostion
					--debugPrint(1,entityposition.y)
					--debugPrint(1,targetedPostions.y)
					if check3DPos(entityposition, targetedPostions.x, targetedPostions.y, targetedPostions.z,trigger.range) then
						result = true
						questMod.EntityManager[index].targetedPostion = nil
						else
						result = false
					end
				end
			end
			if(trigger.name == "entity_in_state") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				if(enti ~= nil) then
					local levelstate = enti:GetHighLevelStateFromBlackboard()
					local triggerlevelstate  = gamedataNPCHighLevelState.Any
					if(trigger.value == 0) then
						triggerlevelstate  = gamedataNPCHighLevelState.Alerted
					end
					if(trigger.value == 2) then
						triggerlevelstate  = gamedataNPCHighLevelState.Combat
					end
					if(trigger.value == 3) then
						triggerlevelstate  = gamedataNPCHighLevelState.Dead
					end
					if(trigger.value == 4) then
						triggerlevelstate  = gamedataNPCHighLevelState.Fear
					end
					if(trigger.value == 5) then
						triggerlevelstate  = gamedataNPCHighLevelState.Relaxed
					end
					if(trigger.value == 6) then
						triggerlevelstate  = gamedataNPCHighLevelState.Stealth 
					end
					if(trigger.value == 7) then
						triggerlevelstate  = gamedataNPCHighLevelState.Unconscious
					end
					if(trigger.value == 8) then
						triggerlevelstate  = gamedataNPCHighLevelState.Wounded
					end
					if(trigger.value == 9) then
						triggerlevelstate  = gamedataNPCHighLevelState.Count
					end
					if(trigger.value == 10) then
						triggerlevelstate  = gamedataNPCHighLevelState.Invalid
					end
					if(levelstate == triggerlevelstate) then
						result = true
					end
				end
			end
			if(trigger.name == "entity_at_relative_player_position") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				local index = getIndexFromManager(trigger.tag)
				if(enti ~= nil) then
					--debugPrint(1,"test")
					local entityposition = enti:GetWorldPosition()
					local playerpos = Game.GetPlayer():GetWorldPosition()
					if questMod.EntityManager[index].targetedPostion == nil then
						questMod.EntityManager[index].targetedPostion = {}
						questMod.EntityManager[index].targetedPostion.x = playerpos.x + trigger.x
						questMod.EntityManager[index].targetedPostion.y = playerpos.y + trigger.y
						questMod.EntityManager[index].targetedPostion.z = playerpos.z + trigger.z
					end
					local targetedPostions = questMod.EntityManager[index].targetedPostion
					if check3DPos(entityposition, targetedPostions.x, targetedPostions.y, targetedPostions.z,trigger.range) then
						result = true
						questMod.EntityManager[index].targetedPostion = nil
						else
						result = false
					end
				end
			end
			if(trigger.name == "entity_inbuilding")then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				result = Game.IsEntityInInteriorArea(enti)
			end
			if(trigger.name == "entity_gender") then
				local obj = getEntityFromManager(trigger.tag)
				if(obj.id ~= nil) then
					local enti = Game.FindEntityByID(obj.id)	
					if(enti ~= nil) then
						debugPrint(1,GetEntityGender(enti))
						if(trigger.value == GetEntityGender(enti)) then
							return true
							else
							return false
						end
					end
				end
				if(trigger.value == GetPlayerGender()) then
					return true
					else
					return false
				end
			end
			if(trigger.name == "entity_is_at_mappin_position") then
				local mappin = getMappinByTag(trigger.tag)
				if(mappin ~= nil) then
					local obj = getEntityFromManager(trigger.entity)
					local enti = Game.FindEntityByID(obj.id)	
					if(enti ~= nil) then
						result = check3DPos(enti:GetWorldPosition(), mappin.position.x, mappin.position.y, mappin.position.z, trigger.range)
						return result 
						else
						return false
					end
					else
					return false
				end
			end
			if(trigger.name == "entity_script_level") then
				local obj = getEntityFromManager(trigger.tag)
				if(obj.id ~= nil) then
					if(obj.scriptlevel ~= nil) then
						
						if(
							(trigger.operator == "<" and obj.scriptlevel < trigger.scriptlevel) or
							(trigger.operator == "<=" and obj.scriptlevel <= trigger.scriptlevel) or
							(trigger.operator == ">" and obj.scriptlevel > trigger.scriptlevel) or
							(trigger.operator == ">=" and obj.scriptlevel >= trigger.scriptlevel) or
							(trigger.operator == "!=" and obj.scriptlevel ~= trigger.scriptlevel) or
						(trigger.operator == "=" and obj.scriptlevel == trigger.scriptlevel)) then
						result = true
						end
						
					end
				end
			end
			
			if(trigger.name == "last_killed_entity_is_registred") then
				if lastTargetKilled ~= nil then
					tarName = lastTargetKilled:ToString()
					appName = Game.NameToString(lastTargetKilled:GetCurrentAppearanceName())
					dipName = lastTargetKilled:GetDisplayName()
					local entid = lastTargetKilled:GetEntityID()
					local entity = getEntityFromManagerById(entid)
					if(entity.id ~= nil) then
						result = true
					end
				end
			end
			
			if(trigger.name == "last_killed_entity_is") then
				if lastTargetKilled ~= nil then
					tarName = lastTargetKilled:ToString()
					appName = Game.NameToString(lastTargetKilled:GetCurrentAppearanceName())
					dipName = lastTargetKilled:GetDisplayName()
					local entid = lastTargetKilled:GetEntityID()
					
					if(entid.tag  == trigger.tag) then
						result = true
					end
				end
			end
			
		end
		
		if groupregion then
			if(trigger.name == "group_is_spawn") then
				local enemy_count = 0
				local group =getGroupfromManager(trigger.tag)
				--debugPrint(1,group.tag)
				--debugPrint(1,#group.entities)
				for i=1, #group.entities do 
					local entityTag = group.entities[i]
					local obj = getEntityFromManager(entityTag)
					local enti = Game.FindEntityByID(obj.id)	
					--debugPrint(1,obj.tag)
					--debugPrint(1,obj.id)
					--debugPrint(1,enti)
					if(enti ~= nil) then
						--debugPrint(1,"entity is active"..tostring(enti:IsAttached()))
						if (enti:IsAttached() == true)then
							--debugPrint(1,"npc have be killed")
							enemy_count = enemy_count + 1
						end
					end
				end
				if (enemy_count == #group.entities) then
					result = true
				end
			end
			if(trigger.name == "killed_group") then
				local enemy_count = 0
				local group =getGroupfromManager(trigger.tag)
				if(group ~= nil ) then
					for i=1, #group.entities do 
						local entityTag = group.entities[i]
						local obj = getEntityFromManager(entityTag)
						local enti = Game.FindEntityByID(obj.id)	
						if(enti ~= nil) then
							--debugPrint(1,"entity is active"..tostring(enti:IsActive()))
							if (enti:IsDead() == true or enti:IsActive() == false)then
								--debugPrint(1,"npc have be killed")
								enemy_count = enemy_count + 1
							end
							elseif(obj.id == nil) then
							enemy_count = enemy_count + 1
						end
					end
					if (enemy_count == #group.entities) then
						result = true
						--debugPrint(1,tostring(result))
					end
				end
			end
			if(trigger.name == "group_script_level") then
				local group =getGroupfromManager(trigger.tag)
				local count = 0
				if(group ~= nil ) then
					for i=1, #group.entities do 
						local entityTag = group.entities[i]
						local obj = getEntityFromManager(entityTag)
						if(obj.id ~= nil) then
							if(obj.scriptlevel ~= nil) then
								
								if(
									(trigger.operator == "<" and obj.scriptlevel < trigger.scriptlevel) or
									(trigger.operator == "<=" and obj.scriptlevel <= trigger.scriptlevel) or
									(trigger.operator == ">" and obj.scriptlevel > trigger.scriptlevel) or
									(trigger.operator == ">=" and obj.scriptlevel >= trigger.scriptlevel) or
									(trigger.operator == "!=" and obj.scriptlevel ~= trigger.scriptlevel) or
								(trigger.operator == "=" and obj.scriptlevel == trigger.scriptlevel)) then
								count = count +1
								end
								
							end
						end
					end
					result = (count == #group.entities)
				end
				
				
				
				
			end
		end
		
		if playerregion then
			if(trigger.name == "position") then
				result = checkPos(curPos, trigger.x, trigger.y,trigger.range)
			end
			if(trigger.name == "3Dposition") then
				result = check3DPos(Game.GetPlayer():GetWorldPosition(), trigger.x, trigger.y, trigger.z, trigger.range)
			end
			if(trigger.name == "stat") then
				--https://nativedb.red4ext.com/gamedataStatType
				local mod_score = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), trigger.value)
				--	debugPrint(1,mod_score)
				if(trigger.score~= nil and tonumber(mod_score) >= tonumber(trigger.score)) then
					result = true
				end
			end
			if(trigger.name == "statpool") then
				--https://nativedb.red4ext.com/gamedataStatPoolType
				local mod_score = Game.GetStatPoolsSystem():GetStatPoolValue(Game.GetPlayer():GetEntityID(), Enum.new('gamedataStatPoolType', trigger.value), trigger.perc)
				--debugPrint(1,mod_score)
				if(trigger.score~= nil and tonumber(mod_score) >= tonumber(trigger.score)) then
					result = true
				end
			end
			if(trigger.name == "item") then
				result = checkItem(trigger.value)
			end
			if(trigger.name == "item_amount") then
				result = checkItemAmount(trigger.value,trigger.score)
			end
			if(trigger.name == "money") then
				result = checkStackableItemAmount("Items.money",trigger.value)
			end
			if(trigger.name == "player_reputation") then
				local score = getScoreKey("player_reputation","Score")
				if(score ~= nil and score >= trigger.score) then
					result = true
				end
			end
			if(trigger.name == "player_inbuilding")then
				result = Game.IsEntityInInteriorArea(Game.GetPlayer())
				--debugPrint(1,result)
			end
			if(trigger.name == "player_in_poi") then
				local resultpos = nil
				resultpos = FindPOI(trigger.tag,trigger.district,trigger.subdistrict,trigger.iscar,trigger.type,trigger.uselocationtag,true,trigger.range)
				if(resultpos ~= nil)then
					result = true
				end
			end
			if(trigger.name == "player_in_metro") then
				result = TakeAIVehicule
			end
			if(trigger.name == "wanted_level") then
				local level = Game.GetBlackboardSystem():Get(Game.GetAllBlackboardDefs().UI_WantedBar):GetInt(Game.GetAllBlackboardDefs().UI_WantedBar.CurrentWantedLevel)
				if level >= trigger.value then
					result =  true
				end
			end
			if(trigger.name == "player_gender") then
				if(trigger.value == GetPlayerGender()) then
					return true
					else
					return false
				end
			end
			if(trigger.name == "player_current_gang") then
				
				local score = getVariableKey("player","current_gang")
				if(score ~= nil and score == trigger.value) then
					result = true
				end
			end
			
		end
		
		if vehiculeregion then
			if(trigger.name == "in_car") then
				local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
				result = inVehicule
			end
			if(trigger.name == "in_car_specific") then
				local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
				if (inVehicule) then
					local vehicule = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
					--debugPrint(1,vehicule:GetDisplayName())
					local isThiscar = (string.find(string.lower(vehicule:GetDisplayName()), trigger.value) ~= nil)
					if isThiscar then
						result = true
					end
				end
			end
			if(trigger.name == "vehicule_is_in_custom_garage") then
				local test = getVehiclefromCustomGarage(trigger.value)
				if(test ~= nil) then
					result = true
				end
			end
		end
		
		if scoreregion then
			if(trigger.name == "npc_star_affinity") then
				local score = 0
				if(currentStar ~= nil) then
					score = getScoreKey(currentStar.Names,"Score")
				end
				if(score ~= nil and score >= trigger.value)then
					result = true
				end
			end
			if(trigger.name == "npc_phone_affinity") then
				local score = 0
				if(currentNPC ~= nil) then
					score = getScoreKey(currentNPC.Names,"Score")
				end
				if(score ~= nil and score >= trigger.value)then
					result = true
				end
			end
			if(trigger.name == "npc_affinity") then
				local score = getScoreKey(trigger.value,"Score")
				if(score ~= nil and score >= trigger.score)then
					result = true
				end
			end
			if(trigger.name == "entity_affinity") then
				local obj = getEntityFromManager(trigger.tag)
				local score = getScoreKey(obj.name,"Score")
				if(score ~= nil and score >= trigger.score)then
					result = true
				end
			end
			if(trigger.name == "custom_condition") then
				local score = getScoreKey(trigger.value,"Score")
				if(score ~= nil and score == trigger.score) then
					result = true
				end
			end
			
			
			if(trigger.name == "check_score") then
				local score = getScoreKey(trigger.value,trigger.key)
				if(score ~= nil ) then
					if(
						(trigger.operator == "<" and score < trigger.score) or
						(trigger.operator == "<=" and score <= trigger.score) or
						(trigger.operator == ">" and score > trigger.score) or
						(trigger.operator == ">=" and score >= trigger.score) or
						(trigger.operator == "!=" and score ~= trigger.score) or
					(trigger.operator == "=" and score == trigger.score)) then
					result = true
					end
				end
			end
			
			
			if(trigger.name == "custom_condition_higher_or_equals") then
				local score = getScoreKey(trigger.value,"Score")
				if(score ~= nil and score >= trigger.score) then
					result = true
				end
			end
			if(trigger.name == "custom_condition_is_between") then
				local score = getScoreKey(trigger.value,"Score")
				if(trigger.strict == true) then
					if(score ~= nil and score > trigger.min and score < trigger.max) then
						result = true
					end
					else
					if(score ~= nil and score >= trigger.min and score <= trigger.max) then
						result = true
					end
				end
			end
			if(trigger.name == "custom_variable") then
				local score = getVariableKey(trigger.variable,trigger.key)
				if(score ~= nil and score == trigger.value) then
					result = true
				end
			end
		end
		
		if houseregion then
			if(trigger.name == "custom_place") then
				if currentHouse ~= nil then
					if(currentHouse.tag == trigger.value)then
						result = true
					end
				end
			end
			if(trigger.name == "is_in_custom_place") then
				if currentHouse ~= nil then
					result = true
				end
			end
			if(trigger.name == "is_in_custom_place_entry") then
				if currentHouse ~= nil then
					result = check3DPos(Game.GetPlayer():GetWorldPosition(), currentHouse.EnterX, currentHouse.EnterY, currentHouse.EnterZ, trigger.range)
				end
			end
			if(trigger.name == "is_in_custom_place_exit") then
				if currentHouse ~= nil then
					result = check3DPos(Game.GetPlayer():GetWorldPosition(), currentHouse.ExitX, currentHouse.ExitY, currentHouse.ExitZ, trigger.range)
				end
			end
			if(trigger.name == "is_in_custom_room") then
				if currentRoom ~= nil then
					result = true
				end
			end
			if(trigger.name == "is_in_buyed_place") then
				if currentHouse ~= nil then
					if(getHouseStatut(currentHouse.tag) ~= nil and getHouseStatut(currentHouse.tag) >= 1) then
						result = true
					end
				end
			end
			if(trigger.name == "is_in_rented_place") then
				if currentHouse ~= nil then
					if(getHouseStatut(currentHouse.tag) ~= nil and getHouseStatut(currentHouse.tag) >= 2) then
						result = true
					end
				end
			end
			if(trigger.name == "place_canbe_buyed") then
				if currentHouse ~= nil then
					local statut = getHouseStatut(currentHouse.tag)
					if(currentHouse.isbuyable == true and getStackableItemAmount("Items.money") > currentHouse.price and (statut == nil or statut < 1)) then
						result = true
					end
				end
			end
			if(trigger.name == "place_canbe_rented") then
				if currentHouse ~= nil then
					local statut = getHouseStatut(currentHouse.tag)
					if(currentHouse.isrentable == true and getStackableItemAmount("Items.money") > (currentHouse.price*currentHouse.coef) and (statut ~= nil and statut == 1)) then
						result = true
					end
				end
			end
			if(trigger.name == "custom_room") then
				if currentRoom ~= nil then
					if(currentRoom.tag == trigger.value)then
						result = true
					end
				end
			end
			if(trigger.name == "custom_place_type") then
				if currentHouse ~= nil then
					if(trigger.value == currentHouse.type) then
						return true
					end
				end
			end
			if(trigger.name == "custom_room_type") then
				if currentRoom ~= nil then
					------debugPrint(1,currentRoom.type[i])
					for i=1,#currentRoom.type do
						------debugPrint(1,currentRoom.type[i])
						if(trigger.value == currentRoom.type[i]) then
							return true
						end
					end
				end
			end
			if(trigger.name == "item_looked_is_registered_in_current_house") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					local entid = objLook:GetEntityID()
					local entity = getItemEntityFromManager(entid)
					if(entity ~= nil) then
						return true
					end
				end
			end
			if(trigger.name == "entity_is_in_custom_place_type") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				if(enti ~= nil and currentHouse ~= nil )then
					if(trigger.value == currentHouse.type) then
						local targetPosition = enti:GetWorldPosition()
						if check3DPos(targetPosition, currentHouse.posX, currentHouse.posX, currentHouse.posZ,currentHouse.range,currentHouse.Zrange) then
							result = true
							else
							result = false
						end
					end
				end
			end
			if(trigger.name == "entity_is_in_custom_room_type") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				if(enti ~= nil and currentRoom ~= nil )then
					local targetPosition = enti:GetWorldPosition()
					if( check3DPos(targetPosition, currentRoom.posX, currentRoom.posX, currentRoom.posZ,currentRoom.range,currentRoom.Zrange)) then
						for i=1,#currentRoom.type do
							
							if(trigger.value == currentRoom.type[i]) then
								return true
							end
						end
					end
					
				end
			end
			if(trigger.name == "item_looked_is_registered") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					local entid = objLook:GetEntityID()
					local entity = getItemEntityFromManager(entid)
					if(entity ~= nil) then
						return true
						else
						entity = getItemEntityFromManagerByPlayerLookinAt()
						if(entity ~= nil) then
							return true
						end
					end
				end
			end
			if(trigger.name == "have_selected_item") then
				if selectedItem ~= nil then
					result =  true
				end
			end
			if(trigger.name == "have_selected_item_can_be_grabbed") then
				if selectedItem ~= nil  and selectedItem.entityId ~= nil and Game.FindEntityByID(selectedItem.entityId)~=nil then
					result = Game.FindEntityByID(selectedItem.entityId):IsA('gameObject') 
				end
			end
		end
		
		if gangregion then
			if(trigger.name == "gang_affinity") then
				local score = 0
				score = getScoreKey(trigger.value,"Score")
				if(score ~= nil and score >= trigger.score)then
					result = true
				end
			end
			if(trigger.name == "entity_looked_is_gangfriendly") then
				if objLook ~= nil then
					result = openCompanion
				end
			end
			if(trigger.name == "entity_looked_gang_score") then
				if objLook ~= nil then
					if(gangscore ~= nil and gangscore == trigger.value) then
						result = true
					end
				end
			end
			if(trigger.name == "entity_looked_is_gang") then
				if lookatgang ~= nil then
					result = true
				end
			end
			if(trigger.name == "entity_looked_is_specific_gang") then
				if lookatgang ~= nil and lookatgang.Tag == trigger.value then
					result = true
				end
			end
			if(trigger.name == "entity_in_faction") then
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				if(enti ~= nil) then
					local targetAttAgent = enti:GetAttitudeAgent()
					local group = Game.NameToString(targetAttAgent:GetAttitudeGroup())
					local npcCurrentName = Game.NameToString(enti:GetCurrentAppearanceName())
					local faction = getFactionByTag(trigger.faction)
					if(faction ~= nil) then
						for y=1,#faction.AttitudeGroup do
							if(string.find(group,faction.AttitudeGroup[y]) ~= nil or string.find(npcCurrentName,faction.AttitudeGroup[y]) ~= nil)then
								result = true
							end
						end
					end
				end
			end
			if(trigger.name == "check_gang_district_score") then
				if 	currentSave.arrayFactionDistrict[trigger.faction][trigger.district] ~= nil then
					if currentSave.arrayFactionDistrict[trigger.faction][trigger.district] >= trigger.value then
						result =  true
					end
				end
			end
			
			if(trigger.name == "check_gang_relation") then
				
				if(trigger.tag == "player") then
					
					trigger.tag = getVariableKey("player","current_gang")
					
				end
				
				if(trigger.tag ~= "") then
					
					if(trigger.mode == "gang") then
						
						
						if(trigger.target ~= trigger.tag ) then
							
							local score = getFactionRelation(trigger.tag,trigger.target)
							if(
								(trigger.operator == "<" and score < trigger.score) or
								(trigger.operator == "<=" and score <= trigger.score) or
								(trigger.operator == ">" and score > trigger.score) or
								(trigger.operator == ">=" and score >= trigger.score) or
								(trigger.operator == "!=" and score ~= trigger.score) or
							(trigger.operator == "=" and score == trigger.score)) then
							result = true
							end
							
							
						end
						
					end
					
					if(trigger.mode == "district_leader" or trigger.mode == "district_subleader") then
						
						local gangs = getGangfromDistrict(trigger.target,20)
						if(#gangs > 0) then
							
							
							
							if(gangs[1].tag ~= trigger.tag) then
								
								local score = getFactionRelation(trigger.tag,gangs[1].tag)
								if(
									(trigger.operator == "<" and score < trigger.score) or
									(trigger.operator == "<=" and score <= trigger.score) or
									(trigger.operator == ">" and score > trigger.score) or
									(trigger.operator == ">=" and score >= trigger.score) or
									(trigger.operator == "!=" and score ~= trigger.score) or
								(trigger.operator == "=" and score == trigger.score)) then
								result = true
								end
								
								
							end
						end
						
						
					end
					
					if(trigger.mode == "current_district_leader") then
						
						if currentDistricts2 ~= nil then
							local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
							if(#gangs > 0) then
								if(gangs[1].tag ~= trigger.tag) then
									
									local score = getFactionRelation(trigger.tag,gangs[1].tag)
									if(
										(trigger.operator == "<" and score < trigger.score) or
										(trigger.operator == "<=" and score <= trigger.score) or
										(trigger.operator == ">" and score > trigger.score) or
										(trigger.operator == ">=" and score >= trigger.score) or
										(trigger.operator == "!=" and score ~= trigger.score) or
									(trigger.operator == "=" and score == trigger.score)) then
									result = true
									end
								end
							end
							
						end
						
					end
					if(trigger.mode == "current_district_subleader") then
						if currentDistricts2 ~= nil then
							if currentDistricts2.districtLabels[2] ~= nil then
								local gangs = getGangfromDistrict(currentDistricts2.districtLabels[2],20)
								if(#gangs > 0) then
									
									if(gangs[1].tag ~= trigger.tag) then
										
										local score = getFactionRelation(trigger.tag,gangs[1].tag)
										if(
											(trigger.operator == "<" and score < trigger.score) or
											(trigger.operator == "<=" and score <= trigger.score) or
											(trigger.operator == ">" and score > trigger.score) or
											(trigger.operator == ">=" and score >= trigger.score) or
											(trigger.operator == "!=" and score ~= trigger.score) or
										(trigger.operator == "=" and score == trigger.score)) then
										result = true
										end
									end
								end
							end
							
						end
						
					end
					
					
				end
				
				
				
			end
			
			
			if(trigger.name == "last_killed_entity_is_in_specific_gang") then
				if lastTargetKilled ~= nil then
					local killComp, killGangScore, killGang = checkAttitudeByGangScore(lastTargetKilled)
					
					if killGang ~= nil and killGang.Tag == trigger.value then
						result = true
					end
				end
			end
			
			if(trigger.name == "last_killed_entity") then
				if lastTargetKilled ~= nil then
					result = true
				end
				
			end
			
			if(trigger.name == "last_killed_entity_is_in_gang") then
				if lastTargetKilled ~= nil then
					local killComp, killGangScore, killGang = checkAttitudeByGangScore(lastTargetKilled)
					if killGang ~= nil then
						result = true
					end
				end
			end
			
			
			if(trigger.name == "last_killed_entity_gang_score") then
				if lastTargetKilled ~= nil then
					local killComp, killGangScore, killGang = checkAttitudeByGangScore(lastTargetKilled)
					if(killGangScore ~= nil) then
						if(
							(trigger.operator == "<" and killGangScore < trigger.score) or
							(trigger.operator == "<=" and killGangScore <= trigger.score) or
							(trigger.operator == ">" and killGangScore > trigger.score) or
							(trigger.operator == ">=" and killGangScore >= trigger.score) or
							(trigger.operator == "!=" and killGangScore ~= trigger.score) or
						(trigger.operator == "=" and killGangScore == trigger.score)) 
						then
						result = true
						end
					end
				end
			end
			
		end
		
		if miscregion then
			if(trigger.name == "auto")then
				result = true
			end
			if(trigger.name == "time") then
				local currentime = tonumber(getGameTimeHHmm())
				----debugPrint(1,"currentime "..currentime)
				if(tonumber(currentime) >= tonumber(trigger.min) and tonumber(currentime) <= tonumber(trigger.max)) then
					result = true
				end
			end
			if(trigger.name == "os_time") then
				local currentime =  getOsTimeHHmm()
				----debugPrint(1,"currentime "..currentime)
				local times = currentime.hour*100 + currentime.min
				if(tonumber(times) >= tonumber(trigger.min) and tonumber(times) <= tonumber(trigger.max)) then
					result = true
				end
			end
			if(trigger.name == "os_date") then
				local currentime =  getOsTimeHHmm()
				----debugPrint(1,"currentime "..currentime)
				if((tonumber(currentime.month) == tonumber(trigger.month) or trigger.month == "") and (tonumber(currentime.day) == tonumber(trigger.day)) or trigger.day == "")  and (tonumber(currentime.year) == tonumber(trigger.year) or trigger.year == "") then
					result = true
				end
			end
			if(trigger.name == "check_setting") then
				local score = 0
				score = getUserSetting(trigger.value)
				if(score ~= nil and score == trigger.score)then
					result = true
				end
			end
			if(trigger.name == "debug") then
				result = questMod.debug
			end
			if(trigger.name == "current_district") then
				if currentDistricts2 ~= nil and currentDistricts2.customdistrict ~= nil then
					if(string.lower(currentDistricts2.customdistrict.EnumName) == string.lower(trigger.value))then 
						--debugPrint(1,"district OK")
						result =  true
					end
				end
			end
			if(trigger.name == "current_subdistrict") then
				if currentDistricts2 ~= nil then
					if(currentDistricts2.districtLabels~=nil)then
						for i, subd in ipairs(currentDistricts2.districtLabels) do
							if i > 1 then
								if(string.lower(subd) == string.lower(trigger.value))then 
									--debugPrint(1,"subdistrict OK")
									result =  true
								end
							end
						end
					end
				end
			end
			if(trigger.name == "salary_is_possible") then
				return SalaryIsPossible
			end
			if(trigger.name == "have_custom_mappin_placed") then
				if(ActivecustomMappin ~= nil) then
					result =  true
				end
			end
			if(trigger.name == "have_fasttravel_mappin_placed") then
				debugPrint(1,"test")
				if(ActiveFastTravelMappin ~= nil) then
					result =  true
					debugPrint(1,"toto"..dump(ActiveFastTravelMappin))
				end
			end
			if(trigger.name == "event_is_finished") then
				if(workerTable[trigger.tag] == nil ) then 
					return true
					else
					return false
				end
			end
			
			if(trigger.name == "event_exist") then
				if(workerTable[trigger.tag] ~= nil ) then 
					return true
					else
					return false
				end
			end
			if(trigger.name == "metro_time_is_finished") then
				if MetroCurrentTime <=0 and activeMetroDisplay == false then
					return true
					else
					return false
				end
			end
			if(trigger.name == "area_security_level") then
				local level = FromVariant(GetPlayer():GetPlayerStateMachineBlackboard():GetVariant(GetAllBlackboardDefs().PlayerStateMachine.SecurityZoneData))
				if level == trigger.value then
					result =  true
				end
			end
			if(trigger.name == "is_recording_mode_active") then
				if recordingMode then
					result =  true
				end
			end
		end
		
		if relationregion then
			if(trigger.name == "current_phoned_npc_is_defined") then
				if(currentNPC ~= nil) then
					result = true
				end
			end
			
			if(trigger.name == "current_phoned_npc_name") then
				if(currentNPC ~= nil) then
					
					if(currentNPC.Names == trigger.value) then
						result = true
					end
				end
			end
			
			if(trigger.name == "current_star_name") then
				if(currentStar ~= nil) then
					
					if(currentStar.Names == trigger.value) then
						result = true
					end
				end
			end
		end
		
		if questregion then
			if(trigger.name == "quest_fact") then
				isquestok =Game.GetQuestsSystem():GetFactStr(trigger.value)
				if(isquestok == 1)then
					result = true
				end
			end
			if(trigger.name == "mission_fact") then
				local score = getScoreKey(trigger.value,"Score")
				if(score ~= nil and score == 1) then
					result = true
				end
			end
		end
		
		if noderegion then
			if(trigger.name == "entity_is_in_node") then
				local founded = false
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					for k,v in pairs(arrayNode) do
						local location = v.node
						local range = 50
						if(trigger.range ~= nil) then
							range = trigger.range
						end
						if(founded == false)then
							if(trigger.atgameplayposition) then
								result = check3DPos(enti:GetWorldPosition(), location.GameplayX, location.GameplayY, location.GameplayZ, range)
								else
								result = check3DPos(enti:GetWorldPosition(), location.X, location.Y, location.Z, range)
							end
							if result == true and(trigger.sorttag == nil or (trigger.sorttag == location.sort)) then
								result = true
								founded = true
								if(trigger.tag == "player") then
									currentPlayerNode = location
								end
								break
							end
						end
					end
				end
				if(result == false) then
					currentPlayerNode =  nil
				end
			end
			if(trigger.name == "entity_is_in_specific_node") then
				local founded = false
				local obj = getEntityFromManager(trigger.tag)
				local enti = Game.FindEntityByID(obj.id)	
				local node = getNode(trigger.node)
				--debugPrint(1,"check for node"..node.tag)
				if(enti ~= nil) then
					--debugPrint(1,"check for entity"..trigger.tag)
					local location = node
					if(founded == false)then
						local range = 25
						if(trigger.range ~= nil) then
							range = trigger.range
						end
						if(trigger.atgameplayposition) then
							result = check3DPos(enti:GetWorldPosition(), location.GameplayX, location.GameplayY, location.GameplayZ, range)
							else
							result = check3DPos(enti:GetWorldPosition(), location.X, location.Y, location.Z, range)
						end
						if result == true then
							result = true
							founded = true
						end
					end
				end
			end
			if(trigger.name == "entity_path_is_finish") then
				local founded = false
				local obj = getEntityFromManager(trigger.tag)
				if(obj.path ~= nil) then
					result = obj.path.finish
					else
					result = true
				end
			end
			if(trigger.name == "is_arrived_to_destination") then
				local obj = getEntityFromManager(trigger.tag)
				--debugPrint(1,obj.tag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local targetPosition = enti:GetWorldPosition()
					if obj.destination ~= nil then
						debugPrint(1,obj.destination.x)
						debugPrint(1,obj.destination.y)
						debugPrint(1,obj.destination.z)
						if check3DPos(targetPosition, obj.destination.x, obj.destination.y, obj.destination.z,trigger.range) then
							result = true
							else
							result = false
						end
						else
						--debugPrint(1,"entity not found : "..trigger.tag)
						result = false
					end
				end
			end
		end
		
		if soundregion then
			if(trigger.name == "gameVolume") then 
				if (GetSoundSettingValue(trigger.value) >= trigger.score) then
					result =  true
				end
			end
			if(trigger.name == "soundmanager_isplaying") then
				--debugPrint(1,"soundmanager_isplaying "..tostring(IsPlaying(trigger.channel)))
				if IsPlaying(trigger.channel) == true then
					result =  true
				end
			end
		end
		
		if logicregion then
			if(trigger.name == "compare") then
				local res = checkTrigger(trigger.trigger)
				--debugPrint(1,tostring(res))
				result = (res == trigger.expected)
				--debugPrint(1,tostring(result))
			end
			if(trigger.name == "testFor") then
				local count = 0
				for i=1, #trigger.triggers do 
					local trig = trigger.triggers[i]
					local rs = checkTrigger(trig)
					if(rs == true ) then
						count = count +1
					end
				end
				if(trigger.logic == "or") then
					--debugPrint(1,tostring(count >=1))
					result = (count >=1 )
					else
					result = (count == #trigger.triggers)
				end
			end
		end
		
		if uiregion then
			if(trigger.name == "dialog_windows_isopen") then
				if(trigger.window == "quest")then
					--debugPrint(1,"opo")
					if(tostring(openQuestDialogWindow) ==  string.lower(tostring(trigger.value))) then 
						return true
					end
				end
				if(trigger.window == "speak")then
					if(tostring(openSpeakDialogWindow) ==  string.lower(tostring(trigger.value))) then 
						return true
					end
				end
				if(trigger.window == "phone")then
					if(tostring(openPhoneDialogWindow) ==  string.lower(tostring(trigger.value)	)) then 
						--debugPrint(1,openPhoneDialogWindow)
						return true
					end
				end
				if(trigger.window == "event")then
					if(tostring(openEventDialogWindow) ==  string.lower(tostring(trigger.value))) then 
						return true
					end
				end
			end
			if(trigger.name == "housing_edit_enable") then
				result =  inEditMode
			end
			if(trigger.name == "crew_menu_enable") then
				result =  inCrewManager
			end
			if(trigger.name == "timer_is_finished") then
				if(currentTimer ~= nil) then
					
					if( tick > currentTimer.time) then
						
						
						result = true
						
					end
					
					
				end
			end
			if(trigger.name == "interact_is_inprogress") then
				return actionistaken
			end
			if(trigger.name == "is_in_menu") then
				return inMenu
			end
			if(trigger.name == "is_in_specific_menu") then
				if(inMenu and ActiveMenu == trigger.menu)then
					return true
					else
					return false
				end
			end
			if(trigger.name == "texture_is_visible") then
				result = (currentLoadedTexture[trigger.tag] ~= nil)
			end
		end
		
		if avregion then
			if(trigger.name == "player_is_in_av") then
				local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
				if (inVehicule) then
					local vehicule = Game.GetMountedVehicle(Game.GetPlayer())
					if(vehicule ~=nil) then
						local entid = vehicule:GetEntityID()
						local entity = getEntityFromManagerById(entid)
						if(entity ~= nil and entity.isAV ~= nil) then
							result = entity.isAV
						end
					end
				end
			end
			if(trigger.name == "entity_looked_is_custom_av") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					--debugPrint(1,appName)
					local entid = objLook:GetEntityID()
					local entity = getEntityFromManagerById(entid)
					if(entity ~= nil) then
						--debugPrint(1,"lloo")
						local garagVeh = getVehiclefromCustomGarageTag(entity.tag)
						if(garagVeh ~= nil and garagVeh.asAV == true or entity.tag == "fake_av") then
							return true
						end
					end
				end
			end
		end
		
		if customnpcregion then
		end
		
		if multiregion then
			if(trigger.name == "entity_looked_is_registered_as_player") then
				if objLook ~= nil then
					tarName = objLook:ToString()
					appName = Game.NameToString(objLook:GetCurrentAppearanceName())
					dipName = objLook:GetDisplayName()
					local entity = getEntityFromManagerById(objLook:GetEntityID())
					if(entity ~= nil and entity.id ~= nil) then
						if(entity.isMP ~= nil and entity.isMP == true) then
							return true
							else
							multiName = ""
						end
						else
						multiName = ""
					end
					else
					multiName = ""
				end
			end
			if(trigger.name == "player_corpo_faction") then
				if currentFaction ~= nil or currentFaction ~= "" then
					if currentFaction == trigger.value then
						result =  true
					end
				end
			end
			if(trigger.name == "player_corpo_faction_rank") then
				if currentFactionRank ~= nil or currentFactionRank ~= "" then
					if currentFactionRank == trigger.value then
						result =  true
					end
				end
			end
			if(trigger.name == "player_is_online") then
				result =  multiReady
			end
			if(trigger.name == "player_is_connected") then
				result =  multiEnabled
				
			end
			if(trigger.name =="player_multi_canbuild")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil) then
					result = ActualPlayerMultiData.instance.CanBuild
				end
			end 
			if(trigger.name =="player_multi_isowner")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil) then
					result = ActualPlayerMultiData.instance.isInstanceOwner
				end
			end 
			if(trigger.name =="player_multi_guild_isowner")then
				
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.currentGuild ~= nil) then
					result = ActualPlayerMultiData.currentGuild.isOwner
				end
			end 
			if(trigger.name == "player_multi_in_buildable_place") then
				if (ActualPlayerMultiData ~= nil and ActualPlayerMultiData.currentPlaces[1] ~= nil) then
					result = true
				end
			end
			if(trigger.name == "have_selected_item_multi") then
				if selectedItemMulti ~= nil then
					result =  true
				end
			end
			if(trigger.name == "have_selected_item_can_be_grabbed_multi") then
				if selectedItemMulti ~= nil  and selectedItemMulti.entityId ~= nil then
					pcall(function()
						result = Game.FindEntityByID(selectedItemMulti.entityId):IsA('gameObject') 
					end)
				end
			end
			if(trigger.name =="player_server_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.scores[trigger.value]
					if(score ~= nil) then
						if(
							(trigger.operator == "<" and score < trigger.score) or
							(trigger.operator == "<=" and score <= trigger.score) or
							(trigger.operator == ">" and score > trigger.score) or
							(trigger.operator == ">=" and score >= trigger.score) or
							(trigger.operator == "!=" and score ~= trigger.score) or
						(trigger.operator == "=" and score == trigger.score)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="looked_player_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.instance_players[multiName].score[trigger.value]
					if(score ~= nil) then
						if(
							(trigger.operator == "<" and score < trigger.score) or
							(trigger.operator == "<=" and score <= trigger.score) or
							(trigger.operator == ">" and score > trigger.score) or
							(trigger.operator == ">=" and score >= trigger.score) or
							(trigger.operator == "!=" and score ~= trigger.score) or
						(trigger.operator == "=" and score == trigger.score)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="server_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.instance.scores[trigger.value]
					if(score ~= nil) then
						if(
							(trigger.operator == "<" and score < trigger.score) or
							(trigger.operator == "<=" and score <= trigger.score) or
							(trigger.operator == ">" and score > trigger.score) or
							(trigger.operator == ">=" and score >= trigger.score) or
							(trigger.operator == "!=" and score ~= trigger.score) or
						(trigger.operator == "=" and score == trigger.score)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="server_score_to_player_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.instance.scores[trigger.server]
					local playerscore = ActualPlayerMultiData.scores[trigger.player]
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="server_score_to_looked_player_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.instance.scores[trigger.server]
					local playerscore = ActualPlayerMultiData.instance_players[multiName].score[trigger.value]
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="server_score_to_server_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.instance.scores[trigger.server]
					local playerscore = ActualPlayerMultiData.instance.scores[trigger.score]
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="server_score_to_game_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
					local score = ActualPlayerMultiData.instance.scores[trigger.server]
					local playerscore = getScoreKey(trigger.score,"Score")
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="guild_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.guildscores ~= nil) then
					local score = ActualPlayerMultiData.guildscores[trigger.guild][trigger.guildscore]
					if(score ~= nil) then
						if(
							(trigger.operator == "<" and score < trigger.score) or
							(trigger.operator == "<=" and score <= trigger.score) or
							(trigger.operator == ">" and score > trigger.score) or
							(trigger.operator == ">=" and score >= trigger.score) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == trigger.score)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="guid_score_to_server_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil and ActualPlayerMultiData.guildscores ~= nil) then
					local playerscore = ActualPlayerMultiData.instance.Scores[trigger.server]
					local score = ActualPlayerMultiData.guildscores[trigger.guild][trigger.guildscore]
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="guild_score_to_player_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil and ActualPlayerMultiData.guildscores ~= nil) then
					local score =  ActualPlayerMultiData.guildscores[trigger.guild][trigger.guildscore]
					local playerscore = ActualPlayerMultiData.scores[trigger.player]
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="guild_score_to_looked_player_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil and ActualPlayerMultiData.guildscores ~= nil) then
					local score =  ActualPlayerMultiData.guildscores[trigger.guild][trigger.guildscore]
					local playerscore = ActualPlayerMultiData.instance_players[multiName].score[trigger.value]
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end 
			if(trigger.name =="guild_score_to_game_score")then
				if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.guildscores ~= nil) then
					local score =  ActualPlayerMultiData.guildscores[trigger.guild][trigger.guildscore]
					local playerscore = getScoreKey(trigger.score,"Score")
					if(score ~= nil and playerscore ~= nil) then
						if(
							(trigger.operator == "<" and score < playerscore) or
							(trigger.operator == "<=" and score <= playerscore) or
							(trigger.operator == ">" and score > playerscore) or
							(trigger.operator == ">=" and score >= playerscore) or
							(trigger.operator == "!=" and score ~= playerscore) or
						(trigger.operator == "=" and score == playerscore)) then
						result = true
						end
					end
				end
			end
		end
		
		if frameworkregion then
			if(trigger.name =="datapack_is_enabled")then
				if( arrayDatapack[trigger.tag] ~= nil and  arrayDatapack[trigger.tag].enabled == true) then
					
					result = true
					
				end
			end
			
			if(trigger.name =="datapack_version")then
				
				local localversion = arrayDatapack[trigger.tag].metadata.version
				result = checkVersionNumber(localversion,trigger.value)
			end
			
			if(trigger.name =="datapack_is_outdated")then
				
				local serverversion = "0.0.0"
				
				for i = 1,#arrayDatapack3  do
					
					local datapack = arrayDatapack3[i]
					if(datapack.tag == trigger.tag) then
						serverversion = datapack.version
					end
					
				end
				local localversion = arrayDatapack[trigger.tag].metadata.version
				result = checkVersionNumber(localversion,serverversion)
				
			end
			
			if(trigger.name =="mod_is_outdated")then
				if(CurrentServerModVersion.version ~= "unknown" and CurrentServerModVersion.version ~= "0.16000069" and checkVersionNumber(questMod.version,CurrentServerModVersion.version))then
					result = true
				end
			end
			
		end
		
	end
	return result
end


--execute actions core function
function executeAction(action,tag,parent,index,source,executortag)
	local result = true
	actionistaken = true
	if(action.tag == "this") then
		action.tag = executortag
	end
	
	
	
	local entityregion = true
	local groupregion = true
	local vehiculeregion = true
	local scoreregion = true
	local houseregion = true
	local gangregion = true
	local miscregion = true
	local relationregion = true
	local questregion = true
	local noderegion = true
	local soundregion = true
	local logicregion = true
	local uiregion = true
	local avregion = true
	local customnpcregion = true
	local multiregion = true
	local framework = true
	local scene = true
	
	
	if groupregion then
		if(action.name == "create_group") then
			local group = {}
			group.tag = action.tag
			group.entities = {}
			table.insert(questMod.GroupManager,group)
			debugPrint(1,"group created")
		end
		if(action.name == "add_entity_to_group") then
			local index =getIndexFromGroupManager(action.tag)
			for i=1, #action.entities do
				table.insert(questMod.GroupManager[index].entities,action.entities[i])
			end
		end
		if(action.name == "set_entity_to_group") then
			local index =getIndexFromGroupManager(action.tag)
			questMod.GroupManager[index].entities = action.entities
		end
		if(action.name == "despawn_group") then
			local group =getGroupfromManager(action.tag)
			if group ~= nil then
				for i=1, #group.entities do 
					local entityTag = group.entities[i]
					--despawnEntity(entiTab.spawnlevel)
					despawnEntity(entityTag)
					--questMod.EntityManager[group[i]] = nil
				end
			end
		end
		if(action.name == "remove_group") then
			local index =getIndexFromGroupManager(action.tag)
			if index ~= nil then
				table.remove(questMod.GroupManager,index)
			end
		end
		if(action.name == "remove_entity_from_group") then
			local index =getIndexFromGroupManager(action.tag)
			for i=1, #questMod.GroupManager[index].entities do 
				local entityTag = questMod.GroupManager[index].entities[i]
				for y=1, action.entities do
					if(entityTag == action.entities[y]) then
						table.remove(questMod.GroupManager[index].entities,i)
					end
				end
			end
		end
		if(action.name == "move_group_at_position") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local positionVec4 = {}
					positionVec4.x = action.x
					positionVec4.y = action.y
					positionVec4.z = action.z
					positionVec4.w = 1
					positionVec4.x =  positionVec4.x + i
					MoveTo(enti, positionVec4, 1, action.move)
				end
			end
		end
		if(action.name == "move_group_at_relative_position") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local positionVec4 = enti:GetWorldPosition()
					positionVec4.x = positionVec4.x + action.x
					positionVec4.y = positionVec4.y + action.y
					positionVec4.z = positionVec4.z + action.z
					positionVec4.x =  positionVec4.x + i
					MoveTo(enti, positionVec4, 1, action.move)
				end
			end
		end
		if(action.name == "move_group_at_entity_relative_position") then
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			if(action.entity ~= "player") then 
				local obj2 = getEntityFromManager(action.entity)
				local enti2 = Game.FindEntityByID(obj2.id)
				positionVec4 = enti2:GetWorldPosition()
			end
			positionVec4.x = positionVec4.x + action.x
			positionVec4.y = positionVec4.y + action.y
			positionVec4.z = positionVec4.z + action.z	
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					positionVec4.x =  positionVec4.x + i
					MoveTo(enti, positionVec4, 1, action.move)
				end
			end
		end
		if(action.name == "teleport_group_at_position") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local isplayer = false
				if entityTag == "player" then
					isplayer = true
				end
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					--debugPrint(1,"moveit")
					teleportTo(enti, Vector4.new( action.x+i, action.y, action.z,1), 1,isplayer)
				end
			end
		end
		if(action.name == "teleport_group_at_relative_position") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local isplayer = false
				if entityTag == "player" then
					isplayer = true
				end
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local positionVec4 = enti:GetWorldPosition()
					positionVec4.x = positionVec4.x + action.x
					positionVec4.y = positionVec4.y + action.y
					positionVec4.z = positionVec4.z + action.z
					teleportTo(enti, Vector4.new( positionVec4.x+i, positionVec4.y, positionVec4.z,1), 1,isplayer)
				end
			end
		end
		if(action.name == "teleport_group_at_entity_relative_position") then
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			if(action.entity ~= "player") then 
				local obj2 = getEntityFromManager(action.entity)
				local enti2 = Game.FindEntityByID(obj2.id)
				positionVec4 = enti2:GetWorldPosition()
			end
			positionVec4.x = positionVec4.x + action.x
			positionVec4.y = positionVec4.y + action.y
			positionVec4.z = positionVec4.z + action.z
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local isplayer = false
				if entityTag == "player" then
					isplayer = true
				end
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					positionVec4.x = positionVec4.x + i
					teleportTo(enti, positionVec4, 1,isplayer)
				end
			end
		end
		if(action.name == "attitude_group_against_entity") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				if action.attitude == "hostile" then
					setAggressiveAgainst(entityTag, action.entity)
				end
				if action.attitude == "passive"   then
					setPassiveAgainst(entityTag, action.entity)
				end
				if action.attitude == "companion"   then
					setFollower(entityTag)
				end
				if action.attitude == "friendly"   then
					setFriendAgainst(entityTag, action.entity)
				end
				if action.attitude == "psycho" then
					setPsycho(entityTag, action.entity)
				end
			end
		end
		if(action.name == "attitude_group_against_group") then
			if action.attitude == "hostile" then
				setAggressiveAgainstAttitudeGroup(action.tag, action.target, action.attitudegroup, action.attitudegrouptarget)
			end
			if action.attitude == "passive" then
				setPassiveAgainstAttitudeGroup(action.tag, action.target, action.attitudegroup, action.attitudegrouptarget)
			end
		end
		if(action.name == "play_group_voice") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					talk(enti,action.voice)
				end
			end
		end
		if(action.name == "play_group_facial") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				local reaction = {}
				reaction.category = action.category
				reaction.idle = action.idle
				if(enti ~= nil) then
					makeFacial(enti,reaction)
				end
			end
		end
		if(action.name == "reset_group_facial") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					resetFacial(enti)
				end
			end
		end
		if(action.name == "look_at_player_group") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					lookAtPlayer(enti)
				end
			end
		end
		if(action.name == "look_at_entity_group") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					if(action.entity == "player") then
						lookAtPlayer(enti)
						else
						lookAtEntity(enti,action.entity)
					end
				end
			end
		end
		if(action.name == "execute_at_script_level_group") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					if(obj.scriptlevel == nil or obj.scriptlevel <= action.scriptlevel) then
						
						runSubActionList(action.action, "execute_at_level_"..math.random(1,99999), tag,source,false,obj.tag)
						
					end
				end
			end
			
		end
		
		if(action.name == "set_script_level_group") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					obj.scriptlevel = action.scriptlevel 
				end
			end
			
		end
		
	end
	
	if vehiculeregion then
		if(action.name == "spawn_vehicule") then
			spawnVehicle(action.value,action.from_behind,action.as_garage,action.as_av)
		end
		if(action.name == "spawn_vehicule_v2") then
			local chara = ""
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(action.source == "random") then
					local indexchara = math.random(1,#arrayVehicles)
					chara = arrayVehicles[indexchara]
				end
				if(action.source == "from_list") then
					local indexchara = math.random(1,#action.source_list)
					chara = action.source_list[indexchara]
				end
				if(action.source == "vehicle") then
					chara = action.source_tag
				end
				if(action.source == "faction") then
					local gang = getFactionByTag(action.source_tag)
					if(action.source_use_rival == true) then
						gang = getFactionByTag(gang.Rivals[1])
					end
					if(#gang.SpawnableVehicule > 0) then
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
					end
				end
				if(action.source == "district_leader" or action.source == "subdistrict_leader") then
					local gangs = getGangfromDistrict(action.source_tag,20)
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						if(action.source_use_rival == true) then
							gang = getFactionByTag(gang.Rivals[1])
						end
						if(#gang.SpawnableVehicule > 0) then
							local index = math.random(1,#gang.SpawnableVehicule)
							chara = gang.SpawnableVehicule[index]
						end
					end
				end
				if(action.source == "current_district_leader") then
					local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						if(action.source_use_rival == true) then
							gang = getFactionByTag(gang.Rivals[1])
						end
						if(#gang.SpawnableVehicule > 0) then
							local index = math.random(1,#gang.SpawnableVehicule)
							chara = gang.SpawnableVehicule[index]
						end
					end
				end
				if(action.source == "current_subdistrict_leader") then
					local gangs = {}
					for j, test in ipairs(currentDistricts2.districtLabels) do
						if j > 1 then
							gangs = getGangfromDistrict(test,20)
							if(#gangs > 0) then
								break
							end
						end
					end
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						
						if(action.source_use_rival == true) then
							gang = getFactionByTag(gang.Rivals[1])
						end
						
						if(#gang.SpawnableVehicule > 0) then
							local index = math.random(1,#gang.SpawnableVehicule)
							chara = gang.SpawnableVehicule[index]
						end
						
					end
				end
				
				if(action.source == "district_rival" or action.source == "subdistrict_rival") then
					
					if(action.source_gang == "player") then
						
						action.source_gang = getVariableKey("player","current_gang")
						
					end
					
					local gangs = getGangRivalfromDistrict(action.source_gang,action.source_tag,20)
					
					
					
					if(#gangs > 0) then
						
						
						local gang = getFactionByTag(gangs[1].tag)
						
						if(#gang.SpawnableVehicule > 0) then
							local index = math.random(1,#gang.SpawnableVehicule)
							chara = gang.SpawnableVehicule[index]
						end
					end
				end
				if(action.source == "current_district_rival") then
					
					if(action.source_gang == "player") then
						
						action.source_gang = getVariableKey("player","current_gang")
						
					end
					
					local gangs = getGangRivalfromDistrict(action.source_gang,currentDistricts2.Tag,20)
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						
						if(#gang.SpawnableVehicule > 0) then
							local index = math.random(1,#gang.SpawnableVehicule)
							chara = gang.SpawnableVehicule[index]
						end
					end
				end
				if(action.source == "current_subdistrict_rival") then
					
					if(action.source_gang == "player") then
						
						action.source_gang = getVariableKey("player","current_gang")
						
					end
					
					
					local gangs = {}
					for j, test in ipairs(currentDistricts2.districtLabels) do
						if j > 1 then
							gangs = getGangRivalfromDistrict(action.source_gang,test,20)
							if(#gangs > 0) then
								break
							end
						end
					end
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						
						if(#gang.SpawnableVehicule > 0) then
							local index = math.random(1,#gang.SpawnableVehicule)
							chara = gang.SpawnableVehicule[index]
						end
					end
				end
				
				local tag = action.tag
				if(action.amount > 1) then
					tag = action.tag.."_"..i
				end
				local position = {}
				if(action.position == "at") then
					position.x = action.x
					position.y = action.y
					position.z = action.z
				end
				if(action.position == "relative_to_entity") then
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.position_tag ~= "player") then
						local obj = getEntityFromManager(action.position_tag)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position_way ~= nil and (action.position_way ~= "" or action.position_way ~= "normal")) then
						if(action.position_way == "behind") then
							positionVec4 = getBehindPosition(entity,action.position_distance)
						end
						if(action.position_way == "forward") then
							positionVec4 = getForwardPosition(entity,action.position_distance)
						end
					end
					position = positionVec4
				end
				if(action.position == "node") then
					local node = getNode(action.position_tag)
					if node ~= nil then
						if(action.position_node_usegameplay == true) then
							position.x = node.GameplayX
							position.y = node.GameplayY
							position.z = node.GameplayZ
							else
							position.x = node.X
							position.y = node.Y
							position.z = node.Z
						end
						else
						error("can't find an node who have tag : "..action.position_tag)
					end
				end
				if(action.position == "current_node") then
					local position = Game.GetPlayer():GetWorldPosition()
					local range = 70
					if(action.position_node_current_detection_range ~= nil) then
						range = action.position_node_current_detection_range
					end
					local node = getNodefromPosition(position.x,position.y,position.z,range)
					if node ~= nil then
						if(action.position_node_usegameplay == true) then
							position.x = node.GameplayX
							position.y = node.GameplayY
							position.z = node.GameplayZ
							else
							position.x = node.X
							position.y = node.Y
							position.z = node.Z
						end
						else
						error("can't find an current node")
					end
				end
				if(action.position == "poi") then
					local currentpoi = nil
					currentpoi = FindPOI(action.position_tag,action.position_poi_district,action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
					if(currentpoi ~= nil) then
						position.x = currentpoi.x
						position.y = currentpoi.y
						position.z = currentpoi.z
						else
						print("can't find an current poi")
						spdlog.error("can't find an current poi . data :"..tostring(dump(action)).." tag "..tag.." parent "..parent.." index "..index)
					end
				end
				if(action.position == "mappin") then
					local mappin = getMappinByTag(action.position_tag)
					if(mappin)then
						position = mappin.position
						else
						error("can't find an mappin with tag : "..action.position_tag)
					end
				end
				if(action.position == "fasttravel") then
					local markerref = nil
					local tempos = nil
					for j=1, #mappedFastTravelPoint do
						local point = mappedFastTravelPoint[j]
						if(point.markerref == action.position_tag) then
							markerref = point.markerrefdata
							tempos = point.position
							break
						end
					end
					if(markerref)then
						position = tempos
						else
						error("can't find an fast travel point with tag : "..action.position_tag)
					end
				end
				if(action.position == "current_fasttravel") then
					if(ActiveFastTravelMappin ~= nil)then
						position = ActiveFastTravelMappin.position
						else
						error("can't find an current fast travel point ")
					end
				end
				if(action.position == "current_custom_mappin") then
					if(ActivecustomMappin ~= nil)then
						local mappin = ActivecustomMappin:GetWorldPosition()
						position.x = mappin.x
						position.y = mappin.y
						position.z = mappin.z
						else
						error("can't find an current custom point ")
					end
				end
				if(action.position == "custom_place") then
					local house = getHouseByTag(action.position_tag)
					if(house ~= nil) then
						if(action.position_house_way == "default") then
							position.x = house.posX
							position.y = house.posY
							position.z = house.posZ
						end
						if(action.position_house_way == "enter") then
							position.x = house.EnterX
							position.y = house.EnterY
							position.z = house.EnterZ
						end
						if(action.position_house_way == "exit") then
							position.x = house.ExitX
							position.y = house.ExitY
							position.z = house.ExitZ
						end
						else
						error("can't find an custom place with tag : "..action.position_tag)
					end
				end
				if(action.position == "custom_room") then
					local room = getRoomByTag(action.position_tag,action.position_house_tag)
					if(room ~= nil) then
						position.x = room.posX
						position.y = room.posY
						position.z = room.posZ
						else
						error("can't find an custom room with tag : "..action.position_tag.." for the house with tag :"..action.position_house_tag)
					end
				end
				if(action.position == "current_custom_place") then
					if(currentHouse ~= nil) then
						if(action.position_house_way == "default") then
							position.x = currentHouse.posX
							position.y = currentHouse.posY
							position.z = currentHouse.posZ
						end
						if(action.position_house_way == "Enter") then
							position.x = currentHouse.EnterX
							position.y = currentHouse.EnterY
							position.z = currentHouse.EnterZ
						end
						if(action.position_house_way == "Exit") then
							position.x = currentHouse.ExitX
							position.y = currentHouse.ExitY
							position.z = currentHouse.ExitZ
						end
						else
						error("can't find an current custom place")
					end
				end	
				if(action.position == "current_custom_room") then
					if(currentRoom ~= nil) then
						position.x = currentRoom.posX
						position.y = currentRoom.posY
						position.z = currentRoom.posZ
						else
						error("can't find an current custom room")
					end				
				end
				if(action.position ~= "at" and position.x ~= nil) then
					position.x = position.x + action.x
					position.y = position.y + action.y
					position.z = position.z + action.z
					else
					
					if(position.x == nil) then
						error("position is empty")
					end
				end
				if(chara ~= "" and position.x ~= nil) then
					spawnVehicleV2(chara,action.appearance,tag, position.x, position.y ,position.z,action.spawnlevel,action.spawn_system,action.isAV,action.appears_from_behind,false,action.wait_for_vehicle, action.scriptlevel)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						if(index == nil and action.create_group_if_not_exist == true) then
							local group = {}
							group.tag = action.group
							group.entities = {}
							table.insert(questMod.GroupManager,group)
							debugPrint(1,"group created")
							index =getIndexFromGroupManager(action.group)
						end
						if(index ~= nil) then
							table.insert(questMod.GroupManager[index].entities,tag)
							else
							debugPrint(1,"group with tag : "..action.group.." doesn't exist")
						end
					end
					else
					print("can't find an vehicule")
				end
			end
		end
		if(action.name == "entity_set_seat") then
			SetSeat(action.tag, action.vehicle, true, action.seat)
		end
		if(action.name == "entity_set_seat_looked_av") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local entity = getEntityFromManagerById(entid)
				if(entity ~= nil) then
					local garagVeh = getVehiclefromCustomGarageTag(entity.tag)
					if(garagVeh ~= nil and garagVeh.asAV == true) then
						SetSeat(action.tag, entity.tag, true, action.seat)
					end
				end
			end
		end
		if(action.name == "set_vehicule_to_garage") then
			SetVehiculeToGarage(action.tweakid,action.enabled,action.asAV,action.tag,action.fakeAV)
		end
		if(action.name == "entity_unset_seat") then
			UnsetSeat(action.tag, action.waitforsit,action.seat)
		end
		if(action.name == "vehicle_follow_entity") then
			VehicleFollowEntity(action.vehicle, action.tag)
		end
		if(action.name == "change_av_velocity") then
			AVVelocity = action.value
		end
		if(action.name == "reset_av_velocity") then
			AVVelocity = 0.005
		end
		if(action.name == "vehicle_change_doors") then
			VehicleDoors(action.tag,action.value)
		end
		if(action.name == "vehicle_change_windows") then
			VehicleWindows(action.tag,action.value)
		end
		if(action.name == "vehicle_detach_all_part") then
			VehicleDetachAll(action.tag)
		end
		if(action.name == "vehicle_explose") then
			VehicleDestroy(action.tag)
		end
		if(action.name == "vehicle_repair") then
			VehicleRepair(action.tag)
		end
		if(action.name == "vehicle_honk_and_flash") then
			VehicleHonkFlash(action.tag)
		end
		if(action.name == "vehicle_change_light") then
			VehicleLights(action.tag,action.value)
		end
		if(action.name == "vehicle_change_engine") then
			VehicleEngine(action.tag,action.value)
		end
		if(action.name == "vehicle_reset") then
			VehicleReset(action.tag)
		end
		if(action.name == "vehicle_set_invincible") then
			VehicleSetInvincible(action.tag)
		end
		if(action.name == "vehicle_go_to_current_fasttravel_point") then
			local vehiculeobj =  getTrueEntityFromManager(action.tag)
			local vehicule = Game.FindEntityByID(vehiculeobj.id)
			if(vehicule ~= nil and ActiveFastTravelMappin ~= nil) then
				vehiculeobj.destination = ActiveFastTravelMappin.position
				VehicleGoToGameNode(action.tag, ActiveFastTravelMappin.markerRef, action.speed, action.forcegreenlight, action.needdriver, action.usetraffic)
			end
		end
		if(action.name == "vehicle_go_to_fasttravel_point") then
			local vehiculeobj =  getEntityFromManager(action.tag)
			local vehicule = Game.FindEntityByID(vehiculeobj.id)
			if(vehicule ~= nil) then
				local markerref = nil
				local position = nil
				for i=1, #mappedFastTravelPoint do
					local point = mappedFastTravelPoint[i]
					if(point.markerref == action.destination) then
						markerref = point.markerrefdata
						position = point.position
					end
					if(markerref ~= nil) then
						vehiculeobj.destination =position
						VehicleGoToGameNode(action.tag, markerref, action.speed, action.forcegreenlight, action.needdriver, action.usetraffic)
					end
				end
			end
		end
		if(action.name == "vehicle_go_to_fasttravel_point_from_mappin") then
			local mappin = getMappinByTag(tag)
			local vehiculeobj =  getTrueEntityFromManager(action.tag)
			local vehicule = Game.FindEntityByID(vehiculeobj.id)
			if(mappin)then
				if(vehicule ~= nil) then
					vehiculeobj.destination =position
					VehicleGoToGameNode(action.tag, point.markerrefdata, action.speed, action.forcegreenlight, action.needdriver, action.usetraffic)
				end
			end
		end
		if(action.name == "summon_vehicule_from_faction") then
			local gang = getFactionByTag(action.faction)
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(#gang.SpawnableVehicule > 0) then
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableVehicule)
					chara = gang.SpawnableVehicule[index]
					local isAV = false
					if(action.isAV ~= nil) then
						isAV = action.isAV
					end
					spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_vehicule_from_faction_rival") then
			local gang = getFactionByTag(action.faction)
			gang = getFactionByTag(gang.Rivals[1])
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(#gang.SpawnableVehicule > 0) then
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableVehicule)
					chara = gang.SpawnableVehicule[index]
					local isAV = false
					if(action.isAV ~= nil) then
						isAV = action.isAV
					end
					spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_vehicule_from_leader_faction_district") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = gangs[1]
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_from_leader_faction_subdistrict") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_from_leader_faction_district_rival") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_from_leader_faction_subdistrict_rival") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_at_entity_relative_from_faction") then
			local gang = getFactionByTag(action.faction)
			if(#gang.SpawnableVehicule > 0) then
				if(action.amount == nil) then
					action.amount = 1
				end
				if(action.amount == 0) then
					action.amount = math.random(1,6)
				end
				for i=1,action.amount do
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableVehicule)
					chara = gang.SpawnableVehicule[index]
					if(chara == "" or chara == nil) then
						chara = "Vehicle.arr_05_objective_truck"
					end
					local isAV = false
					if(action.isAV ~= nil and action.isAV==true) then
						debugPrint(1,"AV is "..tostring(action.isAV))
						isAV = action.isAV
						local group = getGroupfromManager("AV")
						if(group.entities == nil) then
							group.entities = {}
						end
						table.insert(group.entities,tag)
						debugPrint(1,#group.entities)
					end
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.entity ~= "player") then
						local obj = getEntityFromManager(action.entity)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
						if(action.position == "behind") then
							positionVec4 = getBehindPosition(entity,action.distance)
						end
						if(action.position == "forward") then
							positionVec4 = getForwardPosition(entity,action.distance)
						end
						else
						positionVec4.x = positionVec4.x + action.x
						positionVec4.y = positionVec4.y + action.y
						positionVec4.z = positionVec4.z + action.z
					end
					local ambush = false
					if(action.ambush ~= nil) then
						ambush = action.ambush
					end
					spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_vehicule_at_entity_relative_from_faction_rival") then
			local gang = getFactionByTag(action.faction)
			local rivalindex = math.random(1,#gang.Rivals)
			gang = getFactionByTag(gang.Rivals[rivalindex])
			if(#gang.SpawnableVehicule > 0) then
				if(action.amount == nil) then
					action.amount = 1
				end
				if(action.amount == 0) then
					action.amount = math.random(1,6)
				end
				for i=1,action.amount do
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableVehicule)
					chara = gang.SpawnableVehicule[index]
					local isAV = false
					if(action.isAV ~= nil and action.isAV==true) then
						debugPrint(1,"AV is "..tostring(action.isAV))
						isAV = action.isAV
						local group = getGroupfromManager("AV")
						if(group.entities == nil) then
							group.entities = {}
						end
						table.insert(group.entities,tag)
						debugPrint(1,#group.entities)
					end
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.entity ~= "player") then
						local obj = getEntityFromManager(action.entity)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
						if(action.position == "behind") then
							positionVec4 = getBehindPosition(entity,action.distance)
						end
						if(action.position == "forward") then
							positionVec4 = getForwardPosition(entity,action.distance)
						end
						else
						positionVec4.x = positionVec4.x + action.x
						positionVec4.y = positionVec4.y + action.y
						positionVec4.z = positionVec4.z + action.z
					end
					local ambush = false
					if(action.ambush ~= nil) then
						ambush = action.ambush
					end
					spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_vehicule_at_entity_relative_from_faction_leader_district") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_at_entity_relative_from_faction_leader_subdistrict") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_at_entity_relative_from_faction_leader_district_rival") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_vehicule_at_entity_relative_from_faction_leader_subdistrict_rival") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableVehicule > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableVehicule)
						chara = gang.SpawnableVehicule[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
	end
	
	if scoreregion then
		if(action.name == "change_custom_condition") then
			setScore(action.value,"Score",action.score)
		end
		if(action.name == "change_custom_variable") then
			setVariable(action.variable,action.key,action.value)
		end
		if(action.name == "concate_custom_variable") then
			local score  = getVariableKey(action.variable,action.key)
			score = score .. action.value
			setVariable(action.variable,action.key,score)
		end
		if(action.name == "concate_custom_variable_with_variable") then
			local score1  = getVariableKey(action.variable,action.key)
			local score2  = getVariableKey(action.targetvariable,action.targetkey)
			local score = score1 .. score2
			setVariable(action.resultvariable,action.resultkey,score)
		end
		if(action.name == "concate_custom_variable_with_score") then
			local score1  = getVariableKey(action.variable,action.key)
			local score2  = getScoreKey(action.score,"Score")
			local score = score1 .. score2
			setVariable(action.resultvariable,action.resultkey,score)
		end
		if(action.name == "change_custom_score") then
			setScore(action.variable,"Score",action.score)
		end
		if(action.name == "change_custom_score_key") then
			setScore(action.variable,action.key,action.score)
		end
		if(action.name == "add_to_custom_score") then
			local score  = getScoreKey(action.value,"Score")
			if score == nil then
				score = 0
			end
			score = score + action.score
			setScore(action.value,"Score",score)
		end
		if(action.name == "random_custom_score") then
			local score  = getScoreKey(action.variable,"Score")
			score = math.random(action.min,action.max)
			setScore(action.variable,"Score",score)
		end
		if(action.name == "operate_custom_score_to_another_one") then
			local score  = getScoreKey(action.variable,"Score")
			local targetscore  = getScoreKey(action.targetscore,"Score")
			local resultscore  = getScoreKey(action.resultscore,"Score")
			if(action.operator == "+") then
				score = score + targetscore
			end
			if(action.operator == "-") then
				score = score - targetscore
			end
			if(action.operator == "*") then
				score = score * targetscore
			end
			if(action.operator == "/") then
				score = score / targetscore
			end
			if(action.operator == "positive") then
				if(score > 0) then
					score = 0 + score
					else
					score = 0 - score
				end
			end
			if(action.operator == "negative") then
				if(score > 0) then
					score = 0 - score
					else
					score = 0 + score
				end
			end
			setScore(action.resultscore,"Score",score)
		end
		if(action.name == "change_player_reputation") then
			setScore("player_reputation","Score",action.value)
		end
		if(action.name == "concate_custom_variable_with_score") then
			local score1  = getValue(action.object,action.value,action.parameter,action.index)
			setVariable(action.resultvariable,action.resultkey,score1)
		end
	end
	
	if houseregion then
		if(action.name == "change_house_statut") then
			updateHouseStatut(action.value,action.score)
		end
		if(action.name == "change_house_score") then
			updateHouseScore(action.value,action.score)
		end
		if(action.name == "getSalaryFromCurrentRent") then
			if currentHouse ~= nil then
				if(getHouseStatut(currentHouse.tag) >= 2 and currentHouse.isrentable == true) then
					local player = Game.GetPlayer()
					local ts = Game.GetTransactionSystem()
					local tid = TweakDBID.new("Items.money")
					local itemid = ItemID.new(tid)
					local amount = 0
					local playerreput = 1
					local score = getScoreKey("player_reputation","Score")
					if(score ~= nil ) then
						playerreput = score
					end
					local housereputcoef = 1
					if(currentHouse.coef > 0) then
						housereputcoef = currentHouse.coef/10
					end
					local rand = math.random(1,25)
					amount = currentHouse.rent * currentHouse.coef * playerreput * rand
					local result = ts:GiveItem(player, itemid, amount)
					SalaryIsPossible = false
				end
			end
		end
		if(action.name == "buyCurrentHouse") then
			if currentHouse ~= nil then
				local isbuyable = currentHouse.isbuyable
				local statut = getHouseStatut(currentHouse.tag)
				local moneyamount = getStackableItemAmount("Items.money")
				local price = currentHouse.price
				--debugPrint(1,tostring(isbuyable))
				--debugPrint(1,tostring(statut))
				--debugPrint(1,tostring(moneyamount))
				--debugPrint(1,tostring(price))
				if(isbuyable == true and (statut == nil or statut < 1) and moneyamount >= price) then
					local player = Game.GetPlayer()
					local ts = Game.GetTransactionSystem()
					local tid = TweakDBID.new("Items.money")
					local itemid = ItemID.new(tid)
					local amount = currentHouse.price
					local result = ts:RemoveItem(player, itemid, amount)
					updateHouseStatut(currentHouse.tag,1)
					else
					Game.GetPlayer():SetWarningMessage("This place can't be buyed or the price is too high for you !")
				end
			end
		end
		if(action.name == "buyHouse") then
			local house = arrayHouse[action.tag].house
			if house ~= nil then
				local isbuyable = house.isbuyable
				local statut = getHouseStatut(house.tag)
				local moneyamount = getStackableItemAmount("Items.money")
				local price = house.price
				if(isbuyable == true and (statut == nil or statut < 1) and moneyamount >= price) then
					local player = Game.GetPlayer()
					local ts = Game.GetTransactionSystem()
					local tid = TweakDBID.new("Items.money")
					local itemid = ItemID.new(tid)
					local amount = house.price
					local result = ts:RemoveItem(player, itemid, amount)
					updateHouseStatut(house.tag,1)
					else
					Game.GetPlayer():SetWarningMessage("This place can't be buyed or the price is too high for you !")
				end
			end
		end
		if(action.name == "sellHouse") then
			local house = arrayHouse[action.tag].house
			if house ~= nil then
				local isbuyable = house.isbuyable
				local statut = getHouseStatut(house.tag)
				local moneyamount = getStackableItemAmount("Items.money")
				local price = house.price
				if(isbuyable == true and (statut == nil or statut < 1) and moneyamount >= price) then
					local player = Game.GetPlayer()
					local ts = Game.GetTransactionSystem()
					local tid = TweakDBID.new("Items.money")
					local itemid = ItemID.new(tid)
					local amount = house.price
					local result = ts:GiveItem(player, itemid, amount)
					updateHouseStatut(house.tag,1)
					else
					Game.GetPlayer():SetWarningMessage("This place can't be buyed or the price is too high for you !")
				end
			end
		end
		if(action.name == "sellCurrentHouse") then
			if currentHouse ~= nil then
				if(currentHouse.isbuyable == true and getHouseStatut(currentHouse.tag) ~= nil and getHouseStatut(currentHouse.tag) > 0) then
					local player = Game.GetPlayer()
					local ts = Game.GetTransactionSystem()
					local tid = TweakDBID.new("Items.money")
					local itemid = ItemID.new(tid)
					local amount =  round(currentHouse.price/2)
					--debugPrint(1,"amount : "..amount)
					local result = ts:GiveItem(player, itemid, amount)
					updateHouseStatut(currentHouse.tag,0)
					else
					Game.GetPlayer():SetWarningMessage("This place can't be buyed or the price is too high for you !")
				end
			end
		end
		if(action.name == "rentCurrentHouse") then
			if currentHouse ~= nil then
				if(currentHouse.isbuyable == true and currentHouse.isrentable == true and getHouseStatut(currentHouse.tag) == 1 and getStackableItemAmount("Items.money") >= (currentHouse.price*currentHouse.coef)) then
					local player = Game.GetPlayer()
					local ts = Game.GetTransactionSystem()
					local tid = TweakDBID.new("Items.money")
					local itemid = ItemID.new(tid)
					local amount = currentHouse.price*currentHouse.coef
					local result = ts:RemoveItem(player, itemid, amount)
					updateHouseStatut(currentHouse.tag,2)
					else
					Game.GetPlayer():SetWarningMessage("This place can't be rented or the price is too high for you !")
				end
			end
		end
		if(action.name == "trigger_edit_housing_mode") then
			inEditMode = action.value
		end
		if(action.name == "open_placed_item_ui") then
			if currentHouse ~= nil then
				if(getHouseStatut(currentHouse.tag) == 1) then
					PlacedItemsUI()
				end
			end
		end
		if(action.name == "tp_to_currenthouse_enter") then
			if currentHouse ~= nil then
				local isplayer = false
				if action.tag == "player" then
					isplayer = true
				end
				local obj = getEntityFromManager(action.tag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local angle = 1
					if(action.angle ~= nil) then
						angle = action.angle
					end
					if(action.collision ~= nil and action.collision == true) then
						local filters = {
							'Static', -- Buildings, Concrete Roads, Crates, etc.
							'Terrain'
						}
						local from = enti:GetWorldPosition()
						local to = Vector4.new(
							action.x ,
							action.y ,
							action.z,
							1
						)
						local collision = false
						for _, filter in ipairs(filters) do
							local success, result = Game.GetSpatialQueriesSystem():SyncRaycastByCollisionGroup(from, to, filter, false, false)
							if success then
								collision = true
								--debugPrint(1,"collision"..filter)
							end
						end
						if(collision == false) then
							teleportTo(enti, Vector4.new( currentHouse.EnterX, currentHouse.EnterY, currentHouse.EnterZ,1), angle,isplayer)
							else
							if(action.pathfinding ~= nil and action.pathfinding == true) then
								local newpath =  giveGoodPath(from,to,action.axis)
								teleportTo(enti, newpath, angle,isplayer)
							end
						end
						else
						--debugPrint(1,"angle.yaw = "..angle.yaw)
						teleportTo(enti, Vector4.new( currentHouse.EnterX, currentHouse.EnterY, currentHouse.EnterZ,1), angle,isplayer)
					end
				end
			end
		end
		if(action.name == "tp_to_currenthouse_exit") then
			if currentHouse ~= nil then
				local isplayer = false
				if action.tag == "player" then
					isplayer = true
				end
				local obj = getEntityFromManager(action.tag)
				local enti = Game.FindEntityByID(obj.id)
				if(enti ~= nil) then
					local angle = 1
					if(action.angle ~= nil) then
						angle = action.angle
					end
					if(action.collision ~= nil and action.collision == true) then
						local filters = {
							'Static', -- Buildings, Concrete Roads, Crates, etc.
							'Terrain'
						}
						local from = enti:GetWorldPosition()
						local to = Vector4.new(
							action.x ,
							action.y ,
							action.z,
							1
						)
						local collision = false
						for _, filter in ipairs(filters) do
							local success, result = Game.GetSpatialQueriesSystem():SyncRaycastByCollisionGroup(from, to, filter, false, false)
							if success then
								collision = true
								--debugPrint(1,"collision"..filter)
							end
						end
						if(collision == false) then
							teleportTo(enti, Vector4.new( currentHouse.ExitX, currentHouse.ExitY, currentHouse.ExitZ,1), angle,isplayer)
							else
							if(action.pathfinding ~= nil and action.pathfinding == true) then
								local newpath =  giveGoodPath(from,to,action.axis)
								teleportTo(enti, newpath, angle,isplayer)
							end
						end
						else
						--debugPrint(1,"angle.yaw = "..angle.yaw)
						teleportTo(enti, Vector4.new( currentHouse.ExitX, currentHouse.ExitY, currentHouse.ExitZ,1), angle,isplayer)
					end
				end
			end
		end
		if(action.name == "open_buyed_item_ui") then
			if currentHouse ~= nil then
				if(getHouseStatut(currentHouse.tag) == 1) then
					ScrollSpeed = 0.07
					BuyedItemsUI()
				end
			end
		end
		if(action.name == "move_looked_item_to_player_position") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local obj = getItemEntityFromManager(entid)
				if(obj == nil) then
					obj = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(obj ~= nil) then
					local objpos = Game.GetPlayer():GetWorldPosition()
					local qat = Game.GetPlayer():GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(obj, objpos, angle, true)
				end
			end
		end
		if(action.name == "move_looked_item_Z") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local obj = getItemEntityFromManager(entid)
				if(obj == nil) then
					obj = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(obj ~= nil) then
					local objpos = objLook:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					objpos.z = objpos.z + action.value
					local qat = objLook:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(obj, objpos, angle, true)
					else
					debugPrint(1,"null")
				end
			end
		end
		if(action.name == "move_looked_item_X") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local obj = getItemEntityFromManager(entid)
				if(obj == nil) then
					obj = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(obj ~= nil) then
					local objpos = objLook:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					objpos.x = objpos.x + action.value
					local qat = objLook:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(obj, objpos, angle, true)
				end
			end
		end
		if(action.name == "move_looked_item_Y") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local obj = getItemEntityFromManager(entid)
				if(obj == nil) then
					obj = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(obj ~= nil) then
					local objpos = objLook:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					objpos.y = objpos.y + action.value
					local qat = objLook:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(obj, objpos, angle, true)
				end
			end
		end
		if(action.name == "yaw_looked_item") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local obj = getItemEntityFromManager(entid)
				if(obj == nil) then
					obj = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(obj ~= nil) then
					local objpos = objLook:GetWorldPosition()
					local qat = objLook:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.yaw = angle.yaw + action.value
					updateItemPosition(obj, objpos, angle, true)
				end
			end
		end
		if(action.name == "roll_looked_item") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local entity = getItemEntityFromManager(entid)
				if(entity == nil) then
					entity = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(entity ~= nil) then
					local worldpos = entity:GetWorldTransform()
					local pos = worldpos.Position:ToVector4(worldpos.Position)	
					local qat = worldpos:GetOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.roll = angle.roll + action.value
					updateItemPosition(obj, pos, angle)
				end
			end
		end
		if(action.name == "pitch_looked_item") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local entity = getItemEntityFromManager(entid)
				if(entity == nil) then
					entity = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(entity ~= nil) then
					local worldpos = entity:GetWorldTransform()
					local pos = worldpos.Position:ToVector4(worldpos.Position)	
					local qat = worldpos:GetOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.roll = angle.roll + action.value
					updateItemPosition(obj, pos, angle)
				end
			end
		end
		if(action.name == "set_item") then
			if grabbedTarget ~= nil then
				--	tp:Teleport(grabbedTarget, targetPos, targetAngle)
				-- if(Game.FindEntityByID(selectedItem.entityId):IsA('gameObject') == false)then
				-- grabbedTarget:Destroy()
				-- end
				updateItemPosition(selectedItem, targetPos, targetAngle,true)
				grabbedTarget = nil
				grabbed = false
				objPush = false
				objPull = false
				enabled = false
				id = false
			end
		end
		if(action.name == "looked_item_remove") then
			if objLook ~= nil then
				tarName = objLook:ToString()
				appName = Game.NameToString(objLook:GetCurrentAppearanceName())
				dipName = objLook:GetDisplayName()
				local entid = objLook:GetEntityID()
				local entity = getItemEntityFromManager(entid)
				if(entity == nil) then
					entity = getItemEntityFromManagerByPlayerLookinAt()
				end
				if(entity ~= nil) then
					debugPrint(1,entity.Tag)
					debugPrint(1,entity.Tag)
					debugPrint(1,#currentSave.arrayPlayerItems)
					for i =1, #currentSave.arrayPlayerItems do
						local mitem = currentSave.arrayPlayerItems[i]
						debugPrint(1,mitem.Tag)
						if(mitem.Tag == entity.Tag) then
							local housingitem = getHousing(entity.Tag,entity.X,entity.Y,entity.Z)
							deleteHousing(housingitem.Id)
							updatePlayerItemsQuantity(mitem,1)
							despawnItem(entid)
						end
					end
					else
					debugPrint(1,"nope")
				end
			end
		end
		if(action.name == "grab_select_item") then
			if selectedItem ~= nil then
				enabled = true
				id = true
				grabbedTarget = Game.FindEntityByID(selectedItem.entityId)
				if(grabbedTarget:IsA('gameObject') == false)then
					grabbedTarget = nil
					grabbed = false
					objPush = false
					objPull = false
					enabled = false
					id = false
					--Game.GetPlayer():SetWarningMessage(getLang(action.value))
					-- local objpos = grabbedTarget:GetWorldPosition()
					-- local worldpos = Game.GetPlayer():GetWorldTransform()
					-- local qat = grabbedTarget:GetWorldOrientation()
					-- local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					-- local transform = Game.GetPlayer():GetWorldTransform()
					-- transform:SetPosition(objpos)
					-- transform:SetOrientationEuler(angle)
					-- grabbedTarget = WorldFunctionalTests.SpawnEntity("base\\items\\interactive\\dining_accessories\\int_dining_accessories_001__bar_asset_h_sponge.ent", transform, '')
				end
				Cron.After(0.7,function()	
					if (grabbedTarget ~= nil) then
						targetPos = grabbedTarget:GetWorldPosition()
						targetAngle = Vector4.ToRotation(grabbedTarget:GetWorldForward())
						objectDist = Vector4.Distance(targetPos, playerPos)
						phi = math.atan2(playerAngle.y, playerAngle.x)
						targetDeltaPos = Vector4.new(((objectDist * math.cos(phi)) + playerPos.x), ((objectDist * math.sin(phi)) + playerPos.y), (objectDist * math.sin(playerAngle.z) + playerPos.z), targetPos.w)
						targetDeltaPos = Delta(targetDeltaPos, targetPos)
						debugPrint(1,grabbedTarget, "grabbed.")
						grabbed = true
						else
						debugPrint(1,"No target!")
					end
				end)
			end
		end
		if(action.name == "select_item") then
			if(#currentItemSpawned > 0 )then
				for i = 1, #currentItemSpawned do 
					local mitems = currentItemSpawned[i]
					if(mitems.Id == action.value) then
						selectedItem = nil
						selectedItem = mitems
						if(selectedItem.entityId ~= nil and Game.FindEntityByID(selectedItem.entityId) ~=nil and Game.FindEntityByID(selectedItem.entityId):IsA('gameObject') == true)then
							grabbedTarget = Game.FindEntityByID(selectedItem.entityId)
							enabled = true
							id = true
							if (grabbedTarget ~= nil) then
								targetPos = grabbedTarget:GetWorldPosition()
								targetAngle = Vector4.ToRotation(grabbedTarget:GetWorldForward())
								objectDist = Vector4.Distance(targetPos, playerPos)
								phi = math.atan2(playerAngle.y, playerAngle.x)
								targetDeltaPos = Vector4.new(((objectDist * math.cos(phi)) + playerPos.x), ((objectDist * math.sin(phi)) + playerPos.y), (objectDist * math.sin(playerAngle.z) + playerPos.z), targetPos.w)
								targetDeltaPos = Delta(targetDeltaPos, targetPos)
								debugPrint(1,grabbedTarget, "grabbed.")
								grabbed = true
								else
								debugPrint(1,"No target!")
							end
						end
					end
				end
			end
		end
		if(action.name == "unselect_item") then
			selectedItem = nil
			grabbedTarget = nil
			grabbed = false
			objPush = false
			objPull = false
			enabled = false
			id = false
		end
		if(action.name == "move_select_item_to_player_position") then
			if selectedItem ~= nil then
				local objpos = Game.GetPlayer():GetWorldPosition()
				local qat = Game.GetPlayer():GetWorldOrientation()
				local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
				updateItemPosition(selectedItem, objpos, angle, true)
			end
		end
		if(action.name == "move_selected_item_Z") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					objpos.z = objpos.z + action.value
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(selectedItem, objpos, angle, true)
				end
			end
		end
		if(action.name == "move_selected_item_X") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					objpos.x = objpos.x + action.value
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(selectedItem, objpos, angle, true)
				end
			end
		end
		if(action.name == "move_selected_item_Y") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					objpos.y = objpos.y + action.value
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPosition(selectedItem, objpos, angle, true)
				end
			end
		end
		if(action.name == "yaw_selected_item") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.yaw = angle.yaw + action.value
					updateItemPosition(selectedItem, objpos, angle, true)
				end
			end
		end
		if(action.name == "roll_selected_item") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.roll = angle.roll + action.value
					updateItemPosition(selectedItem, objpos, angle, true)
				end
			end
		end
		if(action.name == "pitch_selected_item") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					local objpos = entity:GetWorldPosition()
					local worldpos = Game.GetPlayer():GetWorldTransform()
					local qat = entity:GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					angle.pitch = angle.pitch + action.value
					updateItemPosition(selectedItem, objpos, angle, true)
				end
			end
		end
		if(action.name == "selected_item_remove") then
			if selectedItem ~= nil then
				local entity = Game.FindEntityByID(selectedItem.entityId)
				if(entity ~= nil) then
					for i =1, #currentSave.arrayPlayerItems do
						local mitem = currentSave.arrayPlayerItems[i]
						if(mitem.Tag == selectedItem.Tag) then
							Game.FindEntityByID(selectedItem.entityId):GetEntity():Destroy()
							debugPrint(1,"toto")
							updatePlayerItemsQuantity(mitem,1)
							deleteHousing(selectedItem.Id)
							local index = getItemEntityIndexFromManager(selectedItem.entityId)
							--despawnItem(selectedItem.Id)
							table.remove(currentItemSpawned,index)
							Cron.After(1, function()
								selectedItem = nil
							end)
						end
					end
					else
					debugPrint(1,"nope")
				end
			end
		end
		if(action.name == "spawn_buyed_item") then
			if action.tag ~= nil then
				local pos = Game.GetPlayer():GetWorldPosition()
				local angles = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
				local spawnedItem = {}
				local mitems =  getPlayerItemsbyTag(action.tag)
				if(currentHouse ~= nil and mitems ~= nil and mitems.Quantity > 0 and (string.match(tostring(mitems.Tag), "AMM_Props.") == nil or (string.match(tostring(mitems.Tag), "AMM_Props.") ~= nil and AMM ~= nil)  )    ) then
					spawnedItem.Tag = mitems.Tag
					spawnedItem.HouseTag = currentHouse.tag
					spawnedItem.ItemPath = mitems.Path
					spawnedItem.X = pos.x
					spawnedItem.Y = pos.y
					spawnedItem.Z = pos.z
					spawnedItem.Yaw = angles.yaw
					spawnedItem.Pitch = angles.pitch
					spawnedItem.Roll = angles.roll
					spawnedItem.Title = mitems.Title
					saveHousing(spawnedItem)
					local housing = getHousing(spawnedItem.Tag,spawnedItem.X,spawnedItem.Y,spawnedItem.Z)
					spawnedItem.Id = housing.Id
					updatePlayerItemsQuantity(mitems,-1)
					spawnedItem.entityId = spawnItem(spawnedItem, pos, angles)
					table.insert(currentItemSpawned,spawnedItem)
					selectedItem = spawnedItem
				end
			end
		end
		if(action.name == "despawn_placed_item") then
			if action.tag ~= nil then
				local pos = Game.GetPlayer():GetWorldPosition()
				local angles = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
				local spawnedItem = {}
				if(currentHouse ~= nil)then
					local entity =  getItemByHouseTagandTagFromManager(action.tag,currentHouse.tag)
					if(entity ~= nil) then
						for i =1, #currentSave.arrayPlayerItems do
							local mitem = currentSave.arrayPlayerItems[i]
							if(mitem.Tag == entity.Tag) then
								local housingitem = getHousing(entity.Tag,entity.X,entity.Y,entity.Z)
								despawnItem(entity.entityId)
								deleteHousing(housingitem.Id)
								updatePlayerItemsQuantity(mitem,1)
							end
						end
						else
						debugPrint(1,"nope")
					end
				end
			end
		end
	end
	
	if gangregion then
		if(action.name == "gang_affinity") then
			local score = getScoreKey(action.value,"Score")
			if(score == nil) then
				score = 0
				setScore(action.value,"Score",score)
			end
			score = score + action.score
			setScore(action.value,"Score",score)
		end
		if(action.name == "add_gang_district_score") then
			currentSave.arrayFactionDistrict[action.faction][action.district] = currentSave.arrayFactionDistrict[action.faction][action.district] + action.value
		end
		if(action.name == "remove_gang_district_score") then
			currentSave.arrayFactionDistrict[action.faction][action.district] = currentSave.arrayFactionDistrict[action.faction][action.district] - action.value
		end
		if(action.name == "set_gang_district_score") then
			currentSave.arrayFactionDistrict[action.faction][action.district] = action.value
		end
		if(action.name == "gang_affinity_from_current_district_leader") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local score = getScoreKey(gang.tag,"Score")
				if(score == nil) then
					score = 0
					setScore(gang.tag,"Score",score)
				end
				score = score + action.score
				setScore(gang.Tag,"Score",score)
			end
		end
		if(action.name == "gang_affinity_from_current_district_leader_rival") then
			
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				local score = getScoreKey(gang.tag,"Score")
				if(score == nil) then
					score = 0
					setScore(gang.tag,"Score",score)
				end
				score = score + action.score
				setScore(gang.Tag,"Score",score)
			end
		end
		if(action.name == "gang_affinity_from_current_subdistrict_leader") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						local gangs = getGangfromDistrict(test,20)
						if(#gangs > 0) then
							local gang = getFactionByTag(gangs[1].tag)
							local score = getScoreKey(gang.tag,"Score")
							if(score == nil) then
								score = 0
								setScore(gang.tag,"Score",score)
							end
							score = score + action.score
							setScore(gang.Tag,"Score",score)
							break
						end
					end
				end
			end
		end
		if(action.name == "gang_affinity_from_current_subdistrict_leader_rival") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						local gangs = getGangfromDistrict(test,20)
						if(#gangs > 0) then
							local gang = getFactionByTag(gangs[1].tag)
							local rivalindex = math.random(1,#gang.Rivals)
							gang = getFactionByTag(gang.Rivals[rivalindex])
							local score = getScoreKey(gang.tag,"Score")
							if(score == nil) then
								score = 0
								setScore(gang.tag,"Score",score)
							end
							score = score + action.score
							setScore(gang.Tag,"Score",score)
							break
						end
					end
				end
			end
		end
		
		
		if(action.name == "add_gang_currentdistrict_score") then
			if currentDistricts2 ~= nil then
				currentSave.arrayFactionDistrict[action.faction][currentDistricts2.Tag] = currentSave.arrayFactionDistrict[action.faction][currentDistricts2.Tag] + action.value
			end
		end
		if(action.name == "remove_gang_currentdistrict_score") then
			if currentDistricts2 ~= nil then
				currentSave.arrayFactionDistrict[action.faction][currentDistricts2.Tag] =
				currentSave.arrayFactionDistrict[action.faction][currentDistricts2.Tag] - action.value
			end
		end
		if(action.name == "add_leader_currentdistrict_score") then
			if currentDistricts2 ~= nil then
				local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
				if(#gangs > 0) then
					currentSave.arrayFactionDistrict[gangs[1].tag][currentDistricts2.Tag] = currentSave.arrayFactionDistrict[gangs[1].tag][currentDistricts2.Tag] + action.value
				end
			end
		end
		if(action.name == "remove_leader_currentdistrict_score") then
			if currentDistricts2 ~= nil then
				local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
				if(#gangs > 0) then
					currentSave.arrayFactionDistrict[gangs[1].tag][currentDistricts2.Tag] = currentSave.arrayFactionDistrict[gangs[1].tag][currentDistricts2.Tag] - action.value
				end
			end
		end
		if(action.name == "add_leader_currentsubdistrict_score") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						local gangs = getGangfromDistrict(test,20)
						if(#gangs > 0) then
						debugPrint(1,currentDistricts2.Tag)
						currentSave.arrayFactionDistrict[gangs[1].tag][test] = currentSave.arrayFactionDistrict[gangs[1].tag][test] + action.value
						break
					end
					end
				end
			end
		end
		if(action.name == "remove_leader_currentsubdistrict_score") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						local gangs = getGangfromDistrict(test,20)
						if(#gangs > 0) then
							currentSave.arrayFactionDistrict[gangs[1].tag][test] = currentSave.arrayFactionDistrict[gangs[1].tag][test] - action.value
							break
						end
					end
				end
			end
		end
		if(action.name == "set_gang_currentdistrict_score") then
			if currentDistricts2 ~= nil then
				currentSave.arrayFactionDistrict[action.faction][currentDistricts2.Tag] = action.value
			end
		end
		if(action.name == "add_gang_currentsubdistrict_score") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						debugPrint(1,i)
						debugPrint(1,test)
						debugPrint(1,action.faction)
						currentSave.arrayFactionDistrict[action.faction][test] = currentSave.arrayFactionDistrict[action.faction][test]+ action.value
						break
					end
				end
			end
		end
		if(action.name == "remove_gang_currentsubdistrict_score") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						currentSave.arrayFactionDistrict[action.faction][test] =
						currentSave.arrayFactionDistrict[action.faction][test]- action.value
						break
					end
				end
			end
		end
		if(action.name == "set_gang_currentsubdistrict_score") then
			if #currentDistricts2.districtLabels > 0 then
				for i, test in ipairs(currentDistricts2.districtLabels) do
					if i > 1 then
						currentSave.arrayFactionDistrict[action.faction][test] = action.value
						break
					end
				end
			end
		end
		if(action.name == "trigger_edit_crew_mode") then
			inCrewManager = action.value
		end
		if(action.name == "set_player_current_gang") then
			setVariable("player","current_gang",action.tag)
		end
		if(action.name == "set_gang_relation") then
			
			if(action.tag == "player") then
				
				action.tag = getVariableKey("player","current_gang")
				
			end
			
			
			if(action.mode == "gang") then
				
				
				if(action.target ~= action.tag) then
					
					setFactionRelation(action.tag,action.target,action.score)
					
				end
				
			end
			
			if(action.mode == "district_leader" or action.mode == "district_subleader") then
				
				local gangs = getGangfromDistrict(action.target,20)
				if(#gangs > 0) then
					
					if(gangs[1].tag ~= action.tag) then
						
						setFactionRelation(action.tag,gangs[1].tag,action.score)
						
					end
				end
				
				
			end
			
			if(action.mode == "current_district_leader") then
				
				if currentDistricts2 ~= nil then
					local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
					if(#gangs > 0) then
						setFactionRelation(action.tag,gangs[1].tag,action.score)
						
					end
				end
				
			end
			
			if(action.mode == "current_district_subleader") then
				if currentDistricts2 ~= nil then
					if #currentDistricts2.districtLabels > 0 and #currentDistricts2.districtLabels > 1 then
						local gangs = getGangfromDistrict(currentDistricts2.districtLabels[2],20)
						if(#gangs > 0) then
							setFactionRelation(action.tag,gangs[1].tag,action.score)
							
						end
					end
				end
				
			end
			
		end
		
		if(action.name == "add_gang_relation") then
			
			if(action.tag == "player") then
				
				action.tag = getVariableKey("player","current_gang")
				
			end
			
			
			if(action.mode == "gang") then
				
				
				if(action.target ~= action.tag) then
					
					addFactionRelation(action.tag,action.target,action.score)
					
				end
				
			end
			
			if(action.mode == "district_leader" or action.mode == "district_subleader") then
				
				local gangs = getGangfromDistrict(action.target,20)
				if(#gangs > 0) then
					
					if(gangs[1].tag ~= action.tag) then
						
						addFactionRelation(action.tag,gangs[1].tag,action.score)
						
					end
				end
				
				
			end
			
			if(action.mode == "current_district_leader") then
				
				if currentDistricts2 ~= nil then
					local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
					if(#gangs > 0) then
						addFactionRelation(action.tag,gangs[1].tag,action.score)
						
					end
				end
				
			end
			
			if(action.mode == "current_district_subleader") then
				if currentDistricts2 ~= nil then
					if #currentDistricts2.districtLabels > 0 and #currentDistricts2.districtLabels > 1 then
						local gangs = getGangfromDistrict(currentDistricts2.districtLabels[2],20)
						if(#gangs > 0) then
							addFactionRelation(action.tag,gangs[1].tag,action.score)
							
						end
					end
				end
				
			end
			
		end
	end
	
	if miscregion then
		if(action.name == "set_fact") then
			Game.SetDebugFact(action.value, action.score)
		end
		if(action.name == "buy_item") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = tonumber(action.price)
			if currentHouse ~= nil and currentHouse.coef ~=nil and currentHouse.coef > 0 then
				amount = amount * currentHouse.coef	
			end
			if currentStar ~= nil then
				amount = amount * 2
			end
			local result = ts:RemoveItem(player, itemid, amount)
			------debugPrint(1,"remove money")
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new(action.value)
			local itemid = ItemID.new(tid)
			local result = ts:GiveItem(player, itemid, tonumber(action.amount))
			------debugPrint(1,"give item")
		end
		if(action.name == "give_item") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new(action.value)
			local itemid = ItemID.new(tid)
			local result = ts:GiveItem(player, itemid, tonumber(action.amount))
			------debugPrint(1,"give item")
		end
		if(action.name == "remove_item") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new(action.value)
			local itemid = ItemID.new(tid)
			local result = ts:RemoveItem(player, itemid, tonumber(action.amount))
		end
		if(action.name == "give_money") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = tonumber(action.value)
			if currentHouse ~= nil and currentHouse.coef ~= nil then
				amount = amount * currentHouse.coef	
			end
			local result = ts:GiveItem(player, itemid, amount)
			------debugPrint(1,"give money")
		end
		if(action.name == "give_random_money") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = math.random(action.min,action.max)
			if currentHouse ~= nil and currentHouse.coef ~= nil then
				amount = amount * currentHouse.coef	
			end
			local result = ts:GiveItem(player, itemid, amount)
			------debugPrint(1,"give money")
		end
		if(action.name == "remove_money") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = tonumber(action.value)
			if currentHouse ~= nil and currentHouse.coef ~=nil then
				amount = amount * currentHouse.coef	
			end
			if currentStar ~= nil then
				amount = amount * 2
			end
			local result = ts:RemoveItem(player, itemid, amount)
			debugPrint(1,result)
			--debugPrint(1,"remove money")
		end
		if(action.name == "remove_random_money") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = tonumber(action.value)
			if currentHouse ~= nil and currentHouse.coef ~=nil then
				amount = amount * currentHouse.coef	
			end
			if currentStar ~= nil then
				amount = amount * 2
			end
			local result = ts:RemoveItem(player, itemid, amount)
			--debugPrint(1,result)
			--debugPrint(1,"remove money")
		end
		if(action.name == "give_money_score") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = getScoreKey(action.score,"Score")
			if currentHouse ~= nil and currentHouse.coef ~= nil then
				amount = amount * currentHouse.coef	
			end
			spdlog.info('test ' .. amount)
			local result = ts:GiveItem(player, itemid, math.floor(amount))
			------debugPrint(1,"give money")
		end
		if(action.name == "remove_money_score") then
			local player = Game.GetPlayer()
			local ts = Game.GetTransactionSystem()
			local tid = TweakDBID.new("Items.money")
			local itemid = ItemID.new(tid)
			local amount = getScoreKey(action.score,"Score")
			if currentHouse ~= nil and currentHouse.coef ~=nil then
				amount = amount * currentHouse.coef	
			end
			if currentStar ~= nil then
				amount = amount * 2
			end
			local result = ts:RemoveItem(player, itemid, amount)
			--debugPrint(1,result)
			--debugPrint(1,"remove money")
		end
		if(action.name == "draw_mappin") then
			drawMappin(action.x,action.y)
		end
		if(action.name == "draw_3Dmappin") then
			draw3DMappin(action.x,action.y,action.z)
		end
		if(action.name == "draw_3Dmappin_node") then
			local node = getNode(action.tag)
			draw3DMappin(node.X,node.Y,node.Z)
		end
		if(action.name == "draw_custom_mappin") then
			drawCustomMappin(action.x,action.y)
		end
		if(action.name == "draw_custom_3Dmappin") then
			draw3DCustomMappin(action.x,action.y,action.z)
		end
		if(action.name == "delete_mappin") then
			if(mappinPoint ~= nil) then
				debugPrint(1,"Unregister mappinPoint")
				Game.GetMappinSystem():UnregisterMappin(mappinPoint)
			end
		end
		if(action.name == "clean_custommappin") then
			if(ActivecustomMappin ~= nil) then
				------debugPrint(1,"Unregister mappinPoint")
				
				ActivecustomMappin = nil
			end
		end
		if(action.name == "clean_activefasttravelpoint") then
			if(ActiveFastTravelMappin ~= nil) then
				
				ActiveFastTravelMappin = nil
			end
		end
		
		if(action.name == "notify") then
			Game.GetPlayer():SetWarningMessage(getLang(action.value))
		end
		if(action.name == "simple_message") then
			local message = SimpleScreenMessage.new()
			message.message = getLang(action.value)
			message.isShown = true
			local blackboardDefs = Game.GetAllBlackboardDefs()
			local blackboardUI = Game.GetBlackboardSystem():Get(blackboardDefs.UI_Notifications)
			blackboardUI:SetVariant(
				blackboardDefs.UI_Notifications.OnscreenMessage,
				ToVariant(message),
				true
			)
		end
		if(action.name == "simple_message_metro") then
			local obj = getEntityFromManager(action.entity)
			debugPrint(1,obj.currentNode.tag)
			debugPrint(1,obj.nextNode.tag)
			local startnode = getNode(obj.currentNode.tag)
			local endnode = getNode(obj.nextNode.tag)
			local text = lang["boarding"]..startnode.name..lang["to"]..endnode.name
			if(obj.circuit.reverse == true) then
				text = lang["boarding"]..endnode.name..lang["to"]..startnode.name
			end
			local message = SimpleScreenMessage.new()
			message.message = text
			message.isShown = true
			local blackboardDefs = Game.GetAllBlackboardDefs()
			local blackboardUI = Game.GetBlackboardSystem():Get(blackboardDefs.UI_Notifications)
			blackboardUI:SetVariant(
				blackboardDefs.UI_Notifications.OnscreenMessage,
				ToVariant(message),
				true
			)
		end
		if(action.name == "npcd_finish_notification") then
			local ncpd = NCPDJobDoneEvent.new()
			ncpd.levelXPAwarded = action.levelXPAwarded
			ncpd.streetCredXPAwarded  = action.streetCredXPAwarded
			Game.GetUISystem():QueueEvent(ncpd)
		end
		if(action.name == "quest_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			
			local userData = QuestUpdateNotificationViewData.new()
			userData.text = getLang(action.desc)
			
			if(action.type == "new") then
				
				local questAction = TrackQuestNotificationAction.new()
				questAction.eventDispatcher = JournalNotificationQueue
				
				if(action.quest ~= nil and action.quest ~= "") then
					local questentry = gameJournalQuest.new()
					questentry.districtID = action.quest
					
					questAction.questEntry = questentry
					
				end
				
				userData.title = test
				userData.canBeMerged = false;
				userData.action = questAction
				userData.soundEvent = CName("QuestNewPopup")
				userData.soundAction = CName("OnOpen")
				userData.animation = CName("notification_new_quest_added")
				
				
				
				
				
				local notificationData = gameuiGenericNotificationData.new()
				notificationData.time = action.duration
				notificationData.widgetLibraryItemName = CName('notification_new_quest_added')
				notificationData.notificationData = userData
				JournalNotificationQueue:AddNewNotificationData(notificationData)
				
				
			end
			
			if(action.type == "update") then
				
				local questAction = TrackQuestNotificationAction.new()
				questAction.eventDispatcher = JournalNotificationQueue
				
				
				userData.title = "UI-Notifications-QuestUpdated"
				userData.canBeMerged = false;
				userData.action = questAction
				userData.soundEvent = CName("QuestUpdatePopup")
				userData.soundAction = CName("OnOpen")
				userData.animation = CName("notification_quest_updated")
				
				
				if(action.quest ~= nil and action.quest ~= "") then
					local questentry = gameJournalQuest.new()
					questentry.districtID = action.quest
					
					questAction.questEntry = questentry
					
				end
				
				
				local notificationData = gameuiGenericNotificationData.new()
				notificationData.time = action.duration
				notificationData.widgetLibraryItemName = CName('notification_quest_updated')
				notificationData.notificationData = userData
				JournalNotificationQueue:AddNewNotificationData(notificationData)
				
				
			end
			
			if(action.type == "success") then
				
				
				
				local userData = QuestUpdateNotificationViewData.new()
				userData.title = "UI-Notifications-QuestCompleted"
				userData.canBeMerged = false
				userData.soundEvent = CName("QuestSuccessPopup")
				userData.soundAction = CName("OnOpen")
				userData.animation = CName("notification_quest_completed")
				userData.dontRemoveOnRequest = false
				
				
				
				
				local notificationData = gameuiGenericNotificationData.new()
				notificationData.time = action.duration
				notificationData.widgetLibraryItemName = CName('notification_quest_completed')
				notificationData.notificationData = userData
				JournalNotificationQueue:AddNewNotificationData(notificationData)
				
				
			end
			
			if(action.type == "fail") then
				
				local userData = QuestUpdateNotificationViewData.new()
				userData.title = "LocKey#27566"
				userData.canBeMerged = false
				userData.soundEvent = CName("QuestFailedPopup")
				userData.soundAction = CName("OnOpen")
				userData.animation = CName("notification_quest_failed")
				userData.dontRemoveOnRequest = false
				
				
				
				
				local notificationData = gameuiGenericNotificationData.new()
				notificationData.time = action.duration
				notificationData.widgetLibraryItemName = CName('notification_quest_failed')
				notificationData.notificationData = userData
				JournalNotificationQueue:AddNewNotificationData(notificationData)
				
				
			end
			
		end
		if(action.name == "shard_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			
			local notificationData =  gameuiGenericNotificationData.new()
			
			local userData = ShardCollectedNotificationViewData.new()
			userData.title = GetLocalizedText("UI-Notifications-ShardCollected") .. " " .. test
			userData.text = getLang(action.desc)
			userData.shardTitle = test
			userData.isCrypted = action.iscrypted
			userData.entry = nil
			
			
			if(action.shard ~= nil and action.shard ~= "") then
				
				local shard = getShardByTag(action.shard)
				userData.title = GetLocalizedText("UI-Notifications-ShardCollected") .. " " .. getLang(shard.title)
				userData.text = getLang(shard.description)
				userData.shardTitle = getLang(shard.title)
				arrayShard[shard.tag].shard.locked = false
				userData.isCrypted = shard.crypted
			end
			
			
			
			
			local shardOpenAction = OpenShardNotificationAction.new()
			shardOpenAction.eventDispatcher = Game.GetUISystem()
			
			userData.action = shardOpenAction
			userData.soundEvent = CName("ShardCollectedPopup")
			userData.soundAction = CName("OnLoot")
			
			
			notificationData.time = action.duration
			notificationData.widgetLibraryItemName = CName('notification_shard')
			notificationData.notificationData = userData
			
			
			JournalNotificationQueue:AddNewNotificationData(notificationData)
			
			
		end
		if(action.name == "contact_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			
			local notificationData =  gameuiGenericNotificationData.new()
			
			local userData = QuestUpdateNotificationViewData.new()
			userData.title = GetLocalizedText("Story-base-gameplay-gui-widgets-notifications-quest_update-_localizationString6")
			userData.text = getLang(action.desc)
			userData.animation = CName("notification_newContactAdded")
			
			
			
			
			userData.soundEvent = CName("QuestUpdatePopup")
			userData.soundAction = CName("OnOpen")
			
			notificationData.time = action.duration
			notificationData.widgetLibraryItemName = CName('notification_NewContactAdded')
			notificationData.notificationData = userData
			
			
			JournalNotificationQueue:AddNewNotificationData(notificationData)
			
			
		end
		if(action.name == "location_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			
			local userData = QuestUpdateNotificationViewData.new()
			userData.title = test
			userData.text = getLang(action.desc)
			userData.animation = CName("notification_LocationAdded")
			userData.soundEvent = CName("ui_phone_sms")
			userData.soundAction = CName("OnOpen")
			
			local notificationData = gameuiGenericNotificationData.new()
			notificationData.time = action.duration
			notificationData.widgetLibraryItemName = CName("notification_LocationAdded")
			notificationData.notificationData = userData
			
			
			JournalNotificationQueue:AddNewNotificationData(notificationData)
			
			
		end
		if(action.name == "activity_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			
			local userData = QuestUpdateNotificationViewData.new()
			userData.title = test
			userData.text = getLang(action.desc)
			userData.animation = CName("notification_new_activity")
			userData.soundEvent = CName("QuestNewPopup")
			userData.soundAction = CName("OnOpen")
			userData.canBeMerged = false
			
			local notificationData = gameuiGenericNotificationData.new()
			notificationData.time = action.duration
			notificationData.widgetLibraryItemName = CName("notification_new_activity")
			notificationData.notificationData = userData
			
			
			JournalNotificationQueue:AddNewNotificationData(notificationData)
			
			
		end
		if(action.name == "hacking_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			
			local userData = QuestUpdateNotificationViewData.new()
			userData.title = test
			userData.text = getLang(action.desc)
			userData.animation = CName("notification_hacking_reward")
			userData.soundEvent = CName("QuestNewPopup")
			userData.soundAction = CName("OnOpen")
			userData.canBeMerged = false
			
			local notificationData = gameuiGenericNotificationData.new()
			notificationData.time = action.duration
			notificationData.widgetLibraryItemName = CName("notification_hacking_reward")
			notificationData.notificationData = userData
			
			
			JournalNotificationQueue:AddNewNotificationData(notificationData)
			
			
		end
		if(action.name == "phone_notification") then
			local test = getLang(action.title)
			local obj = getEntityFromManager(action.title)
			local enti = Game.FindEntityByID(obj.id)
			if(action.title == "lookat")then
				enti = objLook
			end
			if(enti ~= nil) then
				if(action.title == "current_phone_npc") then
					if(currentNPC ~= nil) then
						test  = currentNPC.Names
					end
				end
				if(action.title == "current_star") then
					if(currentStar ~= nil) then
						test  = currentStar.Names
					end
				end
			end
			local openAction = OpenMessengerNotificationAction.new()
			openAction.eventDispatcher = JournalNotificationQueue
			local userData = PhoneMessageNotificationViewData.new()
			userData.title = test
			userData.SMSText = getLang(action.desc)
			userData.action = openAction
			userData.animation = CName('notification_phone_MSG')
			userData.soundEvent = CName('PhoneSmsPopup')
			userData.soundAction = CName('OnOpen')
			currentPhoneDialogPopup = gameJournalPhoneMessage.new()
			currentPhoneDialogPopup.sender = 1
			currentPhoneDialogPopup.text = getLang(action.desc)
			currentPhoneDialogPopup.delay = -9999
			currentPhoneDialogPopup.id = test
			
			if(action.conversation ~= nil and action.conversation ~= "") then
				
				for k,v in pairs(arrayPhoneConversation) do
					local phoneConversation = v.conv
					for z=1,#phoneConversation.conversation do
						local conversation = phoneConversation.conversation[z]
						if(conversation.tag == action.conversation)then
							currentPhoneConversation = phoneConversation.conversation[z]
							currentPhoneConversation.currentchoices = {}
							currentPhoneConversation.loaded = 0
							
						end
					end
				end
				
				if(action.conversation == "online") then
					
					if(multiReady and OnlineConversation ~= nil) then
						onlineInstanceMessageProcessing()
						for z=1,#OnlineConversation.conversation do
							local conversation = OnlineConversation.conversation[z]
							if(conversation.tag == "online_instance")then
								currentPhoneConversation = OnlineConversation.conversation[z]
								currentPhoneConversation.currentchoices = {}
								currentPhoneConversation.loaded = 0
								onlineReceiver = OnlineConversation.conversation[z].name
								
							end
						end
					end
				end
			end
			
			local notificationData = gameuiGenericNotificationData.new()
			notificationData.time = action.duration
			notificationData.widgetLibraryItemName = CName('notification_message')
			notificationData.notificationData = userData
			JournalNotificationQueue:AddNewNotificationData(notificationData)
		end
		
		if(action.name == "tutorial_notification") then
			
			--openInterface = true
			if UIPopupsManager.IsReady() then
				local notificationData = TutorialPopupData.new()
				notificationData.notificationName = CName("base\\gameplay\\gui\\widgets\\notifications\\tutorial.inkwidget")
				notificationData.queueName = CName("tutorial")
				notificationData.closeAtInput = action.closeatinput
				notificationData.pauseGame = action.pausegame
				notificationData.position = action.position
				notificationData.isModal = action.ismodal
				notificationData.margin = inkMargin.new()
				notificationData.title = action.title
				notificationData.message = action.desc
				notificationData.imageId = nil
				notificationData.videoType = gameVideoType.Unknown 
				notificationData.video = nil
				notificationData.useCursor = true
				notificationData.isBlocking = action.isblocking
				
				UIPopupsManager.ShowPopup(notificationData)
				else
				Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
			end
			
		end
		if(action.name=="next_help")then
			if currentHelp ~= nil then
				currentHelpIndex =currentHelpIndex+1
				if(currentHelpIndex > #currentHelp.section)then
					UIPopupsManager.ClosePopup()
					currentHelp = nil
					currentHelpIndex = 1
				end
				UIPopupsManager.ClosePopup()
			end
		end
		
		if(action.name=="previous_help")then
			if currentHelp ~= nil then
				currentHelpIndex =currentHelpIndex-1
				if(currentHelpIndex < 1)then
					currentHelpIndex =  1
				end
				UIPopupsManager.ClosePopup()
			end
			
		end
		if(action.name == "open_help") then
			currentHelp = arrayHelp[action.tag].help
			--openInterface = true
			
			if currentHelp ~= nil then
				if(currentHelpIndex > #currentHelp.section)then
					UIPopupsManager.ClosePopup()
					currentHelp = nil
					currentHelpIndex = 1
					else
					currentHelp.action = action
					if UIPopupsManager.IsReady() then
						local notificationData = TutorialPopupData.new()
						notificationData.notificationName = CName("base\\gameplay\\gui\\widgets\\notifications\\tutorial.inkwidget")
						notificationData.queueName = CName("tutorial")
						notificationData.closeAtInput = action.closeatinput
						notificationData.pauseGame = action.pausegame
						notificationData.position = action.popupposition
						notificationData.isModal = action.ismodal
						notificationData.margin = inkMargin.new()
						notificationData.title = currentHelp.title
						notificationData.message = currentHelp.section[currentHelpIndex]
						notificationData.imageId = nil
						notificationData.videoType = gameVideoType.Unknown 
						notificationData.video = nil
						notificationData.useCursor = true
						notificationData.isBlocking = action.isblocking
						
						UIPopupsManager.ShowPopup(notificationData)
						else
						Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
					end
				end
				
				else
				print("no help founded with the tag "..action.tag)
			end
		end
		
		if(action.name == "hide_tutorial_notification") then
			if TutorialPopupGameController ~= nil then
				TutorialPopupGameController:GetRootWidget():SetVisible(false)
			end
		end
		
		if(action.name == "set_progress_bar") then
			local evt = UploadProgramProgressEvent.new()
			evt.state = EUploadProgramState.STARTED
			evt.duration = action.duration
			evt.progressBarType = EProgressBarType.UPLOAD;
			evt.progressBarContext = EProgressBarContext.PhoneCall;
			
			evt.statPoolType = gamedataStatPoolType.QuickHackDuration
			Game.GetPersistencySystem():QueueEntityEvent(Game.GetPlayer():GetEntityID(), evt)
		end
		
		if(action.name == "set_metro_time") then
			MetroCurrentTime =  action.value
		end
		if(action.name == "trigger_metro_time") then
			activeMetroDisplay = action.value
		end
		if(action.name == "consolelog") then
			print(action.value)
		end
		if(action.name == "shard_window") then
			shardUIevent = NotifyShardRead.new()
			shardUIevent.text = action.content
			shardUIevent.title = action.title
			Game.GetUISystem():QueueEvent(shardUIevent)
		end
		if(action.name == "add_time") then
			local temp = getGameTime()
			addGameTime(temp, action.value)
		end
		if(action.name == "set_time") then
			setGameTime(action.hour,action.minute)
		end
		if(action.name == "add_stat") then
			Game.GetStatPoolsSystem():RequestChangingStatPoolValue(Game.GetPlayer():GetEntityID(), action.value, action_score, Game.GetPlayer(), true, false)
		end
		if(action.name == "add_stat_perc") then
			Game.GetStatPoolsSystem():RequestChangingStatPoolValue(Game.GetPlayer():GetEntityID(), action.value, action.score, Game.GetPlayer(), true, true)
		end
		if(action.name == "mod_stat") then
			Game.ModStatPlayer(action.value, action.score)
		end
		if(action.name == "mod_statpool") then
			--https://nativedb.red4ext.com/gamedataStatPoolType
			RequestSettingStatPoolValue(Game.GetPlayer():GetEntityID(), Enum.new('gamedataStatPoolType', action.value), action.score, Game.GetPlayer(), action.perc);
		end
		if(action.name == "mod_statpool_max") then
			--https://nativedb.red4ext.com/gamedataStatPoolType
			RequestSettingStatPoolMaxValue(Game.GetPlayer():GetEntityID(), Enum.new('gamedataStatPoolType', action.value), Game.GetPlayer());
		end
		if(action.name == "wanted_level") then
			local preventionSystem = Game.GetScriptableSystemsContainer():Get("PreventionSystem")
			preventionSystem:AddGeneralPercent(action.value)
			preventionSystem:HeatPipeline()
		end
		if(action.name == "change_zone") then
			if(action.value == "safe") then
				Game.ChangeZoneIndicatorSafe()
			end
			if(action.value == "neutral") then
				Game.ChangeZoneIndicatorPublic()
			end
			if(action.value == "hostile") then
				Game.ChangeZoneIndicatorDanger()
			end
		end
		if(action.name == "recording_mode") then
			if(action.value == "true") then
				Game.t1()
				recordingMode = true
			end
			if(action.value == "false") then
				Game.t2()
				recordingMode = false
			end
		end
		if(action.name == "fade_in") then
			local temp = tick
			local nexttemp = temp
			nexttemp = nexttemp + (action.value*60) 
			fademessage = getLang(action.message)
			action.tick = nexttemp
			result = false
		end
		if(action.name == "fade_out") then
			local temp = tick
			local nexttemp = temp
			nexttemp = nexttemp + (action.value*60) 
			action.tick = nexttemp
			result = false
		end	
		if(action.name == "set_timer") then
			if(currentTimer == nil) then
				local temp = tick
				local nexttemp = temp
				nexttemp = nexttemp + (action.value*60) 
				currentTimer = {}
				currentTimer.time = nexttemp
				currentTimer.value = (action.value) 
				currentTimer.message = action.message
				currentTimer.type = action.type
				ticktimer = 0
				else
				Game.GetPlayer():SetWarningMessage(getLang("An timer is already active."))
			end
		end
		
		
		
		
		
		if(action.name == "reset_timer") then
			currentTimer = nil
			
			ticktimer = 0
		end
		
		
		if(action.name == "open_stash") then
			local stash = getMainStash()
			if stash then
				local openEvent = NewObject('handle:OpenStash')
				openEvent:SetProperties()
				stash:OnOpenStash(openEvent)
			end
		end
		if(action.name == "open_door") then	
			if IsAFakeDoor(objLook) then
				objLook:Dispose()
				else
				local handlePS = objLook:GetDevicePS()
				if handlePS:IsLocked() then handlePS:ToggleLockOnDoor() end
				if handlePS:IsSealed() then handlePS:ToggleSealOnDoor() end
				if handlePS:IsSealed() then handlePS:ToggleSealOnDoor() end
				objLook:OpenDoor()
			end
		end
		if(action.name == "set_mappin") then
			local position = {}
			if(action.position == "at") then
				position.x = action.x
				position.y = action.y
				position.z = action.z
			end
			if(action.position == "poi_district") then
				local currentpoi = nil
				if(action.position_random == true) then
					local district = arrayDistricts[math.random(1,#arrayDistricts)]
					currentpoi = FindPOI(action.position_tag,district.EnumName,action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
					else
					currentpoi = FindPOI(action.position_tag,action.position_poi_district,action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
				end
				if(currentpoi ~= nil) then
					position.x = currentpoi.x
					position.y = currentpoi.y
					position.z = currentpoi.z
					else
					error("No POI founded ")
				end
			end
			if(action.position == "poi_subdistrict") then
				local currentpoi = nil
				if(action.position_random == true) then
					local district = arrayDistricts[math.random(1,#arrayDistricts)]
					local subdistrict = district.SubDistrict[math.random(1,#district.SubDistrict)]
					currentpoi = FindPOI(action.position_tag,action.position_poi_district,subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
					else
					local currentpoi = nil
					currentpoi = FindPOI(action.position_tag,action.position_poi_district,action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
				end
				if(currentpoi ~= nil) then
					position.x = currentpoi.x
					position.y = currentpoi.y
					position.z = currentpoi.z
					else
					error("No POI founded ")
				end
			end
			if(action.position == "poi_current_district") then
				local currentpoi = nil
				currentpoi = FindPOI(action.position_tag,currentDistricts2.districtLabels[2],action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
				if(currentpoi ~= nil) then
					position.x = currentpoi.x
					position.y = currentpoi.y
					position.z = currentpoi.z
					else
					error("No POI founded ")
				end
			end
			if(action.position == "poi_current_subdistrict") then
				local currentpoi = nil
				currentpoi = FindPOI(action.position_tag,action.position_poi_district,currentDistricts2.districtLabels[2],action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
				if(currentpoi ~= nil) then
					position.x = currentpoi.x
					position.y = currentpoi.y
					position.z = currentpoi.z
					else
					error("No POI founded ")
				end
			end
			if(action.position == "relative_to_entity") then
				local positionVec4 = Game.GetPlayer():GetWorldPosition()
				local entity = nil
				if(action.position_tag ~= "player") then
					local obj = getEntityFromManager(action.position_tag)
					entity = Game.FindEntityByID(obj.id)
					positionVec4 = entity:GetWorldPosition()
					else
					entity = Game.GetPlayer()
				end
				if(action.position_way ~= nil and (action.position_way ~= "" or action.position_way ~= "normal")) then
					if(action.position_way == "behind") then
						positionVec4 = getBehindPosition(entity,action.position_distance)
					end
					if(action.position_way == "forward") then
						positionVec4 = getForwardPosition(entity,action.position_distance)
					end
				end
				position.x = positionVec4.x
				position.y = positionVec4.y
				position.z = positionVec4.z
			end
			if(action.position == "node") then
				local node = getNode(action.position_tag)
				if node ~= nil then
					if(action.position_node_usegameplay == true) then
						position.x = node.GameplayX
						position.y = node.GameplayY
						position.z = node.GameplayZ
						else
						position.x = node.X
						position.y = node.Y
						position.z = node.Z
					end
					else
					error("can't find an node who have tag : "..action.position_tag)
				end
			end
			if(action.position == "current_node") then
				local position = Game.GetPlayer():GetWorldPosition()
				local range = 70
				if(action.position_node_current_detection_range ~= nil) then
					range = action.position_node_current_detection_range
				end
				local node = getNodefromPosition(position.x,position.y,position.z,range)
				if node ~= nil then
					if(action.position_node_usegameplay == true) then
						position.x = node.GameplayX
						position.y = node.GameplayY
						position.z = node.GameplayZ
						else
						position.x = node.X
						position.y = node.Y
						position.z = node.Z
					end
					else
					error("can't find an current node")
				end
			end
			if(action.position == "poi") then
				local currentpoi = nil
				currentpoi = FindPOI(action.position_tag,action.position_poi_district,action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
				if(currentpoi ~= nil) then
					position.x = currentpoi.x
					position.y = currentpoi.y
					position.z = currentpoi.z
					else
					error("can't find an current poi")
				end
			end
			if(action.position == "mappin") then
				local mappin = getMappinByTag(action.position_tag)
				if(mappin)then
					position = mappin.position
					else
					error("can't find an mappin with tag : "..action.position_tag)
				end
			end
			if(action.position == "fasttravel") then
				local markerref = nil
				local tempos = nil
				for j=1, #mappedFastTravelPoint do
					local point = mappedFastTravelPoint[j]
					if(point.markerref == action.position_tag) then
						markerref = point.markerrefdata
						tempos = point.position
						break
					end
				end
				if(markerref)then
					position = tempos
					else
					error("can't find an fast travel point with tag : "..action.position_tag)
				end
			end
			if(action.position == "current_custom_mappin") then
				if(ActivecustomMappin ~= nil)then
					local mappin = ActivecustomMappin:GetWorldPosition()
					position.x = mappin.x
					position.y = mappin.y
					position.z = mappin.z
					else
					error("can't find an current custom point ")
				end
			end
			if(action.position == "current_fasttravel") then
				if(ActiveFastTravelMappin ~= nil)then
					position.x = ActiveFastTravelMappin.position.x
					position.y = ActiveFastTravelMappin.position.y
					position.z = ActiveFastTravelMappin.position.z
					else
					error("can't find an current fast travel point ")
				end
			end
			if(action.position == "custom_place") then
				local house = getHouseByTag(action.position_tag)
				if(house ~= nil) then
					if(action.position_house_way == "default") then
						position.x = house.posX
						position.y = house.posY
						position.z = house.posZ
					end
					if(action.position_house_way == "enter") then
						position.x = house.EnterX
						position.y = house.EnterY
						position.z = house.EnterZ
					end
					if(action.position_house_way == "exit") then
						position.x = house.ExitX
						position.y = house.ExitY
						position.z = house.ExitZ
					end
					else
					error("can't find an custom place with tag : "..action.position_tag)
				end
			end
			if(action.position == "custom_room") then
				local room = getRoomByTag(action.position_tag,action.position_house_tag)
				if(room ~= nil) then
					position.x = room.posX
					position.y = room.posY
					position.z = room.posZ
					else
					error("can't find an custom room with tag : "..action.position_tag.." for the house with tag :"..action.position_house_tag)
				end
			end
			if(action.position == "current_custom_place") then
				if(currentHouse ~= nil) then
					if(action.position_house_way == "default") then
						position.x = currentHouse.posX
						position.y = currentHouse.posY
						position.z = currentHouse.posZ
					end
					if(action.position_house_way == "Enter") then
						position.x = currentHouse.EnterX
						position.y = currentHouse.EnterY
						position.z = currentHouse.EnterZ
					end
					if(action.position_house_way == "Exit") then
						position.x = currentHouse.ExitX
						position.y = currentHouse.ExitY
						position.z = currentHouse.ExitZ
					end
					else
					error("can't find an current custom place")
				end
			end	
			if(action.position == "current_custom_room") then
				if(currentRoom ~= nil) then
					position.x = currentRoom.posX
					position.y = currentRoom.posY
					position.z = currentRoom.posZ
					else
					error("can't find an current custom room")
				end				
			end
			if(position.x ~= nil and action.position ~= "at") then
				position.x = position.x + action.x
				position.y = position.y + action.y
				position.z = position.z + action.z
			end
			if(action.position ~= "on_entity" and action.position ~= "on_group")then
				if(position.x ~= nil)then
					registerMappin(position.x,position.y,position.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
					else
					error("can't make an mappin to this position")
				end
				else
				if(action.position == "on_entity")then
					if(action.position_tag ~= nil)then
						local obj = getEntityFromManager(action.position_tag)
						local enti = Game.GetPlayer()
						if(action.position_tag ~= "player") then 
							enti = Game.FindEntityByID(obj.id)
						end
						if(enti ~= nil) then
							registerMappintoEntity(enti,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
							else
							error("can't make an mappin to this entity")
						end
						else
						error("can't make an mappin to this entity")
					end
				end
				if(action.position == "on_group")then
					local group =getGroupfromManager(action.position_tag)
					if group ~= nil then
						for i=1, #group.entities do 
							local entityTag = group.entities[i]
							local obj = getEntityFromManager(entityTag)
							local enti = Game.FindEntityByID(obj.id)
							if(enti ~= nil) then
								local mapTag = action.position_tag.."_"..i
								registerMappintoEntity(enti,mapTag,action.typemap,action.wall,action.active,action.mapgroup,action.title,action.desc)
								else
								error("can't make an mappin to this entity")
							end
						end
						else
						error("can't make an mappin to this group")
					end
				end
			end
		end
		if(action.name == "new_map_point") then
			registerMappin(action.x,action.y,action.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
		end
		if(action.name == "new_map_point_from_district") then
			local currentpoi = nil
			local poilist = {}
			for i=1,#arrayPOI do
				if(#arrayPOI[i].locations > 0) then
					for y=1,#arrayPOI[i].locations do
						local location = arrayPOI[i].locations[y]
						if(location.district == action.district and (arrayPOI[i].isFor == nil or action.type == nil or(arrayPOI[i].isFor == action.type))) then
							table.insert(poilist,location)
						end
					end
				end
			end
			currentpoi = poilist[math.random(1,#poilist)]
			registerMappin(currentpoi.x,currentpoi.y,currentpoi.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
		end
		if(action.name == "new_map_point_from_subdistrict") then
			local currentpoi = nil
			local poilist = {}
			for i=1,#arrayPOI do
				if(#arrayPOI[i].locations > 0) then
					for y=1,#arrayPOI[i].locations do
						local location = arrayPOI[i].locations[y]
						if(location.subdistrict == action.subdistrict and (arrayPOI[i].isFor == nil or action.type == nil or(arrayPOI[i].isFor == action.type))) then
							table.insert(poilist,location)
						end
					end
				end
			end
			currentpoi = poilist[math.random(1,#poilist)]
			registerMappin(currentpoi.x,currentpoi.y,currentpoi.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
		end
		if(action.name == "new_map_point_from_currentdistrict") then
			local poilist = {}
			local currentpoi = nil
			for i=1,#arrayPOI do
				if(#arrayPOI[i].locations > 0) then
					for y=1,#arrayPOI[i].locations do
						local location = arrayPOI[i].locations[y]
						if(location.district == District2.customdistrict.EnumName and (arrayPOI[i].isFor == nil or action.type == nil or(arrayPOI[i].isFor == action.type))) then
							table.insert(poilist,location)
						end
					end
				end
			end
			currentpoi = poilist[math.random(1,#poilist)]
			registerMappin(currentpoi.x,currentpoi.y,currentpoi.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
		end
		if(action.name == "new_map_point_from_currentsubdistrict") then
			debugPrint(1,currentDistricts2.districtLabels[2])
			local currentpoi = nil
			local poilist = {}
			for i=1,#arrayPOI do
				if(#arrayPOI[i].locations > 0) then
					for y=1,#arrayPOI[i].locations do
						local location = arrayPOI[i].locations[y]
						if(location.subdistrict == currentDistricts2.districtLabels[2] and (arrayPOI[i].isFor == nil or action.type == nil or(arrayPOI[i].isFor == action.type))) then
							table.insert(poilist,location)
						end
					end
				end
			end
			currentpoi = poilist[math.random(1,#poilist)]
			registerMappin(currentpoi.x,currentpoi.y,currentpoi.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
		end
		if(action.name == "new_map_point_from_random_district") then
			local currentpoi = nil
			local poilist = {}
			local district = arrayDistricts[math.random(1,#arrayDistricts)]
			for i=1,#arrayPOI do
				if(#arrayPOI[i].locations > 0) then
					for y=1,#arrayPOI[i].locations do
						local location = arrayPOI[i].locations[y]
						if(location.district == district.EnumName and (arrayPOI[i].isFor == nil or action.type == nil or(arrayPOI[i].isFor == action.type))) then
							table.insert(poilist,location)
						end
					end
				end
			end
			currentpoi = poilist[math.random(1,#poilist)]
			if currentpoi ~= nil then
				registerMappin(currentpoi.x,currentpoi.y,currentpoi.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
			end
		end
		if(action.name == "new_map_point_from_random_subdistrict") then
			local currentpoi = nil
			local poilist = {}
			local district = arrayDistricts[math.random(1,#arrayDistricts)]
			local subdistrict = district.SubDistrict[math.random(1,#district.SubDistrict)]
			for i=1,#arrayPOI do
				if(#arrayPOI[i].locations > 0) then
					for y=1,#arrayPOI[i].locations do
						local location = arrayPOI[i].locations[y]
						if(location.subdistrict == action.subdistrict and (arrayPOI[i].isFor == nil or action.type == nil or(arrayPOI[i].isFor == action.type))) then
							table.insert(poilist,location)
						end
					end
				end
			end
			currentpoi = poilist[math.random(1,#poilist)]
			if currentpoi ~= nil then
				registerMappin(currentpoi.x,currentpoi.y,currentpoi.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
			end
		end
		if(action.name == "new_map_point_fast_travel") then
			local markerref = nil
			local position = nil
			for i=1, #mappedFastTravelPoint do
				local point = mappedFastTravelPoint[i]
				if(point.markerref == action.destination) then
					markerref = point.markerrefdata
					position = registerMappin(point.position.x,point.position.y,point.position.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,point,action.title,action.desc)
				end
			end
		end
		if(action.name == "new_map_point_fast_travel_random") then
			local markerref = nil
			local position = nil
			local index = math.random(1,#mappedFastTravelPoint)
			local point = mappedFastTravelPoint[index]
			debugPrint(1,#mappedFastTravelPoint)
			markerref = point.markerrefdata
			markerref = point.markerrefdata
			debugPrint(1,dump(point))
			position = registerMappin(point.position.x,point.position.y,point.position.z,action.tag,action.typemap,action.wall,action.active,action.mapgroup,point,action.title,action.desc)
		end
		if(action.name == "new_map_point_to_entity") then
			local obj = getEntityFromManager(action.entity)
			local enti = Game.GetPlayer()
			if(action.entity ~= "player") then 
				enti = Game.FindEntityByID(obj.id)
			end
			if(enti ~= nil) then
				registerMappintoEntity(enti,action.tag,action.typemap,action.wall,action.active,action.mapgroup,nil,action.title,action.desc)
			end
		end
		if(action.name == "new_map_point_to_group") then
			local group =getGroupfromManager(action.group)
			if group ~= nil then
				for i=1, #group.entities do 
					local entityTag = group.entities[i]
					local obj = getEntityFromManager(entityTag)
					local enti = Game.FindEntityByID(obj.id)
					if(enti ~= nil) then
						local mapTag = action.group.."_"..i
						registerMappintoEntity(enti,mapTag,action.typemap,action.wall,action.active,action.mapgroup,action.title,action.desc)
					end
				end
			end
		end
		if(action.name == "delete_map_point") then
			deleteMappinByTag(action.tag)
		end
		if(action.name == "delete_map_group") then
			local maplist = getMappinByGroup(action.mapgroup)
			if(#maplist > 0) then
				for i = 1,#maplist do 
					deleteMappinByTag(maplist[i].tag)
				end
			end
		end
		if(action.name == "active_map_point") then
			activeMappinByTag(action.tag,action.active)
		end
		if(action.name == "active_map_group") then
			local maplist = getMappinByGroup(action.mapgroup)
			if(#maplist > 0) then
				for i = 1,#maplist do 
					activeMappinByTag(maplist[i].tag,action.active)
				end
			end
		end
		if(action.name == "set_map_point_position") then
			setMappinPositionByTag(action.tag,action.x,action.y,action.z)
		end
		if(action.name == "set_map_group_position") then
			local maplist = getMappinByGroup(action.mapgroup)
			if(#maplist > 0) then
				for i = 1,#maplist do 
					setMappinPositionByTag(maplist[i].tag,action.x,action.y,action.z)
				end
			end
		end
		if(action.name == "set_map_point_type") then
			setMappinTypeByTag(action.tag,action.typemap)
		end
		if(action.name == "set_map_group_type") then
			local maplist = getMappinByGroup(action.mapgroup)
			if(#maplist > 0) then
				for i = 1,#maplist do 
					setMappinTypeByTag(maplist[i].tag,action.typemap)
				end
			end
		end
		if(action.name == "set_map_point_tracking_to") then
			setMappinTrackingByTag(action.tag,action.target)
		end
		if(action.name == "set_map_group_tracking_to") then
			local maplist = getMappinByGroup(action.mapgroup)
			if(#maplist > 0) then
				for i = 1,#maplist do 
					setMappinTrackingByTag(maplist[i].tag,action.target)
				end
			end
		end
		
		
		if(action.name == "save_lock") then
			if(action.value == true)then
				local request = SaveLockRequest.new()
				request.operation = EItemOperationType.ADD
				request.reason = 'FastTravel'
				GameInstance.QueueScriptableSystemRequest('SaveLocksManager', request)
				else
				
				local request = SaveLockRequest.new()
				request.operation = EItemOperationType.REMOVE
				request.reason = 'FastTravel'
				GameInstance.QueueScriptableSystemRequest('SaveLocksManager', request)
				
			end
		end
		
		
	end
	
	if relationregion then
		if(action.name == "dialog") then
			--debugPrint(1,"is print(source)
			local usedial =  SetNextDialog(action.dialog,source,executortag)
			-- debugPrint(1,source)
			-- debugPrint(1,executortag)
			-- debugPrint(1,usedial.Desc)
			createDialog(usedial)	
			-- debugPrint(1,source)
			-- if(source == "quest") then
			-- local dioal = SetNextDialog(action.value,source)
			-- if dioal.havequitoption == nil then dioal.havequitoption = true end
			-- debugPrint(1,dioal.Desc)
			-- openQuestDialogWindow = false
			-- currentQuestdialog = dioal
			-- openQuestDialogWindow = true
			-- end
			-- if(source == "interact") then
			-- local dioal = SetNextDialog(action.value,source)
			-- if dioal.havequitoption == nil then dioal.havequitoption = true end
			-- debugPrint(1,dioal.Desc)
			-- openEventDialogWindow = false
			-- currentEventDialog = dioal
			-- openEventDialogWindow = true
			-- end
			-- if(source == "phone") then
			-- local dioal = SetNextDialog(action.value,source)
			-- if dioal.havequitoption == nil then dioal.havequitoption = true end
			-- debugPrint(1,dioal.Desc)
			-- openPhoneDialogWindow = false
			-- currentPhoneDialog = dioal
			-- openPhoneDialogWindow = true
			-- --SetDialogPhoneUI(dioal)
			-- ------debugPrint(1,"dialog phone enabled")
			-- end
			-- if(source == "speak") then
			-- local dioal = SetNextDialog(action.value,source)
			-- if dioal.havequitoption == nil then dioal.havequitoption = true end
			-- debugPrint(1,dioal.Desc)
			-- openSpeakDialogWindow = false
			-- currentSpeakDialog = dioal
			-- openSpeakDialogWindow = true
			-- end
		end
		
		if(action.name == "speak_npc")then
			
			
			
			if(action.speaker == "current_phone_npc") then
				
				if(currentNPC ~= nil) then
					
					loadBasicDialog(currentNPC,action.way)
					
					else
					
					error("No Current NPC at Phone exist")
				end
				
				
				elseif(action.speaker == "current_star") then
				
				if(currentStar ~= nil) then
					
					loadBasicDialog(currentStar,action.way)
					else
					
					error("No Current Star exist")
				end
				
				
				else
				local phoned = findPhonedNPCByName(action.speaker)
				if(phoned ~= nil) then
					
					loadBasicDialog(phoned,action.way)
					else
					
					error("No NPC exist")
				end
			end
			
		end
		
		
		
		
		if(action.name == "speak_to_current_star")then
			
			
			if currentStar ~= nil then
				--if string.match(currentStar.Names,targName) then
				
				
				
				
				
				loadBasicDialog(currentStar,"speak")
				
				
				
				
				else
				error("Current Star is not defined")
				
			end
		end
		if(action.name == "incoming_call") then
			if(incomingCallGameController ~= nil) then
				local phoneCallInfo= questPhoneCallInformation.new()
				phoneCallInfo.callMode = action.callmode
				phoneCallInfo.isAudioCall  = (action.callmode == 1)
				phoneCallInfo.contactName =  CName(action.caller)
				phoneCallInfo.isPlayerCalling = false
				phoneCallInfo.isPlayerTriggered = false
				phoneCallInfo.callPhase = questPhoneCallPhase.IncomingCall
				phoneCallInfo.isRejectable = action.isrejectable
				incomingCallGameController:GetRootWidget():SetVisible(true)
				inkTextRef.SetLetterCase(incomingCallGameController.contactNameWidget, textLetterCase.UpperCase)
				inkTextRef.SetText(incomingCallGameController.contactNameWidget, action.caller)
				inkWidgetRef.SetVisible(incomingCallGameController.buttonHint,  action.isrejectable)
				currentPhoneCall = action
				incomingCallGameController:GetRootWidget():SetVisible(true)
				StatusEffectHelper.ApplyStatusEffect(Game.GetPlayer(), "GameplayRestriction.FistFight")
				if IsDefined(incomingCallGameController.animProxy) then
					incomingCallGameController.animProxy:Stop()
					incomingCallGameController.animProxy = nil
				end
				this.animProxy = incomingCallGameController.PlayLibraryAnimation("ring")
				else
				error("can't find incomingCallGameController controller, please call an npc for load one or reload an save")
			end
		end
		if(action.name == "subtitle") then 
			if(currentSubtitlesGameController ~= nil) then
				--debugPrint(1,"ye")
				local linesToShow = {}
				--currentSubtitlesGameController:Cleanup()
				local dialogLine = scnDialogLineData.new()
				local id = math.random(1,9999)
				dialogLine.id = CRUID(id)
				dialogLine.text  = getLang(action.title)
				dialogLine.type  = action.type
				dialogLine.speaker = Game.GetPlayer()
				dialogLine.speakerName  = action.speaker
				local candotext = true
				if(action.speaker == "current_phone_npc") then
					if(currentNPC ~= nil) then
						dialogLine.speakerName  = currentNPC.Names
						else
						candotext = false
					end
					elseif(action.speaker == "current_star") then
					if(currentStar ~= nil) then
						dialogLine.speakerName  = currentStar.Names
						else
						candotext = false
					end
					elseif(action.speaker == "entity") then
					local obj = getEntityFromManager(action.speakertag)
					dialogLine.speakerName = obj.name
					candotext = true
					elseif(action.speaker == "mp_player") then
					dialogLine.speakerName = myTag
					candotext = true
					elseif(action.speaker == "mp_looked_player") then
					if(multiName == "") then
						dialogLine.speakerName = "Player"
						else
						dialogLine.speakerName = multiName
					end
					candotext = true
					else
					dialogLine.speakerName = action.speaker
					candotext = true
				end
				if(candotext == true) then
					dialogLine.isPersistent  = true
					dialogLine.duration  = action.duration
					currentSubtitlesGameController:SpawnDialogLine(dialogLine)
					local temp = tick
					local nexttemp = temp
					nexttemp =nexttemp +  math.ceil((action.duration*60))
					action.tick = nexttemp
					result = false
				end
				else
				error("can't find Subtitle controller, please call an npc for load one")
			end
		end
		if(action.name == "random_subtitle") then 
			if(currentSubtitlesGameController ~= nil) then
				--debugPrint(1,"ye")
				local linesToShow = {}
				--currentSubtitlesGameController:Cleanup()
				local tago = math.random(1,#action.title)
				local dialogLine = scnDialogLineData.new()
				local id = math.random(1,9999)
				dialogLine.id = CRUID(id)
				dialogLine.text  = getLang(action.title[tago])
				dialogLine.type  = action.type
				dialogLine.speaker = Game.GetPlayer()
				dialogLine.speakerName  = action.speaker
				local candotext = true
				if(action.speaker == "current_phone_npc") then
					if(currentNPC ~= nil) then
						dialogLine.speakerName  = currentNPC.Names
						else
						candotext = false
					end
					elseif(action.speaker == "current_star") then
					if(currentStar ~= nil) then
						dialogLine.speakerName  = currentStar.Names
						else
						candotext = false
					end
					elseif(action.speaker == "entity") then
					local obj = getEntityFromManager(action.speakertag)
					dialogLine.speakerName = obj.name
					candotext = true
					else
					dialogLine.speakerName = action.speaker
					candotext = true
				end
				if(candotext == true) then
					dialogLine.isPersistent  = true
					dialogLine.duration  = action.duration
					currentSubtitlesGameController:SpawnDialogLine(dialogLine)
					local temp = tick
					local nexttemp = temp
					nexttemp =nexttemp +  math.ceil((action.duration*60))
					action.tick = nexttemp
					result = false
				end
				else
				error("can't find Subtitle controller, please call an npc for load one")
				
			end
		end
		if(action.name == "npc_chat") then 
			if(currentChattersGameController ~= nil) then
				local linesToShow = {}
				local obj = getEntityFromManager(action.target)
				local enti = Game.FindEntityByID(obj.id)
				if(action.target == "lookat")then
					enti = objLook
				end
				if(enti ~= nil) then
					local dialogLine = scnDialogLineData.new()
					local id = math.random(1,9999)
					dialogLine.id = CRUID(id)
					dialogLine.text  = getLang(action.title)
					dialogLine.type  = action.type
					local candotext = true
					dialogLine.speaker = enti
					dialogLine.speakerName  = action.speaker
					if(action.speaker == "current_phone_npc") then
						if(currentNPC ~= nil) then
							dialogLine.speakerName  = currentNPC.Names
							else
							candotext = false
						end
					end
					if(action.speaker == "current_star") then
						if(currentStar ~= nil) then
							dialogLine.speakerName  = currentStar.Names
							else
							candotext = false
						end
					end
					if(action.speaker == "entity") then
						local obj = getEntityFromManager(action.speakertag)
						dialogLine.speakerName = obj.name
						candotext = true
					end
					if(candotext == true) then
						dialogLine.isPersistent  = true
						dialogLine.duration  = action.duration
						currentChattersGameController:SpawnDialogLine(dialogLine)
						local temp = tick
						--debugPrint(1,temp)
						local nexttemp = temp
						--debugPrint(1,math.ceil((action.value*60)))
						nexttemp =nexttemp +  math.ceil((action.duration*60))
						--debugPrint(1,nexttemp)
						action.tick = nexttemp
						result = false
					end
				end
				else
				error("can't find chat Subtitle controller, please go to see an npc who speak in street or an TV or an Radio for load one")
				
			end
		end
		if(action.name == "random_npc_chat") then 
			if(currentChattersGameController ~= nil) then
				local linesToShow = {}
				local tago = math.random(1,#action.title)
				local obj = getEntityFromManager(action.target)
				local enti = Game.FindEntityByID(obj.id)
				if(action.target == "lookat")then
					enti = objLook
				end
				if(enti ~= nil) then
					local dialogLine = scnDialogLineData.new()
					local id = math.random(1,9999)
					dialogLine.id = CRUID(id)
					dialogLine.text  = getLang(action.title[tago])
					dialogLine.type  = action.type
					local candotext = true
					dialogLine.speaker = enti
					dialogLine.speakerName  = action.speaker
					if(action.speaker == "current_phone_npc") then
						if(currentNPC ~= nil) then
							dialogLine.speakerName  = currentNPC.Names
							else
							candotext = false
						end
					end
					if(action.speaker == "current_star") then
						if(currentStar ~= nil) then
							dialogLine.speakerName  = currentStar.Names
							else
							candotext = false
						end
					end
					if(action.speaker == "entity") then
						local obj = getEntityFromManager(action.speakertag)
						dialogLine.speakerName = obj.name
						candotext = true
					end
					if(candotext == true) then
						dialogLine.isPersistent  = true
						dialogLine.duration  = action.duration
						currentChattersGameController:SpawnDialogLine(dialogLine)
						local temp = tick
						--debugPrint(1,temp)
						local nexttemp = temp
						--debugPrint(1,math.ceil((action.value*60)))
						nexttemp =nexttemp +  math.ceil((action.duration*60))
						--debugPrint(1,nexttemp)
						action.tick = nexttemp
						result = false
					end
				end
				else
				error("can't find chat Subtitle controller, please go to see an npc who speak in street or an TV or an Radio for load one")
			end
		end
		if(action.name == "clean_subtitle") then 
			if(currentSubtitlesGameController ~= nil) then
				currentSubtitlesGameController:Cleanup()
				currentSubtitlesGameController:Cleanup()
			end
		end
		if(action.name == "clean_npc_chat") then 
			if(currentChattersGameController ~= nil) then
				currentChattersGameController:Cleanup()
				currentChattersGameController:Cleanup()
			end
		end
		if(action.name == "do_random_dialog")then
			local tago = math.random(1,#action.dialog)
			--	debugPrint(1,action.dialog[tago])
			if( tago ~= nil) then
				createDialog(SetNextDialog(action.dialog[tago],source,executortag))
			end
		end
		if(action.name == "npc_star_affinity") then
			if(currentStar ~= nil) then
				local score = getScoreKey(currentStar.Names,"Score")
				if(score == nil) then score = 0 end
				score = score + action.value
				setScore(currentStar.Names,"Score",score)
			end
		end
		if(action.name == "npc_affinity") then
			local score = getScoreKey(action.value,"Score")
			if(score == nil) then score = 0 end
			score = score + action.score
			setScore(action.value,"Score",score)
		end
		if(action.name == "entity_affinity") then
			local obj = getEntityFromManager(action.tag)
			debugPrint(1,dump((obj)))
			local score = getScoreKey(obj.name,"Score")
			if(score == nil) then score = 0 end
			score = score + action.score
			setScore(obj.name,"Score",score)
		end
		if(action.name == "custom_star_message") then
			------debugPrint(1,npcStarSpawn)
			if(npcStarSpawn) then
				customEventMessage(action.value, currentStar)
			end
		end
		if(action.name == "change_dialog_windows") then
			if(action.window == "quest" ) then
				if(string.lower(tostring(action.value)) == "true")then
					openQuestDialogWindow = true
					else
					openQuestDialogWindow = false
					currentQuestdialog = nil
				end
			end
			if(action.window == "speak" ) then
				if(string.lower(tostring(action.value)) == "true")then
					openSpeakDialogWindow = true
					else
					openSpeakDialogWindow = false
					currentSpeakDialog = nil
				end
			end
			if(action.window == "phone" ) then
				if(string.lower(tostring(action.value)) == "true")then
					openPhoneDialogWindow = true
					else
					openPhoneDialogWindow = false
					currentPhoneDialog = nil
				end
			end
			if(action.window == "event" ) then
				if(string.lower(tostring(action.value)) == "true")then
					openEventDialogWindow = true
					else
					openEventDialogWindow = false
					currentEventDialog = nil
				end
			end
		end
	end
	
	if questregion then
		if(action.name == "change_quest_content") then
			QuestManager.ChangeQuestContent(action.tag,getLang(action.value))
		end
		if(action.name == "change_objective_content") then
			QuestManager.ChangeObjectiveContent(action.tag,getLang(action.value))
		end
		if(action.name == "mission") then
			TriggerQuest(action.value)
			MarkQuestAsActive(action.value)
		end
		if(action.name == "lock_mission") then
			setScore(action.value,"Score",nil)
			QuestManager.MarkQuestAsUnVisited(action.value)
		end
		if(action.name == "lock_objective") then
			QuestManager.MarkObjectiveAsUndefined(action.value)
			if(QuestManager.IsTrackedObjective(action.value)) then
				QuestManager.UntrackObjective()
			end
		end
		if(action.name == "unlock_objective") then
			QuestManager.MarkObjectiveAsActive(action.value)
		end
		if(action.name == "inactive_objective") then
			QuestManager.MarkObjectiveAsInactive(action.value)
			if(QuestManager.IsTrackedObjective(action.value)) then
				QuestManager.UntrackObjective()
			end
		end
		if(action.name == "fail_objective") then
			QuestManager.MarkObjectiveAsFailed(action.value)
		end
		if(action.name == "win_objective") then
			QuestManager.MarkObjectiveAsComplete(action.value)
		end
		if(action.name == "track_objective") then
			QuestManager.TrackObjective(action.value)
		end
		if(action.name == "unlock_mission") then
			setScore(action.value,"Score",0)
		end
		if(action.name == "finish_mission") then
			if currentQuest ~= nil and currentQuest.tag == action.tag then
				canDoEndAction = true
				else
				if currentQuest ~= nil and currentQuest.tag ~= action.tag then
					result = false
				end
			end
		end
		if(action.name == "fail_mission") then
			if currentQuest ~= nil then
				canDoFailAction = true
			end
		end
		if(action.name == "reset_mission") then
			if getQuestByTag(action.tag) ~= nil then
				QuestManager.resetQuestfromJson(action.tag)
			end
		end
	end
	
	if noderegion then
		if(action.name == "draw_custom_3Dmappin_node") then
			local node = getNode(action.tag)
			if(action.atgameplayposition)then
				draw3DCustomMappin(node.GameplayX,node.GameplayY,node.GameplayZ)
				else
				draw3DCustomMappin(node.X,node.Y,node.Z)
			end
		end
		if(action.name == "set_entity_circuit") then
			local circuit = getCircuit(action.circuit)
			circuit.reverse = action.reverse
			local obj = getEntityFromManager(action.tag)
			obj.circuit = circuit
		end
		if(action.name == "set_entity_node_current") then
			local obj = getEntityFromManager(action.tag)
			obj.currentNode = getNode(action.node)
		end
		if(action.name == "set_entity_node_current_auto") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			local positionVec4 = enti:GetWorldPosition()
			obj.currentNode = getNodefromPosition(positionVec4.x, positionVec4.y, positionVec4.z, action.range)
		end
		if(action.name == "set_entity_node_next") then
			local obj = getEntityFromManager(action.tag)
			if(obj.circuit.reverse == false) then
				local nextNodeIndex = getNodeIndexFromCircuit(action.node,obj.circuit.nodes)
				obj.nextNode = obj.circuit.nodes[nextNodeIndex+1]
				else
				local inversed_circuit = reverseTable(obj.circuit.nodes)
				local nextNodeIndex = getNodeIndexFromCircuit(action.node,inversed_circuit)
				obj.nextNode = inversed_circuit[nextNodeIndex+1]
			end
		end
		if(action.name == "set_entity_node_next_auto") then
			local obj = getEntityFromManager(action.tag)
			if(obj.circuit.reverse == false) then
				local nextNodeIndex = getNodeIndexFromCircuit(obj.currentNode.tag,obj.circuit.nodes)
				obj.nextNode = getNode(obj.circuit.nodes[nextNodeIndex+1])
				else
				local inversed_circuit = reverseTable(obj.circuit.nodes)
				local nextNodeIndex = getNodeIndexFromCircuit(obj.currentNode.tag,inversed_circuit)
				obj.nextNode = getNode(inversed_circuit[nextNodeIndex+1])
			end
		end
		if(action.name == "set_entity_node_path") then
			local obj = getEntityFromManager(action.tag)
			obj.path = getPath(action.path)
			if(obj.path == nil) then
				Game.GetPlayer():SetWarningMessage("There is no Path for this two nodes...")
				else
				obj.path.reverse = obj.circuit.reverse
				if(obj.path.reverse == true) then
					obj.path.index = #obj.path.locations
					obj.path.finish = false
					else
					track.index = 1
					obj.path.finish = false
				end
			end
		end
		if(action.name == "set_entity_node_path_auto") then
			local obj = getEntityFromManager(action.tag)
			obj.path = getPathBetweenTwoNode(obj.currentNode.tag, obj.nextNode.tag)
			if(obj.path == nil) then
				Game.GetPlayer():SetWarningMessage("There is no Path for this two nodes...")
				else
				obj.path.reverse = obj.circuit.reverse
				if(obj.path.reverse == true) then
					obj.path.index = #obj.path.locations
					obj.path.finish = false
					else
					obj.path.index = 1
					obj.path.finish = false
				end
			end
		end
		if(action.name == "run_entity_path") then
			local obj = getEntityFromManager(action.tag)
			if(obj ~= nil and obj.path ~= nil) then
				local actionlist = {}
				--debugPrint(1,#actionlist)
				--doActionofIndex(actionlist,"interact",listaction,currentindex)
				result = false
				local path = getEntityFromManager(group.entities[1]).path
				if(path.reverse == false) then
					for i=1,#path.locations do
						local trackpos = obj.path.locations[i]
						local nexttrackpos = obj.path.locations[i+1]
						if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
							debugPrint(1,obj.path.index)
							local direction = {}
							local separate = 0
							if(action.separate ~= nil and action.separate == true) then
								separate = i-1
							end
							direction.x = nexttrackpos.x-separate
							direction.y = nexttrackpos.y-separate
							direction.z = nexttrackpos.z+action.zoffset
							direction.w = 1
							local enti = Game.FindEntityByID(obj.id)
							if(enti ~= nil) then
								local isplayer = false
								if entityTag == "player" then
									isplayer = true
								end
								local dirVector = diffVector(enti:GetWorldPosition(), direction)
								local angle = GetSingleton('Vector4'):ToRotation(dirVector)
								if(path.recordRotation == true) then
									angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
								end
								--debugPrint(1,"yaw "..angle.yaw)
								local newaction = {}
								newaction.name = "teleport_entity_at_position"
								newaction.tag = entityTag
								newaction.x = direction.x
								newaction.y = direction.y
								newaction.z = direction.z
								newaction.angle = angle
								table.insert(actionlist,newaction)
								
								
								if(trackpos.action ~= nil and #trackpos.action > 0) then
									
									for y=1,#trackpos.action do
										
										table.insert(actionlist,trackpos.action[y])
										
									end
									
									
								end
							end
							else
							obj.path.finish = true
						end
					end
					else
					for i= #path.locations, 1,-1 do
						if(obj ~= nil) then
							local trackpos = obj.path.locations[i]
							local nexttrackpos = obj.path.locations[i+1]
							if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
								debugPrint(1,obj.path.index)
								local direction = {}
								local separate = 0
								if(action.separate ~= nil and action.separate == true) then
									separate = i-1
								end
								direction.x = nexttrackpos.x-separate
								direction.y = nexttrackpos.y-separate
								direction.z = nexttrackpos.z+action.zoffset
								direction.w = 1
								local enti = Game.FindEntityByID(obj.id)
								if(enti ~= nil) then
									local isplayer = false
									if entityTag == "player" then
										isplayer = true
									end
									local dirVector = diffVector(enti:GetWorldPosition(), direction)
									local angle = GetSingleton('Vector4'):ToRotation(dirVector)
									if(path.recordRotation == true) then
										angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
									end
									--debugPrint(1,"yaw "..angle.yaw)
									local newaction = {}
									newaction.name = "teleport_entity_at_position"
									newaction.tag = entityTag
									newaction.x = direction.x
									newaction.y = direction.y
									newaction.z = direction.z
									newaction.angle = angle
									table.insert(actionlist,newaction)
									
									
									if(trackpos.action ~= nil and #trackpos.action > 0) then
										
										for y=1,#trackpos.action do
											
											table.insert(actionlist,trackpos.action[y])
											
										end
										
										
									end
								end
								else
								obj.path.finish = true
							end
						end
					end
				end
				-- for i=1,#actionlist do 
				-- executeAction(actionlist[i],tag,parent,index,source)
				-- end
				runSubActionList(actionlist, "run_path_"..math.random(1,99999), tag,source,false,executortag)
			end
		end
		
		if(action.name == "play_path") then
			local obj = getEntityFromManager(action.tag)
			if(obj ~= nil ) then
				local actionlist = {}
				--debugPrint(1,#actionlist)
				--doActionofIndex(actionlist,"interact",listaction,currentindex)
				result = false
				local path = getPath(action.path)
				if(action.reverse == nil or action.reverse == false) then
					path.index = 1
					for i=1,#path.locations do
						local trackpos = path.locations[i]
						local nexttrackpos = path.locations[i+1]
						if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
							debugPrint(1,path.index)
							local direction = {}
							local separate = 0
							if(action.separate ~= nil and action.separate == true) then
								separate = i-1
							end
							direction.x = nexttrackpos.x-separate
							direction.y = nexttrackpos.y-separate
							direction.z = nexttrackpos.z+action.zoffset
							direction.w = 1
							local enti = Game.FindEntityByID(obj.id)
							if(enti ~= nil) then
								local isplayer = false
								if action.tag == "player" then
									isplayer = true
								end
								local dirVector = diffVector(enti:GetWorldPosition(), direction)
								local angle = GetSingleton('Vector4'):ToRotation(dirVector)
								if(path.recordRotation == true) then
									angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
								end
								--debugPrint(1,"yaw "..angle.yaw)
								
								local newaction = {}
								if(action.isrelative ~= nil and action.isrelative == true) then
									newaction.name = "teleport_entity_at_relative_position"
									
									else
									newaction.name = "teleport_entity_at_position"
								end
								newaction.tag = action.tag
								newaction.x = direction.x
								newaction.y = direction.y
								newaction.z = direction.z
								newaction.angle = angle
								table.insert(actionlist,newaction)
								
								if(trackpos.action ~= nil and #trackpos.action > 0) then
									
									for y=1,#trackpos.action do
										
										table.insert(actionlist,trackpos.action[y])
										
									end
									
									
								end
							end
							else
							obj.path = {} 
							obj.path.finish = true
						end
					end
					else
					path.index = #path.locations
					for i= #path.locations, 1,-1 do
						if(obj ~= nil) then
							local trackpos = path.locations[i]
							local nexttrackpos = path.locations[i+1]
							if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
								debugPrint(1,path.index)
								local direction = {}
								local separate = 0
								if(action.separate ~= nil and action.separate == true) then
									separate = i-1
								end
								direction.x = nexttrackpos.x-separate
								direction.y = nexttrackpos.y-separate
								direction.z = nexttrackpos.z+action.zoffset
								direction.w = 1
								local enti = Game.FindEntityByID(obj.id)
								if(enti ~= nil) then
									local isplayer = false
									if action.tag == "player" then
										isplayer = true
									end
									local dirVector = diffVector(enti:GetWorldPosition(), direction)
									local angle = GetSingleton('Vector4'):ToRotation(dirVector)
									if(path.recordRotation == true) then
										angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
									end
									--debugPrint(1,"yaw "..angle.yaw)
									local newaction = {}
									if(action.isrelative ~= nil and action.isrelative == true) then
										newaction.name = "teleport_entity_at_relative_position"
										
										else
										newaction.name = "teleport_entity_at_position"
									end
									newaction.tag = action.tag
									newaction.x = direction.x
									newaction.y = direction.y
									newaction.z = direction.z
									newaction.angle = angle
									table.insert(actionlist,newaction)
									if(trackpos.action ~= nil and #trackpos.action > 0) then
										
										for y=1,#trackpos.action do
											
											table.insert(actionlist,trackpos.action[y])
											
										end
										
										
									end
									
								end
								else
								obj.path = {} 
								obj.path.finish = true
							end
						end
					end
				end
				-- for i=1,#actionlist do 
				-- executeAction(actionlist[i],tag,parent,index,source)
				-- end
				spdlog.error(dump(actionlist))
				runSubActionList(actionlist, "run_path_"..math.random(1,99999), tag,source,false,executortag)
			end
		end
		
		
		
		if(action.name == "clean_entity_circuit") then
			local obj = getEntityFromManager(action.tag)
			if(obj ~= nil) then
				obj.path = nil
				obj.circuit = nil
				obj.currentNode = nil
				obj.nextNode = nil
			end
		end
		if(action.name == "summon_entity_at_node") then
			local node = getNode(action.node)
			local isAV = false
			if(action.isAV ~= nil) then
				isAV = action.isAV
			end
			chara = action.npc
			if(action.atgameplayposition) then
				spawnEntity(chara, action.tag, node.GameplayX, node.GameplayY ,node.GameplayZ,action.spawnlevel,action.ambush, isAV,action.beta)
				else
				spawnEntity(chara, action.tag, node.X, node.Y ,node.Z,action.spawnlevel,action.ambush,isAV,action.beta)
			end
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "summon_entity_at_mappin") then
			local mappin = getMappinByTag(action.mappin)
			local isAV = false
			if(action.isAV ~= nil) then
				isAV = action.isAV
			end
			chara = action.npc
			if(mappin) then
				spawnEntity(chara, action.tag, mappin.position.x, mappin.position.y ,mappin.position.z,action.spawnlevel,action.ambush, isAV,action.beta)
				if(action.group ~= nil and action.group ~= "") then
					local index =getIndexFromGroupManager(action.group)
					table.insert(questMod.GroupManager[index].entities,action.tag)
				end
			end
		end
		if(action.name == "teleport_entity_at_node") then
			local node = getNode(action.node)
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			local isplayer = false
			if(action.tag == "player") then
				enti = Game.GetPlayer()
				isplayer = true
			end
			if(enti ~= nil) then
				--debugPrint(1,"moveit")
				if(action.atgameplayposition) then
					teleportTo(enti, Vector4.new( node.GameplayX+action.offset, node.GameplayY, node.GameplayZ,1), 1,isplayer)
					else
					teleportTo(enti, Vector4.new( node.X+action.offset, node.Y, node.Z,1), 1,isplayer)
				end
			end
		end
		if(action.name == "teleport_entity_at_current_node") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			local isplayer = false
			if(action.tag == "player") then
				enti = Game.GetPlayer()
				isplayer = true
			end
			local position = enti:GetWorldPosition()
			local range = 70
			if(action.range ~= nil) then
				range = action.range
			end
			local node = getNodefromPosition(position.x,position.y,position.z,range)
			if node ~= nil then
				if(enti ~= nil) then
					debugPrint(1,"tp to node "..node.name)
					if(action.atgameplayposition) then
						teleportTo(enti, Vector4.new( node.GameplayX+action.offset, node.GameplayY, node.GameplayZ,1), 1,isplayer)
						else
						teleportTo(enti, Vector4.new( node.X+action.offset, node.Y, node.Z,1), 1,isplayer)
					end
				end
			end
		end
		if(action.name == "summon_entity_at_current_node") then
			local position = Game.GetPlayer():GetWorldPosition()
			local range = 70
			if(action.range ~= nil) then
				range = action.range
			end
			local node = getNodefromPosition(position.x,position.y,position.z,range)
			if node ~= nil then
				chara = action.npc
				local isAV = false
				if(action.isAV ~= nil) then
					isAV = action.isAV
				end
				if(action.atgameplayposition) then
					spawnEntity(chara, action.tag, node.GameplayX, node.GameplayY ,node.GameplayZ,action.spawnlevel,action.ambush,isAV,action.beta)
					else
					spawnEntity(chara, action.tag, node.X, node.Y ,node.Z,action.spawnlevel,action.ambush,isAV,action.beta)
				end
				if(action.group ~= nil and action.group ~= "") then
					local index =getIndexFromGroupManager(action.group)
					table.insert(questMod.GroupManager[index].entities,action.tag)
				end
			end
		end
		if(action.name == "set_group_circuit") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				debugPrint(1,entityTag)
				debugPrint(1,action.circuit)
				local obj = getEntityFromManager(entityTag)
				local circuit = getCircuit(action.circuit)
				debugPrint(1,dump(circuit))
				debugPrint(1,dump(obj))
				obj.circuit =circuit
				debugPrint(1,"set circuit.."..obj.circuit.tag)
				debugPrint(1,"action.reverse"..tostring(action.reverse))
				obj.circuit.reverse = action.reverse
			end
		end
		if(action.name == "set_group_node_current") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getTrueEntityFromManager(entityTag)
				obj.currentNode = getNode(action.node)
				setEntityFromManager(entityTag,obj)
			end
		end
		if(action.name == "set_group_node_current_auto") then
			local group =getGroupfromManager(action.tag)
			debugPrint(1,"test.."..#group.entities)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getTrueEntityFromManager(entityTag)
				local enti = Game.FindEntityByID(obj.id)
				local positionVec4 = enti:GetWorldPosition()
				obj.currentNode = getNodefromPosition(positionVec4.x, positionVec4.y, positionVec4.z, action.range)
				debugPrint(1,"currentNode "..obj.currentNode.tag)	
				--	setEntityFromManager(entityTag,obj)
			end
		end
		if(action.name == "set_group_node_next") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				if(obj.circuit.reverse == false ) then
					local nextNodeIndex = getNodeIndexFromCircuit(action.node,obj.circuit.nodes)
					obj.nextNode = obj.circuit.nodes[nextNodeIndex+1]
					else
					local inversed_circuit = reverseTable(obj.circuit.nodes)
					local nextNodeIndex = getNodeIndexFromCircuit(action.node,inversed_circuit)
					obj.nextNode = inversed_circuit[nextNodeIndex+1]
				end
			end
		end
		if(action.name == "set_group_node_next_auto") then
			local group =getGroupfromManager(action.tag)
			debugPrint(1,"test.."..#group.entities)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getTrueEntityFromManager(entityTag)
				debugPrint(1,"currentNode "..obj.currentNode.tag)	
				debugPrint(1,#obj.circuit)
				debugPrint(1,tostring(obj.circuit.reverse))
				if(obj.circuit.reverse == false or obj.circuit.reverse == nil) then
					local nextNodeIndex = getNodeIndexFromCircuit(obj.currentNode.tag,obj.circuit.nodes)
					debugPrint(1,"nextNodeIndex "..nextNodeIndex)
					obj.nextNode = getNode(obj.circuit.nodes[nextNodeIndex+1])
					debugPrint(1,"nextNode "..obj.nextNode.tag)
					setEntityFromManager(entityTag,obj)
					else
					local inversed_circuit = reverseTable(obj.circuit.nodes)
					local nextNodeIndex = getNodeIndexFromCircuit(obj.currentNode.tag,inversed_circuit)
					obj.nextNode = getNode(inversed_circuit[nextNodeIndex+1])
					--setEntityFromManager(entityTag,obj)
				end
			end
		end
		if(action.name == "set_group_node_path") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				obj.path = getPath(action.path)
				if(obj.path == nil) then
					Game.GetPlayer():SetWarningMessage("There is no Path for this two nodes...")
					else
					obj.path.reverse = obj.circuit.reverse
					if(obj.path.reverse == true) then
						obj.path.index = #obj.path.locations
						obj.path.finish = false
						else
						track.index = 1
						obj.path.finish = false
					end
				end
			end
		end
		if(action.name == "set_group_node_path_auto") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				debugPrint(1,obj.currentNode.tag)
				debugPrint(1,obj.nextNode.tag)
				if(obj.circuit.reverse == true) then
					obj.path = getPathBetweenTwoNode(obj.nextNode.tag, obj.currentNode.tag)
					else
					obj.path = getPathBetweenTwoNode(obj.currentNode.tag, obj.nextNode.tag)
				end
				if(obj.path == nil) then
					Game.GetPlayer():SetWarningMessage("There is no Path for this two nodes...")
					else
					obj.path.reverse = obj.circuit.reverse
					if(obj.path.reverse == true) then
						obj.path.index = #obj.path.locations
						obj.path.finish = false
						else
						obj.path.index = 1
						obj.path.finish = false
					end
				end
			end
		end
		
		if(action.name == "run_group_path_cached" or action.name == "run_group_path") then
			local group =getGroupfromManager(action.tag)
			local actionlist = {}
			--debugPrint(1,#actionlist)
			--doActionofIndex(actionlist,"interact",listaction,currentindex)
			result = false
			local path = getEntityFromManager(group.entities[1]).path
			if(path.reverse == false) then
				for i=1,#path.locations do
					for y=1, #group.entities do 
						local entityTag = group.entities[y]
						local obj = getEntityFromManager(entityTag)
						if(obj ~= nil) then
							local trackpos = obj.path.locations[i]
							local nexttrackpos = obj.path.locations[i+1]
							if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
								debugPrint(1,obj.path.index)
								local direction = {}
								local separate = 0
								if(action.separate ~= nil and action.separate == true) then
									separate = i-1
								end
								direction.x = nexttrackpos.x-separate
								direction.y = nexttrackpos.y-separate
								direction.z = nexttrackpos.z+action.zoffset
								direction.w = 1
								local enti = Game.FindEntityByID(obj.id)
								if(enti ~= nil) then
									local isplayer = false
									if entityTag == "player" then
										isplayer = true
									end
									local dirVector = diffVector(enti:GetWorldPosition(), direction)
									local angle = GetSingleton('Vector4'):ToRotation(dirVector)
									if(path.recordRotation == true) then
										angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
									end
									--debugPrint(1,"yaw "..angle.yaw)
									local newaction = {}
									if(action.isrelative ~= nil and action.isrelative == true) then
										newaction.name = "teleport_entity_at_relative_position"
										
										else
										newaction.name = "teleport_entity_at_position"
									end
									newaction.tag = entityTag
									newaction.x = direction.x
									newaction.y = direction.y
									newaction.z = direction.z
									newaction.angle = angle
									table.insert(actionlist,newaction)
									
									if(trackpos.action ~= nil and #trackpos.action > 0) then
										
										for y=1,#trackpos.action do
											
											table.insert(actionlist,trackpos.action[y])
											
										end
										
										
									end
								end
								else
								obj.path.finish = true
							end
						end
					end
				end
				else
				for i= #path.locations, 1,-1 do
					for y=1, #group.entities do 
						local entityTag = group.entities[y]
						local obj = getEntityFromManager(entityTag)
						if(obj ~= nil) then
							local trackpos = obj.path.locations[i]
							local nexttrackpos = obj.path.locations[i+1]
							if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
								debugPrint(1,obj.path.index)
								local direction = {}
								local separate = 0
								if(action.separate ~= nil and action.separate == true) then
									separate = i-1
								end
								direction.x = nexttrackpos.x-separate
								direction.y = nexttrackpos.y-separate
								direction.z = nexttrackpos.z+action.zoffset
								direction.w = 1
								local enti = Game.FindEntityByID(obj.id)
								if(enti ~= nil) then
									local isplayer = false
									if entityTag == "player" then
										isplayer = true
									end
									local dirVector = diffVector(enti:GetWorldPosition(), direction)
									local angle = GetSingleton('Vector4'):ToRotation(dirVector)
									if(path.recordRotation == true) then
										angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
									end
									--debugPrint(1,"yaw "..angle.yaw)
									local newaction = {}
									if(action.isrelative ~= nil and action.isrelative == true) then
										newaction.name = "teleport_entity_at_relative_position"
										
										else
										newaction.name = "teleport_entity_at_position"
									end
									newaction.tag = entityTag
									newaction.x = direction.x
									newaction.y = direction.y
									newaction.z = direction.z
									newaction.angle = angle
									table.insert(actionlist,newaction)
									
									if(trackpos.action ~= nil and #trackpos.action > 0) then
										
										for y=1,#trackpos.action do
											
											table.insert(actionlist,trackpos.action[y])
											
										end
										
										
									end
								end
								else
								obj.path.finish = true
							end
						end
					end
				end
			end
			-- for i=1,#actionlist do 
			-- executeAction(actionlist[i],tag,parent,index,source)
			-- end
			runSubActionList(actionlist, "run_path_"..math.random(1,99999), tag,source,false,executortag)
		end
		
		-- end
		if(action.name == "play_group_path_cached" or action.name == "play_group_path") then
			local group =getGroupfromManager(action.tag)
			local actionlist = {}
			--debugPrint(1,#actionlist)
			--doActionofIndex(actionlist,"interact",listaction,currentindex)
			result = false
			local path =  getPath(action.path)
			if(path.reverse == false) then
				for i=1,#path.locations do
					for y=1, #group.entities do 
						local entityTag = group.entities[y]
						local obj = getEntityFromManager(entityTag)
						if(obj ~= nil) then
							local trackpos = path.locations[i]
							local nexttrackpos = path.locations[i+1]
							if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
								debugPrint(1,path.index)
								local direction = {}
								local separate = 0
								if(action.separate ~= nil and action.separate == true) then
									separate = i-1
								end
								direction.x = nexttrackpos.x-separate
								direction.y = nexttrackpos.y-separate
								direction.z = nexttrackpos.z+action.zoffset
								direction.w = 1
								local enti = Game.FindEntityByID(obj.id)
								if(enti ~= nil) then
									local isplayer = false
									if entityTag == "player" then
										isplayer = true
									end
									local dirVector = diffVector(enti:GetWorldPosition(), direction)
									local angle = GetSingleton('Vector4'):ToRotation(dirVector)
									if(path.recordRotation == true) then
										angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
									end
									--debugPrint(1,"yaw "..angle.yaw)
									local newaction = {}
									
									if(action.isrelative ~= nil and action.isrelative == true) then
										newaction.name = "teleport_entity_at_relative_position"
										
										else
										newaction.name = "teleport_entity_at_position"
									end
									newaction.tag = entityTag
									newaction.x = direction.x
									newaction.y = direction.y
									newaction.z = direction.z
									newaction.angle = angle
									table.insert(actionlist,newaction)
								end
								else
								obj.path = {} 
								obj.path.finish = true
							end
						end
					end
				end
				else
				for i= #path.locations, 1,-1 do
					for y=1, #group.entities do 
						local entityTag = group.entities[y]
						local obj = getEntityFromManager(entityTag)
						if(obj ~= nil) then
							local trackpos = path.locations[i]
							local nexttrackpos = path.locations[i+1]
							if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
								debugPrint(1,path.index)
								local direction = {}
								local separate = 0
								if(action.separate ~= nil and action.separate == true) then
									separate = i-1
								end
								direction.x = nexttrackpos.x-separate
								direction.y = nexttrackpos.y-separate
								direction.z = nexttrackpos.z+action.zoffset
								direction.w = 1
								local enti = Game.FindEntityByID(obj.id)
								if(enti ~= nil) then
									local isplayer = false
									if entityTag == "player" then
										isplayer = true
									end
									local dirVector = diffVector(enti:GetWorldPosition(), direction)
									local angle = GetSingleton('Vector4'):ToRotation(dirVector)
									if(path.recordRotation == true) then
										angle = EulerAngles.new(trackpos.roll, trackpos.pitch,  nexttrackpos.yaw)
									end
									--debugPrint(1,"yaw "..angle.yaw)
									local newaction = {}
									
									if(action.isrelative ~= nil and action.isrelative == true) then
										newaction.name = "teleport_entity_at_relative_position"
										
										else
										newaction.name = "teleport_entity_at_position"
									end
									newaction.tag = entityTag
									newaction.x = direction.x
									newaction.y = direction.y
									newaction.z = direction.z
									newaction.angle = angle
									table.insert(actionlist,newaction)
								end
								
								else
								obj.path = {} 
								obj.path.finish = true
								
							end
						end
					end
				end
			end
			-- for i=1,#actionlist do 
			-- executeAction(actionlist[i],tag,parent,index,source)
			-- end
			runSubActionList(actionlist, "run_path_"..math.random(1,99999), tag,source,false,executortag)
		end
		
		
		
		if(action.name == "clean_group_circuit") then
			local group =getGroupfromManager(action.tag)
			if group ~= nil then
				for i=1, #group.entities do 
					local entityTag = group.entities[i]
					local obj = getEntityFromManager(entityTag)
					if(obj ~= nil) then
						obj.path = nil
						obj.circuit = nil
						obj.currentNode = nil
						obj.nextNode = nil
					end
				end
			end
		end
		if(action.name == "group_look_at_next_path_position") then
			local group =getGroupfromManager(action.tag)
			for i=1, #group.entities do 
				local entityTag = group.entities[i]
				local obj = getEntityFromManager(entityTag)
				if(obj ~= nil) then
					local trackpos = obj.path.locations[obj.path.index]
					local nexttrackpos = obj.path.locations[obj.path.index+1]
					if obj.path.reverse == true then 
						nexttrackpos = obj.path.locations[obj.path.index-1]
					end
					if(nexttrackpos ~= nil) and (trackpos ~= nil) then 
						debugPrint(1,obj.path.index)
						local direction = {}
						local separate = 0
						if(action.separate ~= nil and action.separate == true) then
							separate = i-1
						end
						direction.x = nexttrackpos.x-separate
						direction.y = nexttrackpos.y-separate
						direction.z = nexttrackpos.z+action.zoffset
						direction.w = 1
						local enti = Game.FindEntityByID(obj.id)
						if(enti ~= nil) then
							local isplayer = false
							if entityTag == "player" then
								isplayer = true
							end
							local dirVector = diffVector(enti:GetWorldPosition(), direction)
							local angle = GetSingleton('Vector4'):ToRotation(dirVector)
							debugPrint(1,"yaw "..angle.yaw)
							teleportTo(enti, enti:GetWorldPosition(), angle,isplayer)
						end
					end
				end
			end
		end
	end
	
	if soundregion then
		if(action.name == "play_game_sound") then
			local audioEvent = SoundPlayEvent.new()
			audioEvent.soundName = action.value
			Game.GetPlayer():QueueEvent(audioEvent)
		end
		if(action.name == "stop_game_sound") then
			local audioEvent = SoundStopEvent.new()
			audioEvent.soundName = action.value
			Game.GetPlayer():QueueEvent(audioEvent)
		end
		if(action.name == "play_sound_file") then 
			local sound = getSoundByNameNamespace(action.value,action.datapack)
			if(sound ~= nil) then
				local path = questMod.soundpath..sound.path
				PlaySound(action.value,path,action.channel,action.volume)
				else
				error("No sound founded")
			end
		end
		if(action.name == "pause_sound_channel") then 
			Pause(action.channel)
		end
		if(action.name == "resume_sound_channel") then 
			Resume(action.channel)
		end
		if(action.name == "stop_sound_channel") then 
			Stop(action.channel)
		end
		if(action.name == "setGameVolume") then 
			SetSoundSettingValue(action.value, action.score)
		end
	end
	
	if entityregion then
		if(action.name == "spawn_npc") then
			local chara = ""
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(action.source == "random") then
					local indexchara = math.random(1,#arrayPnjDb)
					chara = arrayPnjDb[indexchara].TweakIDs
				end
				if(action.source == "from_list") then
					local indexchara = math.random(1,#action.source_list)
					chara = action.source_list[indexchara]
				end
				if(action.source == "npc") then
					chara = action.source_tag
				end
				if(action.source == "current_star") then
					if(currentStar ~= nil) then
						chara = currentStar.TweakIDs
						else
						error("No Current Star defined, can't spawn !")
					end
				end
				if(action.source == "current_phoned_npc") then
					if(currentNPC ~= nil) then
						chara = currentNPC.TweakIDs
						else
						error("No Current Phoned NPC defined, can't spawn !")
					end
				end
				if(action.source == "faction") then
					local gang = getFactionByTag(action.source_tag)
					if(action.source_use_rival == true) then
						gang = getFactionByTag(gang.Rivals[1])
					end
					if(action.source_use_vip == true) then
						if(#gang.VIP > 0) then
							local viptable = getVIPfromfactionbyscore(gang.Tag)
							if(#viptable > 0) then
								local index = math.random(1,#viptable)
								
								chara = viptable[index]
							end
						end
						else
						if(#gang.SpawnableNPC > 0) then
							local index = math.random(1,#gang.SpawnableNPC)
							chara = gang.SpawnableNPC[index]
						end
					end
				end
				if(action.source == "district_leader" or action.source == "subdistrict_leader") then
					local gangs = getGangfromDistrict(action.source_tag,20)
					debugPrint(1,dump(gangs))
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						if(action.source_use_rival == true) then
							gang = getFactionByTag(gang.Rivals[1])
						end
						if(action.source_use_vip == true) then
							if(#gang.VIP > 0) then
								local viptable = getVIPfromfactionbyscore(gang.Tag)
								if(#viptable > 0) then
									local index = math.random(1,#viptable)
									
									chara = viptable[index]
								end
							end
							else
							if(#gang.SpawnableNPC > 0) then
								local index = math.random(1,#gang.SpawnableNPC)
								chara = gang.SpawnableNPC[index]
							end
						end
					end
				end
				if(action.source == "current_district_leader") then
					
					local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
					
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						if(action.source_use_rival == true) then
							gang = getFactionByTag(gang.Rivals[1])
						end
						
						if(action.source_use_vip == true) then
							if(#gang.VIP > 0) then
								local viptable = getVIPfromfactionbyscore(gang.Tag)
								if(#viptable > 0) then
									local index = math.random(1,#viptable)
									
									chara = viptable[index]
								end
							end
							else
							if(#gang.SpawnableNPC > 0) then
								local index = math.random(1,#gang.SpawnableNPC)
								chara = gang.SpawnableNPC[index]
							end
						end
					end
				end
				if(action.source == "current_subdistrict_leader") then
					local gangs = {}
					for j, test in ipairs(currentDistricts2.districtLabels) do
						if j > 1 then
							gangs = getGangfromDistrict(test,20)
							if(#gangs > 0) then
								break
							end
						end
					end
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						if(action.source_use_rival == true) then
							gang = getFactionByTag(gang.Rivals[1])
						end
						if(action.source_use_vip == true) then
							if(#gang.VIP > 0) then
								local viptable = getVIPfromfactionbyscore(gang.Tag)
								if(#viptable > 0) then
									local index = math.random(1,#viptable)
									
									chara = viptable[index]
								end
							end
							else
							if(#gang.SpawnableNPC > 0) then
								local index = math.random(1,#gang.SpawnableNPC)
								chara = gang.SpawnableNPC[index]
							end
						end
					end
				end
				
				if(action.source == "district_rival" or action.source == "subdistrict_rival") then
					
					if(action.source_gang == "player") then
						
						action.source_gang = getVariableKey("player","current_gang")
						
					end
					
					local gangs = getGangRivalfromDistrict(action.source_gang,action.source_tag,20)
					
					
					
					if(#gangs > 0) then
						
						
						local gang = getFactionByTag(gangs[1].tag)
						
						if(action.source_use_vip == true) then
							if(#gang.VIP > 0) then
								local viptable = getVIPfromfactionbyscore(gang.Tag)
								if(#viptable > 0) then
									local index = math.random(1,#viptable)
									
									chara = viptable[index]
								end
							end
							else
							if(#gang.SpawnableNPC > 0) then
								local index = math.random(1,#gang.SpawnableNPC)
								chara = gang.SpawnableNPC[index]
							end
						end
					end
				end
				
				
				if(action.source == "current_district_rival") then
					
					if(action.source_gang == "player") then
						
						action.source_gang = getVariableKey("player","current_gang")
						
					end
					
					local gangs = getGangRivalfromDistrict(action.source_gang,currentDistricts2.Tag,20)
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						
						if(action.source_use_vip == true) then
							if(#gang.VIP > 0) then
								local viptable = getVIPfromfactionbyscore(gang.Tag)
								if(#viptable > 0) then
									local index = math.random(1,#viptable)
									
									chara = viptable[index]
								end
							end
							else
							if(#gang.SpawnableNPC > 0) then
								local index = math.random(1,#gang.SpawnableNPC)
								chara = gang.SpawnableNPC[index]
							end
						end
					end
				end
				
				if(action.source == "current_subdistrict_rival") then
					
					if(action.source_gang == "player") then
						
						action.source_gang = getVariableKey("player","current_gang")
						
					end
					
					local gangs = {}
					for j, test in ipairs(currentDistricts2.districtLabels) do
						if j > 1 then
							gangs = getGangRivalfromDistrict(action.source_gang,test,20)
							if(#gangs > 0) then
								break
							end
						end
					end
					if(#gangs > 0) then
						local gang = getFactionByTag(gangs[1].tag)
						
						if(action.source_use_vip == true) then
							if(#gang.VIP > 0) then
								local viptable = getVIPfromfactionbyscore(gang.Tag)
								if(#viptable > 0) then
									local index = math.random(1,#viptable)
									
									chara = viptable[index]
								end
							end
							else
							if(#gang.SpawnableNPC > 0) then
								local index = math.random(1,#gang.SpawnableNPC)
								chara = gang.SpawnableNPC[index]
							end
						end
					end
				end
				
				
				local tag = action.tag
				if(action.amount > 1) then
					tag = action.tag.."_"..i
				end
				local position = {}
				if(action.position == "at") then
					position.x = action.x
					position.y = action.y
					position.z = action.z
				end
				if(action.position == "relative_to_entity") then
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.position_tag ~= "player") then
						local obj = getEntityFromManager(action.position_tag)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position_way ~= nil and (action.position_way ~= "" or action.position_way ~= "normal")) then
						if(action.position_way == "behind") then
							positionVec4 = getBehindPosition(entity,action.position_distance)
						end
						if(action.position_way == "forward") then
							positionVec4 = getForwardPosition(entity,action.position_distance)
						end
					end
					position = positionVec4
				end
				if(action.position == "node") then
					local node = getNode(action.position_tag)
					if node ~= nil then
						if(action.position_node_usegameplay == true) then
							position.x = node.GameplayX
							position.y = node.GameplayY
							position.z = node.GameplayZ
							else
							position.x = node.X
							position.y = node.Y
							position.z = node.Z
						end
						else
						error("can't find an node who have tag : "..action.position_tag)
					end
				end
				if(action.position == "current_node") then
					local position = Game.GetPlayer():GetWorldPosition()
					local range = 70
					if(action.position_node_current_detection_range ~= nil) then
						range = action.position_node_current_detection_range
					end
					local node = getNodefromPosition(position.x,position.y,position.z,range)
					if node ~= nil then
						if(action.position_node_usegameplay == true) then
							position.x = node.GameplayX
							position.y = node.GameplayY
							position.z = node.GameplayZ
							else
							position.x = node.X
							position.y = node.Y
							position.z = node.Z
						end
						else
						error("can't find an current node")
					end
				end
				if(action.position == "poi") then
					local currentpoi = nil
					currentpoi = FindPOI(action.position_tag,action.position_poi_district,action.position_poi_subdistrict,action.position_poi_is_for_car,action.position_poi_type,action.position_poi_use_location_tag,action.position_poi_from_position,action.position_poi_range)
					if(currentpoi ~= nil) then
						position.x = currentpoi.x
						position.y = currentpoi.y
						position.z = currentpoi.z
						else
						error("can't find an current poi")
					end
				end
				if(action.position == "mappin") then
					local mappin = getMappinByTag(action.position_tag)
					if(mappin)then
						position = mappin.position
						else
						error("can't find an mappin with tag : "..action.position_tag)
					end
				end
				if(action.position == "fasttravel") then
					local markerref = nil
					local tempos = nil
					for j=1, #mappedFastTravelPoint do
						local point = mappedFastTravelPoint[j]
						if(point.markerref == action.position_tag) then
							markerref = point.markerrefdata
							tempos = point.position
							break
						end
					end
					if(markerref)then
						position = tempos
						else
						error("can't find an fast travel point with tag : "..action.position_tag)
					end
				end
				if(action.position == "current_fasttravel") then
					if(ActiveFastTravelMappin ~= nil)then
						position = ActiveFastTravelMappin.position
						else
						error("can't find an current fast travel point ")
					end
				end
				if(action.position == "current_custom_mappin") then
					if(ActivecustomMappin ~= nil)then
						local mappin = ActivecustomMappin:GetWorldPosition()
						position.x = mappin.x
						position.y = mappin.y
						position.z = mappin.z
						else
						error("can't find an current custom point ")
					end
				end
				if(action.position == "custom_place") then
					local house = getHouseByTag(action.position_tag)
					if(house ~= nil) then
						if(action.position_house_way == "default") then
							position.x = house.posX
							position.y = house.posY
							position.z = house.posZ
						end
						if(action.position_house_way == "enter") then
							position.x = house.EnterX
							position.y = house.EnterY
							position.z = house.EnterZ
						end
						if(action.position_house_way == "exit") then
							position.x = house.ExitX
							position.y = house.ExitY
							position.z = house.ExitZ
						end
						else
						error("can't find an custom place with tag : "..action.position_tag)
					end
				end
				if(action.position == "custom_room") then
					local room = getRoomByTag(action.position_tag,action.position_house_tag)
					if(room ~= nil) then
						position.x = room.posX
						position.y = room.posY
						position.z = room.posZ
						else
						error("can't find an custom room with tag : "..action.position_tag.." for the house with tag :"..action.position_house_tag)
					end
				end
				if(action.position == "current_custom_place") then
					if(currentHouse ~= nil) then
						if(action.position_house_way == "default") then
							position.x = currentHouse.posX
							position.y = currentHouse.posY
							position.z = currentHouse.posZ
						end
						if(action.position_house_way == "Enter") then
							position.x = currentHouse.EnterX
							position.y = currentHouse.EnterY
							position.z = currentHouse.EnterZ
						end
						if(action.position_house_way == "Exit") then
							position.x = currentHouse.ExitX
							position.y = currentHouse.ExitY
							position.z = currentHouse.ExitZ
						end
						else
						error("can't find an current custom place")
					end
				end	
				if(action.position == "current_custom_room") then
					if(currentRoom ~= nil) then
						position.x = currentRoom.posX
						position.y = currentRoom.posY
						position.z = currentRoom.posZ
						else
						error("can't find an current custom room")
					end				
				end
				if(action.position ~= "at" and position.x ~= nil) then
					position.x = position.x + action.x
					position.y = position.y + action.y
					position.z = position.z + action.z
					else
					if(position.x == nil) then
						error("position is empty")
					end
				end
				if(chara ~= "" and chara ~= nil and position.x ~= nil) then
					spawnNPC(chara,action.appearance, tag, position.x, position.y ,position.z,action.spawnlevel,action.use_police_prevention_system,action.scriptlevel)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						if(index == nil and action.create_group_if_not_exist == true) then
							local group = {}
							group.tag = action.group
							group.entities = {}
							table.insert(questMod.GroupManager,group)
							debugPrint(1,"group created")
							index =getIndexFromGroupManager(action.group)
						end
						if(index ~= nil) then
							table.insert(questMod.GroupManager[index].entities,tag)
							else
							error("group with tag : "..action.group.." doesn't exist")
						end
					end
					else
					error("bad character or position. character tweak : "..chara.." position : "..dump(position))
				end
			end
		end
		if(action.name == "despawn_lookat") then
			if(objLook ~= nil) then
				local enti = getEntityFromManagerById(objLook:GetEntityID()) 
				if(enti ~= nil)then
					debugPrint(1,"yahoo")
					despawnEntity(enti.tag)
					else
					Game.GetPreventionSpawnSystem():RequestDespawn(objLook:GetEntityID())
					objLook:Dispose()
				end
			end
		end
		if(action.name == "despawnAll") then
			despawnAll()
		end
		if(action.name == "teleport_player") then
			--Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Vector4.new( action.x, action.y, action.z,1) , 1)
			Game.TeleportPlayerToPosition(action.x,action.y,action.z)
		end
		if(action.name == "summon_entity") then
			chara = action.npc
			local isAV = false
			if(action.isAV ~= nil) then
				isAV = action.isAV
			end
			spawnEntity(chara, action.tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "summon_current_star") then
			if(currentNPC ~= nil) then
				chara = currentNPC.TweakIDs
				local isAV = false
				if(action.isAV ~= nil) then
					isAV = action.isAV
				end
				spawnEntity(chara, "current_star", action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
				if(action.group ~= nil and action.group ~= "") then
					local index =getIndexFromGroupManager(action.group)
					table.insert(questMod.GroupManager[index].entities,"current_star")
				end
				currentStar = currentNPC
				
			end
		end
		if(action.name == "set_current_star") then
			if(currentNPC ~= nil) then
				
				currentStar = currentNPC
				currentNPC = nil
				
				else
				
				error("No current Phoned NPC ")
			end
		end
		if(action.name == "summon_entity_from_faction") then
			local gang = getFactionByTag(action.faction)
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(#gang.SpawnableNPC > 0) then
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableNPC)
					chara = gang.SpawnableNPC[index]
					local isAV = false
					if(action.isAV ~= nil) then
						isAV = action.isAV
					end
					spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_faction") then
			local gang = getFactionByTag(action.faction)
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(#gang.SpawnableNPC > 0) then
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local viptable = getVIPfromfactionbyscore(gang.Tag)
					local index = math.random(1,#viptable)
					chara = viptable[index]
					local isAV = false
					if(action.isAV ~= nil) then
						isAV = action.isAV
					end
					spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_entity_from_faction_rival") then
			local gang = getFactionByTag(action.faction)
			gang = getFactionByTag(gang.Rivals[1])
			if(action.amount == nil) then
				action.amount = 1
			end
			if(action.amount == 0) then
				action.amount = math.random(1,6)
			end
			for i=1,action.amount do
				if(#gang.SpawnableNPC > 0) then
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableNPC)
					chara = gang.SpawnableNPC[index]
					local isAV = false
					if(action.isAV ~= nil) then
						isAV = action.isAV
					end
					spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_district") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = gangs[1]
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_subdistrict") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_district_rival") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_subdistrict_rival") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_district") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = gangs[1]
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_subdistrict") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_district_rival") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_subdistrict_rival") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, action.x, action.y ,action.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_district_at_current_poi") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = gangs[1]
				if(#gang.SpawnableNPC > 0 and currentpoi ~=nil) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_subdistrict_at_current_poi") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_district_rival_at_current_poi") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_from_leader_faction_subdistrict_rival_at_current_poi") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_district_at_current_poi") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = gangs[1]
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_subdistrict_at_current_poi") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_district_rival_at_current_poi") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_from_leader_faction_subdistrict_rival_at_current_poi") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0 and currentpoi ~=nil) then
				local gang = getFactionByTag(gangs[1].tag) 
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil) then
							isAV = action.isAV
						end
						spawnEntity(chara, tag, currentpoi.x, currentpoi.y ,currentpoi.z,action.spawnlevel,action.ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_at_entity_relative") then
			local isAV = false
			if(action.isAV ~= nil and action.isAV==true) then
				debugPrint(1,"AV is "..tostring(action.isAV))
				isAV = action.isAV
				local group = getGroupfromManager("AV")
				if(group.entities == nil) then
					group.entities = {}
				end
				debugPrint(1,action.tag)
				table.insert(group.entities,action.tag)
				debugPrint(1,#group.entities)
			end
			local viptable = getVIPfromfactionbyscore(action.faction)
			debugPrint(1,dump(viptable))
			local index = math.random(1,#viptable)
			debugPrint(1,index)	
			chara = viptable[index]
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			local entity = nil
			if(action.entity ~= "player") then
				local obj = getEntityFromManager(action.entity)
				entity = Game.FindEntityByID(obj.id)
				positionVec4 = entity:GetWorldPosition()
				else
				entity = Game.GetPlayer()
			end
			if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
				if(action.position == "behind") then
					positionVec4 = getBehindPosition(entity,action.distance)
				end
				if(action.position == "forward") then
					positionVec4 = getForwardPosition(entity,action.distance)
				end
				else
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
			end
			local ambush = false
			if(action.ambush ~= nil) then
				ambush = action.ambush
			end
			spawnEntity(chara, action.tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "summon_entity_at_entity_relative") then
			local isAV = false
			if(action.isAV ~= nil and action.isAV==true) then
				debugPrint(1,"AV is "..tostring(action.isAV))
				isAV = action.isAV
				local group = getGroupfromManager("AV")
				if(group.entities == nil) then
					group.entities = {}
				end
				debugPrint(1,action.tag)
				table.insert(group.entities,action.tag)
				debugPrint(1,#group.entities)
			end
			chara = action.npc
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			local entity = nil
			if(action.entity ~= "player") then
				local obj = getEntityFromManager(action.entity)
				entity = Game.FindEntityByID(obj.id)
				positionVec4 = entity:GetWorldPosition()
				else
				entity = Game.GetPlayer()
			end
			if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
				if(action.position == "behind") then
					positionVec4 = getBehindPosition(entity,action.distance)
				end
				if(action.position == "forward") then
					positionVec4 = getForwardPosition(entity,action.distance)
				end
				else
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
			end
			local ambush = false
			if(action.ambush ~= nil) then
				ambush = action.ambush
			end
			spawnEntity(chara, action.tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "summon_random_entity_at_entity_relative") then
			local isAV = false
			if(action.isAV ~= nil and action.isAV==true) then
				debugPrint(1,"AV is "..tostring(action.isAV))
				isAV = action.isAV
				local group = getGroupfromManager("AV")
				if(group.entities == nil) then
					group.entities = {}
				end
				debugPrint(1,action.tag)
				table.insert(group.entities,action.tag)
				debugPrint(1,#group.entities)
			end
			local index = math.random(1,#action.npc)
			chara = action.npc[index]
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			local entity = nil
			if(action.entity ~= "player") then
				local obj = getEntityFromManager(action.entity)
				entity = Game.FindEntityByID(obj.id)
				positionVec4 = entity:GetWorldPosition()
				else
				entity = Game.GetPlayer()
			end
			if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
				if(action.position == "behind") then
					positionVec4 = getBehindPosition(entity,action.distance)
				end
				if(action.position == "forward") then
					positionVec4 = getForwardPosition(entity,action.distance)
				end
				else
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
			end
			local ambush = false
			if(action.ambush ~= nil) then
				ambush = action.ambush
			end
			spawnEntity(chara, action.tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "summon_current_star_at_entity_relative") then
			if(currentNPC ~= nil) then
				local isAV = false
				if(action.isAV ~= nil and action.isAV==true) then
					debugPrint(1,"AV is "..tostring(action.isAV))
					isAV = action.isAV
					local group = getGroupfromManager("AV")
					if(group.entities == nil) then
						group.entities = {}
					end
					table.insert(group.entities,"current_star")
					debugPrint(1,#group.entities)
				end
				chara = currentNPC.TweakIDs
				local positionVec4 = Game.GetPlayer():GetWorldPosition()
				local entity = nil
				if(action.entity ~= "player") then
					local obj = getEntityFromManager(action.entity)
					entity = Game.FindEntityByID(obj.id)
					positionVec4 = entity:GetWorldPosition()
					else
					entity = Game.GetPlayer()
				end
				if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
					if(action.position == "behind") then
						positionVec4 = getBehindPosition(entity,action.distance)
					end
					if(action.position == "forward") then
						positionVec4 = getForwardPosition(entity,action.distance)
					end
					else
					positionVec4.x = positionVec4.x + action.x
					positionVec4.y = positionVec4.y + action.y
					positionVec4.z = positionVec4.z + action.z
				end
				local ambush = false
				if(action.ambush ~= nil) then
					ambush = action.ambush
				end
				spawnEntity(chara, "current_star", positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
				if(action.group ~= nil and action.group ~= "") then
					local index =getIndexFromGroupManager(action.group)
					table.insert(questMod.GroupManager[index].entities,"current_star")
				end
				currentStar = currentNPC
				
			end
		end
		if(action.name == "summon_entity_at_entity_relative_from_faction") then
			local gang = getFactionByTag(action.faction)
			if(#gang.SpawnableNPC > 0) then
				if(action.amount == nil) then
					action.amount = 1
				end
				if(action.amount == 0) then
					action.amount = math.random(1,6)
				end
				for i=1,action.amount do
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableNPC)
					chara = gang.SpawnableNPC[index]
					local isAV = false
					if(action.isAV ~= nil and action.isAV==true) then
						debugPrint(1,"AV is "..tostring(action.isAV))
						isAV = action.isAV
						local group = getGroupfromManager("AV")
						if(group.entities == nil) then
							group.entities = {}
						end
						table.insert(group.entities,tag)
						debugPrint(1,#group.entities)
					end
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.entity ~= "player") then
						local obj = getEntityFromManager(action.entity)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
						if(action.position == "behind") then
							positionVec4 = getBehindPosition(entity,action.distance)
						end
						if(action.position == "forward") then
							positionVec4 = getForwardPosition(entity,action.distance)
						end
						else
						positionVec4.x = positionVec4.x + action.x
						positionVec4.y = positionVec4.y + action.y
						positionVec4.z = positionVec4.z + action.z
					end
					local ambush = false
					if(action.ambush ~= nil) then
						ambush = action.ambush
					end
					spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_at_entity_relative_from_faction") then
			local gang = getFactionByTag(action.faction)
			if(#gang.SpawnableNPC > 0) then
				if(action.amount == nil) then
					action.amount = 1
				end
				if(action.amount == 0) then
					action.amount = math.random(1,6)
				end
				for i=1,action.amount do
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local viptable = getVIPfromfactionbyscore(gang.Tag)
					local index = math.random(1,#viptable)
					chara = viptable[index]
					local isAV = false
					if(action.isAV ~= nil and action.isAV==true) then
						debugPrint(1,"AV is "..tostring(action.isAV))
						isAV = action.isAV
						local group = getGroupfromManager("AV")
						if(group.entities == nil) then
							group.entities = {}
						end
						table.insert(group.entities,tag)
						debugPrint(1,#group.entities)
					end
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.entity ~= "player") then
						local obj = getEntityFromManager(action.entity)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
						if(action.position == "behind") then
							positionVec4 = getBehindPosition(entity,action.distance)
						end
						if(action.position == "forward") then
							positionVec4 = getForwardPosition(entity,action.distance)
						end
						else
						positionVec4.x = positionVec4.x + action.x
						positionVec4.y = positionVec4.y + action.y
						positionVec4.z = positionVec4.z + action.z
					end
					local ambush = false
					if(action.ambush ~= nil) then
						ambush = action.ambush
					end
					spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_entity_at_entity_relative_from_faction_rival") then
			local gang = getFactionByTag(action.faction)
			local rivalindex = math.random(1,#gang.Rivals)
			gang = getFactionByTag(gang.Rivals[rivalindex])
			if(#gang.SpawnableNPC > 0) then
				if(action.amount == nil) then
					action.amount = 1
				end
				if(action.amount == 0) then
					action.amount = math.random(1,6)
				end
				for i=1,action.amount do
					local tag = action.tag
					if(action.amount > 1) then
						tag = action.tag.."_"..i
					end
					local index = math.random(1,#gang.SpawnableNPC)
					chara = gang.SpawnableNPC[index]
					debugPrint(1,chara)
					local isAV = false
					if(action.isAV ~= nil and action.isAV==true) then
						debugPrint(1,"AV is "..tostring(action.isAV))
						isAV = action.isAV
						local group = getGroupfromManager("AV")
						if(group.entities == nil) then
							group.entities = {}
						end
						table.insert(group.entities,tag)
						debugPrint(1,#group.entities)
					end
					local positionVec4 = Game.GetPlayer():GetWorldPosition()
					local entity = nil
					if(action.entity ~= "player") then
						local obj = getEntityFromManager(action.entity)
						entity = Game.FindEntityByID(obj.id)
						positionVec4 = entity:GetWorldPosition()
						else
						entity = Game.GetPlayer()
					end
					if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
						if(action.position == "behind") then
							positionVec4 = getBehindPosition(entity,action.distance)
						end
						if(action.position == "forward") then
							positionVec4 = getForwardPosition(entity,action.distance)
						end
						else
						positionVec4.x = positionVec4.x + action.x
						positionVec4.y = positionVec4.y + action.y
						positionVec4.z = positionVec4.z + action.z
					end
					local ambush = false
					if(action.ambush ~= nil) then
						ambush = action.ambush
					end
					spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,tag)
					end
				end
			end
		end
		if(action.name == "summon_entity_at_entity_relative_from_faction_leader_district") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_at_entity_relative_from_faction_leader_subdistrict") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_at_entity_relative_from_faction_leader_district_rival") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_at_entity_relative_from_faction_leader_subdistrict_rival") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.SpawnableNPC > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local index = math.random(1,#gang.SpawnableNPC)
						chara = gang.SpawnableNPC[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_at_entity_relative_from_faction_leader_district") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_at_entity_relative_from_faction_leader_subdistrict") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_at_entity_relative_from_faction_leader_district_rival") then
			local gangs = getGangfromDistrict(currentDistricts2.Tag,20)
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "summon_entity_vip_at_entity_relative_from_faction_leader_subdistrict_rival") then
			local gangs = {}
			for i, test in ipairs(currentDistricts2.districtLabels) do
				if i > 1 then
					gangs = getGangfromDistrict(test,20)
					if(#gangs > 0) then
						break
					end
				end
			end
			if(#gangs > 0) then
				local gang = getFactionByTag(gangs[1].tag)
				local rivalindex = math.random(1,#gang.Rivals)
				gang = getFactionByTag(gang.Rivals[rivalindex])
				if(#gang.VIP > 0) then
					if(action.amount == nil) then
						action.amount = 1
					end
					if(action.amount == 0) then
						action.amount = math.random(1,6)
					end
					for i=1,action.amount do
						local tag = action.tag
						if(action.amount > 1) then
							tag = action.tag.."_"..i
						end
						local viptable = getVIPfromfactionbyscore(gang.Tag)
						local index = math.random(1,#viptable)
						chara = viptable[index]
						local isAV = false
						if(action.isAV ~= nil and action.isAV==true) then
							debugPrint(1,"AV is "..tostring(action.isAV))
							isAV = action.isAV
							local group = getGroupfromManager("AV")
							if(group.entities == nil) then
								group.entities = {}
							end
							debugPrint(1,tag)
							table.insert(group.entities,tag)
							debugPrint(1,#group.entities)
						end
						local positionVec4 = Game.GetPlayer():GetWorldPosition()
						local entity = nil
						if(action.entity ~= "player") then
							local obj = getEntityFromManager(action.entity)
							entity = Game.FindEntityByID(obj.id)
							positionVec4 = entity:GetWorldPosition()
							else
							entity = Game.GetPlayer()
						end
						if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
							if(action.position == "behind") then
								positionVec4 = getBehindPosition(entity,action.distance)
							end
							if(action.position == "forward") then
								positionVec4 = getForwardPosition(entity,action.distance)
							end
							else
							positionVec4.x = positionVec4.x + action.x
							positionVec4.y = positionVec4.y + action.y
							positionVec4.z = positionVec4.z + action.z
						end
						local ambush = false
						if(action.ambush ~= nil) then
							ambush = action.ambush
						end
						spawnEntity(chara, tag, positionVec4.x, positionVec4.y ,positionVec4.z,action.spawnlevel,ambush,isAV,action.beta)
						if(action.group ~= nil and action.group ~= "") then
							local index =getIndexFromGroupManager(action.group)
							table.insert(questMod.GroupManager[index].entities,tag)
						end
					end
				end
			end
		end
		if(action.name == "register_entity_you_look_at") then
			if(objLook ~= nil) then
				local entity = getEntityFromManager(action.tag)
				if (entity.id == nil) then
					local entity = {}
					entity.id = objLook:GetEntityID()
					entity.tag = action.tag
					entity.tweak = "None"
					entity.iscompanion = false
					table.insert(questMod.EntityManager,entity)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,action.tag)
					end
					else
					Game.GetPlayer():SetWarningMessage("An entity with this tag already exist.")
				end
			end
		end
		
		if(action.name == "register_last_killed_entity") then
			if(lastTargetKilled ~= nil) then
				local entity = getEntityFromManager(action.tag)
				if (entity.id == nil) then
					local entity = {}
					entity.id = lastTargetKilled:GetEntityID()
					entity.tag = action.tag
					entity.tweak = "None"
					entity.iscompanion = false
					table.insert(questMod.EntityManager,entity)
					if(action.group ~= nil and action.group ~= "") then
						local index =getIndexFromGroupManager(action.group)
						table.insert(questMod.GroupManager[index].entities,action.tag)
					end
					lastTargetKilled = nil
					else
					Game.GetPlayer():SetWarningMessage("An entity with this tag already exist.")
				end
				else
				error("No killed entity fonded")
			end
		end
		
		if(action.name == "destroy_entity_you_look_at") then
			if(objLook ~= nil) then
				objLook:Dispose()
			end
		end
		
		if(action.name == "reset_last_killed_entity") then
			if(lastTargetKilled ~= nil) then
				lastTargetKilled = nil
			end
		end
		if(action.name == "register_entity_you_look_at_as_companion") then
			if(objLook ~= nil) then
				local tag = "companion_"..math.random(0,999)
				local entity = getEntityFromManager(tag)
				if (entity.id == nil) then
					local entity = {}
					local appearance = objLook:GetCurrentAppearanceName()
					table.insert(questMod.EntityManager,entity)
					local index = getIndexFromGroupManager("companion")
					table.insert(questMod.GroupManager[index].entities,tag)
					local pos = objLook:GetWorldPosition()
					spawnEntity(objLook:GetRecordID(), tag, pos.x, pos.y ,pos.z,99,true,false,false)
					objLook:Dispose()
					Cron.After(2, function(tag, appearance)
						local entity = getEntityFromManager(tag)
						if (entity.id ~= nil) then
							entity.tweak = "None"
							entity.iscompanion = true
							local enti = Game.FindEntityByID(entity.id)
							AIControl.MakeFriendly(enti, Game.GetPlayer())
							setAppearance(enti,appearance)
						end
					end)
					else
					Game.GetPlayer():SetWarningMessage("An entity with this tag already exist.")
				end
			end
		end
		if(action.name == "register_entity_you_look_at_in_group") then
			if(objLook ~= nil) then
				local tag = "entity_"..math.random(0,999)
				local entity = getEntityFromManager(tag)
				if (entity.id == nil) then
					local entity = {}
					entity.id = objLook:GetEntityID()
					entity.tag = tag
					entity.tweak = "None"
					entity.iscompanion = false
					table.insert(questMod.EntityManager,entity)
					local index =getIndexFromGroupManager(action.group)
					table.insert(questMod.GroupManager[index].entities,tag)
					else
					Game.GetPlayer():SetWarningMessage("An entity with this tag already exist.")
				end
			end
		end
		if(action.name == "kill_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				enti:Kill(enti, false, false)
			end
		end
		if(action.name == "resurrect_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				enti.Revive() 
				enti.Revive(0.5) 
				enti.Revive(5) 
				Game.GetStatPoolsSystem():RequestChangingStatPoolValue(enti:GetEntityID(), "Health", 5, Game.GetPlayer(), true, false)
			end
		end
		if(action.name == "despawn_entity") then
			--local enti = Game.FindEntityByID(questMod.EntityManager[action.tag])
			--despawnEntity(questMod.EntityManager[action.tag].spawnlevel)
			despawnEntity(action.tag)
			if(action.tag == "current_star") then
				currentStar = nil
			end
		end
		if(action.name == "unregister_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if enti ~= nil then
				local index = getIndexFromManager(action.tag)
				table.remove(questMod.EntityManager,index)
			end
		end
		
		if(action.name == "change_stance_entity") then 
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				changeStance(enti,action.value)
			end
		end
		
		
		
		if(action.name == "move_entity_at_position") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				local positionVec4 = {}
				positionVec4.x = action.x
				positionVec4.y = action.y
				positionVec4.z = action.z
				positionVec4.w = 1
				MoveTo(enti, positionVec4, 1, action.move)
			end
		end
		if(action.name == "move_entity_at_relative_position") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				local positionVec4 = enti:GetWorldPosition()
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
				MoveTo(enti, positionVec4, 1, action.move)
			end
		end
		if(action.name == "move_entity_at_entity_relative") then
			local enti = nil
			local obj = nil 
			if(action.tag =="lookat") then 
				enti = objLook
				obj = getEntityFromManagerById(objLook:GetEntityID())
				else
				obj = getEntityFromManager(action.tag)
				enti = Game.FindEntityByID(obj.id)
			end
			if(enti ~= nil) then
				local positionVec4 = Game.GetPlayer():GetWorldPosition()
				if(action.entity ~= "player") then
					local obj2 = getEntityFromManager(action.entity)
					local enti2 = Game.FindEntityByID(obj2.id)
					positionVec4 = enti2:GetWorldPosition()
				end
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
				MoveTo(enti, positionVec4, 1, action.move)
			end
		end
		if(action.name == "move_entity_at_player_lookat") then
			local enti = nil
			local obj = nil 
			if(action.tag =="lookat") then 
				enti = objLook
				obj = getEntityFromManagerById(objLook:GetEntityID())
				else
				obj = getEntityFromManager(action.tag)
				enti = Game.FindEntityByID(obj.id)
			end
			if(enti ~= nil) then
				local positionVec4 = getForwardPosition(Game.GetPlayer(),action.distance)
				local isplayer = false
				if action.tag == "player" then
					isplayer = true
				end
				if(enti:IsVehicle() ~= true) then
					MoveTo(enti, positionVec4, 1, action.move)
					else
					teleportTo(enti, positionVec4, 1,isplayer)
				end
			end
		end
		if(action.name == "entity_hold_position") then
			local enti = nil
			local obj = nil 
			if(action.tag =="lookat") then 
				enti = objLook
				obj = getEntityFromManagerById(objLook:GetEntityID())
				else
				obj = getEntityFromManager(action.tag)
				enti = Game.FindEntityByID(obj.id)
			end
			local stealth = false
			if(action.stealth == nil) then
				local state = Game.GetPlayer():GetPlayerStateMachineBlackboard():GetInt(Game.GetAllBlackboardDefs().PlayerStateMachine.Combat)
				if(state == 3) then
					stealth = true
				end
				else
				stealth = action.stealth
			end
			if(enti ~= nil) then
				if(enti:IsVehicle() ~= true) then
					InterruptBehavior(enti)
					HoldPosition(enti, action.timer, stealth)
				end
			end
		end
		if(action.name == "rotate_entity_to_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				local enti2 = Game.GetPlayer()
				if(action.entity ~= "player") then
					local obj2 = getEntityFromManager(action.entity)
					enti2 = Game.FindEntityByID(obj2.id)
				end
				RotateTo(enti, enti2)
			end
		end
		if(action.name == "rotate_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				RotateEntityTo(enti, action.pitch, action.yaw, action.roll)
			end
		end
		if(action.name == "choose_target") then
			if(objLook ~= nil) then
				selectTarget = objLook:GetEntityID()
			end
		end
		if(action.name == "reset_target") then
			selectTarget = nil
		end
		if(action.name == "follow_entity_to_entity") then
			local enti = nil
			if(action.tag =="lookat") then 
				enti = objLook
				else
				local obj = getEntityFromManager(action.tag)
				enti = Game.FindEntityByID(obj.id)
			end
			local stealth = false
			if(enti ~= nil) then
				local enti2 = Game.GetPlayer()
				if(action.stealth == nil) then
					local state = Game.GetPlayer():GetPlayerStateMachineBlackboard():GetInt(Game.GetAllBlackboardDefs().PlayerStateMachine.Combat)
					if(state == 3) then
						stealth = true
					end
					else
					stealth = action.stealth
				end
				if(action.entity ~= "player") then
					if(action.entity =="lookat") then 
						local id = enti:GetEntityID()
						Cron.After(5, function(id)
							enti = Game.FindEntityByID(id)
							enti2 = objLook
							if(enti2 ~= nil) then
								FollowEntity(enti, enti2, action.move, stealth)
							end
						end)
						else
						local obj2 = getEntityFromManager(action.entity)
						enti2 = Game.FindEntityByID(obj2.id)
						FollowEntity(enti, enti2, action.move, stealth)
					end
					if(action.entity =="target") then 
						enti2 = Game.FindEntityByID(selectTarget)
						FollowEntity(enti, enti2, action.move, stealth)
					end
					else
					FollowEntity(enti, enti2, action.move, stealth)
				end
			end
		end
		if(action.name == "teleport_entity_to_entity_relative") then
			local isplayer = false
			
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			
			if(enti ~= nil) then
				local positionVec4 = Game.GetPlayer():GetWorldPosition()
				
				local obj2 = getEntityFromManager(action.entity)
				local enti2 = Game.FindEntityByID(obj2.id)
				if(enti2 ~= nil) then
					positionVec4 = enti2:GetWorldPosition()
					
					positionVec4.x = positionVec4.x + action.x
					positionVec4.y = positionVec4.y + action.y
					positionVec4.z = positionVec4.z + action.z
					
					local rot =  GetSingleton('Quaternion'):ToEulerAngles(enti2:GetWorldOrientation())
					
					teleportTo(enti, positionVec4, rot,isplayer)
					else
					error("no entity for "..action.entity)
				end
				else
				error("no entity for "..action.tag)
			end
		end
		if(action.name == "teleport_entity_at_position") then
			local isplayer = false
			if action.tag == "player" then
				isplayer = true
			end
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				local angle = 1
				if(action.angle ~= nil) then
					angle = action.angle
				end
				if(action.collision ~= nil and action.collision == true) then
					local filters = {
						'Static', -- Buildings, Concrete Roads, Crates, etc.
						'Terrain'
					}
					local from = enti:GetWorldPosition()
					local to = Vector4.new(
						action.x ,
						action.y ,
						action.z,
						1
					)
					local collision = false
					for _, filter in ipairs(filters) do
						local success, result = Game.GetSpatialQueriesSystem():SyncRaycastByCollisionGroup(from, to, filter, false, false)
						if success then
							collision = true
							--debugPrint(1,"collision"..filter)
						end
					end
					if(collision == false) then
						teleportTo(enti, Vector4.new( action.x, action.y, action.z,1), angle,isplayer)
						else
						if(action.pathfinding ~= nil and action.pathfinding == true) then
							local newpath =  giveGoodPath(from,to,action.axis)
							teleportTo(enti, newpath, angle,isplayer)
						end
					end
					else
					--debugPrint(1,"angle.yaw = "..angle.yaw)
					teleportTo(enti, Vector4.new( action.x, action.y, action.z,1), angle,isplayer)
				end
			end
		end
		if(action.name == "teleport_entity_at_relative_position") then
			local isplayer = false
			if action.tag == "player" then
				isplayer = true
			end
			
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				local angle = 1
				if(action.angle ~= nil) then
					angle = action.angle
				end
				local positionVec4 = enti:GetWorldPosition()
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
				teleportTo(enti, Vector4.new( positionVec4.x, positionVec4.y, positionVec4.z,1), angle,isplayer)
			end
		end
		if(action.name == "teleport_player_at_relative_position") then
			local playerpos = Game.GetPlayer():GetWorldPosition()
			Game.TeleportPlayerToPosition(playerpos.x+action.x,playerpos.y+action.y,playerpos.z+action.z)
		end
		if(action.name == "entity_stop_fight") then
			InterruptCombat(action.tag)
		end
		if(action.name == "switch_primary_secondary_weapon_entity") then
			local enti = nil
			local obj = nil 
			if(action.tag =="lookat") then 
				enti = objLook
				obj = getEntityFromManagerById(objLook:GetEntityID())
				else
				obj = getEntityFromManager(action.tag)
				enti = Game.FindEntityByID(obj.id)
			end
			if(enti ~= nil and  enti:HasPrimaryOrSecondaryEquipment()) then
				if obj.usePrimary == nil or true then
					EquipPrimaryWeaponCommand(objlook, false)
					EquipSecondaryWeaponCommand(objlook, true)
					obj.usePrimary = false
					else
					EquipSecondaryWeaponCommand(objlook, false)
					EquipPrimaryWeaponCommand(objlook, true)
					obj.usePrimary = true
				end
			end
		end
		if(action.name == "equip_weapon_entity_from_current_player") then
			local enti = nil
			local obj = nil 
			if(action.tag =="lookat") then 
				enti = objLook
				obj = getEntityFromManagerById(objLook:GetEntityID())
				else
				obj = getEntityFromManager(action.tag)
				enti = Game.FindEntityByID(obj.id)
			end
			if(enti ~= nil and  enti:HasPrimaryOrSecondaryEquipment()) then
				local es = Game.GetScriptableSystemsContainer():Get(CName.new("EquipmentSystem"))
				local weapon = es:GetActiveWeaponObject(Game.GetPlayer(), 39)
				local weaponTDBID = weapon:GetItemID().tdbid
				EquipGivenWeapon(enti, weaponTDBID, true)
			end
		end
		if(action.name == "attitude_entity_against_entity") then
			if action.attitude == "hostile" then
				setAggressiveAgainst(action.tag, action.entity)
			end
			if action.attitude == "passive"   then
				setPassiveAgainst(action.tag, action.entity)
			end
			if action.attitude == "companion"   then
				setFollower(action.tag)
			end
			if action.attitude == "friendly"   then
				setFriendAgainst(action.tag, action.entity)
			end
			if action.attitude == "psycho" then
				setPsycho(action.tag, action.entity)
			end
		end
		if(action.name == "play_entity_voice") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				talk(enti,action.voice)
			end
		end
		if(action.name == "toggle_immortal_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				if(action.tag == "player") then
					if (action.immortal == true) then
						Game.GetGodModeSystem():EnableOverride(Game.GetPlayer():GetEntityID(), "Invulnerable", CName.new("SecondHeart"))
						if Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer()) then
							veh = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
							if veh then
								Game.GetGodModeSystem():AddGodMode(veh:GetEntityID(), "Invulnerable", CName.new("Default"))
							end
						end
						else
						ssc = Game.GetScriptableSystemsContainer()
						es = ssc:Get(CName.new('EquipmentSystem'))
						espd = es:GetPlayerData(Game.GetPlayer())
						espd['GetItemInEquipSlot2'] = espd['GetItemInEquipSlot;gamedataEquipmentAreaInt32']
						for i=0,2 do
							if espd:GetItemInEquipSlot2("CardiovascularSystemCW", i).tdbid.hash == 3619482064 then
								hasSecondHeart = true
							end
						end
						if hasSecondHeart then
							Game.GetGodModeSystem():EnableOverride(Game.GetPlayer():GetEntityID(), "Immortal", CName.new("SecondHeart"))
							else
							Game.GetGodModeSystem():DisableOverride(Game.GetPlayer():GetEntityID(), CName.new("SecondHeart"))
						end
						if Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer()) then
							veh = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
							if veh then
								Game.GetGodModeSystem():ClearGodMode(veh:GetEntityID(), CName.new("Default"))
							end
						end
					end
					else
					ToggleImmortal(enti, action.immortal)
				end
			end
		end
		if(action.name == "play_entity_facial") then
			
			
			local reaction = getExpression(action.value)
			
			makeFacial(action.tag,reaction)
			
		end
		if(action.name == "reset_entity_facial") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				resetFacial(enti)
			end
		end
		if(action.name == "look_at_entity_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				if(action.entity == "player") then
					lookAtPlayer(enti)
					else
					lookAtEntity(enti,action.entity,action.duration)
				end
			end
		end
		if(action.name == "reset_lookat_entity") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				resetLookAt(enti)
			end
		end
		if(action.name == "player_look_at_entity") then
			playerLookAtEntity(action.tag)
			Game.GetPlayer():GetFPPCameraComponent().pitchMin = pitch - 0.01 -- Use pitchMin/Max to set pitch, needs to have a small difference between Min and Max
			Game.GetPlayer():GetFPPCameraComponent().pitchMax = pitch
			Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition() , EulerAngles.new(0,0,yaw)) -- Set yaw when teleporting
		end
		if(action.name == "player_look_at_position") then
			playerLookAtDirection(action.x, action.y,action.z)
			Game.GetPlayer():GetFPPCameraComponent().pitchMin = pitch - 0.01 -- Use pitchMin/Max to set pitch, needs to have a small difference between Min and Max
			Game.GetPlayer():GetFPPCameraComponent().pitchMax = pitch
			Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition() , EulerAngles.new(0,0,yaw)) -- Set yaw when teleporting
		end
		if(action.name == "player_look_at_rotation") then
			Game.GetPlayer():GetFPPCameraComponent().pitchMin = pitch - 0.01 -- Use pitchMin/Max to set pitch, needs to have a small difference between Min and Max
			Game.GetPlayer():GetFPPCameraComponent().pitchMax = pitch
			Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition() , EulerAngles.new(action.roll,action.pitch,action.yaw)) -- Set yaw when teleporting
		end
		if(action.name == "player_move_head_to_position") then
			
			local player = Game.GetPlayer()
			
			local direction = {}
			direction.x = action.x
			direction.y = action.y
			direction.z = action.z
			direction.w = 1
			
			local dirVector = diffVector(player:GetWorldPosition(), direction)
			local angle = GetSingleton('Vector4'):ToRotation(dirVector)
			
			local pitch = angle.pitch
			local yaw = angle.yaw 
			
			local oldangle = GetSingleton('Vector4'):ToRotation(player:GetWorldPosition())
			
			local how = angle.yaw -oldangle.yaw
			print(how)
			local actionlist = {}
			for i=1,0-how do
				local newaction = {}
				newaction.name = "player_look_at_rotation"
				
				newaction.roll = angle.roll
				newaction.pitch = angle.pitch
				newaction.yaw = oldangle.yaw+i
				table.insert(actionlist,newaction)
				
				local newaction = {}
				newaction.name = "wait_second"
				
				newaction.value = 0.1
				table.insert(actionlist,newaction)
				
			end
			runSubActionList(actionlist, "forlist_"..math.random(1,99999), tag,source,false,executortag)
		end
		if(action.name == "player_look_at_forward") then
			local position = getForwardPosition(Game.GetPlayer(),5)
			playerLookAtDirection(position.x, position.y,position.z)
			Game.GetPlayer():GetFPPCameraComponent().pitchMin = pitch - 0.01 -- Use pitchMin/Max to set pitch, needs to have a small difference between Min and Max
			Game.GetPlayer():GetFPPCameraComponent().pitchMax = pitch
			Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition() , EulerAngles.new(0,0,yaw)) -- Set yaw when teleporting
		end
		if(action.name == "rotate_player_camera") then
			--EulerAngles.new(ROLL,PITCH, YAW)
			--https://en.wikipedia.org/wiki/Aircraft_principal_axes#/media/File:Yaw_Axis_Corrected.svg
			Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(90, 0, 0)))
		end
		if(action.name == "player_look_at_unlock") then
			freezeCamera =  false
		end
		if(action.name == "set_entity_appearance") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				--debugPrint(1,"go")
				getAppearance(enti)
				setAppearance(enti,action.appearance)
			end
		end
		if(action.name == "swap_character") then
			swapEntity(action.target,action.swap)
		end
		if(action.name == "swap_character_current_star") then
			if(currentStar ~= nil) then
				swapEntity(action.target,currentStar.TweakIDs)
			end
		end
		if(action.name == "change_character_preset") then
			changePreset(action.target,action.preset)
		end
		if(action.name == "freeze_player") then
			local blackboardDefs = Game.GetAllBlackboardDefs()
			local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
			local test = blackboardPSM:GetInt(blackboardDefs.PlayerStateMachine.SceneTier)
			blackboardPSM:SetInt(blackboardDefs.PlayerStateMachine.SceneTier, 5, true) -- GameplayTier.Tier5_Cinematic
			times = Game.GetTimeSystem()
			times:SetIgnoreTimeDilationOnLocalPlayerZero(false)
			Game.SetTimeDilation(0.0000000000001)
		end
		if(action.name == "unfreeze_player") then
			local blackboardDefs = Game.GetAllBlackboardDefs()
			local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
			blackboardPSM:SetInt(blackboardDefs.PlayerStateMachine.SceneTier, 1, true) -- GameplayTier.Tier1_FullGameplay 
			Game.SetTimeDilation(0)
		end
		if(action.name == "apply_effect") then
			if(action.tag == "player") then
				Game.ApplyEffectOnPlayer(action.value)
				else
				local obj = getEntityFromManager(action.tag)
				local enti = Game.FindEntityByID(obj.id)
				local applyStatusEffect = Game['StatusEffectHelper::ApplyStatusEffectForTimeWindow;GameObjectTweakDBIDEntityIDFloatFloat'] 
				applyStatusEffect(enti, TweakDBID.new(action.value),obj.id, 0,1000)
			end
		end
		if(action.name == "remove_effect") then
			if(action.tag == "player") then
				Game.RemoveEffectPlayer(action.value)
				else
				local obj = getEntityFromManager(action.tag)
				Game.RemoveStatusEffect(obj.id,TweakDBID.new(action.value))
			end
		end
		if(action.name == "set_timedilationforplayer") then
			Game.GetTimeSystem():SetIgnoreTimeDilationOnLocalPlayerZero(action.value)  
		end
		if(action.name == "set_timedilation") then
			Game.SetTimeDilation(action.value)
		end
		if(action.name == "change_camera_position") then
			local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			fppComp:SetLocalPosition(Vector4:new(action.x, action.y, action.z, 1.0))
		end
		if(action.name == "change_camera_rotation") then
			local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			fppComp:SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(action.roll, action.pitch, action.yaw)))
		end
		if(action.name == "add_camera_position") then
			local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			local pos = fppComp:GetLocalPosition()
			pos.x = pos.x + action.x
			pos.y = pos.y + action.y
			pos.x = pos.z + action.z
			fppComp:SetLocalPosition(Vector4:new(pos.x, pos.y, pos.z, 1.0))
		end
		if(action.name == "add_camera_rotation") then
			local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			local pos = fppComp:GetLocalOrientation()
			local rot = GetSingleton('Quaternion'):ToEulerAngles(pos)
			rot.yaw = rot.yaw + action.yaw
			rot.pitch = rot.pitch + action.pitch
			rot.roll = rot.roll + action.roll
			fppComp:SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(rot.roll, rot.pitch, rot.yaw)))
		end
		if(action.name == "reset_camera") then
			local fppComp = Game.GetPlayer():GetFPPCameraComponent()
			fppComp:SetLocalPosition(Vector4:new(0, 0, 0, 1.0))
			fppComp:SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(0, 0, 0)))
		end
		if(action.name == "execute_at_script_level") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				if(obj.scriptlevel == nil or obj.scriptlevel <= action.scriptlevel) then
					
					runSubActionList(action.action, "execute_at_level_"..math.random(1,99999), tag,source,false,obj.tag)
					
				end
			end
			
		end
		
		if(action.name == "set_script_level") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				obj.scriptlevel = action.scriptlevel 
				
			end
			
		end
		
		if(action.name == "player_toggle_invisible") then
			PlayerToggleInvisible(action.value)
		end
		
		if(action.name == "player_toggle_v_component_visibility") then
			toggleVBodyComponent(action.value)
		end
		
		
		
	end
	
	if logicregion then
		if(action.name == "if") then
			checkIf(action,tag,source,executortag)
			result = false
		end
		if(action.name == "lightif") then
			if(checkTrigger(action.trigger)) then
				for i=1,#action.if_action do
					executeAction(action.if_action[i],tag,parent,index,source,executortag)
				end
				else
				for i=1,#action.else_action do
					executeAction(action.else_action[i],tag,parent,index,source,executortag)
				end
			end
		end
		if(action.name == "for") then
			local actionlist = {}
			for i=1,action.amount do
				for y=1, #action.action do 
					table.insert(actionlist,action.action[y])
				end
			end
			--debugPrint(1,#actionlist)
			--doActionofIndex(actionlist,"interact",listaction,currentindex)
			runSubActionList(actionlist, "forlist_"..math.random(1,99999), tag,source,false,executortag)
			result = false
		end
		if(action.name == "clean_thread") then
			workerTable[action.tag] = nil
		end
		if(action.name == "wait") then
			local temp = getGameTime()
			local nexttemp = temp
			nexttemp.min = nexttemp.min + action.value
			if(nexttemp.min > 60) then
				nexttemp.min = nexttemp.min-60
				nexttemp.hour = nexttemp.hour+1
			end
			if(nexttemp.hour == 25)then
				nexttemp.hour = 1
			end
			if(nexttemp.hour == 0)then
				nexttemp.hour = 24
			end
			nexttemp.hour = nexttemp.hour
			action.hour = nexttemp.hour
			action.min = nexttemp.min
			result = false
		end
		if(action.name == "wait_second") then
			local temp = tick
			--debugPrint(1,temp)
			local nexttemp = temp
			--debugPrint(1,math.ceil((action.value*60)))
			nexttemp =nexttemp +  math.ceil((action.value*60))
			--debugPrint(1,nexttemp)
			action.tick = nexttemp
			result = false
		end
		if(action.name == "wait_for_trigger") then
			result = false
		end
		if(action.name == "wait_for_framework") then
			waiting = true
			result = false
		end
		if(action.name == "wait_for_target") then
			result = false
		end
		if(action.name == "wait_for_selection") then
			enableEntitySelection = true
			entitySelectionIsVehicule = action.isvehicule
			selectionSlot = action.slot
			result = false
		end
		if(action.name == "clean_selection") then
			if(action.slot == 1) then
				local obj = getEntityFromManager("selection")
				obj.id = nil
			end
			if(action.slot == 2) then
				local obj = getEntityFromManager("selection2")
				obj.id = nil
			end
			if(action.slot == 3) then
				local obj = getEntityFromManager("selection3")
				obj.id = nil
			end
			if(action.slot == 4) then
				local obj = getEntityFromManager("selection4")
				obj.id = nil
			end
			if(action.slot == 5) then
				local obj = getEntityFromManager("selection5")
				obj.id = nil
			end
		end
		if(action.name == "clean_all_selection") then
			local obj = getEntityFromManager("selection")
			obj.id = nil
			obj = getEntityFromManager("selection2")
			obj.id = nil
			obj = getEntityFromManager("selection3")
			obj.id = nil
			obj = getEntityFromManager("selection4")
			obj.id = nil
			obj = getEntityFromManager("selection5")
			obj.id = nil
		end
		if(action.name == "do_random_event")then
			local tago = math.random(1,#action.events)
			local boj = arrayEvent[action.events[tago]]
			if( boj ~= nil) then
				local event = boj.event
				if(action.bypass ~= nil and action.bypass == true) then
					debugPrint(1,"Doing event : "..event.name)
					if(action.parallele == nil or action.parallele == false)then
						runSubActionList(event.action, action.value, tag,source,false,executortag)
						result=false
						else
						runActionList(event.action, action.value, tag,source,false,executortag)
					end
					else
					if(checkTriggerRequirement(event.requirement,event.trigger))then
						--debugPrint(1,"check for "..interact2.name)
						debugPrint(1,"Doing event : "..event.name)
						if(action.parallele == nil or action.parallele == false)then
							runSubActionList(event.action, action.value, tag,source,false,executortag)
							result=false
							else
							runActionList(event.action, action.value, tag,source,false,executortag)
						end
						else
						error("can't do event : "..event.name)
					end
				end
			end
			
		end
		if(action.name == "while_one") then
			result = false
		end
		if(action.name == "do_event") then
			local boj = arrayEvent[action.value]
			debugPrint(1,action.value)
			if( boj ~= nil) then
				local event = boj.event
				debugPrint(1,boj.event.tag)
				if(action.bypass ~= nil and action.bypass == true) then
					debugPrint(1,"Doing event : "..event.name)
					if(action.parallele == nil or action.parallele == false)then
						runSubActionList(event.action, action.value, tag,source,false,executortag)
						result=false
						else
						runActionList(event.action, action.value, tag,source,false,executortag)
					end
					
					else
					if(checkTriggerRequirement(event.requirement,event.trigger))then
						--debugPrint(1,"check for "..interact2.name)
						debugPrint(1,"Doing event : "..event.name)
						if(action.parallele == nil or action.parallele == false)then
							runSubActionList(event.action, action.value, tag,source,false,executortag)
							result=false
							else
							runActionList(event.action, action.value, tag,source,false,executortag)
						end
						else
						error("can't do event : "..event.name)
					end
				end
				testTriggerRequirement(event.requirement,event.trigger)
			end
			
		end
		if(action.name == "do_function") then
			local boj = arrayFunction[action.value]
			local event = boj.func
			if( boj ~= nil) then
				local exector = executortag
				
				
				if(action.applyto ~= nil and action.applyto ~= "")then
					exector = action.applyto
				end
				
				
				if(action.parallele == nil or action.parallele == false)then
					
					
					runSubActionList(event.action, action.value, tag,source,false,exector)
					result=false
					else
					runActionList(event.action,action.value,source,false,exector)
					
					
				end
				
				
			end
			
		end
		if(action.name == "goto") then
			local index = workerTable[tag]["index"]
			local list = workerTable[tag]["action"]
			local parent = workerTable[tag]["parent"]
			local pending = workerTable[tag]["pending"]	
			debugPrint(1,index)
			debugPrint(1,dump(list))
			debugPrint(1,parent)
			debugPrint(1,tostring(pending))
			if(list[index].parent == true) then
				debugPrint(1,"Go to"..action.index.." of "..parent)
				workerTable[parent]["index"] = action.index-1
				workerTable[tag]["index"] = workerTable[tag]["index"]+1
				workerTable[parent]["pending"] =  false
				tag = parent
				else
				debugPrint(1,"Go to"..action.index.." of "..tag)
				workerTable[tag]["index"] = action.index 
			end
		end
		if(action.name == "do_random_function")then
			local tago = math.random(1,#action.funcs)
			debugPrint(1,action.funcs[tago])
			local boj = arrayFunction[action.funcs[tago]]
			if( boj ~= nil) then
				
				
				local exector = executortag
				
				
				if(action.applyto ~= nil and action.applyto ~= "")then
					exector = action.applyto
				end
				
				if(action.parallele == nil or action.parallele == false)then
					runSubActionList(boj.func.action, tago,parent,source,false,exector)
					result=false
					else
					runActionList(boj.func.action,tago,source,false,exector)
				end
			end
			
		end
	end
	
	if uiregion then
		if(action.name == "show_texture") then
			local frame = {}
			frame.texture = ImGui.LoadTexture(getTextureByTag(action.tag))
			frame.tag = action.tag
			frame.size = {}
			frame.size.x = action.sizeX
			frame.size.y = action.sizeY
			frame.position = {}
			frame.position.x = action.positionX
			frame.position.y = action.positionY
			frame.bgcolor = action.bgcolor
			frame.bgopacity = action.bgopacity
			frame.bordercolor = action.bordercolor
			frame.borderopacity = action.borderopacity
			frame.title = action.title
			frame.titlecolor = action.titlecolor
			
			frame.titleopacity = 0
			
			if(action.showtitle == true) then
				frame.titleopacity = 1
			end
			
			currentLoadedTexture[action.tag] = frame
		end
		if(action.name == "hide_texture") then
			currentLoadedTexture[action.tag] = nil
		end
		if(action.name == "set_scroll_speed") then
			ScrollSpeed = action.value
		end
		if(action.name == "reset_scroll_speed") then
			ScrollSpeed = 0.002
		end
		if(action.name == "update_mod_setting") then
			updateUserSetting(action.tag,action.value)
		end
		if(action.name == "launch_gang_affinity_calculator") then
			GangAffinityCalculator()
		end
		if(action.name == "open_interface") then
			currentInterface = arrayInterfaces[action.tag].ui
			--debugPrint(1,dump(currentInterface))
			if(currentInterface ~= nil) then
				--openInterface = true
				if UIPopupsManager.IsReady() then
					local notificationData = inkGameNotificationData.new()
					notificationData.notificationName = 'base\\gameplay\\gui\\widgets\\notifications\\shard_notification.inkwidget'
					notificationData.queueName = 'modal_popup'
					notificationData.isBlocking = true
					notificationData.useCursor = true
					UIPopupsManager.ShowPopup(notificationData)
					else
					Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
				end
				else
				Game.GetPlayer():SetWarningMessage("Open and close Main menu before call an popup.")
			end
		end
		
		if(action.name == "start_effect") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				GameObjectEffectHelper.StartEffectEvent(enti, action.value)
			end
		end
		if(action.name == "stop_effect") then
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				GameObjectEffectHelper.StopEffectEvent(enti, action.value)
				GameObjectEffectHelper.BreakEffectLoopEvent(enti, action.value)
			end
		end
		
		if(action.name == "effect_tester") then
			
			local actionlist = {}
			for i=1,#listFX do
				
				
				
				local actiond = {}
				actiond.name = "start_effect"
				actiond.value = listFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "simple_message"
				actiond.value = listFX[i]
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "stop_effect"
				actiond.value = listFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				
			end
			
			runSubActionList(actionlist, "effect_tester"..math.random(1,99999), tag,source,false,executortag)
		end
		
		if(action.name == "effect_player_tester") then
			
			local actionlist = {}
			for i=1,#transistionFX do
				
				
				
				local actiond = {}
				actiond.name = "start_effect"
				actiond.value = transistionFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "simple_message"
				actiond.value = transistionFX[i]
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "stop_effect"
				actiond.value = transistionFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				
			end
			
			runSubActionList(actionlist, "effect_tester"..math.random(1,99999), tag,source,false,executortag)
		end
		
		if(action.name == "effect_npc_tester") then
			
			local actionlist = {}
			for i=1,#npcFX do
				
				
				
				local actiond = {}
				actiond.name = "start_effect"
				actiond.value = npcFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "simple_message"
				actiond.value = npcFX[i]
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "stop_effect"
				actiond.value = npcFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				
			end
			
			runSubActionList(actionlist, "effect_tester"..math.random(1,99999), tag,source,false,executortag)
		end
		
		if(action.name == "effect_car_tester") then
			
			local actionlist = {}
			for i=1,#carFX do
				
				
				
				local actiond = {}
				actiond.name = "start_effect"
				actiond.value = carFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "simple_message"
				actiond.value = carFX[i]
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "stop_effect"
				actiond.value = carFX[i]
				actiond.tag = action.tag
				
				table.insert(actionlist,actiond)
				
				actiond = {}
				actiond.name = "wait_second"
				actiond.value = 2
				
				table.insert(actionlist,actiond)
				
				
			end
			
			runSubActionList(actionlist, "effect_tester"..math.random(1,99999), tag,source,false,executortag)
		end
		
		if(action.name == "change_interface_label_text") then
			if(#currentevt > 0) then
				for i =1,#currentevt do 
					if(currentevt[i].tag == action.tag) then
						currentevt[i].ink:SetText(action.value)
					end
				end
			end
		end
		if(action.name == "change_interface_cart") then
			if(#currentevt > 0) then
				for i =1,#currentevt do 
					if(currentevt[i].tag == action.tag) then
						currentevt[i].ink:SetText("Cart Total : "..CartPrice)
					end
				end
			end
		end
		if(action.name == "open_radio") then
			if radiopopup then
				openRadio()
				else
				Game.GetPlayer():SetWarningMessage("Open and close radio from vehicule before or reload an save to call the popup.")
			end
		end
		if(action.name == "set_datapack_group") then
			currentInteractGroupIndex = action.value
		end
		if(action.name == "set_selected_item_category") then
			Keystone_currentSelectedItemCategory = action.value
		end
		if(action.name == "set_selected_item") then
			Keystone_currentSelectedItem = action.value
		end
		if(action.name == "set_selected_keystone_datapack") then
			Keystone_currentSelectedDatapack = action.value
		end
		if(action.name == "open_datapack_group_ui") then
			ScrollSpeed = 0.07
			ActivatedGroup()
		end
		if(action.name == "open_keystone_datapack_main") then
			ScrollSpeed = 0.07
			Keystone_Datapack()
		end
		
		if(action.name == "open_keystone_datapack_mine") then
			ScrollSpeed = 0.07
			Keystone_myDatapack()
		end
		if(action.name == "open_keystone_main") then
			ScrollSpeed = 0.07
			Keystone_Main()
		end
		if(action.name == "open_keystone_update_warning") then
			Keystone_Warning()
		end
		if(action.name == "open_keystone_corpowars") then
			Keystone_corpoWars()
		end
		if(action.name == "open_keystone_multiinfo") then
			Keystone_MultiInfo()
		end
		if(action.name == "open_keystone_changelog") then
			Keystone_Changelog()
		end
		if(action.name == "open_keystone_stock") then
			ScrollSpeed = 0.07
			Keystone_stock()
		end
		if(action.name == "open_keystone_item") then
			ScrollSpeed = 0.07
			Keystone_item()
		end
		if(action.name == "open_keystone_item_category") then
			Keystone_item_category()
		end
		if(action.name == "open_datapack_detail_ui") then
			
			Keystone_Datapack_details(action.redirect)
		end
		if(action.name == "open_menu") then
			local startHub = StartHubMenuEvent.new()
			startHub:SetStartMenu(action.value)
			Game.GetUISystem():QueueEvent(startHub)
		end
		if(action.name == "close_menu") then
			local closeHub = ForceCloseHubMenuEvent.new()
			Game.GetUISystem():QueueEvent(closeHub)
		end
		if(action.name == "close_interface") then
			--	openInterface = false
			ScrollSpeed = getUserSetting("ScrollSpeed")
			currentInterface = nil
			buttonsData = {}
			UIPopupsManager.ClosePopup()
		end
		if(action.name == "lock_conversation" or action.name == "lock_message") then
			setScore(action.tag,"unlocked",0)
		end
		if(action.name == "unlock_conversation" or action.name == "unlock_message") then
			setScore(action.tag,"unlocked",1)
		end
	end
	
	if avregion then
		if(action.name == "vehicule_autodrive_activate") then
			local mappin = {}
			mappin.x = action.x
			mappin.y = action.y
			mappin.z = action.z
			local actionlist = {}
			debugPrint(1,#actionlist)
			local obj = getEntityFromManager(action.tag)
			local enti = Game.FindEntityByID(obj.id)
			if(enti ~= nil) then
				local myPos = enti:GetWorldPosition()
				local newPos = myPos
				local angle = EulerAngles.new(0,0,0)
				local tempangle = {}
				tempangle.roll = 0
				tempangle.pitch = 0
				tempangle.yaw = 0
				local numbertimes = 0
				if(action.isAV == true) then
					local ztimes = action.zfly - myPos.z
					debugPrint(1,"ztimes "..ztimes)
					numbertimes = math.floor(ztimes / action.speed)
					debugPrint(1,"ztimes "..ztimes)
					for i=1,numbertimes do 
						local oldPos = newPos
						newPos.z = newPos.z +   action.speed
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = angle
						newaction.collision = false
						newaction.pathfinding = false
						newaction.axis = "z"
						table.insert(actionlist,newaction)
					end
				end
				local destination = Vector4.new(mappin.x, myPos.y, myPos.z,1)			
				local dirVector = diffVector(myPos, destination)
				if(action.isAV == true) then
					local newangle = GetSingleton('Vector4'):ToRotation(dirVector)
					newangle.roll = 0
					newangle.pitch = 0
					debugPrint(1,"newangle.yaw "..newangle.yaw)
					local anglesub = newangle.yaw/100
					for i=1,100 do 
						local oldPos = newPos
						tempangle.yaw = tempangle.yaw + anglesub
						debugPrint(1,"tempangle.yaw "..tempangle.yaw)
						local angletomake= tempangle
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = {}
						newaction.angle.roll = 0+angletomake.roll
						newaction.angle.pitch = 0+angletomake.pitch
						newaction.angle.yaw = 0+angletomake.yaw
						debugPrint(1,"newaction.angle.yaw "..newaction.angle.yaw)
						newaction.pathfinding = action.pathfinding
						newaction.collision = false
						newaction.axis = "x"
						table.insert(actionlist,newaction)
					end
					angle = GetSingleton('Vector4'):ToRotation(dirVector)
					angle.roll = 0
					angle.pitch = 0
				end
				local xtimes = mappin.x - myPos.x
				numbertimes = math.floor(xtimes / action.speed)
				newnumbertimes = 0
				local isNegative = false
				if(numbertimes <0) then
					newnumbertimes = -numbertimes
					isNegative = true
					else
					newnumbertimes = numbertimes
				end
				for i=1,newnumbertimes do 
					local oldPos = newPos
					if(isNegative == true) then
						newPos.x = newPos.x -  action.speed
						else
						newPos.x = newPos.x +   action.speed
					end
					local newaction = {}
					newaction.name = "teleport_entity_at_position"
					newaction.tag = action.tag
					newaction.x = newPos.x
					newaction.y = newPos.y
					newaction.z = newPos.z
					newaction.angle = angle
					newaction.pathfinding = action.pathfinding
					newaction.collision = true
					newaction.axis = "x"
					table.insert(actionlist,newaction)
				end
				destination = Vector4.new(myPos.x, mappin.y, myPos.z,1)			
				dirVector = diffVector(myPos, destination)
				local newangle = GetSingleton('Vector4'):ToRotation(dirVector)
				newangle.roll = 0
				newangle.pitch = 0
				local anglesub = newangle.yaw/100
				if(action.do_rotation == nil or action.do_rotation == true ) then
					for i=1,100 do 
						local oldPos = newPos
						tempangle.yaw =tempangle.yaw + anglesub
						debugPrint(1,"tempangle.yaw "..tempangle.yaw)
						local angletomake= tempangle
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = {}
						newaction.angle.roll = 0+angletomake.roll
						newaction.angle.pitch = 0+angletomake.pitch
						newaction.angle.yaw = 0+angletomake.yaw
						debugPrint(1,"newaction.angle.yaw "..newaction.angle.yaw)
						newaction.pathfinding = action.pathfinding
						newaction.collision = false
						newaction.axis = "y"
						table.insert(actionlist,newaction)
					end
				end
				angle = GetSingleton('Vector4'):ToRotation(dirVector)
				angle.roll = 0
				angle.pitch = 0
				local ytimes = mappin.y - myPos.y
				numbertimes = math.floor(ytimes /  action.speed)
				newnumbertimes = 0
				isNegative = false
				if(numbertimes <0) then
					newnumbertimes = -numbertimes
					isNegative = true
					else
					newnumbertimes = numbertimes
				end
				for i=1,newnumbertimes do 
					local oldPos = newPos
					if(isNegative == true) then
						newPos.y = newPos.y -  action.speed
						else
						newPos.y = newPos.y +  action.speed
					end
					local newaction = {}
					newaction.name = "teleport_entity_at_position"
					newaction.tag = action.tag
					newaction.x = newPos.x
					newaction.y = newPos.y
					newaction.z = newPos.z
					newaction.angle = angle
					newaction.pathfinding = action.pathfinding
					newaction.collision = true
					newaction.axis = "y"
					table.insert(actionlist,newaction)
				end
				if(action.isAV == true) then
					ztimes = action.zfly - 0
					numbertimes = math.floor(ztimes / action.speed)
					numbertimes = numbertimes
					for i=1,numbertimes do 
						local oldPos = newPos
						newPos.z = newPos.z - action.speed
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = angle
						newaction.collision = true
						newaction.pathfinding = false
						newaction.axis = "z"
						table.insert(actionlist,newaction)
					end
				end
				local namescript = "vehicule_autodrive_activate_"..math.random(1,99999)
				-- local file = assert(io.open("json/report/"..namescript..".json", "w"))
				-- local stringg = dump(actionlist)
				-- debugPrint(1,stringg)
				-- file:write(stringg)
				-- file:close()
				-- end
				runSubActionList(actionlist, "av_autodrive_activate_"..math.random(1,99999), tag,source,false,executortag)
				result = false
			end
		end
		if(action.name == "vehicule_autodrive_activate_custom_mappin") then
			if(ActivecustomMappin ~= nil) then
				local mappin = ActivecustomMappin:GetWorldPosition()
				local actionlist = {}
				debugPrint(1,#actionlist)
				--doActionofIndex(actionlist,"interact",listaction,currentindex)
				local obj = getEntityFromManager(action.tag)
				local enti = Game.FindEntityByID(obj.id)
				local myPos = enti:GetWorldPosition()
				local newPos = myPos
				local angle = EulerAngles.new(0,0,0)
				local tempangle = {}
				tempangle.roll = 0
				tempangle.pitch = 0
				tempangle.yaw = 0
				local numbertimes = 0
				if(action.isAV == true) then
					local ztimes = action.zfly - myPos.z
					debugPrint(1,"ztimes "..ztimes)
					numbertimes = math.floor(ztimes / action.speed)
					debugPrint(1,"ztimes "..ztimes)
					for i=1,numbertimes do 
						local oldPos = newPos
						newPos.z = newPos.z +   action.speed
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = angle
						newaction.collision = false
						newaction.pathfinding = false
						newaction.axis = "z"
						table.insert(actionlist,newaction)
					end
				end
				local destination = Vector4.new(mappin.x, myPos.y, myPos.z,1)			
				local dirVector = diffVector(myPos, destination)
				if(action.isAV == true) then
					local newangle = GetSingleton('Vector4'):ToRotation(dirVector)
					newangle.roll = 0
					newangle.pitch = 0
					debugPrint(1,"newangle.yaw "..newangle.yaw)
					local anglesub = newangle.yaw/100
					for i=1,100 do 
						local oldPos = newPos
						tempangle.yaw = tempangle.yaw + anglesub
						debugPrint(1,"tempangle.yaw "..tempangle.yaw)
						local angletomake= tempangle
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = {}
						newaction.angle.roll = 0+angletomake.roll
						newaction.angle.pitch = 0+angletomake.pitch
						newaction.angle.yaw = 0+angletomake.yaw
						debugPrint(1,"newaction.angle.yaw "..newaction.angle.yaw)
						newaction.pathfinding = action.pathfinding
						newaction.collision = false
						newaction.axis = "x"
						table.insert(actionlist,newaction)
					end
					angle = GetSingleton('Vector4'):ToRotation(dirVector)
					angle.roll = 0
					angle.pitch = 0
				end
				local xtimes = mappin.x - myPos.x
				numbertimes = math.floor(xtimes / action.speed)
				newnumbertimes = 0
				local isNegative = false
				if(numbertimes <0) then
					newnumbertimes = -numbertimes
					isNegative = true
					else
					newnumbertimes = numbertimes
				end
				for i=1,newnumbertimes do 
					local oldPos = newPos
					if(isNegative == true) then
						newPos.x = newPos.x -  action.speed
						else
						newPos.x = newPos.x +   action.speed
					end
					local newaction = {}
					newaction.name = "teleport_entity_at_position"
					newaction.tag = action.tag
					newaction.x = newPos.x
					newaction.y = newPos.y
					newaction.z = newPos.z
					newaction.angle = angle
					newaction.pathfinding = action.pathfinding
					newaction.collision = true
					newaction.axis = "x"
					table.insert(actionlist,newaction)
				end
				destination = Vector4.new(myPos.x, mappin.y, myPos.z,1)			
				dirVector = diffVector(myPos, destination)
				local newangle = GetSingleton('Vector4'):ToRotation(dirVector)
				newangle.roll = 0
				newangle.pitch = 0
				local anglesub = newangle.yaw/100
				if(action.do_rotation == nil or action.do_rotation == true ) then
					for i=1,100 do 
						local oldPos = newPos
						tempangle.yaw =tempangle.yaw + anglesub
						debugPrint(1,"tempangle.yaw "..tempangle.yaw)
						local angletomake= tempangle
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = {}
						newaction.angle.roll = 0+angletomake.roll
						newaction.angle.pitch = 0+angletomake.pitch
						newaction.angle.yaw = 0+angletomake.yaw
						debugPrint(1,"newaction.angle.yaw "..newaction.angle.yaw)
						newaction.pathfinding = action.pathfinding
						newaction.collision = false
						newaction.axis = "y"
						table.insert(actionlist,newaction)
					end
				end
				angle = GetSingleton('Vector4'):ToRotation(dirVector)
				angle.roll = 0
				angle.pitch = 0
				local ytimes = mappin.y - myPos.y
				numbertimes = math.floor(ytimes /  action.speed)
				newnumbertimes = 0
				isNegative = false
				if(numbertimes <0) then
					newnumbertimes = -numbertimes
					isNegative = true
					else
					newnumbertimes = numbertimes
				end
				for i=1,newnumbertimes do 
					local oldPos = newPos
					if(isNegative == true) then
						newPos.y = newPos.y -  action.speed
						else
						newPos.y = newPos.y +  action.speed
					end
					local newaction = {}
					newaction.name = "teleport_entity_at_position"
					newaction.tag = action.tag
					newaction.x = newPos.x
					newaction.y = newPos.y
					newaction.z = newPos.z
					newaction.angle = angle
					newaction.pathfinding = action.pathfinding
					newaction.collision = true
					newaction.axis = "y"
					table.insert(actionlist,newaction)
				end
				if(action.isAV == true) then
					ztimes = action.zfly -2 --safe floor
					numbertimes = math.floor(ztimes / action.speed)
					numbertimes = numbertimes
					
					for i=1,numbertimes do 
						local oldPos = newPos
						newPos.z = newPos.z - action.speed
						local newaction = {}
						newaction.name = "teleport_entity_at_position"
						newaction.tag = action.tag
						newaction.x = newPos.x
						newaction.y = newPos.y
						newaction.z = newPos.z
						newaction.angle = angle
						newaction.collision = true
						newaction.pathfinding = false
						newaction.axis = "z"
						table.insert(actionlist,newaction)
					end
				end
				local namescript = "vehicule_autodrive_activate_custom_mappin_"..math.random(1,99999)
				-- local file = assert(io.open("json/report/"..namescript..".json", "w"))
				-- local stringg = dump(actionlist)
				-- debugPrint(1,stringg)
				-- file:write(stringg)
				-- file:close()
				-- end
				runSubActionList(actionlist, "av_autodrive_activate__@custom_mappin_"..math.random(1,99999), tag,source,false,executortag)
				result = false
			end
		end
		if(action.name == "toggle_av_engine") then
			local obj = getEntityFromManager(action.tag)
			if(obj ~= nil) then
				if(obj.isAV == true) then
					obj.isAV = false
					else
					obj.isAV = true
				end
			end
		end
		if(action.name == "toggle_av_engine_for_current_drived_vehicule") then
			local inVehicule = Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer())
			if (inVehicule) then
				local vehicule = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
				if(vehicule ~= nil) then
					local obj = getEntityFromManagerById(vehicule:GetEntityID())
					if(obj.id == nil) then
						local entity = {}
						entity.id = vehicule:GetEntityID()
						entity.tag = "vehicule_"..math.random(1,9999)
						entity.tweak = "nope"
						entity.takenSeat = {}
						entity.isAV = false
						local group = getGroupfromManager("AV")
						entity.availableSeat = GetSeats(vehicule)
						entity.driver = "player"
						table.insert(questMod.EntityManager,entity)
						--debugPrint(1,"new "..entity.tag)
						obj = entity
					end
					debugPrint(1,obj.tag)
					local obj = getTrueEntityFromManager(obj.tag)
					if(obj.isAV == true) then
						obj.isAV = false
						local index =getIndexFromGroupManager("AV")
						for i=1, #questMod.GroupManager[index].entities do 
							local entityTag = questMod.GroupManager[index].entities[i]
							if(entityTag == obj.tag) then
								table.remove(questMod.GroupManager[index].entities,i)
							end
						end
						--debugPrint(1,"removedAV"..obj.tag)
						else
						local group =getGroupfromManager("AV")
						obj.isAV = true
						if(group.entities == nil) then
							group.entities = {}
						end
						debugPrint(1,"addedAV"..obj.tag)
						table.insert(group.entities,obj.tag)
					end
				end
			end
		end
	end
	
	if customnpcregion then 
		if(action.name == "npc_custom_summon_custom_npc_at_entity_relative") then
			local positionVec4 = Game.GetPlayer():GetWorldPosition()
			local entity = nil
			if(action.entity ~= "player") then
				local obj = getEntityFromManager(action.entity)
				entity = Game.FindEntityByID(obj.id)
				positionVec4 = entity:GetWorldPosition()
				else
				entity = Game.GetPlayer()
			end
			if(action.position ~= nil and (action.position ~= "" or action.position ~= "nothing")) then
				if(action.position == "behind") then
					positionVec4 = getBehindPosition(entity,action.distance)
				end
				if(action.position == "forward") then
					positionVec4 = getForwardPosition(entity,action.distance)
				end
				else
				positionVec4.x = positionVec4.x + action.x
				positionVec4.y = positionVec4.y + action.y
				positionVec4.z = positionVec4.z + action.z
			end
			local npc =  getCustomNPCbyTag(action.tag)
			npc.spawnforced=true
			npc.dospawnaction=action.dospawnaction
			npc.doroutineaction=action.doroutineaction
			npc.dodeathaction=action.dodeathaction
			npc.dodespawnaction=action.dodespawnaction
			if(action.replacelocation == true) then
				npc.workinglocation.x = positionVec4.x
				npc.workinglocation.y = positionVec4.y
				npc.workinglocation.z = positionVec4.z
			end
			if(npc.useBetaSpawn == true) then
				spawnEntity(npc.tweakDB, npc.tag,  positionVec4.x ,  positionVec4.y , positionVec4.z, 90, true, false,true)
				else
				spawnEntity(npc.tweakDB, npc.tag,  positionVec4.x ,  positionVec4.y , positionVec4.z, 90, true, false,false)
			end
			npc.isspawn=true
			npc.init=false
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "npc_custom_summon_custom_npc") then
			local npc =  getCustomNPCbyTag(action.tag)
			npc.spawnforced=true
			npc.dospawnaction=action.dospawnaction
			npc.doroutineaction=action.doroutineaction
			npc.dodeathaction=action.dodeathaction
			npc.dodespawnaction=action.dodespawnaction
			if(action.replacelocation == true) then
				npc.workinglocation.x = action.x
				npc.workinglocation.y = action.y
				npc.workinglocation.z = action.z
			end
			if(npc.useBetaSpawn == true) then
				spawnEntity(npc.tweakDB, npc.tag,  action.x ,  action.y , action.z, 90, true, false,true)
				else
				spawnEntity(npc.tweakDB, npc.tag,  action.x ,  action.y , action.z, 90, true, false,false)
			end
			npc.isspawn=true
			npc.init=false
			if(action.group ~= nil and action.group ~= "") then
				local index =getIndexFromGroupManager(action.group)
				table.insert(questMod.GroupManager[index].entities,action.tag)
			end
		end
		if(action.name == "npc_custom_edit_custom_npc") then
			local npc =  getCustomNPCbyTag(action.tag)
			npc.spawnforced=true
			npc.dospawnaction=action.dospawnaction
			npc.doroutineaction=action.doroutineaction
			npc.dodeathaction=action.dodeathaction
			npc.dodespawnaction=action.dodespawnaction
			npc.repeat_routine = action.repeat_routine
			npc.auto_despawn = action.auto_despawn
			if(action.replacelocation == true) then
				npc.workinglocation.x = action.x
				npc.workinglocation.y = action.y
				npc.workinglocation.z = action.z
				npc.workinglocation.range = action.range
			end
			if(action.appeareance ~= nil and action.appeareance ~= "") then
				npc.appeareance = action.appearance
			end
		end
		if(action.name == "npc_custom_despawn_custom_npc") then
			local npc =  getCustomNPCbyTag(action.tag)
			npc.isspawn=false
			npc.init=false
			npc.appearancesetted = nil
			npc.spawnforced=false
			npc.dospawnaction=true
			npc.doroutineaction=true
			npc.dodeathaction=true
			npc.dodespawnaction=true
			npc.workinglocation = npc.location
			if(workerTable[npc.tag.."_spawn"] ~= nil) then
				workerTable[npc.tag.."_spawn"] = nil
			end
			if(workerTable[npc.tag.."_death"] ~= nil) then
				workerTable[npc.tag.."_death"] = nil
			end
			if(workerTable[npc.tag.."_routine"] ~= nil) then
				workerTable[npc.tag.."_routine"] = nil
			end
			despawnEntity(npc.tag)
			if(workerTable[npc.tag.."_despawn"] == nil and #npc.despawnaction > 0) then
				runActionList(npc.despawnaction, npc.tag.."_despawn", "interact",false,npc.tag)
			end
		end
		if(action.name == "npc_custom_set_autodespawn") then 
			local npc = getCustomNPCByTag(action.tag)
			npc.auto_despawn = action.value
		end
		if(action.name == "npc_custom_set_autoroutine") then 
			local npc = getCustomNPCByTag(action.tag)
			npc.repeat_routine = action.value
		end
		if(action.name == "npc_custom_copy") then 
			local npc =  getCustomNPCbyTag(action.sourcetag)
			local newnpc = 	deepcopy(npc, newnpc)
			newnpc.tag = action.newtag
			newnpc.name = action.newname
			addCustomNPC(newnpc)
		end
	end
	
	if multiregion then
		if not player_region then
			if(action.name == "send_action_to_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
				if action.tag == "lookat" and multiName ~= "" then
					action.tag = multiName
				end
				sendActionstoUser(action.tag,action.action)
				result = true
			end
			if(action.name == "help_faction") then
				if(multiReady)then
					HelpFaction()
					else
					Game.GetPlayer():SetWarningMessage(getLang("You need to be online for help your faction"))
				end
			end
			if(action.name == "disconnect") then
				if(multiEnabled and multiReady) then
					disconnectUser()
					multiReady = false
					multiEnabled = false
					
					
					friendIsSpaned = false
					lastFriendPos = {}
					Game.GetPreventionSpawnSystem():RequestDespawnPreventionLevel(-13)
					
					netontracthub.login = true
					netontracthub.register = false
					netontracthub.main = false
					
					openNetContract = false
					firstload = true
					firstloadMission = true
					firstloadMarket = true
					initfinish = false
				end
			end
			
			if(action.name == "connect") then
				
				connectUser()
				
			end
			if(action.name == "send_message") then
				if(multiEnabled and multiReady) then
					MessageSenderController()
				end
			end
			if(action.name == "toggle_message_popup") then
				if(multiEnabled and multiReady) then
					if onlineMessagePopup then
						onlineMessagePopup = false
						else
						onlineMessagePopup = true
					end
					else
					onlineMessagePopup = false
				end
			end
			if(action.name == "open_avatar_list" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
				ScrollSpeed = 0.07
				Multi_AvatarList()
			end
			if(action.name == "change_avatar" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
				currentSave.myAvatar = action.value
				Cron.After(2,function()	
					updatePlayerSkin()
				end)
			end
			if(action.name == "shoot_talk" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then 
				onlineShootMessage = true
			end
			if(action.name == "select_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil ) then
				selectedUser = action.value
				onlineReceiver = selectedUser.pseudo
			end
			if(action.name == "unblock_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil and selectedUser ~= nil and selectedUser.pseudo ~= nil and selectedUser.pseudo ~= "" ) then
				UnblockFriend()
			end
			if(action.name == "delete_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil and selectedUser ~= nil and selectedUser.pseudo ~= nil and selectedUser.pseudo ~= "" ) then
				DeleteFriend()
			end
			if(action.name == "block_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil and selectedUser ~= nil and selectedUser.pseudo ~= nil and selectedUser.pseudo ~= "" ) then
				BlockFriend()
			end
			if(action.name == "add_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil and selectedUser ~= nil and selectedUser.pseudo ~= nil and selectedUser.pseudo ~= "" ) then
				AddFriend()
			end
			if(action.name == "tp_to_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil and selectedUser ~= nil and selectedUser.pseudo ~= nil and selectedUser.pseudo ~= "" ) then
				Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Vector4.new( selectedUser.x, selectedUser.y, selectedUser.z,1) ,EulerAngles.new(0,0,0))
			end
			if(action.name == "select_friend" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil ) then
				selectedFriend = action.value
				onlineReceiver = selectedUser.name	
			end
			if(action.name == "open_friend_list" and multiEnabled and multiReady) then
				local next = next 
				if ActualFriendList == nil or next(ActualFriendList) == nil then
					Game.GetPlayer():SetWarningMessage("There is no connected friend..")
					else
					Multi_FriendList()
				end
			end
			if(action.name == "join_instance_friend" and multiEnabled and multiReady) then
				if(multiEnabled and multiReady) then
					MessageSenderController()
				end
			end
		end
		if not instance_region then
			if(action.name == "open_players_list"  and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
				if #ActualPlayersList > 0 then
					ScrollSpeed = 0.07
					Multi_InstanceUserList()
					else
					Game.GetPlayer():SetWarningMessage("There is no players around..")
				end
			end
			if(action.name == "open_instance_list" and multiEnabled) then
				ScrollSpeed = 0.07
				Multi_InstanceList()
			end
			if(action.name == "select_instance" and multiEnabled ) then
				selectedInstance = action.value
			end
			if(action.name == "connect_instance" and multiEnabled ) then
				connectMultiplayer()
			end
			if(action.name == "get_instance_list" and multiEnabled) then
				GetInstances()
			end
			if(action.name == "open_instance_creation" and multiEnabled) then
				onlineInstanceCreation = true
			end
			if(action.name == "notify_instance" and multiEnabled and multiReady and CurrentInstance.Title ~= nil) then
				Game.GetPlayer():SetWarningMessage("Welcome to "..CurrentInstance.Title)
			end
			if(action.name == "close_instance_password_popup" and multiEnabled) then
				onlinePasswordPopup = false
			end
			if(action.name == "open_instance_password_popup" and multiEnabled) then
				selectedInstancePassword="nothing"
				onlinePasswordPopup = true
			end
			if(action.name == "open_instance_management" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
				onlineInstanceUpdate = true
			end
			if(action.name == "open_instance_management_users" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
				ScrollSpeed = 0.07
				Multi_InstanceOwnerUserList()
			end
			if(action.name == "block_instance_user" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
				banUserFromInstance()
			end
			if(action.name == "kick_instance_user" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
				kickUserFromInstance()
			end
			if(action.name == "unban_instance_user" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
				unBanUserFromInstance()
			end
		end
		if not instance_place_management_region then
			if(action.name == "open_instance_management_create_custom_place" ) then
				if(ActualPlayerMultiData.currentPlaces ~= nil and #ActualPlayerMultiData.currentPlaces == 0 and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
					onlineInstancePlaceCreation = true
					else
					Game.GetPlayer():SetWarningMessage("There is already an custom place here..")
				end
			end
			if(action.name == "delete_custom_place" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.isInstanceOwner == true) then
				if(ActualPlayerMultiData.currentPlaces ~= nil and #ActualPlayerMultiData.currentPlaces > 0) then
					deleteInstancePlace()
				end
			end
		end
		if not instance_place_item_region then
			if(action.name == "open_placed_item_ui_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if (ActualPlayerMultiData.currentPlaces[1] ~= nil) then
					ScrollSpeed = 0.07
					PlacedItemsUIMulti()
				end
			end
			if(action.name == "open_buyed_item_ui_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if(ActualPlayerMultiData.currentPlaces[1] ~= nil) then
					ScrollSpeed = 0.07
					BuyedItemsUIMulti()
				end
			end
			if(action.name == "set_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if grabbedTarget ~= nil then
					--	tp:Teleport(grabbedTarget, targetPos, targetAngle)
					-- if(Game.FindEntityByID(selectedItemMulti.entityId):IsA('gameObject') == false)then
					-- grabbedTarget:Destroy()
					-- end
					updateItemPositionMulti(selectedItemMulti, targetPos, targetAngle,true)
					UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
					enabled = false
					grabbedTarget = nil
					grabbed = false
					objPush = false
					objPull = false
					id = false
				end
			end
			if(action.name == "grab_select_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					enabled = true
					id = true
					grabbedTarget = Game.FindEntityByID(selectedItemMulti.entityId)
					if(grabbedTarget:IsA('gameObject') == false)then
						grabbedTarget = nil
						grabbed = false
						objPush = false
						objPull = false
						enabled = false
						id = false
						--Game.GetPlayer():SetWarningMessage(getLang(action.value))
						-- local objpos = grabbedTarget:GetWorldPosition()
						-- local worldpos = Game.GetPlayer():GetWorldTransform()
						-- local qat = grabbedTarget:GetWorldOrientation()
						-- local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						-- local transform = Game.GetPlayer():GetWorldTransform()
						-- transform:SetPosition(objpos)
						-- transform:SetOrientationEuler(angle)
						-- grabbedTarget = WorldFunctionalTests.SpawnEntity("base\\items\\interactive\\dining_accessories\\int_dining_accessories_001__bar_asset_h_sponge.ent", transform, '')
					end
					Cron.After(0.7,function()	
						if (grabbedTarget ~= nil) then
							targetPos = grabbedTarget:GetWorldPosition()
							targetAngle = Vector4.ToRotation(grabbedTarget:GetWorldForward())
							objectDist = Vector4.Distance(targetPos, playerPos)
							phi = math.atan2(playerAngle.y, playerAngle.x)
							targetDeltaPos = Vector4.new(((objectDist * math.cos(phi)) + playerPos.x), ((objectDist * math.sin(phi)) + playerPos.y), (objectDist * math.sin(playerAngle.z) + playerPos.z), targetPos.w)
							targetDeltaPos = Delta(targetDeltaPos, targetPos)
							debugPrint(1,grabbedTarget, "grabbed.")
							grabbed = true
							else
							error("No target!")
						end
					end)
				end
			end
			if(action.name == "select_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if(#currentItemMultiSpawned > 0 )then
					for i = 1, #currentItemMultiSpawned do 
						local mitems = currentItemMultiSpawned[i]
						if(mitems.Id == action.value) then
							selectedItemMulti = nil
							selectedItemMulti = mitems
						end
					end
				end
			end
			if(action.name == "unselect_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				selectedItemMulti = nil
				grabbedTarget = nil
				grabbed = false
				objPush = false
				objPull = false
				enabled = false
				id = false
			end
			if(action.name == "move_select_item_to_player_position_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local objpos = Game.GetPlayer():GetWorldPosition()
					local qat = Game.GetPlayer():GetWorldOrientation()
					local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
					updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
					UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
				end
			end
			if(action.name == "move_selected_item_Z_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					debugPrint(1,"yep01")
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						local objpos = entity:GetWorldPosition()
						debugPrint(1,"yep02")
						local worldpos = Game.GetPlayer():GetWorldTransform()
						objpos.z = objpos.z + action.value
						local qat = entity:GetWorldOrientation()
						local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
						UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
						else
						debugPrint(1,"Nope")
					end
				end
			end
			if(action.name == "move_selected_item_X_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						local objpos = entity:GetWorldPosition()
						local worldpos = Game.GetPlayer():GetWorldTransform()
						objpos.x = objpos.x + action.value
						local qat = entity:GetWorldOrientation()
						local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
						UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
					end
				end
			end
			if(action.name == "move_selected_item_Y_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						local objpos = entity:GetWorldPosition()
						local worldpos = Game.GetPlayer():GetWorldTransform()
						objpos.y = objpos.y + action.value
						local qat = entity:GetWorldOrientation()
						local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
						UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
					end
				end
			end
			if(action.name == "open_precision_mod_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					selectedItemMultiBackup = selectedItemMulti
					openEditItemsMulti = true
				end
			end
			if(action.name == "yaw_selected_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						local objpos = entity:GetWorldPosition()
						local worldpos = Game.GetPlayer():GetWorldTransform()
						local qat = entity:GetWorldOrientation()
						local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						angle.yaw = angle.yaw + action.value
						updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
						UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
					end
				end
			end
			if(action.name == "roll_selected_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						local objpos = entity:GetWorldPosition()
						local worldpos = Game.GetPlayer():GetWorldTransform()
						local qat = entity:GetWorldOrientation()
						local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						angle.roll = angle.roll + action.value
						updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
						UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
					end
				end
			end
			if(action.name == "pitch_selected_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						local objpos = entity:GetWorldPosition()
						local worldpos = Game.GetPlayer():GetWorldTransform()
						local qat = entity:GetWorldOrientation()
						local angle = GetSingleton('Quaternion'):ToEulerAngles(qat)
						angle.pitch = angle.pitch + action.value
						updateItemPositionMulti(selectedItemMulti, objpos, angle, true)
						UpdateItem(selectedItemMulti.Tag, selectedItemMulti.X, selectedItemMulti.Y, selectedItemMulti.Z, selectedItemMulti.Roll, selectedItemMulti.Pitch ,selectedItemMulti.Yaw )
					end
				end
			end
			if(action.name == "selected_item_remove_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if selectedItemMulti ~= nil then
					local entity = Game.FindEntityByID(selectedItemMulti.entityId)
					if(entity ~= nil) then
						Game.FindEntityByID(selectedItemMulti.entityId):GetEntity():Destroy()
						debugPrint(1,"toto")
						updatePlayerItemsQuantity(selectedItemMulti,1)
						deleteHousing(selectedItemMulti.Id)
						DeleteItem(selectedItemMulti.Tag)
						local index = getItemEntityIndexFromManager(selectedItemMulti.entityId)
						--despawnItem(selectedItemMulti.Id)
						table.remove(currentItemMultiSpawned,index)
						Cron.After(1, function()
							selectedItemMulti = nil
						end)
						else
						debugPrint(1,"nope")
					end
				end
			end
			if(action.name == "spawn_buyed_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if action.tag ~= nil then
					local pos = Game.GetPlayer():GetWorldPosition()
					local angles = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
					local spawnedItem = {}
					local mitems =  getPlayerItemsbyTag(action.tag)
					if(#ActualPlayerMultiData.currentPlaces > 0 and mitems ~= nil and mitems.Quantity > 0 and (string.match(tostring(mitems.Tag), "AMM_Props.") == nil or (string.match(tostring(mitems.Tag), "AMM_Props.") ~= nil and AMM ~= nil)  )    ) then
						spawnedItem.Tag = mitems.Tag
						spawnedItem.HouseTag = ActualPlayerMultiData.currentPlaces[1].tag
						spawnedItem.ItemPath = mitems.Path
						spawnedItem.X = pos.x
						spawnedItem.Y = pos.y
						spawnedItem.Z = pos.z
						spawnedItem.Yaw = angles.yaw
						spawnedItem.Pitch = angles.pitch
						spawnedItem.Roll = angles.roll
						spawnedItem.Title = mitems.Title
						saveHousing(spawnedItem)
						local housing = getHousing(spawnedItem.Tag,spawnedItem.X,spawnedItem.Y,spawnedItem.Z)
						spawnedItem.Id = housing.Id
						updatePlayerItemsQuantity(mitems,-1)
						spawnedItem.entityId = spawnItem(spawnedItem, pos, angles)
						table.insert(currentItemMultiSpawned,spawnedItem)
						SetItem(spawnedItem.Tag,spawnedItem.X,spawnedItem.Y,spawnedItem.Z,spawnedItem.Roll,spawnedItem.Pitch,spawnedItem.Yaw)
						selectedItemMulti = spawnedItem
					end
				end
			end
			if(action.name == "despawn_placed_item_multi" and  ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.CanBuild == true) then
				if action.tag ~= nil then
					local pos = Game.GetPlayer():GetWorldPosition()
					local angles = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
					local spawnedItem = {}
					DeleteItem(action.tag)
					if(entity ~= nil) then
						for i =1, #currentSave.arrayPlayerItems do
							local mitem = currentSave.arrayPlayerItems[i]
							if(mitem.Tag == entity.Tag) then
								local housingitem = getHousing(entity.Tag,entity.X,entity.Y,entity.Z)
								despawnItem(entity.entityId)
								deleteHousing(housingitem.Id)
								updatePlayerItemsQuantity(mitem,1)
							end
						end
						else
						debugPrint(1,"nope")
					end
				end
			end
		end
		if not guild_region then
			if(action.name == "open_guild_list" and multiEnabled and multiReady) then
				if(multiEnabled and multiReady) then
					ScrollSpeed = 0.07
					Multi_GuildList()
				end
			end
			if(action.name == "open_guild_pending" and multiEnabled and multiReady) then
				if(multiEnabled and multiReady) then
					Multi_GuildPendingList()
				end
			end
			if(action.name == "open_guild_members" and multiEnabled and multiReady) then
				if(multiEnabled and multiReady) then
					ScrollSpeed = 0.07
					Multi_GuildUserList()
				end
			end
			if(action.name == "open_guild_creation" and multiEnabled and multiReady) then
				if(multiEnabled and multiReady) then
					onlineGuildCreation = true
				end
			end
			
			if(action.name == "open_guild_update" and multiEnabled and multiReady) then
				if(multiEnabled and multiReady) then
					onlineGuildUpdate = true
				end
			end
			
			if(action.name == "select_guild") then
				if(multiEnabled and multiReady ) then
					selectedGuild = action.parameter
				end
			end
			if(action.name == "select_guild_user") then
				if(multiEnabled and multiReady ) then
					selectedGuildUser = action.parameter
				end
			end
			if(action.name == "join_guild") then
				if(multiEnabled and multiReady and selectedGuild ~= nil) then
					joinGuild(mytag,selectedGuild)
				end
			end
			if(action.name == "leave_guild") then
				if(multiEnabled and multiReady and mytag ~= "") then
					leaveGuild(mytag)
				end
			end
			if(action.name == "accept_to_guild") then
				if(multiEnabled and multiReady and selectedGuildUser ~= "") then
					acceptGuild(selectedGuildUser)
				end
			end
			if(action.name == "refuse_to_guild") then
				if(multiEnabled and multiReady and selectedGuildUser ~= "") then
					refuseGuild(selectedGuildUser)
				end
			end
			if(action.name == "remove_to_guild") then
				if(multiEnabled and multiReady and multiName ~= "") then
					removeGuild(selectedGuildUser)
				end
			end
		end
	if not server_player_score_region then
	if(action.name == "operate_server_score" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
	if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
	local score = ActualPlayerMultiData.instance.scores[action.value]
	if(score ~= nil) then
	score = score + action.score
	else
	score = 0 + action.score
	end
	operateInstanceScore(myTag,action.value,score)
	end
	end
	if(action.name == "set_server_score" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
	if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
	local score = ActualPlayerMultiData.instance.scores[action.value]
	if(score ~= nil) then
	score = action.score
	else
	score = action.score
	end
	setInstanceScore(myTag,action.value,score)
	end
	end
	if(action.name == "delete_server_score" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
	if(multiEnabled and multiReady and ActualPlayerMultiData ~= nil and ActualPlayerMultiData.instance ~= nil and ActualPlayerMultiData.instance.scores ~= nil) then
	deleteInstanceScore(myTag,action.value)
	end
	end
	if(action.name == "edit_server_score_user" and multiEnabled and multiReady and  ActualPlayerMultiData ~= nil) then
	editServerScoreUser(action.score,action.value)
	result = true
	end
	end
	end
	
	if framework then
	if(action.name == "download_datapack") then
	arrayDatapack[action.tag] = {}
	arrayDatapack[action.tag].state = "new"
	DownloadModpack(action.value)
	
	end
	if(action.name == "update_datapack") then
	arrayDatapack[action.tag] = {}
	arrayDatapack[action.tag].state = "new"
	UpdateModpack(action.value,action.tag)
	end
	if(action.name == "delete_datapack") then
	DeleteModpack(action.tag)
	end
	if(action.name == "enable_datapack") then
	EnableDatapack(action.tag)
	end
	if(action.name == "disable_datapack") then
	DisableDatapack(action.tag)
	end
	if(action.name == "update_mod") then
	UpdateMods()
	end
	if(action.name == "refresh_news") then
	GetCorpoNews()
	end
	if(action.name == "refresh_market") then
	GetScores()
	end
	if(action.name == "select_stock") then
	CurrentStock = action.value
	debugPrint(1,dump(CurrentStock))
	end
	if(action.name == "buy_score") then
	debugPrint(1,dump(CurrentStock))
	if(CurrentStock ~= nil and checkStackableItemAmount("Items.money",CurrentStock.price)) then
	BuyScore(CurrentStock.tag)
	end
	end
	if(action.name == "sell_score") then
	if(CurrentStock ~= nil and CurrentStock.price ~= nil and CurrentStock.userQuantity ~= nil and CurrentStock.statut ~= 0 and CurrentStock.userQuantity ~= nil and CurrentStock.userQuantity > 0) then
	SellScore(CurrentStock.tag)
	end
	end
	if(action.name == "refresh_item_market") then
	GetItems()
	end
	if(action.name == "buy_cart") then
	if(checkStackableItemAmount("Items.money",CartPrice)) then
	local itemCartTagList = {}
	waiting = true
	for i = 1,#ItemsCart do
	local items = ItemsCart[i]
	table.insert(itemCartTagList,items.Tag)
	updatePlayerItemsQuantity(items,1)
	local player = Game.GetPlayer()
	local ts = Game.GetTransactionSystem()
	local tid = TweakDBID.new("Items.money")
	local itemid = ItemID.new(tid)
	local amount = tonumber(items.Price)
	local result = ts:RemoveItem(player, itemid, amount)
	end
	BuyItemsCart(itemCartTagList)
	ItemsCart = {}
	CartPrice = 0	
	end	
	end
	if(action.name == "add_to_cart") then
	table.insert(ItemsCart,Keystone_currentSelectedItem)
	CartPrice = CartPrice + Keystone_currentSelectedItem.Price
	end
	if(action.name == "remove_to_cart") then
	local res = removeItemInCart(Keystone_currentSelectedItem.tag)
	if(res == true) then
	CartPrice = CartPrice - Keystone_currentSelectedItem.Price
	end
	end
	if(action.name == "select_item_stock") then
	CurrentItemStock = action.value
	end
	if(action.name == "connectUser") then
	connectUser()
	end
	if(action.name == "userversion") then
	setUserVersion()
	end
	if(action.name == "get_datapacklist") then
	GetModpackList()
	end
	if(action.name == "get_branch") then
	GetBranch()
	end
	if(action.name == "get_role") then
	GetRole()
	end
	if(action.name == "fetch_data") then
	FetchData()
	end
	if(action.name == "get_faction") then
	GetFaction()
	end
	if(action.name == "get_possiblebranch") then
	GetPossibleBranch()
	end
	if(action.name == "get_factionrank") then
	GetFactionRank()
	end
	if(action.name == "getitemcat") then
	GetItemCat()
	end
	if(action.name == "get_itemlist") then
	GetItems()
	end
	if(action.name == "get_modversion") then
	GetModVersion()
	end
	end
	
	if scene then 
	if(action.name == "show_braindance_ui") then
	
	if(BraindanceGameController ~= nil) then
	local root = BraindanceGameController.rootWidget 
	
	
	
	root:SetVisible(true)
	
	BraindanceGameController.PlayLibraryAnimation(CName("SHOW"))
	
	
	end
	
	end
	
	if(action.name == "hide_braindance_ui") then
	
	if(BraindanceGameController ~= nil) then
	local root = BraindanceGameController.rootWidget 
	
	
	
	root:SetVisible(false)
	
	
	
	
	end
	
	end
	
	
	if(action.name == "load_scene") then
	
	local scene = arrayScene[action.tag]
	
	if(scene ~= nil) then
	
	currentScene = scene.scene
	currentScene.index = 0
	
	else
	
	error("No scene founded for the tag "..action.tag)
	
	
	end
	
	end
	
	if(action.name == "unload_scene") then
	
	
	
	if(currentScene ~= nil) then
	
	currentScene = nil
	
	
	
	
	end
	end
	
	if(action.name == "play_scene") then
	
	
	
	if(currentScene ~= nil) then
	
	
	
	
	runActionList(currentScene.reset_action, currentScene.tag.."_reset", "interact",false,"scene")
	
	local actionlist = {}
	
	local actiontd = {}
	actiontd.name = "wait_for_trigger"
	actiontd.trigger = {}
	actiontd.trigger.name = "event_is_finished"
	actiontd.trigger.tag = currentScene.tag.."_reset"
	
	table.insert(actionlist,actiontd)
	
	for i=1,#currentScene.init_action do
	
	table.insert(actionlist,currentScene.init_action[i])
	
	end
	
	
	runActionList(actionlist, currentScene.tag.."_init", "interact",false,"scene")
	
	
	actionlist = {}
	
	actiontd = {}
	actiontd.name = "wait_for_trigger"
	actiontd.trigger = {}
	actiontd.trigger.name = "event_is_finished"
	actiontd.trigger.tag = currentScene.tag.."_init"
	
	table.insert(actionlist,actiontd)
	
	for i=1,#currentScene.step do
	
	
	local step = currentScene.step[i]
	
	
	
	for y=1,#step.action do
	
	table.insert(actionlist,step.action[y])
	
	end
	
	end
	
	
	for i=1,#currentScene.end_action do
	
	table.insert(actionlist,currentScene.end_action[i])
	
	end
	
	
	runActionList(actionlist, currentScene.tag.."_full", "interact",false,"scene")
	else
	
	error("No scene loaded")
	
	end
	end
	
	
	if(action.name == "reset_scene") then
	
	
	
	if(currentScene ~= nil) then
	
	
	
	
	runActionList(currentScene.reset_action, currentScene.tag.."_reset", "interact",false,"scene")
	currentScene.index = 0
	
	end
	end
	
	
	if(action.name == "init_scene") then
	
	
	
	if(currentScene ~= nil) then
	
	
	
	
	runActionList(currentScene.init_action, currentScene.tag.."_init", "interact",false,"scene")
	currentScene.index = 0
	else
	
	error("No scene loaded")
	end
	end
	
	if(action.name == "play_scene_step_index") then
	
	
	
	if(currentScene ~= nil) then
	
	
	
	if(currentScene.step[action.value] ~= nil) then
	runActionList(currentScene.step[action.value].action, currentScene.tag.."_"..action.value, "interact",false,"scene")
	currentScene.index = action.value
	end
	
	end
	end
	
	if(action.name == "play_scene_step_by_tag") then
	
	
	
	if(currentScene ~= nil) then
	
	
	for i=1,#currentScene.step do
	if(currentScene.step[i].tag == action.tag) then
	runActionList(currentScene.step[i].action, currentScene.tag.."_"..i, "interact",false,"scene")
	currentScene.index = i
	end
	end
	
	end
	end
	
	if(action.name == "play_next_scene_step") then
	
	
	
	if(currentScene ~= nil) then
	
	
	local index = currentScene.index +1
	
	if(currentScene.step[index] ~= nil) then
	runActionList(currentScene.step[index].action, currentScene.tag.."_"..index, "interact",false,"scene")
	currentScene.index = index
	
	end
	
	end
	end
	
	if(action.name == "play_previous_scene_step") then
	
	
	
	if(currentScene ~= nil) then
	
	
	local index = currentScene.index -1
	
	if(currentScene.step[index] ~= nil) then
	runActionList(currentScene.step[index].action, currentScene.tag.."_"..index, "interact",false,"scene")
	currentScene.index = index
	
	end
	
	end
	end
	
	if(action.name == "spawn_camera") then
	local position = {}
	position.x = action.x
	position.y = action.y
	position.z = action.z
	
	local angle = {}
	angle.roll = action.roll
	angle.pitch = action.pitch
	angle.yaw = action.yaw
	
	spawnCamera(action.tag,action.type,action.entity,position,angle,action.surveillance)
	
	end
	
	if(action.name == "move_camera") then
	local position = {}
	position.x = action.x
	position.y = action.y
	position.z = action.z
	
	local angle = {}
	angle.roll = action.roll
	angle.pitch = action.pitch
	angle.yaw = action.yaw
	
	moveCamera(action.tag,action.type,action.entity,position,angle)
	end
	
	if(action.name == "activate_camera") then
	enableCamera(action.tag)
	end
	
	if(action.name == "delete_camera") then
	stopCamera(action.tag)
	end
	
	
	
	
	
	end
	
	return result
	end																																							