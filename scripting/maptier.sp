// 2023 • Deividas Gedgaudas • github.com/sidicer

#include <sourcemod>
#include <dbi>
#include <morecolors>

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max) {
    MarkNativeAsOptional("GetUserMessageType");
    return APLRes_Success;
} 

Database db;
new String:g_mapName[128];
char db_error[255];
int g_mapTier;

public Plugin myinfo =
{
	name = "Map Tier",
	author = "noil.lt",
	description = "Get current surf map tier",
	version = "0.0.1",
	url = "https://noil.lt/"
};

public void OnPluginStart()
{
  LoadTranslations("maptier.phrases.txt");
  RegConsoleCmd("sm_tier", Command_Tier);
  db = SQL_Connect("influx-mysql", true, db_error, sizeof(db_error));
}

public int getMapTier(Database g_db, char[] mapname)
{
  DBResultSet rQuery;
  int tempTier;
  char query[100];
  Format(query, sizeof(query), "SELECT tier FROM maps WHERE mapname = '%s'", mapname);
  if ((rQuery = SQL_Query(g_db, query)) == null)
  {
    return 0;
  }
  
  while (SQL_FetchRow(rQuery))
  {
    tempTier = SQL_FetchInt(rQuery, 0);
  }
  return tempTier;
}

public void OnMapStart()
{
  GetCurrentMap(g_mapName, sizeof(g_mapName));
  g_mapTier = getMapTier(db, g_mapName);
}

public Action Command_Tier(int client, int args)
{
  MC_PrintToChatAll("%t", "CurrentMapTier", g_mapName, g_mapTier);
  return Plugin_Handled;
}