library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.mp7_data_types.all;
use work.ipbus.all;
use work.ipbus_dpram_dist;

use work.GMTTypes.all;
use work.ugmt_constants.all;

entity eta_index_bits_mem is
  port (
    clk_ipb : in  std_logic;
    rst     : in  std_logic;
    ipb_in  : in  ipb_wbus;
    ipb_out : out ipb_rbus;
    clk     : in  std_logic;
    addr    : in  std_logic_vector(8 downto 0);
    q       : out std_logic_vector(4 downto 0));
end eta_index_bits_mem;

architecture Behavioral of eta_index_bits_mem is
begin
  eta_idx_bits_mem : entity work.ipbus_dpram_dist
    generic map (
      DATA_FILE  => "IdxSelMemEta.dat",
      ADDR_WIDTH => ETA_IXD_MEM_ADDR_WIDTH,
      WORD_WIDTH => ETA_IXD_MEM_WORD_SIZE
      )
    port map (
      clk     => clk_ipb,
      ipb_in  => ipb_in,
      ipb_out => ipb_out,
      rclk    => clk,
      q       => q,
      addr    => addr
      );

end Behavioral;
