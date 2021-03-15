#!/bin/bash
export WORKING_DIR=$PWD
SCRIPTDIR="$(dirname "$(realpath "$0")")"

# copy tests
rsync -a --delete $LAMMPS_TESTING_DIR/tests .

source pyenv/bin/activate




# run tests
export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64:$VIRTUAL_ENV/lib:$LD_LIBRARY_PATH
export LAMMPS_BINARY=${VIRTUAL_ENV}/bin/lmp
export LAMMPS_POTENTIALS="${VIRTUAL_ENV}/share/lammps/potentials"
export LAMMPS_MPI_MODE="openmpi"
export LAMMPS_TEST_MODES="serial"
export LAMMPS_TESTING_NPROC=8

if [ "$HOSTNAME" = atlas2 ]; then
    taskset -pc 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30 $$
fi

lammps_run_tests --processes ${LAMMPS_TESTING_NPROC} tests/test_commands.py tests/test_examples.py

#gcovr -s -x -r ${LAMMPS_DIR}/src --object-directory=${PWD}/build -o build/coverage.xml

deactivate
