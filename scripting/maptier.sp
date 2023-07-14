// 2023 • Deividas Gedgaudas • github.com/sidicer

#include <sourcemod>
#include <dbi>
#include <morecolors>

// Prepare for database connection
Database g_db;
char g_dbError[255];

// Additional variables
new String:g_currentMap[128];
int g_mapTier;

// Plugin info
public Plugin myinfo =
{
	name = "Map Tier",
	author = "noil.lt",
	description = "Get current surf map tier",
	version = "0.0.2",
	url = "https://noil.lt/"
};

// Needed for morecolors.inc
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max) {
    MarkNativeAsOptional("GetUserMessageType");
    return APLRes_Success;
} 

public void OnPluginStart()
{
  // Init translations file
  LoadTranslations("maptier.phrases.txt");

  // Register !tier/sm_tier command
  RegConsoleCmd("sm_tier", Command_Tier);

  // Connect to database reusing previous conenection (if there was one)
  g_db = SQL_Connect("influx-mysql", true, g_dbError, sizeof(g_dbError));
}

public int GetMapTier(Database i_db, char[] i_mapname)
{
  DBResultSet queryResult;
  char mapTierQuery[100];
  int tempTier;

  // Prepare MySQL Query and run it storing the result to queryResult
  Format(mapTierQuery, sizeof(mapTierQuery), "SELECT tier FROM maps WHERE mapname = '%s'", i_mapname);
  if ((queryResult = SQL_Query(i_db, mapTierQuery)) == null) { return 0; }
  
  // Loop through the results and store the last one into tempTier which is then returned
  while (SQL_FetchRow(queryResult)) { tempTier = SQL_FetchInt(queryResult, 0); }
  return tempTier;
}

public void OnMapStart()
{
  GetCurrentMap(g_currentMap, sizeof(g_currentMap));
}

public Action Command_Tier(int client, int args)
{
  new String:i_arg[128];
  // We only take the first argument as we do not query multiple maps
  GetCmdArg(1, i_arg, sizeof(i_arg));

  // Check if command returned an argument or not
  if (args >= 1)
  {
    // If the command had an argument - get tier of the provided map
    g_mapTier = GetMapTier(g_db, i_arg);
  }
  else
  {
    // If the command had no arguments - get the tier of current map
    // Check if GetCurrentMap actually ran after plugin was loaded
    if (IsNullString(g_currentMap))
    {
      // If it was not ran GetCurrentMap
      GetCurrentMap(g_currentMap, sizeof(g_currentMap));
    }
    // Get map tier
    g_mapTier = GetMapTier(g_db, g_currentMap);
  }

  // Check if the tier was returned
  if (g_mapTier == 0)
  {
    // If the query returned a 0 that means the map was not found in the database
    MC_PrintToChat(client, "%t", "MapTierNotFound", i_arg);
    return Plugin_Handled; 
  }

  if (args >= 1)
  {
    MC_PrintToChatAll("%t", "CurrentMapTier", i_arg, g_mapTier);
  }
  else
  {
    MC_PrintToChatAll("%t", "CurrentMapTier", g_currentMap, g_mapTier);
  }
  return Plugin_Handled; 
}