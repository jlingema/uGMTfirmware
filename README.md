uGMTfirmware
============

Firmware for the CMS uGMT.

This repository contains the algorithm part of the CMS uGMT firmware. It has been written for the Imperial MP7, a Virtex-7 based AMC module.

This most probably isn't of use for anyone outside the CMS Level-1 Trigger.

## Instructions for setting up the build environment
This has been tested on SLC6, but no guarantees given for anything.

### Obtaining required sources
Instructions for obtaining the MP7 framework firmware can be found at https://twiki.cern.ch/twiki/bin/viewauth/CMS/MP7FirmwareNews. These should be followed until step 6. 

Following this check out the uGMT algorithms to a directory of your choice. The `uGMT_algos` should either be linked or copied to `cactusupgrades/components/`:

```
cd [mp7framework_directory]/cactusupgrades/components
ln -s [...]/uGMTfirmware/uGMT_algos uGMT_algos
```

### Auto-generating the Vivado project
To automatically generate an Vivado project file the following steps then need to be followed:

1. Add `include -c components/uGMT_algos uGMT_algo.dep` and `addrtab -t mp7_payload.xml` to `cactusupgrades/components/mp7_null_algo/firmware/cfg/mp7_null_algo.dep`
2. Copy `mp7_payload.xml` from `uGMTfirmware` to `cactusupgrades/components/mp7_null_algo/addr_table`
3. Replace the existing payload entry in `cactusupgrades/components/mp7_infra/addr_table/mp7xe_infra.xml` with `<node id="payload" module="file://mp7_payload.xml" address="0x80000000" fwinfo="endpoint"/>`
5. Replace the payload definition with the `ugmt_serdes.vhd` block definition

  ```
  algo : entity work.ugmt_serdes
  generic map (
    NCHAN     => 72,
    VALID_BIT => '1'
    )
  port map (
    clk_ipb => clk_ipb,
    rst     => rst_ipb,
    ipb_in  => ipb_in_payload,
    ipb_out => ipb_out_payload,
    clk240  => clk_p,
    clk40   => clk40,
    d       => payload_d,
    q       => payload_q
    );
  ```
  in the top block. You can find it in `cactusupgrades/boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd`
6. Finally visit the project folder, source the Xilinx environment (if you haven't already) and execute `make project`:

  ```
  cd [mp7framework_directory]/mp7xe_690
  make project
  ```

## Instructions for building the firmware

*Note:* To ensure that the IPbus decoder logic is up-to-date run:
```
make addrtab
cd addrtab
../cactus/trunk/cactusupgrades/scripts/firmware/dep_tree.py -p b ../cactus/trunk/cactusupgrades projects/examples/mp7xe_690 > mkDecode.sh
chmod u+x mkDecode.sh
./mkDecode.sh
```

The provided Makefile then provides the facilities to build the project from the command line:

```
cd [mp7framework_directory]/mp7xe_690
make bitfile
```

The bitfile can then be found in `top/top.runs/impl_1/`. To produce a package containing the address tables run `make package`.
