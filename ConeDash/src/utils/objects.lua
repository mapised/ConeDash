local constants = require("src/utils/constants")

return {
    [1] = {
        "Block";
        constants.objectTypes.block;
        {"block", 1, 1};
    },
    [2] = {
        "Spike";
        constants.objectTypes.spike;
        {"spike", 1, 1};
    },
    [3] = {
        "Yellow Orb";
        constants.objectTypes.orb;
        {"yellowOrb", constants.orbTypes.jump, 0.984}
    },
    [4] = {
        "Pink Orb";
        constants.objectTypes.orb;
        {"pinkOrb", constants.orbTypes.jump, 0.706}
    },
    [5] = {
        "Red Orb";
        constants.objectTypes.orb;
        {"redOrb", constants.orbTypes.jump, 1.38}
    },
    [6] = {
        "Yellow Pad";
        constants.objectTypes.pad;
        {"yellowPad", constants.orbTypes.jump, 1.42}
    },
    [7] = {
        "Pink Pad";
        constants.objectTypes.pad;
        {"pinkPad", constants.orbTypes.jump, 0.922}
    },
    [8] = {
        "Red Pad";
        constants.objectTypes.pad;
        {"redPad", constants.orbTypes.jump, 1.88}
    },
    [9] = {
        "Cone";
        constants.objectTypes.spike;
        {"cone", 1, 1}
    },
    [10] = {
        "Slab";
        constants.objectTypes.block;
        {"slab", 1, 0.5}
    },
    [11] = {
        "Short Spike";
        constants.objectTypes.spike;
        {"spike2", 1, 0.5};
    },
    [12] = {
        "Wave Portal";
        constants.objectTypes.portal;
        {"wavePortal", constants.portalTypes.mode, constants.modes.wave}
    },
    [13] = {
        "Cube Portal";
        constants.objectTypes.portal;
        {"cubePortal", constants.portalTypes.mode, constants.modes.cube}
    },
    [14] = {
        "Ship Portal";
        constants.objectTypes.portal;
        {"shipPortal", constants.portalTypes.mode, constants.modes.ship}
    },
    [15] = {
        "Gravity Orb";
        constants.objectTypes.orb;
        {"gravityOrb", constants.orbTypes.gravity}
    },
    [16] = {
        "Gravity Pad";
        constants.objectTypes.pad;
        {"gravityPad", constants.orbTypes.gravity}
    },
    [17] = {
        "Normal Gravity Portal";
        constants.objectTypes.portal;
        {"gravityPortalA", constants.portalTypes.gravity, 1}
    },
    [18] = {
        "Upside Down Portal";
        constants.objectTypes.portal;
        {"gravityPortalB", constants.portalTypes.gravity, -1}
    },
    [19] = {
        "Block 2";
        constants.objectTypes.block;
        {"block2", 1, 1};
    },
    [20] = {
        "Block 3";
        constants.objectTypes.block;
        {"block3", 1, 1};
    },
    [21] = {
        "Block 4";
        constants.objectTypes.block;
        {"block4", 1, 1};
    },
    [22] = {
        "Block 5";
        constants.objectTypes.block;
        {"block5", 1, 1};
    },
    [23] = {
        "Block 6";
        constants.objectTypes.block;
        {"block6", 1, 1};
    },
    [24] = {
        "Block 7";
        constants.objectTypes.block;
        {"block7", 1, 1};
    },
    [25] = {
        "Block 8";
        constants.objectTypes.block;
        {"block8", 1, 1};
    },
    [26] = {
        "Block 9";
        constants.objectTypes.block;
        {"block9", 1, 1};
    },
    [27] = {
        "Slab 2";
        constants.objectTypes.block;
        {"slab2", 1, 0.5}
    },
    [28] = {
        "Slab 3";
        constants.objectTypes.block;
        {"slab3", 1, 0.5}
    },
}
