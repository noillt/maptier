<div align="center">
  <h1><code>maptier</code></h1>
  <p>
    <strong>Get surf map tier from database (chat/console)</strong>
  </p>
</div>


## Requirements ##
- Sourcemod and Metamod
- MySQL Database connected to the server (`sourcemod/configs/databases.cfg`)
- [morecolors.inc](https://github.com/noillt/SourceMod-IncludeLibrary/raw/master/include/multicolors/morecolors.inc) (For compiling only)

## Setup

1. Grab the latest release from the [release page](https://github.com/noillt/maptier/releases) or  
`git clone https://github.com/noillt/maptier.git`

### Prepare the database
2. Create a new database or choose the one you're already using
3. Import surf map tiers into the database:  
`mysql -u username -p database < maplist.sql`

### Plugin installation ##
1. Place `plugins` and `translations` into `addons/sourcemod/`
2. Set `maptier-db` in `addons/sourcemod/configs/databases.cfg`  
```
"maptier-db"
{
    "driver" "mysql"
    "host" "127.0.0.1"
    "database" ""
    "user" ""
    "pass" ""
}
```
3. Restart the server or type `sm plugins load maptier` in the console to load the plugin.

## Configuration ##
- You can modify the phrases in `addons/sourcemod/translations/maptier.phrases.txt`
- Change which database is used in `addons/sourcemod/configs/databases.cfg` (`maptier-db`)

## Usage ##
```
# In chat:
!tier / !tier <mapname>

# In console
sm_tier / sm_tier <mapname>
```

### Notice
`maplist.sql` is a direct replica of [OuiSURF/Surf_Maps](https://github.com/OuiSURF/Surf_Maps) maintained spreadsheet of all the maps.  
We will be updating `maplist.sql` regurarily to match it  
Current map count: `802`

# Latest changes

## [0.0.6] - 2023-07-16

### Added

- `maplist.sql`
    - surf_seaside

### Changed

- `maplist.sql` - `DROP TABLE IF EXISTS` for easier update
- `maplist.sql`
    - surf_assail `tier 4 -> 5`
    - surf_intra `tier 4 -> 5`
    - surf_undergrowth `tier 2 -> 3`