-- recursively merges the second given table into the first given table
function MergeTables( mission, newFlags )
	--for each table entry,
	local array = type({})
	for key,value in pairs(newFlags) do
		--check for nested tables
		if type(value) == array then
			--mission must have this key as a table too
			if type(mission[key]) ~= array then
				mission[key] = {}
			end
			--merge these two tables recursively
			MergeTables(mission[key], value)
		else
			--the key is a simple variable, so simply store it
			mission[key] = value
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--Search through the missionlist to find a map that matches mapName,
--then insert the new flags into said entry.
--Use this when you know the map already exists, but this content patch is just
--adding new gamemodes (otherwise you should just add whole new entries to the missionlist)
-----------------------------------------------------------------------------------------------------------

function AddNewGameModes(missionList, mapName, newFlags)
	for i, mission in missionList do
		if mission.mapluafile == mapName then
			MergeTables(mission, newFlags)
		end
	end
end

--------------------------------------------------------------------------
-- functionality to add strings 
if( modStringTable == nil ) then
	modStringTable = {} -- table to hold custom strings 
	
	-- function to add custom strings  
	function addModString(stringId, content)
		modStringTable[stringId] = ScriptCB_tounicode(content)
	end 

	if oldScriptCB_getlocalizestr == nil then 
		-- Overwrite 'ScriptCB_getlocalizestr()' to first check for the strings we added
		print("redefine: ScriptCB_getlocalizestr() ")

		oldScriptCB_getlocalizestr = ScriptCB_getlocalizestr
		ScriptCB_getlocalizestr = function (...)
			local stringId = " "
			if( table.getn(arg) > 0 ) then 
				stringId = arg[1]
			end
			if( modStringTable[stringId] ~= nil) then -- first check 'our' strings
				retVal = modStringTable[stringId]
			else 
				retVal = oldScriptCB_getlocalizestr( unpack(arg) )
			end 
			return retVal 
		end
	end 
end

-- Force 'IFText_fnSetString' to use strings from our 'modStringTable' too 
if ( oldIFText_fnSetString == nil )then 
    oldIFText_fnSetString = IFText_fnSetString
    IFText_fnSetString = function(...)
        if( table.getn(arg) > 1 and modStringTable[arg[2]] ~= nil ) then 
            arg[2] = modStringTable[arg[2]]
            IFText_fnSetUString(unpack(arg))
            return 
        end 
        oldIFText_fnSetString(unpack(arg))
    end 
end 

addModString("mapname.name.ARE", "Gametoast Arena")
addModString("mapname.description.ARE", " FelipeGabe's Gametoast Arena (XBOX port by BAD_AL) Find the PC version on moddb" )

--insert totally new maps here:

local newEntry = { 	
		red = 64, green = 64, blue = 225, isModLevel = 1, 
		mapluafile = "ARE%s_%s",  era_g = 1,        era_c = 1,         mode_con_g = 1,     mode_con_c  = 1,  mode_ctf_g = 1,  
		                          mode_ctf_c  = 1,  mode_1flag_g = 1,  mode_1flag_c  = 1,  mode_eli_g = 1, 
		--mode_xl_c = 1, mode_xl_g = 1, 
		mode_c4_g = 1 
}
table.insert(sp_missionselect_listbox_contents, newEntry)
table.insert(mp_missionselect_listbox_contents, newEntry)

AddNewGameModes( 
	sp_missionselect_listbox_contents, 
	"ARE%s_%s", 
	{
		era_g = 1, 
		mode_c4_g = 1, 
		change = { 
			mode_c4 = { name="Hero XL", icon="mode_icon_XL", about="A massive clash between heroes and villains!" },
		},
	}
)

AddNewGameModes( 
	mp_missionselect_listbox_contents, 
	"ARE%s_%s", 
	{
		era_g = 1, 
		mode_c4_g = 1,
		change = { 
			mode_c4 = { name="Hero XL", icon="mode_icon_XL", about="A massive clash between heroes and villains!" },
		},
	}
)

-- MAVERITCHELL'S DARK TIMES II: RISING SON ----------------------------------------------------------------------

if ScriptCB_IsFileExist("..\\..\\addon\\BDT\\data\\_LVL_PC\\dtshell.lvl") == 1 then
    print("addme.ARE: Dark Times II: Rising Son is installed! Adding missions...")
    ReadDataFile("..\\..\\addon\\BDT\\data\\_LVL_PC\\dtshell.lvl")
    AddNewGameModes(
	sp_missionselect_listbox_contents, 
	"ARE%s_%s", 
	{
		era_1 = 1, 
		mode_con_1 = 1,
		mode_ctf_1 = 1,
		mode_1flag_1 = 1,
		mode_eli_1 = 1,
		mode_xl_1 = 1,
		mode_c4_1 = 1,
		change = { 
			era_1 =	{ name="Dark Times", icon2="darktimes_icon" },
		},
	}
    )
	
    AddNewGameModes( 
	mp_missionselect_listbox_contents, 
	"ARE%s_%s", 
	{
		era_1 = 1, 
		mode_con_1 = 1,
		mode_ctf_1 = 1,
		mode_1flag_1 = 1,
		mode_eli_1 = 1,
		mode_xl_1 = 1,
		mode_c4_1 = 1,
		change = { 
			era_1 = { name="Dark Times", icon2="darktimes_icon" },
		},
	}
    )
else
    print("addme.ARE: Dark Times II: Rising Son is not installed! Continuing...")
end

-- ARCCOMMANDER'S BATTLEFRONT EXTREME 2.2 ----------------------------------------------------------------------

if ScriptCB_IsFileExist("..\\..\\addon\\BFX\\addme.script") == 1 then
    print("addme.ARE: Battlefront Extreme is installed! Adding missions...")
    AddNewGameModes( 
	sp_missionselect_listbox_contents, 
	"ARE%s_%s", 
	{
		era_a = 1, 
		era_b = 1, 
		mode_con_a = 1, 
		mode_con_b = 1, 
		mode_ctf_a = 1, 
		mode_ctf_b = 1, 
		mode_1flag_a = 1, 
		mode_1flag_b = 1, 
		mode_eli_b = 1, 
		mode_xl_a = 1, 
		mode_xl_b = 1, 
		mode_c4_b = 1, 
	}
    )
	
    AddNewGameModes( 
	mp_missionselect_listbox_contents, 
	"ARE%s_%s", 
	{
		era_a = 1, 
		era_b = 1, 
		mode_con_a = 1, 
		mode_con_b = 1, 
		mode_ctf_a = 1, 
		mode_ctf_b = 1, 
		mode_1flag_a = 1, 
		mode_1flag_b = 1, 
		mode_eli_b = 1, 
		mode_xl_a = 1, 
		mode_xl_b = 1, 
		mode_c4_b = 1, 
	}
    )
else
    print("addme.ARE: Battlefront Extreme is not installed! Continuing...")
end

-----------------------------------------------------------------------------------------------------------
-- associate this mission name with the current downloadable content directory
-- (this tells the engine which maps are downloaded, so you need to include all new mission lua's here)
-- first arg: mapluafile from above
-- second arg: mission script name
-- third arg: level memory modifier.  the arg to LuaScript.cpp: DEFAULT_MODEL_MEMORY_PLUS(x)
-----------------------------------------------------------------------------------------------------------

if( ScriptCB_GetPlatform() == "PC" ) then 
	AddDownloadableContent("ARE","AREg_con",4)
	AddDownloadableContent("ARE","AREc_con",4)
	AddDownloadableContent("ARE","AREg_ctf",4)
	AddDownloadableContent("ARE","AREc_ctf",4)
	AddDownloadableContent("ARE","AREg_1flag",4)
	AddDownloadableContent("ARE","AREc_1flag",4)
	AddDownloadableContent("ARE","AREg_eli",4)
	AddDownloadableContent("ARE","AREc_xl",4)
	AddDownloadableContent("ARE","AREg_xl",4)
	AddDownloadableContent("ARE","AREg_c4",4)

	if ScriptCB_IsFileExist("..\\..\\addon\\BDT\\data\\_LVL_PC\\dtshell.lvl") == 1 then
		AddDownloadableContent("ARE","ARE1_con",4)
		AddDownloadableContent("ARE","ARE1_ctf",4)
		AddDownloadableContent("ARE","ARE1_1flag",4)
		AddDownloadableContent("ARE","ARE1_eli",4)
		AddDownloadableContent("ARE","ARE1_xl",4)
		AddDownloadableContent("ARE","ARE1_c4",4)
	end

	if ScriptCB_IsFileExist("..\\..\\addon\\BFX\\addme.script") == 1 then
		AddDownloadableContent("ARE","AREa_con",4)
		AddDownloadableContent("ARE","AREb_con",4)
		AddDownloadableContent("ARE","AREa_ctf",4)
		AddDownloadableContent("ARE","AREb_ctf",4)
		AddDownloadableContent("ARE","AREa_1flag",4)
		AddDownloadableContent("ARE","AREb_1flag",4)
		AddDownloadableContent("ARE","AREb_eli",4)
		AddDownloadableContent("ARE","AREa_xl",4)
		AddDownloadableContent("ARE","AREb_xl",4)
		AddDownloadableContent("ARE","AREb_c4",4)
	end
	
	-- Now load our core.lvl into the shell to add our localize keys
	ReadDataFile("..\\..\\addon\\ARE\\data\\_LVL_PC\\core.lvl")
end
