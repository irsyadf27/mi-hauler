Config = {}

Config.BailPrice = 250

Config.Locations = {
    ["main"] = {
        label = "Hauler HQ",
        coords = vector4(454.87, -600.81, 28.55, 114.5),
    },
    ["vehicle"] = {
        model = "packer",
        coords = vector4(466.15, -619.05, 28.5, 178.81),
    },
    ["truckspot"] = {
        [1] = { -- Kayu
            model = "TrailerLogs",
            livery = nil,
            spawn_coords = vector4(-565.32, 5360.58, 70.21, 342.07),
            target_coords = vector3(1205.42, -1287.9, 35.23),
            prize = 160
        },
        [2] = { -- Tanker 1
            model = "Tanker",
            livery = nil,
            spawn_coords = vector4(1721.89, -1653.49, 112.53, 183.85),
            target_coords = vector3(1205.42, -1287.9, 35.23),
            prize = 180
        },
        [3] = { -- Tanker 2
            model = "Tanker2",
            livery = nil,
            spawn_coords = vector4(1685.85, -1542.25, 112.73, 75.45),
            target_coords = vector3(1205.42, -1287.9, 35.23),
            prize = 180
        },
        [4] = { -- Cardealer
            model = "TR4",
            livery = nil,
            spawn_coords = vector4(-137.01, -2417.88, 6.0, 177.59),
            target_coords = vector3(-22.39, -1083.3, 26.63),
            prize = 220
        },
        [5] = { -- Ayam
            model = "Trailers2",
            livery = 2,
            -- spawn_coords = vector4(-602.56, -1216.02, 14.82, 309.58),
            spawn_coords = vector4(-73.69, 6273.46, 31.38, 41.83),
            target_coords = vector3(-602.56, -1216.02, 14.82),
            prize = 320
        }
    }
}