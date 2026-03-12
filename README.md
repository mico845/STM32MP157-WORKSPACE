# PRJ on STM32MP157F_DK2 

基于 STM32MP157F-DK2 开发板的项目

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
