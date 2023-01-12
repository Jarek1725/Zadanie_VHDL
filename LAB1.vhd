LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_textio.ALL;
use std.textio.all;

ENTITY LAB1 IS
	PORT (
		refresh_program  : IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		selected_product : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		selected_payment : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		restart_machine : IN STD_LOGIC;
		how_much_cash : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		breakdown : OUT STD_LOGIC := '0';
		no_product : OUT STD_LOGIC := '0';
		not_enaught_cash_error : OUT STD_LOGIC := '0'
	);
END ENTITY;

ARCHITECTURE rtl OF LAB1 IS
	TYPE integer_array IS ARRAY (0 TO 2) OF INTEGER RANGE 0 TO 20;
	
	FUNCTION giving_change(
		given_cash_value : INTEGER RANGE 0 TO 32;
		product_price : INTEGER RANGE 0 TO 10;
		coins_in_machine : integer_array
	)
		RETURN integer_array IS
		VARIABLE conis_left_in_machine : integer_array;
		VARIABLE rest_to_give : INTEGER RANGE 0 TO 20 := -(product_price - given_cash_value);
		VARIABLE counter : INTEGER RANGE 0 TO 20 := 20;

	BEGIN
		conis_left_in_machine := coins_in_machine;

		--   rest_to_give := - rest_to_give;
		--	 conis_left_in_machine(5) := conis_left_in_machine(5) - 1;

		report "start rest_to_give: "&integer'image(rest_to_give);
		report "start product_price: "&integer'image(product_price);
		report "start given_cash_value: "&integer'image(given_cash_value);
		report "rest to give loop start";
		WHILE counter > 0 LOOP
			
			counter := counter - 1;
				report "rest to give new iteration";
				IF(rest_to_give = 0) THEN
					EXIT;
				END IF;

				IF(rest_to_give >= 5 and conis_left_in_machine(2) > 0) THEN
					rest_to_give := rest_to_give - 5;
					conis_left_in_machine(2) := conis_left_in_machine(2) - 1;
					report "rest_to_give: "&integer'image(rest_to_give);
					report "coins_left_in_machine(2): "&integer'image(conis_left_in_machine(2));
					NEXT WHEN counter = counter - 1;			
			
				ELSIF(rest_to_give >= 2 and conis_left_in_machine(1) > 0) THEN
					rest_to_give := rest_to_give - 2;
					conis_left_in_machine(1) := conis_left_in_machine(1) - 1;
					report "rest_to_give: "&integer'image(rest_to_give);
					report "coins_left_in_machine(1): "&integer'image(conis_left_in_machine(1));
					NEXT WHEN counter = counter - 1;
					
				ELSIF (rest_to_give >= 1) THEN
					IF(conis_left_in_machine(0) > 0) THEN
						rest_to_give := rest_to_give - 1;
						conis_left_in_machine(0) := conis_left_in_machine(0) - 1;
						report "rest_to_give: "&integer'image(rest_to_give);
						report "coins_left_in_machine(0): "&integer'image(conis_left_in_machine(0));
						NEXT WHEN counter = counter - 1;
					ELSE
						report "End of coins to give";
						return coins_in_machine;
					END IF;
				END IF;

		END LOOP;
		
		report "coins_left_in_machine(0): "&integer'image(conis_left_in_machine(0));
		report "coins_left_in_machine(1): "&integer'image(conis_left_in_machine(1));
		report "coins_left_in_machine(2): "&integer'image(conis_left_in_machine(2));
		--	 conis_left_in_machine(3) := 2;
		RETURN conis_left_in_machine;
		
END FUNCTION giving_change;

FUNCTION add_money_from_customer(
		given_cash_value : INTEGER RANGE 0 TO 32;
		coins_in_machine : integer_array
)
		RETURN integer_array IS
		VARIABLE conis_left_in_machine : integer_array := coins_in_machine;
		VARIABLE given_cash_value_var : INTEGER RANGE 0 TO 32 := given_cash_value;
		VARIABLE counter : INTEGER RANGE 0 TO 20 := 20;
		
		BEGIN
		
		WHILE counter > 0 LOOP
			counter := counter - 1;
			
			IF(given_cash_value_var>0) THEN
				IF(given_cash_value_var>= 5) THEN
					REPORT "Added 5 to coins in machine";
					given_cash_value_var := given_cash_value_var - 5;
					conis_left_in_machine(2) := conis_left_in_machine(2) + 1;
				
				ELSIF(given_cash_value_var >= 2) THEN
					REPORT "Added 2 to coins in machine";
					given_cash_value_var:= given_cash_value_var - 2;
					conis_left_in_machine(1) := conis_left_in_machine(1) + 1;
					
				ELSE
					IF(given_cash_value_var>0) THEN
					REPORT "Added 1 to coins in machine";
					given_cash_value_var := given_cash_value_var - 1;
					END IF;
					conis_left_in_machine(0) := conis_left_in_machine(0) + 1;			
				END IF;
			END IF;
		
		END LOOP;
		
		RETURN conis_left_in_machine;

END FUNCTION add_money_from_customer;

BEGIN
	PROCESS (refresh_program)

		VARIABLE number_of_ham_sandwiches : INTEGER RANGE 0 TO 10 := 9;
		VARIABLE number_of_cheese_sandwiches : INTEGER RANGE 0 TO 10 := 2;
		VARIABLE number_of_egg_sandwiches : INTEGER RANGE 0 TO 10 := 2;
		VARIABLE number_of_tuna_sandwiches : INTEGER RANGE 0 TO 10 := 2;
		VARIABLE number_of_vege_sandwiches : INTEGER RANGE 0 TO 10 := 2;

		VARIABLE ham_sandwich_price : INTEGER := 1;
		VARIABLE egg_sandwich_price : INTEGER := 3;
		VARIABLE cheese_sandwich_price : INTEGER := 2;
		VARIABLE tuna_sandwich_price : INTEGER := 2;
		VARIABLE vege_sandwich_price : INTEGER := 2;

		VARIABLE how_much_cash_int : INTEGER RANGE 0 TO 32 := 0;

		VARIABLE current_product_prive : INTEGER RANGE 0 TO 10 := 0;

		VARIABLE coins_in_machine : integer_array := (4, 4, 4);

		VARIABLE coins_in_machine_left_after_transaction : integer_array := (0, 0, 0);
	BEGIN
		breakdown <= '0';
		no_product <= '0';
		current_product_prive := 0;
		not_enaught_cash_error <= '0';
		IF(restart_machine = '1') THEN
			report "restart machine";
			number_of_ham_sandwiches 	 := 9;
			number_of_cheese_sandwiches := 2;
			number_of_egg_sandwiches 	 := 2;
			number_of_tuna_sandwiches   := 2;
			number_of_vege_sandwiches   := 2;
			coins_in_machine := (4, 4, 4);
		ELSE
			CASE selected_product IS
				WHEN "000" => breakdown <= '1';

				WHEN "001" =>
					how_much_cash_int := to_integer(unsigned(how_much_cash));
					IF (number_of_ham_sandwiches > 0) THEN
						CASE selected_payment IS
								-- platnosc blik
							WHEN ("00" OR "01") =>
								number_of_ham_sandwiches := number_of_ham_sandwiches - 1;

								-- platnosc gotowka
							WHEN "10" =>
								IF (how_much_cash_int >= ham_sandwich_price) THEN
									IF ((how_much_cash_int - ham_sandwich_price) = 0) THEN
										number_of_ham_sandwiches := number_of_ham_sandwiches - 1;
									ELSE
										coins_in_machine_left_after_transaction := giving_change(
											how_much_cash_int,
											ham_sandwich_price,
											coins_in_machine
											);
										IF (coins_in_machine_left_after_transaction = coins_in_machine) THEN
											breakdown <= '1';
										ELSE
											number_of_ham_sandwiches := number_of_ham_sandwiches - 1;
											coins_in_machine := coins_in_machine_left_after_transaction;
											coins_in_machine := add_money_from_customer(
												how_much_cash_int,
												coins_in_machine
											);										
											END IF;
									END IF;
									ELSE
										not_enaught_cash_error <= '1';
									END IF;

							WHEN OTHERS => breakdown <= '1';

						END CASE;
					ELSE
							  no_product <= '1';
					END IF;
					
				WHEN "010" =>
					how_much_cash_int := to_integer(unsigned(how_much_cash));
					IF (number_of_tuna_sandwiches > 0) THEN
						CASE selected_payment IS
								-- platnosc blik
							WHEN ("00" OR "01") =>
								number_of_tuna_sandwiches := number_of_tuna_sandwiches - 1;

								-- platnosc gotowka
							WHEN "10" =>
								IF (how_much_cash_int >= tuna_sandwich_price) THEN
									IF ((how_much_cash_int - tuna_sandwich_price) = 0) THEN
										number_of_tuna_sandwiches:= number_of_tuna_sandwiches - 1;
									ELSE
										coins_in_machine_left_after_transaction := giving_change(
											how_much_cash_int,
											tuna_sandwich_price,
											coins_in_machine
											);
										IF (coins_in_machine_left_after_transaction = coins_in_machine) THEN
											breakdown <= '1';
										ELSE
											number_of_tuna_sandwiches := number_of_tuna_sandwiches - 1;
											coins_in_machine := coins_in_machine_left_after_transaction;	
											coins_in_machine := add_money_from_customer(
												how_much_cash_int,
												coins_in_machine
											);															
										END IF;
									END IF;
									ELSE
										not_enaught_cash_error <= '1';
									END IF;

							WHEN OTHERS => breakdown <= '1';

						END CASE;
					ELSE
							  no_product <= '1';
					END IF;

				WHEN "011" =>
					how_much_cash_int := to_integer(unsigned(how_much_cash));
					IF (number_of_cheese_sandwiches > 0) THEN
						CASE selected_payment IS
								-- platnosc blik
							WHEN ("00" OR "01") =>
								number_of_cheese_sandwiches := number_of_cheese_sandwiches - 1;

								-- platnosc gotowka
							WHEN "10" =>
								IF (how_much_cash_int >= tuna_sandwich_price) THEN
									IF ((how_much_cash_int - tuna_sandwich_price) = 0) THEN
										number_of_cheese_sandwiches:= number_of_cheese_sandwiches - 1;
									ELSE
										coins_in_machine_left_after_transaction := giving_change(
											how_much_cash_int,
											cheese_sandwich_price,
											coins_in_machine
											);
										IF (coins_in_machine_left_after_transaction = coins_in_machine) THEN
											breakdown <= '1';
										ELSE
											number_of_cheese_sandwiches := number_of_cheese_sandwiches - 1;
											coins_in_machine := coins_in_machine_left_after_transaction;			
											coins_in_machine := add_money_from_customer(
												how_much_cash_int,
												coins_in_machine
											);															
										END IF;
									END IF;
									ELSE
										not_enaught_cash_error <= '1';
									END IF;

							WHEN OTHERS => breakdown <= '1';

						END CASE;
					ELSE
							  no_product <= '1';
					END IF;					
					
			WHEN "100" =>
					how_much_cash_int := to_integer(unsigned(how_much_cash));
					IF (number_of_egg_sandwiches > 0) THEN
						CASE selected_payment IS
								-- platnosc blik
							WHEN ("00" OR "01") =>
								number_of_egg_sandwiches := number_of_egg_sandwiches - 1;

								-- platnosc gotowka
							WHEN "10" =>
								IF (how_much_cash_int >= egg_sandwich_price) THEN
									IF ((how_much_cash_int - egg_sandwich_price) = 0) THEN
										number_of_egg_sandwiches := number_of_egg_sandwiches - 1;
									ELSE
										coins_in_machine_left_after_transaction := giving_change(
											how_much_cash_int,
											egg_sandwich_price,
											coins_in_machine
											);
										IF (coins_in_machine_left_after_transaction = coins_in_machine) THEN
											breakdown <= '1';
										ELSE
											number_of_egg_sandwiches := number_of_egg_sandwiches - 1;
											coins_in_machine := coins_in_machine_left_after_transaction;
											coins_in_machine := add_money_from_customer(
												how_much_cash_int,
												coins_in_machine
											);															
										END IF;
									END IF;
									ELSE
										not_enaught_cash_error <= '1';
									END IF;

							WHEN OTHERS => breakdown <= '1';

						END CASE;
						
					ELSE
							  no_product <= '1';
					END IF;
				WHEN OTHERS => breakdown <= '1';
			END CASE;
			
		END IF;
	END PROCESS;
END rtl;