PROJECT_DIR=$(realpath $(dirname $0))
readonly PROJECT_DIR

pushd $PROJECT_DIR || exit 1

readonly TILING_HEADER="./op_host/scatter_reduce_custom_tiling.h"

bear intercept -- bash build.sh
bear citnames --input events.json --output compile_commands_1.json
jq --compact-output 'select((.started.execution.executable | strings | test("bisheng")) and (.started.execution.arguments // [] | any(. == "-includestdio.h")))' events.json > kernel_events.json
jq --compact-output 'select(any(.started.execution.arguments[]; endswith(".cpp"))) | {arguments: .started.execution.arguments, directory: .started.execution.working_dir, file: (first(.started.execution.arguments[] | select(endswith(".cpp"))) | split("/") | last | "'"${PROJECT_DIR}/op_kernel/"'" + .)} | [.]' kernel_events.json > compile_commands_2.json

jq --slurp '.[0] + .[1]' compile_commands_1.json compile_commands_2.json > compile_commands.json

rm compile_commands_1.json compile_commands_2.json events.json kernel_events.json ./op_kernel/stub_tiling.h

python ./cmake/util/tiling_data_def_build.py ${TILING_HEADER} ./op_kernel/stub_tiling.h

popd || exit 1