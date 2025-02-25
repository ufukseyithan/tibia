return {
    name = "Tibia",
    author = "Weiwen & Masea",
    version = "1.0",
    description = "RPG Tibia mod.",

    namespace = "tibia",

    path = {
        gfx = "gfx/weiwen/",
        
        saves = "sys/lua/sea-framework/app/tibia/saves/",
    },

    scripts = {
        "admin",
        "commands",
        "functions",
        "events",
        "init"
    }
}