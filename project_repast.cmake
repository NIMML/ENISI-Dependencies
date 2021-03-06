if("${BUILD_STEP}" STREQUAL "patch")
  foreach(REPAST_PATCH 
      BaseGrid.h
      Context.h
      DirectedVertex.h
      GridComponents.h
      Point.h
      RepastProcess.h
      SharedBaseGrid.cpp
      SharedBaseGrid.h
      SharedDiscreteSpace.h
      UndirectedVertex.h)

    message(STATUS "Patching: " ${REPAST_DIR}/src/repast_hpc/${REPAST_PATCH})

    execute_process(
        COMMAND patch ${REPAST_DIR}/src/repast_hpc/${REPAST_PATCH} -i ${REPAST_PATCH}.patch
        WORKING_DIRECTORY ${PATCH_DIR}
        OUTPUT_FILE ${LOG_DIR}/repast_patch.log
        ERROR_FILE ${LOG_DIR}/repast_patch_errors.log)

  endforeach(REPAST_PATCH)

  message(STATUS "Patching: " ${REPAST_DIR}/INSTALLATION/install.sh)

  execute_process(
      COMMAND patch ${REPAST_DIR}/INSTALLATION/install.sh -i install.sh.patch
      WORKING_DIRECTORY ${PATCH_DIR}
      OUTPUT_FILE ${LOG_DIR}/repast_patch.log
      ERROR_FILE ${LOG_DIR}/repast_patch_errors.log)
endif()

if("${BUILD_STEP}" STREQUAL "install")
  if (NOT EXISTS .mpich_install_done AND NOT MPI_CXX_COMPILER)
    message(STATUS "Installing MPICH...")
    file(REMOVE_RECURSE ${REPAST_EXT_DIR}/MPICH)
    execute_process(
      COMMAND bash ./install.sh mpich "${INSTALL_PREFIX}"
      WORKING_DIRECTORY ${WORK_DIR}
      OUTPUT_FILE ${LOG_DIR}/mpich_install.log
      ERROR_FILE ${LOG_DIR}/mpich_install_errors.log
    )
    execute_process(COMMAND touch .mpich_install_done)
  endif()

  if (NOT EXISTS .boost_install_done)
    message(STATUS "Installing Boost...")
    file(REMOVE_RECURSE ${REPAST_EXT_DIR}/Boost)
    execute_process(COMMAND bash ./install.sh boost "${INSTALL_PREFIX}" ${MPI_CXX_COMPILER}
      WORKING_DIRECTORY ${WORK_DIR}
      OUTPUT_FILE ${LOG_DIR}/boost_install.log
      ERROR_FILE ${LOG_DIR}/boost_install_errors.log
    )
    execute_process(COMMAND touch .boost_install_done)
  endif()

  if (NOT EXISTS .netcdf_install_done)
    message(STATUS "Installing NetCDF...")
    file(REMOVE_RECURSE ${REPAST_EXT_DIR}/NetCDF)
    execute_process(COMMAND bash ./install.sh netcdf-netcpp "${INSTALL_PREFIX}"
      WORKING_DIRECTORY ${WORK_DIR}
      OUTPUT_FILE ${LOG_DIR}/netcdf_install.log
      ERROR_FILE ${LOG_DIR}/netcdf_install_errors.log
    )
    execute_process(COMMAND touch .netcdf_install_done)
  endif()

  if (NOT EXISTS .curl_install_done)
    message(STATUS "Installing Curl...")
    file(REMOVE_RECURSE ${REPAST_EXT_DIR}/CURL)
    execute_process(COMMAND bash ./install.sh lcurl "${INSTALL_PREFIX}"
      WORKING_DIRECTORY ${WORK_DIR}
      OUTPUT_FILE ${LOG_DIR}/lcurl_install.log
      ERROR_FILE ${LOG_DIR}/lcurl_install_errors.log
    )
    execute_process(COMMAND touch .curl_install_done)
  endif()

  if (NOT EXISTS ${REPAST_DIR}/lib/librepast_hpc-2.0.a)
    message(STATUS "Installing Repast HPC libraries...")
    execute_process(COMMAND bash ./install.sh rhpc "${INSTALL_PREFIX}" "${MPI_CXX_COMPILER}" "${MPI_CXX_LINK_FLAGS}"
      WORKING_DIRECTORY ${WORK_DIR}
      OUTPUT_FILE ${LOG_DIR}/rhpc_install.log
      ERROR_FILE ${LOG_DIR}/rhpc_install_errors.log
    )
  endif()
endif()
