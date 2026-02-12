--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

    ScriptCB_DoFile("ObjectiveConquest")
    ScriptCB_DoFile("setup_teams")
    ScriptCB_DoFile("TFURandom")
    ScriptCB_DoFile("AIHeroSupport")

    --  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\core.lvl")
    
function ScriptPostLoad()	   
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    cp8 = CommandPost:New{name = "cp8"}
    cp9 = CommandPost:New{name = "cp9"}
    cp10 = CommandPost:New{name = "cp10"}
    cp11 = CommandPost:New{name = "cp11"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    conquest:AddCommandPost(cp9)
    conquest:AddCommandPost(cp10)
    conquest:AddCommandPost(cp11)
    
    conquest:Start()

    EnableSPHeroRules()

    if not ScriptCB_InMultiplayer() then    
    	herosupport = AIHeroSupport:New{AIATTHeroHealth = 4000,   AIDEFHeroHealth = 4000, gameMode = "NonConquest",}
    	herosupport:SetHeroClass(ALL, herostrAll)
    	herosupport:SetHeroClass(IMP, herostrEmp)
    	herosupport:AddSpawnCP("cp1","cp1_spawn")    
    	herosupport:AddSpawnCP("cp2","cp2_spawn") 
    	herosupport:AddSpawnCP("cp3","cp3_spawn") 
    	herosupport:AddSpawnCP("cp4","cp4_spawn") 
    	herosupport:AddSpawnCP("cp5","cp5_spawn") 
    	herosupport:AddSpawnCP("cp6","cp6_spawn")
    	herosupport:AddSpawnCP("cp7","cp7_spawn")
    	herosupport:AddSpawnCP("cp8","cp8_spawn")
    	herosupport:AddSpawnCP("cp9","cp9_spawn")
    	herosupport:AddSpawnCP("cp10","cp10_spawn")
    	herosupport:AddSpawnCP("cp11","cp11_spawn")
    	herosupport:Start() 
    else
    end
    
end

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptInit()
    
    ReadDataFile("dc:Load\\ARE.lvl")

    gcwera = math.random(1,4)

    if not ScriptCB_InMultiplayer() then
	bothan = "all_inf_bothan_offline"
	if gcwera < 3 then
		DecideUnitsANH(1, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2)
		allsoldier = "all_inf_soldier_anh"
		allheavy = "all_inf_heavy_anh"
		allmarksman = "all_inf_marksman_anh"
		impsoldier = "imp_inf_soldier_anh"
		impheavy = "imp_inf_heavy_anh"
		impmarksman = "imp_inf_marksman_anh"
		allsupport = "all_inf_honorguard"
		impsupport = "imp_inf_darktrooper_p1"
	elseif gcwera > 2 then
		DecideUnits(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
		allsoldier = "all_inf_soldier"
		allheavy = "all_inf_heavy"
		allmarksman = "all_inf_marksman"
		impsoldier = "imp_inf_soldier"
		impheavy = "imp_inf_heavy"
		impmarksman = "imp_inf_marksman"
		allsupport = "all_inf_durosmerc"
		impsupport = "imp_inf_heavymelee"
	end
    elseif ScriptCB_InMultiplayer() then
	allsoldier = "all_inf_soldier"
	allheavy = "all_inf_heavy"
	allmarksman = "all_inf_marksman"
	impsoldier = "imp_inf_soldier"
	impheavy = "imp_inf_heavy"
	impmarksman = "imp_inf_marksman"
	allsupport = "all_inf_durosmerc"
	impsupport = "imp_inf_heavymelee"
	bothan = "all_inf_bothan"
	herostrAll = "all_hero_kento"
	supportstrAll = "all_inf_clone"
	herostrEmp = "imp_hero_marek"
	supportstrEmp = "imp_inf_commander"
    end

    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2500)
    SetMemoryPoolSize("ParticleTransformer::PositionTr", 1700)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1800)

    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\ingame.lvl")
    ReadDataFile("dc:ingame.lvl")
    ReadDataFile("ingame.lvl")

    SetMaxFlyHeight(-22)
    SetMaxPlayerFlyHeight(-22)

    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\sound\\tes.lvl;tescw")
    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\sound\\bgl.lvl;bglgcw")
    ReadDataFile("sound\\yav.lvl;yav1gcw")
    ReadDataFile("dc:sound\\ARE.lvl")

    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\SIDE\\dark.lvl",
			"all_hero_bail",
			allsoldier,
			allheavy,
			allmarksman,
			"all_inf_moncaleng",
			allsupport,
			bothan,
			impsoldier,
			impmarksman,
			impheavy,
			"imp_inf_gunner",
			impsupport,
			"imp_inf_commando",
			"imp_inf_jumptrooper",
			supportstrAll,
			supportstrEmp)
               
    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\SIDE\\lead.lvl",
			herostrAll,
			herostrEmp)

    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\SIDE\\tfuvehicles.lvl",
			"imp_hover_speederbike")

    ReadDataFile("SIDE\\tur.lvl", 
			"tur_bldg_laser",
			"tur_bldg_beam") 
 
	SetupTeams{
		all = {
			team = ALL,
			units = 32,
			reinforcements = 150,
			soldier	= { allsoldier, 9, 25},
			assault	= { allheavy, 1, 4},
			engineer = { "all_inf_moncaleng", 1, 4},
			sniper	= { allmarksman, 1, 4},
			officer	= { allsupport, 1, 4},
			special	= { bothan, 1, 4},

		},
		imp = {
			team = IMP,
			units = 32,
			reinforcements = 150,
			soldier	= { impsoldier,9, 25},
			assault	= { impheavy, 1, 4},
			engineer = { "imp_inf_gunner", 1, 4},
			sniper	= { impmarksman, 1, 4},
			officer	= { impsupport, 1, 4},
			special	= { "imp_inf_jumptrooper", 1, 4},
		},
	}

    AddUnitClass(IMP, supportstrEmp, 1, 4)
    AddUnitClass(ALL, supportstrAll, 1, 4)
    
    if ScriptCB_InMultiplayer() then
	SetHeroClass(ALL, herostrAll)
	SetHeroClass(IMP, herostrEmp)
    else
    end

    ScriptCB_EnableHeroMusic(0)

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 32)
    SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 300)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 46)
    SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
    SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("RedOmniLight", 296)
    SetMemoryPoolSize("RedShadingState", 80)
    SetMemoryPoolSize("SoldierAnimation", 660)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
    SetMemoryPoolSize("UnitAgent", 128)
    SetMemoryPoolSize("UnitController", 128)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:ARE\\ARE.lvl", "ARE_conquest")
    SetDenseEnvironment("false")

    PlayAnimation("sky_beams")
    -- PlayAnimation("movingheads")

    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("gate_sky_lights",0))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("gate_sky_lights",1))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("gate_sky_lights",2))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("gate_sky_lights",3))

    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("tower_sky_lights",0))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("tower_sky_lights",1))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("tower_sky_lights",2))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("tower_sky_lights",3))

    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",0))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",1))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",2))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",3))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",4))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",5))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",6))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",7))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",8))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",9))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",10))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",11))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",12))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",13))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",14))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",15))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",16))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",17))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",18))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",19))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",20))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",21))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",22))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights",23))

    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",0))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",1))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",2))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",3))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",4))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",5))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",6))
    AttachEffectToMatrix(CreateEffect("sky_light"),GetPathPoint("arena_sky_lights_2",7))

    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_01"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_05"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_09"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_13"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_17"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_21"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_25"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_29"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_33"))

    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_02"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_06"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_10"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_14"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_18"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_22"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_26"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_30"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_34"))

    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_03"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_07"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_11"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_15"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_19"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_23"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_27"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_31"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_35"))

    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_04"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_08"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_12"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_16"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_20"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_24"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_28"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_32"))
    AttachEffectToMatrix(CreateEffect("pinspot_beam_blue"), GetEntityMatrix("parcan_36"))

    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_01"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_05"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_09"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_13"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_17"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_21"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_25"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_29"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_33"))

    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_02"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_06"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_10"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_14"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_18"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_22"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_26"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_30"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_34"))

    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_03"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_07"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_11"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_15"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_19"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_23"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_27"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_31"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_35"))

    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_04"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_08"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_12"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_16"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_20"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_24"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_28"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_32"))
    AttachEffectToMatrix(CreateEffect("pinspot_flare_white"), GetEntityMatrix("parcan_36"))

    SetProperty("turret01", "CurHealth", 800)
    SetProperty("turret02", "CurHealth", 800)
    SetProperty("turret03", "CurHealth", 800)
    SetProperty("turret04", "CurHealth", 800)
    SetProperty("turret05", "CurHealth", 800)
    SetProperty("turret06", "CurHealth", 800)
    SetProperty("turret07", "CurHealth", 800)
    SetProperty("turret08", "CurHealth", 800)
    SetProperty("turret09", "CurHealth", 800)
    SetProperty("turret10", "CurHealth", 800)
    SetProperty("turret11", "CurHealth", 800)
    SetProperty("turret12", "CurHealth", 800)
    SetProperty("turret13", "CurHealth", 800)
    SetProperty("turret14", "CurHealth", 800)
    SetProperty("turret15", "CurHealth", 800)
    SetProperty("turret16", "CurHealth", 800)
    SetProperty("turret17", "CurHealth", 800)
    SetProperty("turret18", "CurHealth", 800)
    SetProperty("turret19", "CurHealth", 800)
    SetProperty("turret20", "CurHealth", 800)
    SetProperty("turret21", "CurHealth", 800)
    SetProperty("turret22", "CurHealth", 800)
    SetProperty("turret23", "CurHealth", 800)
    SetProperty("turret24", "CurHealth", 800)
    SetProperty("turret25", "CurHealth", 800)
    SetProperty("turret26", "CurHealth", 800)
    SetProperty("turret27", "CurHealth", 800)
    SetProperty("turret28", "CurHealth", 800)

    SetProperty("turret29", "CurHealth", 800)
    SetProperty("turret30", "CurHealth", 800)
    SetProperty("turret31", "CurHealth", 800)
    SetProperty("turret32", "CurHealth", 800)

    SetProperty("turret33", "CurHealth", 800)
    SetProperty("turret34", "CurHealth", 800)
    SetProperty("turret35", "CurHealth", 800)
    SetProperty("turret36", "CurHealth", 800)
    SetProperty("turret37", "CurHealth", 800)
    SetProperty("turret38", "CurHealth", 800)
    SetProperty("turret39", "CurHealth", 800)
    SetProperty("turret40", "CurHealth", 800)

    SetClassProperty("imp_hover_speederbike", "WaterEffect", "are_sfx_waterwake_sm")

    SetClassProperty("imp_hover_speederbike", "ImpMusic", "")
    SetClassProperty("imp_hover_speederbike", "AllMusic", "")

    --  Sound

    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)    
    
    -- OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("dc:sound\\ARE.lvl", "are1")
    OpenAudioStream("dc:sound\\are.lvl", "are1")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetAmbientMusic(ALL, 1.0, "are_music",  0,1)
    -- SetAmbientMusic(ALL, 0.8, "all_nab_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.2,"all_nab_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "are_music",  0,1)
    -- SetAmbientMusic(IMP, 0.8, "imp_nab_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.2,"imp_nab_amb_end",    2,1)

    SetVictoryMusic(ALL, "are_victory")
    SetDefeatMusic (ALL, "are_defeat")
    SetVictoryMusic(IMP, "are_victory")
    SetDefeatMusic (IMP, "are_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    --  Opening Satelite Shot
    AddCameraShot(0.180885, 0.008718, -0.982325, 0.047342, -89.209885, -51.902580, -47.551785);

end