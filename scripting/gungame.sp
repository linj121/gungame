#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
    name = "Gun Game",
    author = "Josh Lin",
    description = "Gain random weapons upon kills",
    version = "0.0.3",
    url = "https://github.com/linj121/gungame"
};

/**
 * 0 -> target both special infected and common infected
 * 1 -> only target special infected
 */
ConVar g_cvarOnlySpecialInfected = null;

public void OnPluginStart()
{
    PrintToServer("[SM] Gun Game has been loaded!");
    HookEvent("player_death", OnPlayerDeath, EventHookMode_Post);

    g_cvarOnlySpecialInfected = CreateConVar("sm_only_sp_infected", "1", "Whether only target special infected or not");
    AutoExecConfig(true, "gungame");
}

void OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    /**
     * Fetched from play_death event
     */
    static char COMMON_INFECTED_NAME[64] = "Infected";

    int is_only_sp_infected = g_cvarOnlySpecialInfected.IntValue;

    /**
     * userid -> player, bot, special infected
     * entityid -> common infected
     */
    // int userid = event.GetInt("userid");
    int entityid = event.GetInt("entityid");
    if(is_only_sp_infected && entityid)
        return;

    /**
     * Infected was killed by a player, not a bot or an entity
     */
    int attacker = event.GetInt("attacker");
    bool attacker_is_bot = event.GetBool("attackerisbot");
    int attacker_entid = event.GetInt("attackerentid");
    if(!attacker || attacker_is_bot || attacker_entid)
        return;

    /**
     * Filter damage type:
     * Docs: https://developer.valvesoftware.com/wiki/Damage_types
     * A damage could be consists of multiple damage types.
     * Use bit-wise AND to detect desired type: https://forums.alliedmods.net/showthread.php?t=244205
     */
    int damage_type = event.GetInt("type");
    if(damage_type & DMG_BURN)
        return;

    int attacker_client_id = GetClientOfUserId(attacker);

    if(!IsClientInGame(attacker_client_id))
        return;

    char victim_name[64];
    event.GetString("victimname", victim_name, sizeof(victim_name));

    if(StrEqual(victim_name, "") || (is_only_sp_infected && StrEqual(victim_name, COMMON_INFECTED_NAME)))
        return;

    char attacker_name[256];
    GetClientName(attacker_client_id, attacker_name, sizeof(attacker_name));

    char weapon_name[64];
    event.GetString("weapon", weapon_name, sizeof(weapon_name));

    PrintToChatAll("[SM] %s killed %s with %s", attacker_name, victim_name, weapon_name);

    static const char weapon_store[][] = {
      // Primary firearms
      "weapon_autoshotgun",      // 10 shells, 90 shells reserve
      "weapon_grenade_launcher", // 1 grenade, 30 grenades reserve
      "weapon_hunting_rifle",    // 15 rounds, 180 rounds reserve
      //   "weapon_pistol",           // 15 rounds (30 if dual-wielded), infinite reserve
      //   "weapon_pistol_magnum",    // 8 rounds, infinite reserve
      "weapon_pumpshotgun",     // 8 shells, 128 shells reserve
      "weapon_rifle",           // 50 rounds, 360 rounds reserve
      "weapon_rifle_ak47",      // 40 rounds, 360 rounds reserve
      "weapon_rifle_desert",    // 60 rounds, 360 rounds reserve
      "weapon_rifle_m60",       // 150 rounds, 0 rounds reserve
      "weapon_rifle_sg552",     // 50 rounds, 360 rounds reserve
      "weapon_shotgun_chrome",  // 8 shells, 56 shells reserve
      "weapon_shotgun_spas",    // 10 shells, 90 shells reserve
      "weapon_smg",             // 50 rounds, 480 rounds reserve
      "weapon_smg_mp5",         // 50 rounds, 650 rounds reserve
      "weapon_smg_silenced",    // 50 rounds, 650 rounds reserve
      "weapon_sniper_awp",      // 20 rounds, 180 rounds reserve
      "weapon_sniper_military", // 30 rounds, 180 rounds reserve
      "weapon_sniper_scout",    // 15 rounds, 195 rounds reserve

      // Melee weapons
      //   "weapon_baseball_bat",
      //   "weapon_cricket_bat",
      //   "weapon_crowbar",
      //   "weapon_electric_guitar",
      //   "weapon_fireaxe",
      //   "weapon_frying_pan",
      //   "weapon_golfclub",
      //   "weapon_katana",
      //   "weapon_machete",
      //   "weapon_tonfa",
      //   "weapon_knife",

      // Special melee
      //   "weapon_chainsaw",

      // Health and utility items
      //   "weapon_adrenaline",
      //   "weapon_defibrillator",
      //   "weapon_first_aid_kit",
      //   "weapon_pain_pills",

      // Explosives and environmental weapons
      //   "weapon_fireworkcrate",
      //   "weapon_gascan",
      //   "weapon_oxygentank",
      //   "weapon_propanetank",

      // Throwable weapons
      //   "weapon_molotov",
      //   "weapon_pipe_bomb",
      //   "weapon_vomitjar",

      // Ammo upgrades
      //   "weapon_ammo_spawn",
      //   "weapon_upgradepack_explosive",
      //   "weapon_upgradepack_incendiary",

      // Miscellaneous
      "weapon_gnome",
      "weapon_cola_bottles"};

    /**
     * Get a random weapon
     */
    int random_weapon_index = GetRandomInt(0, sizeof(weapon_store) - 1);

    /**
     * Give the newly generated weapon to the attacker
     */
    GivePlayerItem(attacker_client_id, weapon_store[random_weapon_index]);

    return;
}