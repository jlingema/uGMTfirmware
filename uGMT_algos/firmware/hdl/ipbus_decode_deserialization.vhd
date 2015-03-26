-- Address decode logic for ipbus fabric
-- 
-- This file has been AUTOGENERATED from the address table - do not hand edit
-- 
-- We assume the synthesis tool is clever enough to recognise exclusive conditions
-- in the if statement.
-- 
-- Dave Newbold, February 2011

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package ipbus_decode_deserialization is

  constant IPBUS_SEL_WIDTH: positive := 5; -- Should be enough for now?
  subtype ipbus_sel_t is std_logic_vector(IPBUS_SEL_WIDTH - 1 downto 0);
  function ipbus_sel_deserialization(addr : in std_logic_vector(31 downto 0)) return ipbus_sel_t;

-- START automatically  generated VHDL the Thu Mar 26 14:43:17 2015 
  constant N_SLV_SORT_RANKS_QUAD0: integer := 0;
  constant N_SLV_SORT_RANKS_QUAD1: integer := 1;
  constant N_SLV_SORT_RANKS_QUAD2: integer := 2;
  constant N_SLV_SORT_RANKS_QUAD3: integer := 3;
  constant N_SLV_SORT_RANKS_QUAD4: integer := 4;
  constant N_SLV_SORT_RANKS_QUAD5: integer := 5;
  constant N_SLV_SORT_RANKS_QUAD6: integer := 6;
  constant N_SLV_SORT_RANKS_QUAD7: integer := 7;
  constant N_SLV_SORT_RANKS_QUAD8: integer := 8;
  constant N_SLAVES: integer := 9;
-- END automatically generated VHDL

    
end ipbus_decode_deserialization;

package body ipbus_decode_deserialization is

  function ipbus_sel_deserialization(addr : in std_logic_vector(31 downto 0)) return ipbus_sel_t is
    variable sel: ipbus_sel_t;
  begin

-- START automatically  generated VHDL the Thu Mar 26 14:43:17 2015 
    if    std_match(addr, "-------------0000---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD0, IPBUS_SEL_WIDTH)); -- sort_ranks_quad0 / base 0x00000000 / mask 0x00078000
    elsif std_match(addr, "-------------0001---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD1, IPBUS_SEL_WIDTH)); -- sort_ranks_quad1 / base 0x00008000 / mask 0x00078000
    elsif std_match(addr, "-------------0010---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD2, IPBUS_SEL_WIDTH)); -- sort_ranks_quad2 / base 0x00010000 / mask 0x00078000
    elsif std_match(addr, "-------------0011---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD3, IPBUS_SEL_WIDTH)); -- sort_ranks_quad3 / base 0x00018000 / mask 0x00078000
    elsif std_match(addr, "-------------0100---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD4, IPBUS_SEL_WIDTH)); -- sort_ranks_quad4 / base 0x00020000 / mask 0x00078000
    elsif std_match(addr, "-------------0101---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD5, IPBUS_SEL_WIDTH)); -- sort_ranks_quad5 / base 0x00028000 / mask 0x00078000
    elsif std_match(addr, "-------------0110---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD6, IPBUS_SEL_WIDTH)); -- sort_ranks_quad6 / base 0x00030000 / mask 0x00078000
    elsif std_match(addr, "-------------0111---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD7, IPBUS_SEL_WIDTH)); -- sort_ranks_quad7 / base 0x00038000 / mask 0x00078000
    elsif std_match(addr, "-------------1000---------------") then
      sel := ipbus_sel_t(to_unsigned(N_SLV_SORT_RANKS_QUAD8, IPBUS_SEL_WIDTH)); -- sort_ranks_quad8 / base 0x00040000 / mask 0x00078000
-- END automatically generated VHDL

    else
        sel := ipbus_sel_t(to_unsigned(N_SLAVES, IPBUS_SEL_WIDTH));
    end if;

    return sel;

  end function ipbus_sel_deserialization;

end ipbus_decode_deserialization;

