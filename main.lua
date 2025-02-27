return {
    name = "Tibia",
    author = "Weiwen & Masea",
    version = "1.0",
    description = "RPG Tibia mod.",

    namespace = "tibia",

    path = {
        gfx = "gfx/weiwen/",
        
        mapSave = "sys/lua/sea-framework/app/tibia/saves/"..sea.map.name.. ".lua"
    },

    scripts = {
        "admin",
        "commands",
        "functions",
        "events",
        "init"
    }
}