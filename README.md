# Ascend C++ + Clangd 示例工程

这是一个尝试让 Ascend C++ 在 VSCode 中使用 Clangd 的示例工程，改编自[官方示例](https://gitee.com/ascend/samples/tree/master/operator/ascendc/0_introduction/3_add_kernellaunch/AddKernelInvocationNeo)。

众所周知，昇腾算子文件需要使用[毕昇编译器](https://www.hiascend.com/bisheng)才能正常运行。遗憾的是，华为没有像 NVIDIA 那样，将 CUDA 语法扩展和编译前端提交到上游社区（即 LLVM Project），而是自己维护了一个私有分支（基于 LLVM 15）。

这就使得目前没有一个 IDE 能够很好地正常支持昇腾算子开发，要么没有语法高亮，要么到处标红报错、找不到符号。本项目的目的就是让 VSCode + Clangd 能够正常工作，从而提供语法高亮、代码补全、跳转到定义等功能，提升开发体验。

## 存在的问题

- 由于我目前仅在非昇腾设备上开发，所以没有测试过在昇腾设备上是否能正常工作，并且 `my_build.sh` 只支持编译为 `sim` 模拟器目标（`sim/npu/cpu`）。
- `stub.h` 仅针对不让目前最小实现的 `AddOp` 算子报错而填充，并不完整，可能会导致其他算子报错。需要根据实际需要对其进行修改。

## 使用流程

1. 安装 Ascend CANN Toolkit (Community)。过程不再赘述，总之你应该大概率安装在 `~/Ascend/` 目录下。请保证安装后存在 `~/Ascend/ascend-toolkit/latest` 这样的目录结构；
2. 在 VSCode 中安装 `clangd` 扩展，并卸载与之冲突的 `C/C++` 扩展；
3. 安装 `jq`，在构建脚本中需要用它修改 `.json` 文件。例如 `sudo apt install jq`；
4. 克隆本项目到本地；
5. 打开 `stub.h`，将其中的绝对路径替换为你的本地路径，例如 `/home/zhangsan/Ascend/ascend-toolkit/latest/...`；
6. 执行 `my_build.sh` 脚本，编译项目；
7. 打开 `add_custom.cpp` 文件，检查是否能正常工作。

## 项目结构

```bash
.
├── CMakeLists.txt：CMake 构建文件
├── README.md：本文件
├── add_custom.cpp：自定义算子实现
├── cmake：上游项目的核函数编译配置模板，不用动啦
│   ├── cpu_lib.cmake
│   └── npu_lib.cmake
├── data_utils.h：数据处理工具类，和本项目关系不大
├── main.cpp：主函数，调用自定义算子
├── my_build.sh：编译项目的最小实现，由 run.sh.bak 精简而来
├── run.sh.bak：原项目的编译脚本，包含了很多不必要的探测和配置
└── stub.h：昇腾算子编译器的头文件 stub，为 clangd 提供最小的关键字补全
```