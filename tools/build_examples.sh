#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPT_DIR/..

EXAMPLES=(declapi depth shadow stencil swapchain texture triangle)
CODE=0

for EX in ${EXAMPLES[*]}
do
    dub build gfx:$EX --compiler=${DC}
    if [ $? -ne 0 ]; then ((CODE++)); fi
done

exit $CODE
