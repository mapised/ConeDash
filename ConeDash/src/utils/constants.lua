local constants = {}

constants.blockSize = 122
constants.orbDistance = constants.blockSize * 2.5

constants.objectTypes = {
    ["block"] = 1;
    ["spike"] = 2;
    ["pad"] = 3;
    ["orb"] = 4;
    ["portal"] = 5;
}

constants.modes = {
    ["cube"] = 1;
    ["wave"] = 2;
}

return constants