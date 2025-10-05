#!/bin/bash

for averaging in none "harmonic average"; do # arithmetic/geometric/harmonic average
  for nsinkers in 1 4 8  16 ; do
    for viscosity in 1e4 1e6 1e8 1e10; do
      for refinement in 3; do  4 5 6 7
        echo "subsection Material model" > current.prm
        echo "  set Material averaging = $averaging" >> current.prm
        echo "  subsection NSinker" >> current.prm
        echo "    set Number of sinkers = $nsinkers" >> current.prm
        echo "    set Dynamic viscosity ratio = $viscosity" >> current.prm
        echo "  end" >> current.prm
        echo "end" >> current.prm

        echo "subsection Mesh refinement" >> current.prm
        echo "  set Initial global refinement = $refinement" >> current.prm
        echo "end" >> current.prm

	current_model="averaging${averaging}_nsinkers${nsinkers}_viscosity${viscosity}_refinement${refinement}"
        echo "set Output directory = output-${current_model}" >> current.prm
        echo "Starting ${current_model}"
	echo "subsection Solver parameters">>current.prm
	echo "subsection Stokes solver parameters">> current.prm
	echo "set Stokes solver type = block GMG">> current.prm
	echo "end">>current.prm
	echo "end">>current.prm
        cat nsinker.prm current.prm | mpirun -np  32 ./aspect --
      done
    done
  done
done
