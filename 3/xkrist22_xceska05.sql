--SQL skript obsahující dotazy SELECT musí obsahovat konkrétně alespoň dva dotazy využívající spojení dvou tabulek, jeden využívající spojení tří tabulek, 
--dva dotazy s klauzulí GROUP BY a agregační funkcí, jeden dotaz obsahující predikát EXISTS a jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat). 
--U každého z dotazů musí být (v komentáři SQL kódu) popsáno srozumitelně, jaká data hledá daný dotaz (jaká je jeho funkce v aplikaci).
--------------------
-- 2x spojení 2 tabulek [1/2]
-- 1x spojení 3 tabulek
-- 2x GROUP BY + agregační fce
-- 1x EXISTS
-- 1x IN + vnořený select
-- 7x popisky k čemu select spouží [1/7]

-- Nová hospoda ve Svitavách chce zaslat nabídku akcí místním uživatelům systému. [zobraz jméno a kontakt uživatelů žijících ve Svitavách.]
SELECT person.name AS jméno, person.surname AS příjmení, account.email AS kontakt FROM person JOIN account ON person.id = account.id WHERE account.city='Svitavy';
