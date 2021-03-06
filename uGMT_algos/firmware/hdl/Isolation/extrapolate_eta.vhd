library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.mp7_data_types.all;
use work.ipbus.all;
use work.ipbus_decode_extrapolation_eta.all;

use work.GMTTypes.all;
use work.ugmt_constants.all;

entity extrapolate_eta is
  generic (
    DATA_FILE: string
      );
  port (
    clk_ipb                  : in  std_logic;
    rst                      : in  std_logic;
    ipb_in                   : in  ipb_wbus;
    ipb_out                  : out ipb_rbus;
    clk                      : in  std_logic;
    iEtaExtrapolationAddress : in  TEtaExtrapolationAddress(35 downto 0);
    oDeltaEta                : out TDelta_vector(35 downto 0)
    );
end extrapolate_eta;

architecture Behavioral of extrapolate_eta is

  signal ipbusWe_vector : std_logic_vector(iEtaExtrapolationAddress'range);

  signal ipbw : ipb_wbus_array(N_SLAVES-1 downto 0);
  signal ipbr : ipb_rbus_array(N_SLAVES-1 downto 0);

  signal sLutOutput : TLutBuf(iEtaExtrapolationAddress'range);

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
        sel             => ipbus_sel_extrapolation_eta(ipb_in.ipb_addr),
        ipb_to_slaves   => ipbw,
        ipb_from_slaves => ipbr
        );


  extrapolation : for i in iEtaExtrapolationAddress'range generate
    eta_extrapolation : entity work.ipbus_dpram
        generic map (
          DATA_FILE  => DATA_FILE,
          ADDR_WIDTH => ETA_EXTRAPOLATION_ADDR_WIDTH,
          WORD_WIDTH => ETA_EXTRAPOLATION_WORD_SIZE
          )
        port map (
            clk => clk_ipb,
            rst => rst,
            ipb_in => ipbw(i),
            ipb_out => ipbr(i),
            rclk => clk,
            q => sLutOutput(i)(3 downto 0),
            addr => iEtaExtrapolationAddress(i)
        );
    oDeltaEta(i) <= signed(sLutOutput(i)(3 downto 0));
  end generate extrapolation;

end Behavioral;
