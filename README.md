<div align="center">
  <h1><code>maptier</code></h1>
  <p>
    <strong>Outputs current map`s surf tier in chat</strong>
  </p>
</div>


## Requirements ##
- Sourcemod and Metamod
- MySQL Database connected to the server (`sourcemod/configs/databases.cfg`)
- [morecolors.inc](https://github.com/noillt/SourceMod-IncludeLibrary/raw/master/include/multicolors/morecolors.inc) (For compiling only)

## Preparing database
1. Create a database or choose the one you're already using
2. `mysql -u username -p database < maplist.sql`

## Plugin installation ##
1. Grab the latest release from the release page and unzip it in your sourcemod folder.
2. Restart the server or type `sm plugins load maptier` in the console to load the plugin.
3. The config file will be automatically generated in cfg/sourcemod/

## Configuration ##
- You can modify the phrases in addons/sourcemod/translations/maptier.phrases.txt.

## Usage ##
`!tier` in chat or `sm_tier` in console