# STM32MP157 WORKSPACE

STM32MP157 WORKSPACE 是一个基于 STM32MP157 的开发环境，旨在为开发者提供一个完整的工具链和资源，以便快速进行应用开发和系统集成。

该工作空间包含了 ST 官方提供的 SDK 和 BSP，以及一些自定义的脚本和项目，帮助开发者更高效地进行开发。

<-*测试案例以 STM32MP157C-DK2 开发板为基础，其他型号开发板可能需要进行适当调整*->

## Quick Start


|                |                                                                              |
|----------------|------------------------------------------------------------------------------|
| **开发环境部署** | [`docs/STM32MP157_DEVELOPENV_SETUP.md`](docs/STM32MP157_DEVELOPENV_SETUP.md) |

## Structure

```
stm32mpu_workspace/
├── ecosystem/                      ← ST 官方目录结构，命名不改           
│   └── developer-package/
│       ├── sdk/                    ← SDK 安装位置
│       └── source/                 ← OpenSTLinux BSP 源码     
├── build/                          ← 编译输出  
├── output/                         ← 编译产物 
├── scripts/                        ← 自定义自动化脚本
├── projects/                       ← 应用项目
├── downloads/                     
├── tmp/                                                           
└── docs/
```
