--SQL skript obsahující dotazy SELECT musí obsahovat konkrétně alespoň dva dotazy využívající spojení dvou tabulek, jeden využívající spojení tří tabulek, 
--dva dotazy s klauzulí GROUP BY a agregační funkcí, jeden dotaz obsahující predikát EXISTS a jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat). 
--U každého z dotazů musí být (v komentáři SQL kódu) popsáno srozumitelně, jaká data hledá daný dotaz (jaká je jeho funkce v aplikaci).
--------------------
-- 2x spojení 2 tabulek [2/2] DONE
-- 1x spojení 3 tabulek 
-- 2x GROUP BY + agregační fce [2/2] DONE
-- 1x EXISTS DONE
-- 1x IN + vnořený select
-- 7x popisky k čemu select spouží [5/7]

-- Nová hospoda ve Svitavách chce zaslat nabídku akcí místním uživatelům systému. [Zobraz jméno a kontakt uživatelů žijících ve Svitavách.]
SELECT person.name AS jméno, person.surname AS příjmení, account.email AS kontakt FROM person JOIN account ON person.id = account.id WHERE account.city='Svitavy';

-- Chceme porovnat, jak závisí hořkost výsledného piva na hořkosti chmelu. [Vypiš ke každému pivu jeho název, hořkost a hořkost použitého chmelu.]
SELECT beer.name AS název, beer.bitterness AS hořkost_piva, hop.bitterness AS hořkost_chmelu FROM beer LEFT JOIN hop ON beer.hop_id = hop.id;

--Chceme vědět, jak hodně jsou uživatelé aktivní v hodnocení piv. [Vypiš, kolik piv jednotliví uživatelé ohodnotili.]
SELECT  beer_rating.person_id as ID, CONCAT(CONCAT(person.name,' '), person.surname) as jméno, COUNT(beer_id) AS počet_hodnocení FROM beer_rating JOIN person ON beer_rating.person_id=person.id GROUP BY beer_rating.person_id, CONCAT(CONCAT(person.name,' '), person.surname);

--Chceme zjistit, jaká piva chutnají našim uživatelům nejvíce (sestavit žebříček). [Vypiš průměrné hodnocení jednotlivých piv a jejich názvy.]
SELECT beer_rating.beer_id AS id, beer.name AS název, AVG(beer_rating.taste + beer_rating.smell + beer_rating.foam) AS avg FROM beer_rating JOIN beer ON beer.id = beer_rating.beer_id GROUP BY beer_rating.beer_id, beer.name ORDER BY avg DESC;

--Uživatel si chce zajít Mouřenína, vypíšeme mu, v jakých hospodách ho čepují. [Zobraz hospody, kde čepují pivo s id=1.]
SELECT pub.name FROM pub WHERE EXISTS(SELECT pub_id FROM offer WHERE pub.id = pub_id AND beer_id = 1);
