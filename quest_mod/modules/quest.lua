debugPrint(3,"CyberMod: quest module loaded")
questMod.module = questMod.module +1


--Main function
function QuestThreadManager()
		--debugPrint(1,getScoreKey("joytoy_quest_radiant","Score"))
	if currentQuest ~= nil and GameUI.IsMenu() == false then
	
	
		possibleQuest = {}
		-- debugPrint(1,"Score quest init")
		-- debugPrint(1,getScoreKey(currentQuest.tag,"Score"))
	
		
			if(getScoreKey(currentQuest.tag,"Score") == 0)then
				setScore(currentQuest.tag,"Score",1)
				--debugPrint(1,"Score quest init")
				end
			
			if(getScoreKey(currentQuest.tag,"Score") == 1)then
				if(canDoTriggerAction) then
					if(DoedTriggerAction == false) then
					DoedTriggerAction = true
					doTriggerAction(currentQuest)
					
					canDoTriggerAction = false
					debugPrint(1,"Quest Trigger ACtion")
					end
					
					
				end
				
			
				
			end
		
		
		if(currentQuest.alreadyStart == true and currentQuest.lastIndex ~= nil) then
		
			runActionList(currentQuest.objectives[currentQuest.lastIndex].resume_action,currentQuest.objectives[currentQuest.lastIndex].tag.."_resume","quest",true,"see_engine")
		
		end
	
		
		if(getScoreKey(currentQuest.tag,"Score") == 2)then
		
		local completedobjective = 0
		local totalobjectivenotoptionnal = 0
		
			for i=1, #currentQuest.objectives do
			
				
					local objectif =  currentQuest.objectives[i]
					
					
				
					
					if(QuestManager.GetObjectiveState(objectif.tag).isActive == true) then
					--debugPrint(1,objectif.tag.." active "..tostring(QuestManager.GetObjectiveState(objectif.tag).isActive))
						
						local result = false
						result = checkTriggerRequirement(objectif.requirement,objectif.trigger)
						--debugPrint(1,objectif.tag.." result "..tostring(result))
					
						
						if(result == true and workerTable[objectif.tag.."_action"] == nil) then
					--	debugPrint(1,objectif.tag.." ACtion")
							
							runActionList(objectif.action,objectif.tag.."_action","quest",true,"see_engine")
							
							QuestManager.MarkObjectiveAsComplete(objectif.tag)
						end
						
						else
							
					end
					
					if(QuestManager.GetObjectiveState(objectif.tag).state == gameJournalEntryState.Succeeded and objectif.isoptionnal == false) then
								completedobjective = completedobjective +1
							
					end
					
					if(objectif.isoptionnal == false) then
						totalobjectivenotoptionnal = totalobjectivenotoptionnal +1
							
					end
					
				
			
			end
			
			if(completedobjective >= totalobjectivenotoptionnal) then
			
				canDoEndAction = true
			
			end
			
	
			if(canDoEndAction) then
			
			if(DoedEndAction == false and canwaitend == false) then
			
			DoedEndAction = true
			
			end
				
				if(DoedEndAction == true) then
					DoedEndAction = false
						
						local action = {}
						action.name = "simple_message"
						action.value =  "Quest Finished : "..currentQuest.title
						table.insert(currentQuest.end_action,action)
						debugPrint(1,"mark5")
						if(currentQuest.isNCPD ~= nil and currentQuest.isNCPD == true ) then
							local action = {}
							action.name = "npcd_finish_notification"
							action.levelXPAwarded = math.random(1,50)
							action.streetCredXPAwarded = math.random(1,50)
							
							table.insert(currentQuest.end_action,action)
						end
						
						doEndAction(currentQuest)
						
					
					
					
						
				end
				
				if(workerTable[currentQuest.tag.."_end"] == nil and canwaitend == true) then
						
							
							closeQuest(currentQuest)
							canDoEndAction = false
							debugPrint(1,"Quest End ACtion")
						
				end
			end
			
			
			if(canDoFailAction) then
			
					if(DoedFailAction == false) then
						DoedFailAction = true
						doFailAction(currentQuest)
						setScore(currentQuest.tag,"Score",0)
						canDoFailAction = false
						debugPrint(1,"Quest Fail ACtion")
					--	closeQuest(currentQuest)
					end
				
					
					
			end
			
			
			if(canDoResetAction) then
			
					if(DoedResetAction == false) then
						resetQuest()
						debugPrint(1,"Quest Reset")
					end
				
					
					
			end
			
			
			-- if(completedobjective == totalobjectivenotoptionnal and QuestManager.GetQuestState(currentQuest.tag).isComplete == true)then
				
				
				-- closeQuest(currentQuest)
				
				
			-- end
	end
	
	
end
end


--Quest States
function startQuest(quest)
	
	print(tostring(QuestManager.GetQuestState(quest.tag).isActive))
	print(tostring(getScoreKey(quest.tag,"Score")))
	
	
	if(QuestManager.GetQuestState(quest.tag).isActive == true) then
		Game.untrack()
		
		currentSave.arrayPlayerData.CurrentQuest = quest.tag

		phonedFixer = false
		haveMission = true
		draw = true
		npcSpawned = false
		npcStarSpawn = false
		canDoTriggerAction = true
		currentQuest = quest
		
		currentQuest.alreadyStart = false
		
		
		for i=1,#quest.objectives do
			local objectif = quest.objectives[i]
			if(QuestManager.GetObjectiveState(objectif.tag).isComplete == true) then
			
				currentQuest.alreadyStart = true
				currentQuest.lastIndex = i
				debugPrint(1,"alreadustart")
				
				
			end
			
		end
		
		if(currentQuest.alreadyStart == true) then
			
			QuestManager.MarkObjectiveAsActive(quest.objectives[currentQuest.lastIndex+1])
		
		end
		
		
		
		
		
			local action = {}
			action.name = "simple_message"
			action.value =  "Starting Quest : "..currentQuest.title
			table.insert(currentQuest.trigger_action,action)
		
			setScore(currentQuest.tag,"Score",0)
	
	end
	
	
end

function TriggerQuest(unlockTagQuest)
	------debugPrint(1,unlockTagQuest)
	if(unlockTagQuest ~= nil and unlockTagQuest ~= "") then
		
		isAlreadyDo = false
		
		local score = getScoreKey(unlockTagQuest,"Score")
			
		if(score ~= nil and score == 3) then
			isAlreadyDo = true
			
		end
					
		
		
		if isAlreadyDo == false then
			
			
			local quest = arrayQuest2[unlockTagQuest].quest
			
			startQuest(quest)
			
			Game.GetPlayer():SetWarningMessage("Mission : " .. quest.Title)
			------debugPrint(1,"Forced Contract" .. quest.Title)
			
			
		end
		
	end
	
	
	
end

function restoreQuestProgression(CurrentQuestStatut)
	debugPrint(1,"resume progression")
	if(CurrentQuestStatut ~= nil and CurrentQuestStatut ~= "nil")then
		
		if(CurrentQuestStatut == 0)then
			canDoTriggerAction = true
			currentQuestStarted = false
			currentQuestFinished = false
			doTriggerAction(currentQuest)
		end
		
		if(CurrentQuestStatut == 1)then
			canDoTriggerAction = false
			currentQuestStarted = true
			currentQuestFinished = true
			doStartAction(currentQuest)
		end
		else
		canDoTriggerAction = true
		currentQuestStarted = false
		currentQuestFinished = false
		
	end
	
end

function untrackQuest()
	if currentQuest ~= nil then
		resetQuest()
	end
end

function resetQuest()
		
	workerTable[currentQuest.tag.."_start"] = nil
	workerTableKey[currentQuest.tag.."_start"] = nil
	
	workerTable[currentQuest.tag.."_trigger"] = nil
	workerTableKey[currentQuest.tag.."_trigger"] = nil
	
	workerTable[currentQuest.tag.."_end"] = nil
	workerTableKey[currentQuest.tag.."_end"] = nil
	
	workerTable[currentQuest.tag.."_fail"] = nil
	workerTableKey[currentQuest.tag.."_fail"] = nil
	
	workerTable[currentQuest.tag.."_reset"] = nil
	workerTableKey[currentQuest.tag.."_reset"] = nil
	
	
	if(currentQuest.reset_action ~= nil) then
	
	runActionList(currentQuest.reset_action,currentQuest.tag.."_reset","quest",false,"see_engine")
	
	
	end
	
	QuestManager.MarkQuestAsActive(currentQuest.tag)
	QuestManager.MarkAllObjectiveOfQuestAs(currentQuest.tag,"Active")
	QuestManager.MarkQuestAsUnVisited(entryId)
	setScore(currentQuest.tag,"Score",0)
	
	
	QuestManager.resetQuestfromJson(currentQuest.tag)
	
	
	currentQuest = nil
	currentQuestStarted = false
	currentQuestFinished = false
	currentQuestFailed = false
	enemySpawned = false
	npcSpawned = false
	npcStarSpawn = false
	haveMission = false
	
	currentSave.arrayPlayerData.CurrentQuest = nil
	currentSave.arrayPlayerData.CurrentQuestStatut = nil
	updatePlayerData(currentSave.arrayPlayerData)
	
	
	canDoTriggerAction = false
	canDoStartAction = false
	canDoEndAction = false
	canDoFailAction = false

	DoedTriggerAction = false
	DoedStartAction = false
	DoedEndAction = false
	DoedFailAction = false
	
	debugPrint(1,"Interrupt quest")
	
end

function closeQuest(quest)
	
	workerTable[quest.tag.."_start"] = nil
	workerTableKey[quest.tag.."_start"] = nil
	
	
	

	QuestManager.UntrackObjective()
	
	QuestManager.MarkQuestASucceeded(quest.tag)
	
	for i=1, #quest.objectives do
		
			QuestManager.MarkObjectiveAsInactive(quest.objectives[i].tag)
			
			workerTableKey[quest.objectives[i].tag.."_action"] = nil
			workerTable[quest.objectives[i].tag.."_action"] = nil
		
	end
	setScore(quest.tag,"Score",3)
	
	if(quest.recurrent ~= nil and quest.recurrent == true) then
	
	QuestManager.resetQuestfromJson(quest.tag)
	setScore(quest.tag,"Score",-1)
	debugPrint(1,"resetjson")
	end
	
	QuestTrackerUI.Reset()
	currentQuest = nil
	currentQuestStarted = false
	currentQuestFinished = false
	currentQuestFailed = false
	enemySpawned = false
	npcSpawned = false
	npcStarSpawn = false
	haveMission = false
	currentSave.arrayPlayerData.CurrentQuest = nil
	currentSave.arrayPlayerData.CurrentQuestStatut = nil
	currentSave.arrayPlayerData.CurrentQuestState = nil
	updatePlayerData(currentSave.arrayPlayerData)
	debugPrint(1,"closed quest")
	canDoTriggerAction = false
	canDoStartAction = false
	canDoEndAction = false
	canDoFailAction = false
	canwaitend = false
	DoedTriggerAction = false
	DoedStartAction = false
	DoedEndAction = false
	DoedFailAction = false
	
	
end


--Trigger Quest and action Quest

function HaveTriggerCondition(quest)
	local result = false
	--testTriggerRequirement(quest.trigger_condition_requirement,quest.trigger_condition)
	result = checkTriggerRequirement(quest.trigger_condition_requirement,quest.trigger_condition)
	----debugPrint(1,askTriggerRequirement(quest.trigger_condition_requirement,quest.trigger_condition))
	if(result)then
		----debugPrint(1,quest.title.." is okk")
	end
	return result
end

function doTriggerAction(quest)
	if(#quest.trigger_action >0)then
		runActionList(quest.trigger_action,quest.tag.."_trigger","quest",false,"see_engine")
	end
	setScore(currentQuest.tag,"Score",2)
end



function HaveStartCondition(quest)
	local result = false
	
	--testTriggerRequirement(quest.start_condition_requirement,quest.start_condition)
	
	result = checkTriggerRequirement(quest.start_condition_requirement,quest.start_condition)
	
	
	
	
	
	return result
end

function doStartAction(quest)
	
	
	runActionList(quest.start_action,quest.tag.."_start","quest",true,"see_engine")

	setScore(currentQuest.tag,"Score",2)
end



function HaveFailCondition(quest)
	--debugPrint(1,"toto")
	local result = false
	--testTriggerRequirement(quest.failure_condition_requirement,quest.failure_condition)
	result = checkTriggerRequirement(quest.failure_condition_requirement,quest.failure_condition)
	return result
end

function HaveEndCondition(quest)
	local result = false
	result = checkTriggerRequirement(quest.end_condition_requirement,quest.end_condition)
	return result
end



function doEndAction(quest)
	
	if(#quest.end_action >0)then
		runActionList(quest.end_action,quest.tag.."_end","quest",false,"see_engine")
	end
	canwaitend = true
	
end

function doFailAction(quest)
	if(#quest.failure_action >0)then
		runActionList(quest.failure_action,quest.tag.."_fail","quest",false,"see_engine")
	end
	
	setScore(currentQuest.tag,"Score",2)
	
end

