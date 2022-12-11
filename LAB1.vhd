LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_textio.ALL;
use std.textio.all;

ENTITY LAB1 IS
	PORT (
		wybor_kanapki : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		wybor_platnosci : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		ilosc_gotowki : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		awaria : OUT STD_LOGIC := '0';
		brak_towaru : OUT STD_LOGIC := '0';
		za_malo_pieniedzy : OUT STD_LOGIC := '0'
	);
END ENTITY;

ARCHITECTURE rtl OF LAB1 IS
	TYPE integer_array IS ARRAY (0 TO 5) OF INTEGER RANGE 0 TO 100;
	
	FUNCTION wydawanie_pieniedzy(
		podana_kwota : INTEGER RANGE 0 TO 100;
		cena : INTEGER RANGE 0 TO 100;
		ilosc_pieniedzy_do_wydania : integer_array
	)
		RETURN integer_array IS
		VARIABLE reszta_pieniedzy_do_wydania : integer_array;
		VARIABLE kwota_do_wydania : INTEGER RANGE -100 TO 100 := (cena - podana_kwota);
		VARIABLE counter : INTEGER RANGE 0 TO 100 := 100;

	BEGIN

		reszta_pieniedzy_do_wydania := ilosc_pieniedzy_do_wydania;

		kwota_do_wydania := - kwota_do_wydania;
		--	 reszta_pieniedzy_do_wydania(5) := reszta_pieniedzy_do_wydania(5) - 1;

		WHILE counter > 0 LOOP
			counter := counter - 1;
			
				IF(kwota_do_wydania >= 50 and reszta_pieniedzy_do_wydania(5) > 0) THEN
					kwota_do_wydania := kwota_do_wydania - 50;
					reszta_pieniedzy_do_wydania(5) := reszta_pieniedzy_do_wydania(5) - 1;
					NEXT WHEN counter = counter - 1;			
				END IF;
			
				IF(kwota_do_wydania >= 20 and reszta_pieniedzy_do_wydania(4) > 0) THEN
					kwota_do_wydania := kwota_do_wydania - 20;
					reszta_pieniedzy_do_wydania(4) := reszta_pieniedzy_do_wydania(4) - 1;
					NEXT WHEN counter = counter - 1;	
				END IF;			
			
				IF(kwota_do_wydania >= 10 and reszta_pieniedzy_do_wydania(3) > 0) THEN
					kwota_do_wydania := kwota_do_wydania - 10;
					reszta_pieniedzy_do_wydania(3) := reszta_pieniedzy_do_wydania(3) - 1;
					NEXT WHEN counter = counter - 1;			
				END IF;
			
				IF(kwota_do_wydania >= 5 and reszta_pieniedzy_do_wydania(2) > 0) THEN
					kwota_do_wydania := kwota_do_wydania - 5;
					reszta_pieniedzy_do_wydania(2) := reszta_pieniedzy_do_wydania(2) - 1;
					NEXT WHEN counter = counter - 1;			
				END IF;
			
				IF(kwota_do_wydania >= 2 and reszta_pieniedzy_do_wydania(1) > 0) THEN
					kwota_do_wydania := kwota_do_wydania - 2;
					reszta_pieniedzy_do_wydania(1) := reszta_pieniedzy_do_wydania(1) - 1;
					NEXT WHEN counter = counter - 1;
				END IF;
				IF (kwota_do_wydania >= 1) THEN
					IF(reszta_pieniedzy_do_wydania(0) > 0) THEN
						kwota_do_wydania := kwota_do_wydania - 1;
						reszta_pieniedzy_do_wydania(0) := reszta_pieniedzy_do_wydania(0) - 1;
						NEXT WHEN counter = counter - 1;
					ELSE
						return ilosc_pieniedzy_do_wydania;
					END IF;
				END IF;

		END LOOP;
		--	 reszta_pieniedzy_do_wydania(3) := 2;
		RETURN reszta_pieniedzy_do_wydania;
		
END FUNCTION wydawanie_pieniedzy;



BEGIN
	PROCESS (wybor_kanapki)
		VARIABLE res, BB, BC, BA : signed (16 DOWNTO 0);
		VARIABLE CF, ZF, SF : STD_LOGIC;

		VARIABLE ilosc_kanapek_z_szynka : INTEGER RANGE 0 TO 10 := 9;
		VARIABLE ilosc_kanapek_z_jajkiem : INTEGER RANGE 0 TO 10 := 2;

		VARIABLE cena_kanapki_z_szynka : INTEGER := 1;
		VARIABLE cena_kanapki_z_jajkiem : INTEGER := 3;

		VARIABLE ilosc_gotowki_int : INTEGER RANGE 0 TO 100 := 0;

		VARIABLE aktualna_cena : INTEGER RANGE 0 TO 10 := 0;

		VARIABLE pieniadze_do_wydania : integer_array := (2, 2, 2, 2, 2, 2);

		VARIABLE pieniadze_do_wydania_save : integer_array := (2, 10, 10, 10, 10, 10);
	BEGIN
		awaria <= '0';
		brak_towaru <= '0';
		aktualna_cena := 0;
		za_malo_pieniedzy <= '0';
		CASE wybor_kanapki IS
			WHEN "00" => awaria <= '1';

			WHEN "01" =>
				ilosc_gotowki_int := to_integer(unsigned(ilosc_gotowki));
				IF (ilosc_kanapek_z_szynka > 0) THEN

					CASE wybor_platnosci IS

							-- platnosc blik
						WHEN "00" =>
							ilosc_kanapek_z_szynka := ilosc_kanapek_z_szynka - 1;

							-- platnosc karta
						WHEN "01" =>
							ilosc_kanapek_z_szynka := ilosc_kanapek_z_szynka - 1;

							-- platnosc gotowka
						WHEN "10" =>
							IF (ilosc_gotowki_int >= cena_kanapki_z_szynka) THEN
								IF ((ilosc_gotowki_int - cena_kanapki_z_szynka) = 0) THEN
									ilosc_kanapek_z_szynka := ilosc_kanapek_z_szynka - 1;
								ELSE
									pieniadze_do_wydania_save := wydawanie_pieniedzy(
										ilosc_gotowki_int,
										cena_kanapki_z_szynka,
										pieniadze_do_wydania
										);
									IF (pieniadze_do_wydania_save = pieniadze_do_wydania) THEN
										awaria <= '1';
									ELSE
										ilosc_kanapek_z_szynka := ilosc_kanapek_z_szynka - 1;
										pieniadze_do_wydania := pieniadze_do_wydania_save;
									END IF;
								END IF;
								ELSE
									za_malo_pieniedzy <= '1';
								END IF;

						WHEN OTHERS => awaria <= '1';

					END CASE;
				ELSE
					brak_towaru <= '1';
				END IF;
			WHEN OTHERS => awaria <= '1';
		END CASE;

	END PROCESS;
END rtl;