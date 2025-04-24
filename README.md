# Ascend C++ 工程模板 + Clangd 

这是一个尝试让 Ascend C++ 在 VSCode 中使用 Clangd 的示例工程。

与 main 分支不同，本分支介绍的是结合[自定义算子工程](https://www.hiascend.com/document/detail/zh/CANNCommunityEdition/81RC1alpha002/devguide/opdevg/ascendcopdevg/atlas_ascendc_10_0006.html)的开发方式。这种方式实际上是华为目前推荐的。

## 使用流程

1. 安装 Ascend CANN Toolkit (Community)。过程不再赘述，总之你应该大概率安装在 `~/Ascend/` 目录下；
2. 在 VSCode 中安装 `clangd` 扩展，并卸载与之冲突的 `C/C++` 扩展；
3. 安装 `jq`，在构建脚本中需要用它修改 `.json` 文件。例如 `sudo apt install jq`；
4. 安装 `bear`，在构建脚本中需要用它追踪和生成 `compile_commands.json` 文件。例如 `sudo apt install bear`；
5. 正常按照[官方介绍](https://www.hiascend.com/document/detail/zh/CANNCommunityEdition/81RC1alpha002/devguide/opdevg/ascendcopdevg/atlas_ascendc_10_0006.html)，创建一个新工程；
6. 将本项目中的文件添加到你创建的工程中，添加位置和说明见下；
7. 打开 `stub.h`，将其中的绝对路径替换为你的本地路径，例如 `/home/zhangsan/Ascend/ascend-toolkit/latest/...`；
8. 执行 `gencompile_commands.sh` 脚本，编译项目；
9. 打开 `op_kernel/{算子名}_custom.cpp` 文件，在最前面导入 `stub.h`，例如 `#include "stub.h"`。检查代码提示是否正常工作。

## 项目结构

```bash
.
├── .clangd：.clangd 配置文件，用于让 clangd 适应 bishang 编译器的怪癖。放在项目根目录下；
├── gencompile_commands.sh：用于生成给 clangd 用的 compile_commands.json 的脚本，每次修改 tiling.h 后需要重新执行。放在项目根目录下；
└── stub.h：昇腾算子编译器的头文件 stub，为 clangd 提供最小的关键字补全。放在 op_kernel 目录下；
```