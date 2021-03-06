#!/bin/bash

# TODO: Add warning to modify path to CACTUSREPO here!

################## MODIFY HERE ##################
CACTUSREPOPATH=/home/scratch/vhdl/uGMT/vivado/prod/1.5.2/
#################################################

PATTERNFILE=ugmt_testfile.dat

vlib sortAndCancel_tb
vmap work sortAndCancel_tb
vcom ../../cgn/mem_libs/blk/blk_mem_gen_v8_2.vhd
vcom -check_synthesis ../../hdl/common/ugmt_constants.vhd
vcom -check_synthesis $CACTUSREPOPATH/cactusupgrades/components/mp7_datapath/firmware/hdl/mp7_data_types.vhd
vcom -check_synthesis ../../hdl/common/GMTTypes_pkg.vhd
vcom -check_synthesis $CACTUSREPOPATH/cactusupgrades/components/ipbus_core/firmware/hdl/ipbus_package.vhd
vcom -check_synthesis ../../hdl/ipbus_decode_sorting.vhd
vcom -check_synthesis $CACTUSREPOPATH/cactusupgrades/components/ipbus_core/firmware/hdl/ipbus_fabric_sel.vhd
vcom -check_synthesis ../../hdl/Sorting/SorterUnit.vhd
vcom -check_synthesis ../../hdl/MatchAndMerge/*
vcom -check_synthesis ../../hdl/GhostBusting/GhostCheckerUnit.vhd
vcom -check_synthesis ../../hdl/ipbus_slaves/ipbus_dpram_dist.vhd
vcom -check_synthesis ../../hdl/ipbus_decode_cancel_out_*.vhd
vcom -check_synthesis ../../hdl/GhostBusting/GhostCheckerUnit_spatialCoords.vhd
vcom -check_synthesis ../../hdl/GhostBusting/WedgeCheckerUnit.vhd
vcom -check_synthesis ../../hdl/GhostBusting/CancelOutUnit_BO_WedgeComp.vhd
vcom -check_synthesis ../../hdl/GhostBusting/CancelOutUnit_BO.vhd
vcom -check_synthesis ../../hdl/GhostBusting/CancelOutUnit_FO_WedgeComp.vhd
vcom -check_synthesis ../../hdl/GhostBusting/CancelOutUnit_FO.vhd
vcom -check_synthesis ../../hdl/GhostBusting/CancelOutUnit_*
vcom -check_synthesis ../../hdl/common/comp10_ge_behavioral.vhd
vcom -check_synthesis ../../hdl/Sorting/Stage0/SortStage0_countWins.vhd
vcom -check_synthesis ../../hdl/Sorting/Stage0/SortStage0_Mux.vhd
vcom -check_synthesis ../../hdl/Sorting/Stage0/SortStage0_behavioral.vhd
vcom -check_synthesis ../../hdl/Sorting/Stage0/HalfSortStage0.vhd
vcom -check_synthesis ../../hdl/Sorting/Stage1/SortStage1_behavioral.vhd
vcom -check_synthesis ../../hdl/Sorting/SortAndCancelUnit.vhd
vcom -check_synthesis ../tb_helpers.vhd
vcom -check_synthesis SortAndCancelUnit_tb.vhd
vmake work > Makefile
ln -s ../../hdl/ipbus_slaves/BrlSingleMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/OvlPosSingleMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/OvlNegSingleMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/FwdPosSingleMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/FwdNegSingleMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/BOPosMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/BONegMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/FOPosMatchQual.dat .
ln -s ../../hdl/ipbus_slaves/FONegMatchQual.dat .
bash update_testfiles.sh
echo "WARNING: Using many_events.txt pattern file. Modify $PATTERNFILE link if other pattern file required."
if [ -f $PATTERNFILE ];
then
    rm -f $PATTERNFILE
fi
ln -s many_events.txt $PATTERNFILE
