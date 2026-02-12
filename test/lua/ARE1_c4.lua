--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

    ScriptCB_DoFile("ObjectiveTDM")
    ScriptCB_DoFile("setup_teams")

    --  Empire Attacking (attacker is always #1)
    local ALL = 1
    local IMP = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\core.lvl")
    
function ScriptPostLoad()	   
    
    TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true, isUberMode = true, uberScoreLimit = 1000}

    TDM:Start()

    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)

    -- EnableSPHeroRules()
    
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

    SetUberMode(1)

    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2500)
    SetMemoryPoolSize("ParticleTransformer::PositionTr", 1600)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 2100)

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
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("dc:sound\\ARE.lvl")

    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\SIDE\\lead.lvl",
			"all_hero_solo",
			"all_hero_colserra",
			"all_hero_lukerotj",
			"all_hero_oldben",
			"all_hero_yoda",
			"all_hero_macewindu",
			"all_hero_shaakti",
			"all_hero_vace",
			"all_hero_kota",
			"imp_hero_fett",
			"imp_hero_vader",
			"imp_hero_maul",
			"imp_hero_bossk",
			"imp_hero_maris",
			"imp_hero_sidious",
			"imp_hero_dengar",
			"imp_hero_ig88",
			"imp_hero_dooku")

    ReadDataFile("SIDE\\tur.lvl", 
			"tur_bldg_laser",
			"tur_bldg_beam") 
 
	SetupTeams{
		hero = {
			team = ALL,
			units = 80,
			reinforcements = -1,
			soldier = { "all_hero_solo",1,15},
			assault = { "all_hero_colserra",   1,15},
			engineer= { "all_hero_lukerotj",   1,15},
			sniper  = { "all_hero_oldben",  1,15},
			officer = { "all_hero_yoda",        1,15},
			special = { "all_hero_macewindu",   1,15},           
		},
	}   

    	SetupTeams{
        	villain = {
            		team = IMP,
			units = 80,
			reinforcements = -1,
			soldier = { "imp_hero_fett",    1,15},
			assault = { "imp_hero_vader",1,15},
			engineer= { "imp_hero_maul", 1,15},
			sniper  = { "imp_hero_bossk", 1,15},
			officer = { "imp_hero_maris",    1,15},
			special = { "imp_hero_sidious", 1,15},
		},
	}
   
    AddUnitClass(ALL, "all_hero_shaakti",   1,15)
    AddUnitClass(ALL, "all_hero_vace",  1,15)
    AddUnitClass(ALL, "all_hero_kota",1,15)
    AddUnitClass(IMP, "imp_hero_ig88",1,15)
    AddUnitClass(IMP, "imp_hero_dengar",1,15)
    AddUnitClass(IMP, "imp_hero_dooku",1,15)

    ScriptCB_EnableHeroMusic(0)

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 96
    SetMemoryPoolSize("Aimer", 60)
    SetMemoryPoolSize("AmmoCounter", 900)
    SetMemoryPoolSize("BaseHint", 320)
    SetMemoryPoolSize("ConnectivityGraphFollower", 150)
    SetMemoryPoolSize("EnergyBar", 900)
    SetMemoryPoolSize("EntityCloth",150)
    SetMemoryPoolSize("EntityDefenseGridTurret", 0)
    SetMemoryPoolSize("EntityDroid", 0)
    SetMemoryPoolSize("EntityFlyer", 15) -- to account for 15 chewbaccas
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 300, 300) -- stupid trickery to actually set lights to 300
    SetMemoryPoolSize("EntityPortableTurret", 0) -- nobody has autoturrets AFAIK - MZ
    SetMemoryPoolSize("EntitySoundStream", 2)
    SetMemoryPoolSize("EntitySoundStatic", 45)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 120)
    SetMemoryPoolSize("MountedTurret", 46)
    SetMemoryPoolSize("Navigator", 182)
    SetMemoryPoolSize("Obstacle", 667)
    SetMemoryPoolSize("Ordnance", 80)	-- not much ordnance going on in the level
    SetMemoryPoolSize("ParticleEmitter", 512)
    SetMemoryPoolSize("ParticleEmitterInfoData", 512)
    SetMemoryPoolSize("PathFollower", 180)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("RedOmniLight", 296)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("SoldierAnimation", 1186)
    SetMemoryPoolSize("TentacleSimulator", 24)
    SetMemoryPoolSize("TreeGridStack", 290)
    SetMemoryPoolSize("UnitAgent", 182)
    SetMemoryPoolSize("UnitController", 182)
    SetMemoryPoolSize("Weapon", 900)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:ARE\\ARE.lvl", "ARE_hero_xl")
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

    --  Sound

    ScriptCB_EnableHeroVO(0)

    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)    
    
    -- OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("dc:sound\\ARE.lvl", "are1")
    OpenAudioStream("dc:sound\\ARE.lvl", "are1")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Allleaving")
    SetOutOfBoundsVoiceOver(2, "Impleaving")

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