-- BLOCO 1: Aluguéis por Cliente
BEGIN
  FOR r IN (
    SELECT C.NOME AS cliente, COUNT(A.ID_ALUGUEL) AS total_alugueis
    FROM CLIENTE C
    JOIN ALUGUEL A ON C.ID_CLIENTE = A.ID_CLIENTE
    GROUP BY C.NOME
    ORDER BY total_alugueis DESC
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || r.cliente || ' | Aluguéis: ' || r.total_alugueis);
  END LOOP;
END;
/

-- BLOCO 2: Motos por Modelo
BEGIN
  FOR r IN (
    SELECT M.DESCRICAO AS modelo, COUNT(MT.ID_MOTO) AS total_motos
    FROM MODELOMOTO M
    JOIN MOTO MT ON M.ID_MODELO = MT.ID_MODELO
    GROUP BY M.DESCRICAO
    ORDER BY total_motos DESC
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Modelo: ' || r.modelo || ' | Total de motos: ' || r.total_motos);
  END LOOP;
END;
/

-- BLOCO 3: Manutenções por Tipo
BEGIN
  FOR r IN (
    SELECT MO.PLACA, MA.TIPO, COUNT(*) AS total
    FROM MANUTENCAO MA
    JOIN MOTO MO ON MO.ID_MOTO = MA.ID_MOTO
    GROUP BY MO.PLACA, MA.TIPO
    ORDER BY MO.PLACA
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Moto: ' || r.PLACA || ' | Tipo: ' || r.TIPO || ' | Total: ' || r.TOTAL);
  END LOOP;
END;
/

-- BLOCO 4: Localização – Atual, Anterior e Próxima
DECLARE
  CURSOR c IS
    SELECT * FROM LOCALIZACAOMOTO
    WHERE ID_MOTO = 1
    ORDER BY DATA_REGISTRO;

  TYPE loc_table IS TABLE OF LOCALIZACAOMOTO%ROWTYPE INDEX BY PLS_INTEGER;
  v_loc loc_table;
BEGIN
  OPEN c;
  FETCH c BULK COLLECT INTO v_loc;
  CLOSE c;

  FOR i IN 1 .. v_loc.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('--- Registro ' || i || ' ---');

    IF i = 1 THEN
      DBMS_OUTPUT.PUT_LINE('Anterior: Vazio');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Anterior: ' || v_loc(i-1).LATITUDE || ', ' || v_loc(i-1).LONGITUDE);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Atual: ' || v_loc(i).LATITUDE || ', ' || v_loc(i).LONGITUDE);

    IF i = v_loc.COUNT THEN
      DBMS_OUTPUT.PUT_LINE('Próximo: Vazio');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Próximo: ' || v_loc(i+1).LATITUDE || ', ' || v_loc(i+1).LONGITUDE);
    END IF;
  END LOOP;
END;
/
