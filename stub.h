#pragma once

#ifdef __CLANGD__
// For pipe_t and other common definitions
#include "/home/w568w/Packages/cann/home/Ascend/ascend-toolkit/latest/x86_64-linux/ccec_compiler/lib/clang/15.0.5/include/cce_aicore_intrinsics.h"

// Dummy definitions for AscendC
#define __aicore__
#define __global__
#define __gm__
#define __ubuf__
#define __sync_alias__
#define __inout_pipe__(...)
#define __in_pipe__(...)
#define __out_pipe__(...)
#define __check_sync_alias__
typedef _Float16 half;

// Dummy definitions for clangd's CUDA extensions
int cudaConfigureCall(...);
#endif