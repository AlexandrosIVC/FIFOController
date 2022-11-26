library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------Entity Declaration-----------------------------------------

entity FIFO_Controller is 
	port (
		Clock: 			in std_logic;
		Reset:			in std_logic;
		WriteEnable:		in std_logic;
		ReadEnable:		in std_logic;
		WriteAddress:		out std_logic_vector(1 downto 0);
		ReadAddress:		out std_logic_vector(1 downto 0);
		Empty:			out std_logic;
		Full:	 		out std_logic
	);
end FIFO_Controller;

--------------------------Architectures Declaration------------------------------------

architecture FIFO_Controller_Arch of FIFO_Controller is

--------------------------Types Declaration--------------------------------------------

--------------------------Architecture Internal Signals Declaration--------------------

signal ReadAddress_Unsigned:		unsigned(2 downto 0) := "000";
signal WriteAddress_Unsigned:		unsigned(2 downto 0) := "000";
signal Full_Signal:			std_logic := '0';
signal Empty_Signal:			std_logic := '1';

--------------------------Body of Architecture-----------------------------------------

begin

--------------------------Concurrent Code----------------------------------------------

	Full <= Full_Signal;
	Empty <= Empty_Signal;

--------------------------Sequential Code----------------------------------------------

	ReadAddress_Logic:	process(ReadEnable, Clock, Reset)

-------------------------Process Variables---------------------------------------------

-------------------------Process Body--------------------------------------------------
	begin
		if (Reset = '1') then
			ReadAddress_Unsigned <= "000";
		elsif (ReadEnable = '1') then
			ReadAddress <= std_logic_vector(ReadAddress_Unsigned(1 downto 0));
			if (rising_edge(Clock) AND Empty_Signal = '0') then
				ReadAddress_Unsigned <= ReadAddress_Unsigned + 1;
			end if;
		else
			ReadAddress <="ZZ";
		end if;
	end process;

	WriteAddress_Logic:	process(WriteEnable, Clock, Reset)

-------------------------Process Variables---------------------------------------------

-------------------------Process Body--------------------------------------------------
	begin
		if (Reset = '1') then
			WriteAddress_Unsigned <= "000";
		elsif (WriteEnable = '1') then
			WriteAddress <= std_logic_vector(WriteAddress_Unsigned(1 downto 0));
			if (rising_edge(Clock) AND Full_Signal = '0') then
				WriteAddress_Unsigned <= WriteAddress_Unsigned + 1;
			end if;
		else
			WriteAddress <="ZZ";
		end if;
	end process;

	Full_Empty_Logic:	process(WriteAddress_Unsigned, ReadAddress_Unsigned, Reset)

-------------------------Process Variables---------------------------------------------

-------------------------Process Body--------------------------------------------------
	begin
		if (Reset = '1') then
			Empty_Signal <= '1';
			Full_Signal <= '0';
		elsif (WriteAddress_Unsigned(1 downto 0) = ReadAddress_Unsigned(1 downto 0)) then
			if (WriteAddress_Unsigned(2) = ReadAddress_Unsigned(2)) then
				Empty_Signal <= '1';
				Full_Signal <= '0';
			else
				Full_Signal <= '1';
				Empty_Signal <= '0';
			end if;
		else
			Empty_Signal <= '0';
			Full_Signal <= '0';
		end if;
	end process;
end FIFO_Controller_Arch;