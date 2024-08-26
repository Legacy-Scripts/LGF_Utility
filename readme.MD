# LGF_Utility API

![GitHub Downloads](https://img.shields.io/github/downloads/ENT510/LGF_Utility/total?logo=github)
![GitHub Release](https://img.shields.io/github/v/release/ENT510/LGF_Utility?logo=github)

**LGF_Utility** is a versatile library designed to facilitate the development of modules, functions, exports, and UI components within your project. It provides a unified framework for managing various aspects of your application, making it easier to build complex systems and interfaces.

## Features

- **Modular Functionality**: Manage and utilize reusable modules.
- **Exports System**: Share functions and data across different parts of your project.
- **UI Components**: Create and manage user interfaces seamlessly.

## Integration

### Importing via Export

To access **LGF_Utility** functions and data, you can import it using the export system:

```lua
local LGF = exports['LGF_Utility']:UtilityData()
```

Importing Via Module

To include `LGF_Utility` directly in your project, add the following line to your fxmanifest.lua:

```lua
fx_version 'adamant'
game 'gta5'

author 'ENT510'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@LGF_Utility/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}
```
