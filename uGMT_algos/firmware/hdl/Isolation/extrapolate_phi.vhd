library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.mp7_data_types.all;
use work.ipbus.all;
use work.ipbus_decode_extrapolation_phi.all;

use work.GMTTypes.all;

entity extrapolate_phi is
  generic (
  	DATA_FILE: string
      );
  port (
    clk_ipb                  : in  std_logic;
    rst                      : in  std_logic;
    ipb_in                   : in  ipb_wbus;
    ipb_out                  : out ipb_rbus;
    clk                      : in  std_logic;
    iPhiExtrapolationAddress : in  TPhiExtrapolationAddress(35 downto 0);
    oDeltaPhi                : out TDelta_vector(35 downto 0)
    );
end extrapolate_phi;

architecture Behavioral of extrapolate_phi is

  signal ipbusWe_vector : std_logic_vector(iPhiExtrapolationAddress'range);

  signal ipbw : ipb_wbus_array(N_SLAVES-1 downto 0);
  signal ipbr : ipb_rbus_array(N_SLAVES-1 downto 0);

  signal sLutOutput : TLutBuf(iPhiExtrapolationAddress'range);

begin

    -- IPbus address decode
    fabric : entity work.ipbus_fabric_sel
      generic map(
        NSLV      => N_SLAVES,
        SEL_WIDTH => IPBUS_SEL_WIDTH
        )
      port map(
        ipb_in          => ipb_in,
        ipb_out         => ipb_out,
        sel             => ipbus_sel_extrapolation_phi(ipb_in.ipb_addr),
        ipb_to_slaves   => ipbw,
        ipb_from_slaves => ipbr
        );


  extrapolation : for i in iPhiExtrapolationAddress'range generate
    -- ipbusWe_vector(i) <= ipbw(i).ipb_write and ipbw(i).ipb_strobe;
    -- phi_extrapolation : entity work.phi_extrapolation_mem
    --   port map (
    --     clka   => clk,
    --     wea    => "0",
    --     addra  => std_logic_vector(iPhiExtrapolationAddress(i)),
    --     dina   => (others => '0'),
    --     douta  => sLutOutput(i)(3 downto 0),
    --     clkb   => clk_ipb,
    --     web(0) => ipbusWe_vector(i),
    --     addrb  => ipbw(i).ipb_addr(10 downto 0),
    --     dinb   => ipbw(i).ipb_wdata(31 downto 0),
    --     doutb  => ipbr(i).ipb_rdata(31 downto 0)
    --     );
    phi_extrapolation : entity work.ipbus_dpram
        generic map (
          DATA_FILE  => DATA_FILE,
          ADDR_WIDTH => 14,
          WORD_WIDTH => 4
          )
        port map (
            clk => clk_ipb,
            rst => rst,
            ipb_in => ipbw(i),
            ipb_out => ipbr(i),
            rclk => clk,
            q => sLutOutput(i)(3 downto 0),
            addr => std_logic_vector(iPhiExtrapolationAddress(i))
        );
    oDeltaPhi(i) <= signed(sLutOutput(i)(3 downto 0));
  end generate extrapolation;

end Behavioral;
