# STM32MP157 Development Workspace

**Board**: `STM32MP157F-DK2` | **Ecosystem**: `v6.2.0` | **Host**: `Ubuntu 22.04 (WSL2)`

## Quick Start

### Flash the Starter Package on the board


**Starter Package** 需要使用 ST 官方提供的工具 [*STM32CubeProgrammer*](https://www.st.com/en/development-tools/stm32cubeprog.html) 来烧录

这里 `Open File` 选择为 `FlashLayout_sdcard_stm32mp157f-dk2-opteemin.tsv`

参考官网 WiKi：
- [Downloading the Starter Package and flashing it on the board](https://wiki.st.com/stm32mpu/wiki/STM32MP15_Discovery_kits_-_Starter_Package)

### Host computer configuration

- Packages required by OpenEmbedded/Yocto

```bash
sudo apt update
sudo apt install gawk wget git git-lfs diffstat unzip texinfo gcc-multilib  chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libsdl1.2-dev pylint xterm bsdmainutils libusb-1.0-0 bison flex
sudo apt install libssl-dev libgmp-dev libmpc-dev lz4 zstd
sudo apt install libegl1-mesa
```


- Packages needed for some "Developer Package" use cases
  
```bash
sudo apt install build-essential libncurses-dev libyaml-dev libssl-dev
```


- Useful tools
  
```bash
sudo apt install coreutils bsdmainutils sed curl bc lrzsz corkscrew cvs subversion mercurial nfs-common nfs-kernel-server libarchive-zip-perl dos2unix texi2html libxml2-utils
```

- Additional configurations have to be installed to support up to 16 partitions per MMC. By default, on Linux® systems, a maximum of 8 partitions are allowed on MMC. All Packages (Starter Package, ...) need more than 10 partitions for the storage device. In order to extend the number of partitions per device to 16, the following options must be added to modprobe:


```bash
echo 'options mmc_block perdev_minors=16' > /tmp/mmc_block.conf
sudo mv /tmp/mmc_block.conf /etc/modprobe.d/mmc_block.conf
```

### Install the SDK

这里编写了 `scripts/install_sdk.sh` 脚本来自动化安装 SDK，执行以下命令即可：

```bash
./scripts/install_sdk.sh
```

### Start the SDK up
  
使用脚本 `scripts/setup_env.sh` 来加载环境变量（包含 SDK 和后续命令或脚本用到的环境变量），执行以下命令（ **每次开终端** ）：
  
```bash
source scripts/setup_env.sh                # 加载环境（每次开终端）
```

## Develop

### Install the OpenSTLinux BSP packages

- 以该工程文件结构来组织源码

```bash
mkdir -p "${MPU_TMP_DIR}"
tar xvf "${MPU_DOWNLOADS_DIR}/SOURCES-stm32mp-openstlinux-6.6-yocto-scarthgap-mpu-v26.02.18.tar.gz" -C "${MPU_TMP_DIR}"
mkdir -p "${MPU_SOURCE_DIR}"
cp -a "${MPU_TMP_DIR}/stm32mp-openstlinux-6.6-yocto-scarthgap-mpu-v26.02.18/sources/ostl-linux/." "${MPU_SOURCE_DIR}"
```

### Deploy the OpensSTLinux BSP packages using SDK-info utilities

- 生成脚本文件（ `stm32mp1` ）

```bash
cd "${MPU_SOURCE_DIR}"
sdk-infos-1.1-r0/generated_build_script-stm32mpx.sh stm32mp1
```

- 配置脚本的参数

```bash
vi sdk_compilation-stm32mp1-my-custom-board.sh 
```

- 以 `STM32MP157F-DK2` 为例：

```bash
sdk_absolute_path="${MPU_SDK_DIR}"
sdk_env_file="environment-setup-cortexa7t2hf-neon-vfpv4-ostl-linux-gnueabi"
your_board_name="stm32mp157f-dk2"
your_soc_name="stm32mp15"
your_storage_boot_scheme_security="opteemin"
your_storage_boot_scheme_cortex_a="opteemin-sdcard"
your_deploy_dir_path="${MPU_DEPLOY_DIR}"
your_build_subdir_path="${MPU_BUILD_DIR}"
PARALLEL_MAKE=-j10
externaldt_path=
```

- 解压源码（第一次必须执行）

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh extract
```

- 编译 FIP 相关组件（optee + u-boot + tf-a）
- 部署并打包 FIP

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh compile-for-fip
./sdk_compilation-stm32mp1-my-custom-board.sh deploy-for-fip
```

- 生成 programmer（刷机）版本 boot artifacts

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh programmer
```

- 编译并部署 Linux® 内核（uImage/dtb/modules）

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh linux-stm32mp
 ```

- 编译并部署 GPU 驱动模块

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh gcnano-driver-stm32mp
 ```

- 清理所有编译产物（包括 FIP、boot artifacts、内核、模块等）：

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh clean
```

- 清理特定组件的编译产物（如 FIP、内核、模块等）：

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh <component-name>-clean
```

- 获得更多帮助：
```bash
./sdk_compilation-stm32mp1-my-custom-board.sh help
```

### Deploy kernel to board

- 确保已编译并部署了内核相关组件（uImage、dtb、modules）到 `${MPU_DEPLOY_DIR}/kernel` 目录下
```bash
./sdk_compilation-stm32mp1-my-custom-board.sh linux-stm32mp-configure
./sdk_compilation-stm32mp1-my-custom-board.sh linux-stm32mp-compile
./sdk_compilation-stm32mp1-my-custom-board.sh linux-stm32mp-deploy
```

- 部署 uImage 和 dtb 到主板

```bash
scp "${MPU_DEPLOY_DIR}/kernel/uImage" "${MPU_TARGET_USER}"@"${MPU_TARGET_IP}":/boot
scp "${MPU_DEPLOY_DIR}/kernel/stm32mp157f-dk2.dtb" "${MPU_TARGET_USER}"@"${MPU_TARGET_IP}":/boot
```

- 同步内核模块到主板

```bash
scp -r "${MPU_DEPLOY_DIR}/kernel/modules/lib" "${MPU_TARGET_USER}"@"${MPU_TARGET_IP}":/lib
```

- 主板执行以下命令来更新内核模块依赖并重启系统：

```bash
Board $> depmod -a
Board $> sync
Board $> reboot
```


### Modify the kernel source code

- 主板检查显示驱动时是否没有日志信息

```bash
Board $> dmesg | grep -i modified
Board $> 
```

- 修改 Linux® 源码

```bash
cd "${MPU_SOURCE_DIR}/linux-stm32mp-6.6.116-stm32mp-r3-r0/linux-6.6.116"
```

- 编辑 `./drivers/pinctrl/stm32/pinctrl-stm32.c` 源文件
- 在 `stm32_pctl_probe` 函数中添加日志信息如下

```c
int stm32_pctl_probe(struct platform_device *pdev)
{
   [...]
   dev_info(dev, "Pinctrl STM32 initialized\n");
   dev_info(dev, "I modified a linux kernel device driver\n"); //  <- 添加
   [...]
}
```

- 保存文件
- 重建 Linux® 内核

```bash
./sdk_compilation-stm32mp1-my-custom-board.sh linux-stm32mp-images
```

- 部署 uImage 到主板

```bash
scp "${MPU_BUILD_DIR}/arch/${ARCH}/boot/uImage" "${MPU_TARGET_USER}"@"${MPU_TARGET_IP}":/boot
```

- 重启主板

```bash
Board $> reboot
```

- 检查当前显示驱动时是否存在日志信息

```bash
Board $> dmesg | grep -i modified
[    2.518298] stm32mp157-pinctrl soc:pinctrl@50002000: I modified a linux kernel device driver
[    2.524513] stm32mp157-pinctrl soc:pinctrl@54004000: I modified a linux kernel device driver 
```


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


## References
- [STM32MP157x-DK2](https://wiki.st.com/stm32mpu/wiki/Getting_started/STM32MP1_boards/STM32MP157x-DK2%20)
- [STM32MP15 Starter Package](https://wiki.st.com/stm32mpu/wiki/STM32MP15_Discovery_kits_-_Starter_Package)
- [STM32MPU Developer Package](https://wiki.st.com/stm32mpu/wiki/STM32MPU_Developer_Package)
