library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.GMTTypes.all;

entity MatchingUnit is
  
  port (
    iSortRanksBrlFwd : in  TSortRank10_vector(7 downto 0);
    iEmptyBrlFwd     : in  std_logic_vector(7 downto 0);
    iIdxBitsBrlFwd   : in  TIndexBits_vector(7 downto 0);
    iMuonsBrlFwd     : in  TGMTMu_vector(7 downto 0);
    iSortRanksOvl    : in  TSortRank10_vector(7 downto 0);
    iEmptyOvl        : in  std_logic_vector(7 downto 0);
    iIdxBitsOvl      : in  TIndexBits_vector(7 downto 0);
    iMuonsOvl        : in  TGMTMu_vector(7 downto 0);
    iPairVec         : in  TPairVector(3 downto 0);
    oSortRanks       : out TSortRank10_vector(3 downto 0);
    oEmpty           : out std_logic_vector(3 downto 0);
    oIdxBits         : out TIndexBits_vector(3 downto 0);
    oMuons           : out TGMTMu_vector(3 downto 0);
    oCancelBrlFwd    : out std_logic_vector(7 downto 0);
    oCancelOvl       : out std_logic_vector(7 downto 0);
    clk              : in  std_logic;
    sinit            : in  std_logic);

end MatchingUnit;

architecture behavioral of MatchingUnit is
  signal sMuonsTF          : TGMTMu_vector(15 downto 0);
  signal sSortRanksTF      : TSortRank10_vector(15 downto 0);
  signal sEmptyTF          : std_logic_vector(15 downto 0);
  signal sIdxBitsTF        : TIndexBits_vector(15 downto 0);
  signal sMuonsMatched     : TGMTMu_vector(3 downto 0);
  signal sSortRanksMatched : TSortRank10_vector(3 downto 0);
  signal sEmptyMatched     : std_logic_vector(3 downto 0);
  signal sIdxBitsMatched   : TIndexBits_vector(3 downto 0);
  signal sCancelBrlFwd     : std_logic_vector(7 downto 0) := (others => '0');
  signal sCancelOvl        : std_logic_vector(7 downto 0) := (others => '0');
begin  -- behavioral

  sMuonsTF     <= iMuonsBrlFwd & iMuonsOvl;
  sSortRanksTF <= iSortRanksBrlFwd & iSortRanksOvl;
  sEmptyTF     <= iEmptyBrlFwd & iEmptyOvl;

  -- Add an offset to ovl index bits
  add_offset : for i in iMuonsOvl'range generate
    sIdxBitsTF(i)   <= iIdxBitsBrlFwd(i);
    sIdxBitsTF(i+8) <= iIdxBitsOvl(i) + 36;
  end generate add_offset;


  mux : process (iPairVec, sIdxBitsTF, sSortRanksTF, sEmptyTF, sMuonsTF, sCancelBrlFwd, sCancelOvl) is
    variable sSelBits : TSelBits_1_of_16_vec(3 downto 0);
  begin  -- process mux
    sCancelBrlFwd <= (others => '0');
    sCancelOvl    <= (others => '0');

    for i in iPairVec'range loop
      -- Construct select vector:
      -- If index in pair vector is equal to index in idx vector that muon is
      -- matched.
      for j in sIdxBitsTF'range loop
        if iPairVec(i) = sIdxBitsTF(j) then
          sSelBits(i)(j) := '1';
        else
          sSelBits(i)(j) := '0';
        end if;
      end loop;  -- j
      -- Now put the selected muon into the output vector.
      case sSelBits(i) is
        when "1000000000000000" => sMuonsMatched(i) <= sMuonsTF(0);
        when "0100000000000000" => sMuonsMatched(i) <= sMuonsTF(1);
        when "0010000000000000" => sMuonsMatched(i) <= sMuonsTF(2);
        when "0001000000000000" => sMuonsMatched(i) <= sMuonsTF(3);
        when "0000100000000000" => sMuonsMatched(i) <= sMuonsTF(4);
        when "0000010000000000" => sMuonsMatched(i) <= sMuonsTF(5);
        when "0000001000000000" => sMuonsMatched(i) <= sMuonsTF(6);
        when "0000000100000000" => sMuonsMatched(i) <= sMuonsTF(7);
        when "0000000010000000" => sMuonsMatched(i) <= sMuonsTF(8);
        when "0000000001000000" => sMuonsMatched(i) <= sMuonsTF(9);
        when "0000000000100000" => sMuonsMatched(i) <= sMuonsTF(10);
        when "0000000000010000" => sMuonsMatched(i) <= sMuonsTF(11);
        when "0000000000001000" => sMuonsMatched(i) <= sMuonsTF(12);
        when "0000000000000100" => sMuonsMatched(i) <= sMuonsTF(13);
        when "0000000000000010" => sMuonsMatched(i) <= sMuonsTF(14);
        when "0000000000000001" => sMuonsMatched(i) <= sMuonsTF(15);
        when others             => sMuonsMatched(i) <= ("00", "000000000", "0000", "0000000000", "0000000000");
      end case;
      case sSelBits(i) is
        when "1000000000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(0);
        when "0100000000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(1);
        when "0010000000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(2);
        when "0001000000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(3);
        when "0000100000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(4);
        when "0000010000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(5);
        when "0000001000000000" => sIdxBitsMatched(i) <= sIdxBitsTF(6);
        when "0000000100000000" => sIdxBitsMatched(i) <= sIdxBitsTF(7);
        when "0000000010000000" => sIdxBitsMatched(i) <= sIdxBitsTF(8);
        when "0000000001000000" => sIdxBitsMatched(i) <= sIdxBitsTF(9);
        when "0000000000100000" => sIdxBitsMatched(i) <= sIdxBitsTF(10);
        when "0000000000010000" => sIdxBitsMatched(i) <= sIdxBitsTF(11);
        when "0000000000001000" => sIdxBitsMatched(i) <= sIdxBitsTF(12);
        when "0000000000000100" => sIdxBitsMatched(i) <= sIdxBitsTF(13);
        when "0000000000000010" => sIdxBitsMatched(i) <= sIdxBitsTF(14);
        when "0000000000000001" => sIdxBitsMatched(i) <= sIdxBitsTF(15);
        when others             => sIdxBitsMatched(i) <= (others => '0');
      end case;
      case sSelBits(i) is
        when "1000000000000000" => sEmptyMatched(i) <= sEmptyTF(0);
        when "0100000000000000" => sEmptyMatched(i) <= sEmptyTF(1);
        when "0010000000000000" => sEmptyMatched(i) <= sEmptyTF(2);
        when "0001000000000000" => sEmptyMatched(i) <= sEmptyTF(3);
        when "0000100000000000" => sEmptyMatched(i) <= sEmptyTF(4);
        when "0000010000000000" => sEmptyMatched(i) <= sEmptyTF(5);
        when "0000001000000000" => sEmptyMatched(i) <= sEmptyTF(6);
        when "0000000100000000" => sEmptyMatched(i) <= sEmptyTF(7);
        when "0000000010000000" => sEmptyMatched(i) <= sEmptyTF(8);
        when "0000000001000000" => sEmptyMatched(i) <= sEmptyTF(9);
        when "0000000000100000" => sEmptyMatched(i) <= sEmptyTF(10);
        when "0000000000010000" => sEmptyMatched(i) <= sEmptyTF(11);
        when "0000000000001000" => sEmptyMatched(i) <= sEmptyTF(12);
        when "0000000000000100" => sEmptyMatched(i) <= sEmptyTF(13);
        when "0000000000000010" => sEmptyMatched(i) <= sEmptyTF(14);
        when "0000000000000001" => sEmptyMatched(i) <= sEmptyTF(15);
        when others             => sEmptyMatched(i) <= '1';
      end case;
      case sSelBits(i) is
        when "1000000000000000" => sSortRanksMatched(i) <= sSortRanksTF(0);
        when "0100000000000000" => sSortRanksMatched(i) <= sSortRanksTF(1);
        when "0010000000000000" => sSortRanksMatched(i) <= sSortRanksTF(2);
        when "0001000000000000" => sSortRanksMatched(i) <= sSortRanksTF(3);
        when "0000100000000000" => sSortRanksMatched(i) <= sSortRanksTF(4);
        when "0000010000000000" => sSortRanksMatched(i) <= sSortRanksTF(5);
        when "0000001000000000" => sSortRanksMatched(i) <= sSortRanksTF(6);
        when "0000000100000000" => sSortRanksMatched(i) <= sSortRanksTF(7);
        when "0000000010000000" => sSortRanksMatched(i) <= sSortRanksTF(8);
        when "0000000001000000" => sSortRanksMatched(i) <= sSortRanksTF(9);
        when "0000000000100000" => sSortRanksMatched(i) <= sSortRanksTF(10);
        when "0000000000010000" => sSortRanksMatched(i) <= sSortRanksTF(11);
        when "0000000000001000" => sSortRanksMatched(i) <= sSortRanksTF(12);
        when "0000000000000100" => sSortRanksMatched(i) <= sSortRanksTF(13);
        when "0000000000000010" => sSortRanksMatched(i) <= sSortRanksTF(14);
        when "0000000000000001" => sSortRanksMatched(i) <= sSortRanksTF(15);
        when others             => sSortRanksMatched(i) <= (others => '0');
      end case;
      case sSelBits(i) is
        when "1000000000000000" => sCancelBrlFwd(0) <= '1';
        when "0100000000000000" => sCancelBrlFwd(1) <= '1';
        when "0010000000000000" => sCancelBrlFwd(2) <= '1';
        when "0001000000000000" => sCancelBrlFwd(3) <= '1';
        when "0000100000000000" => sCancelBrlFwd(4) <= '1';
        when "0000010000000000" => sCancelBrlFwd(5) <= '1';
        when "0000001000000000" => sCancelBrlFwd(6) <= '1';
        when "0000000100000000" => sCancelBrlFwd(7) <= '1';
        when "0000000010000000" => sCancelOvl(0)    <= '1';
        when "0000000001000000" => sCancelOvl(1)    <= '1';
        when "0000000000100000" => sCancelOvl(2)    <= '1';
        when "0000000000010000" => sCancelOvl(3)    <= '1';
        when "0000000000001000" => sCancelOvl(4)    <= '1';
        when "0000000000000100" => sCancelOvl(5)    <= '1';
        when "0000000000000010" => sCancelOvl(6)    <= '1';
        when "0000000000000001" => sCancelOvl(7)    <= '1';
        when others             => null;
      end case;
    end loop;  -- i
  end process mux;

  oIdxBits      <= sIdxBitsMatched;
  oEmpty        <= sEmptyMatched;
  oSortRanks    <= sSortRanksMatched;
  oMuons        <= sMuonsMatched;
  oCancelBrlFwd <= sCancelBrlFwd;
  oCancelOvl    <= sCancelOvl;

end behavioral;
