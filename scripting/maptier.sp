// 2023 • Deividas Gedgaudas • github.com/sidicer

#include <sourcemod>
#include <dbi>
#include <morecolors>

// Prepare for database connection
Database g_db;
ConVar g_dbName;

// Additional variables
char g_currentMap[128];
int g_mapTier;

// Plugin info
public Plugin myinfo = {
  name = "Map Tier",
  author = "noil.lt",
  description = "Get current surf map tier",
  version = "0.0.4",
  url = "https://noil.lt/"
};

// Needed for morecolors.inc
public APLRes AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max) {
    MarkNativeAsOptional("GetUserMessageType");
    return APLRes_Success;
} 

public void OnPluginStart() {
  // Generate require ConVars for plugin
  g_dbName = CreateConVar("maptier_database", "default", "In which database to look for 'maps' table");

  // Generate config file if it doesn't exist
  AutoExecConfig(true);

  // Init translations file
  LoadTranslations("maptier.phrases.txt");

  // Register !tier/sm_tier command
  RegConsoleCmd("sm_tier", Command_Tier);

  // Connect to the database
  ConnectToDB();
}

void ConnectToDB() {
  char dbName[128];
  g_dbName.GetString(dbName, sizeof(dbName));
  // Connect to the database
  Database.Connect(DB_OnConnect, dbName);
}

void DB_OnConnect(Database i_db, const char[] error, any data) {
  if (i_db == null || error[0]){
    LogError("[maptier] Connection to the database failed. Error: %s", error);
  }
  // Use database globally
  g_db = i_db;
}

void GetMapTier(Database i_db, char[] i_mapname) {
  char mapTierQuery[100];
  // Prepare MySQL Query and run it storing the result to queryResult
  FormatEx(mapTierQuery, sizeof(mapTierQuery), "SELECT tier FROM maps WHERE mapname = '%s'", i_mapname);
  // Run the query
  i_db.Query(c_GetMapTier, mapTierQuery);
}

public void c_GetMapTier(Database i_db, DBResultSet i_results, const char[] error, any data) {
  if (i_db == null || i_results == null || error[0] != '\0') {
    LogError("[maptier] Query failed! %s", error);
  }

  if (!i_results.FetchRow()) {
    g_mapTier = 0;
  } else {
    g_mapTier = i_results.FetchInt(0);
  }
}

public Action Check_gMapTier(Handle timer, DataPack i_command_arguments) {
  int client, args;
  char i_arg[128];

  i_command_arguments.Reset();
  client = i_command_arguments.ReadCell();
  args = i_command_arguments.ReadCell();
  i_command_arguments.ReadString(i_arg, sizeof(i_arg));

  if (g_mapTier == 0) {
    // If the query returned a 0 that means the map was not found in the database
    MC_PrintToChat(client, "%t", "MapTierNotFound", i_arg);
  }

  if (args >= 1) {
    MC_PrintToChatAll("%t", "CurrentMapTier", i_arg, g_mapTier);
  } else {
    MC_PrintToChatAll("%t", "CurrentMapTier", g_currentMap, g_mapTier);
  }
}

public void OnMapStart() {
  GetCurrentMap(g_currentMap, sizeof(g_currentMap));
}

public Action Command_Tier(int client, int args) {
  char i_arg[128];
  // We only take the first argument as we do not query multiple maps
  GetCmdArg(1, i_arg, sizeof(i_arg));

  // Check if command returned an argument or not
  if (args >= 1) {
    // If the command had an argument - get tier of the provided map
    GetMapTier(g_db, i_arg);
  } else {
    // If the command had no arguments - get the tier of current map
    // Check if GetCurrentMap actually ran after plugin was loaded
    if (IsNullString(g_currentMap)) {
      // If it was not ran GetCurrentMap
      GetCurrentMap(g_currentMap, sizeof(g_currentMap));
    }
    // Get map tier
    GetMapTier(g_db, g_currentMap);
  }

  // Check if the tier was returned
  DataPack command_arguments;
  CreateDataTimer(0.1, Check_gMapTier, command_arguments);
  command_arguments.WriteCell(client);
  command_arguments.WriteCell(args);
  command_arguments.WriteString(i_arg);
  return Plugin_Handled; 
}