-- Triger pro generování identifikátoru piv
CREATE SEQUENCE ids;
CREATE OR REPLACE TRIGGER beer_id_generate
	BEFORE INSERT OR UPDATE ON beer
	FOR EACH ROW
BEGIN
	IF :new.id is null THEN
	   :new.id := ids.NEXTVAL;
	END IF;
END;

-- Triger pro vymazání záznamů o pivě z ostatních tabulek, pokud se vymaže pivo
CREATE OR REPLACE TRIGGER tst
BEFORE DELETE ON beer
FOR EACH ROW
BEGIN
DELETE FROM beer_rating WHERE beer_id = :old.id;
DELETE FROM offer WHERE beer_id = :old.id;
END;
