begin;

SELECT 'TWROZENIE TABELE I INSERTOWANIE DANYCH';

DROP TABLE IF EXISTS uczestnicy CASCADE;
CREATE TABLE uczestnicy (
    id SERIAL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(20) NOT NULL,
    plec CHAR(1),
    data_urodzenia DATE NOT NULL,
    CHECK ((plec = 'M') OR plec = 'F')
);


DROP TABLE IF EXISTS autor CASCADE;
CREATE TABLE autor(
    id_uczestnika INT PRIMARY KEY,
    ilosc_pytan_odrzuconych INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_autor_uczestnicy
        FOREIGN KEY(id_uczestnika)
            REFERENCES uczestnicy(id)
);


DROP TABLE IF EXISTS kategorie CASCADE;
CREATE TABLE kategorie (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL UNIQUE
);


DROP TABLE IF EXISTS pytania CASCADE;
CREATE TABLE pytania (
    id SERIAL PRIMARY KEY,
    tresc TEXT NOT NULL,
    odpowiedz VARCHAR(40) NOT NULL,
    id_kategorii INT,
    CONSTRAINT fk_pytania_kategorie
        FOREIGN KEY(id_kategorii)
            REFERENCES kategorie(id)
);


DROP TABLE IF EXISTS autorzy_pytan CASCADE;
CREATE TABLE autorzy_pytan (
    id_autora INT,
    id_pytania INT,
    PRIMARY KEY(id_autora, id_pytania),
    CONSTRAINT fk_autorzy_patan_uczestnicy
        FOREIGN KEY(id_autora)
            REFERENCES uczestnicy(id),
    CONSTRAINT fk_autorzy_pytan_pytania
        FOREIGN KEY(id_pytania)
            REFERENCES pytania(id)
);


DROP TABLE IF EXISTS miejscowosci CASCADE;
CREATE TABLE miejscowosci (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL
);


DROP TABLE IF EXISTS adresy CASCADE;
CREATE TABLE adresy (
    id SERIAL PRIMARY KEY,
    miejscowosc INT NOT NULL,
    CONSTRAINT fk_miejscowosci_adresy
        FOREIGN KEY(miejscowosc)
            REFERENCES miejscowosci(id),
    ulica VARCHAR,
    kod_pocztowy VARCHAR(6) NOT NULL,
    numer_budynku VARCHAR(6),
    numer_mieszkania VARCHAR(6)
);


DROP TABLE IF EXISTS turnieje CASCADE;
CREATE TABLE turnieje (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL,
    opis TEXT NOT NULL,
    data_startu DATE NOT NULL,
    data_konca DATE NOT NULL,
    id_adresu INT,
    CONSTRAINT fk_turnieje_adresy
        FOREIGN KEY(id_adresu)
            REFERENCES adresy(id),
    CHECK (data_konca > data_startu)
);


DROP TABLE IF EXISTS typy_kar CASCADE;
CREATE TABLE typy_kar (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(20) UNIQUE NOT NULL
);


DROP TABLE IF EXISTS zespoly CASCADE;
CREATE TABLE zespoly(
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(20) NOT NULL,
    data_zalozenia DATE NOT NULL DEFAULT CURRENT_DATE,
    data_likwidacji DATE,
    CHECK (data_likwidacji > data_zalozenia)
);


DROP TABLE IF EXISTS "role" CASCADE;
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(20) UNIQUE NOT NULL
);


DROP TABLE IF EXISTS sklady_w_zespolach CASCADE;
CREATE TABLE sklady_w_zespolach(
    id_osoby INT NOT NULL,
    id_zespolu INT NOT NULL,
    id_turnieju INT NOT NULL,
    rola INT NOT NULL,
    PRIMARY KEY(id_osoby, id_zespolu, id_turnieju),
    CONSTRAINT fk_sklady_w_zespolach_uczestnicy
        FOREIGN KEY(id_osoby)
            REFERENCES uczestnicy(id),
    CONSTRAINT fk_sklady_w_zespolach_zespoly
        FOREIGN KEY(id_zespolu)
            REFERENCES zespoly(id),
    CONSTRAINT fk_sklady_w_zespolach_rele
        FOREIGN KEY(rola)
            REFERENCES ROLE(id),
    CONSTRAINT fk_sklady_w_zespolach_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id)
);

DROP TABLE IF EXISTS kary_dla_zespolow CASCADE;
CREATE TABLE kary_dla_zespolow(
    -- PRIMARY KEY nie jest potrzebny
    -- bo po co? - tak nie ma potrzeby(po chwyli przemyślenia)
    typ_kary INT NOT NULL,
    id_zespolu INT NOT NULL,
    id_turnieju INT NOT NULL,
    CONSTRAINT fk_kary_dla_zespolow_typy_kar
        FOREIGN KEY(typ_kary)
            REFERENCES typy_kar(id),
    CONSTRAINT fk_kary_dla_zespolow_zespoly
        FOREIGN KEY(id_zespolu)
            REFERENCES zespoly(id),
    CONSTRAINT fk_kary_dla_zespolow_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id)
);


DROP TABLE IF EXISTS nagrody CASCADE;
CREATE TABLE nagrody(
    id SERIAL PRIMARY KEY,
    opis VARCHAR(100) UNIQUE NOT NULL
);


DROP TABLE IF EXISTS nagrody_w_turniejach CASCADE;
CREATE TABLE nagrody_w_turniejach(
    id_nagrody INT NOT NULL,
    id_turnieju INT NOT NULL,
    miejsce INT NOT NULL,
    PRIMARY KEY(id_turnieju, miejsce),
    CONSTRAINT fk_nagrody_w_turniejach_nagrody
        FOREIGN KEY(id_nagrody)
            REFERENCES nagrody(id),
    CONSTRAINT fk_nagrody_w_turniejach_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id)
);


DROP TABLE IF EXISTS zmiany CASCADE;
CREATE TABLE zmiany (
    -- Chyba nie jest portzebny primary key
    -- trzeba tylko trigger dodać
    id_turnieju INT NOT NULL,
    id_zchodzacego INT NOT NULL,
    id_wchodzacego INT NOT NULL,
    numer_pytania INT NOT NULL,
    CONSTRAINT fk_zmiany_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_zmiany_uczestnicy_zchodzacy
        FOREIGN KEY(id_zchodzacego)
            REFERENCES uczestnicy(id),
    CONSTRAINT fk_zmiany_uczestnicy_wchodzacy
        FOREIGN KEY(id_wchodzacego)
            REFERENCES uczestnicy(id)
);


DROP TABLE IF EXISTS poprawne_odpowiedzi CASCADE;
CREATE TABLE poprawne_odpowiedzi(
    id_turnieju INT NOT NULL,
    id_zespolu INT NOT NULL,
    numer_pytania INT NOT NULL,
    PRIMARY KEY(id_turnieju, id_zespolu, numer_pytania),
    CONSTRAINT fk_poprawne_odpowiedzi_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_poprawne_odpowiedzi_zespoly
        FOREIGN KEY(id_zespolu)
            REFERENCES zespoly(id)
);


DROP TABLE IF EXISTS organizacja CASCADE;
CREATE TABLE organizacja(
    id_turnieju INT PRIMARY KEY,
    sedzia_glowny INT,
    organizator VARCHAR(30) NOT NULL,
    CONSTRAINT fk_organizacja_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_organizacja_uczestnicy
        FOREIGN KEY(sedzia_glowny)
            REFERENCES uczestnicy(id)
);


DROP TABLE IF EXISTS pytania_na_turniejach CASCADE;
CREATE TABLE pytania_na_turniejach(
    id_turnieju INT NOT NULL,
    id_pytania INT NOT NULL,
    PRIMARY KEY(id_turnieju, id_pytania),
    numer_pytania INT NOT NULL,
    CONSTRAINT fk_pytania_na_turniejach_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_pytania_na_turniejach_pytania
        FOREIGN KEY(id_pytania)
            REFERENCES pytania(id),
    CHECK ((numer_pytania > 0) AND (numer_pytania <= 36))
);

commit;

begin;

SELECT 'TWROZENIE WIDOKOW';
CREATE OR REPLACE VIEW role_zaangazowane AS
    SELECT id 
    FROM "role"
    WHERE id < 4;

commit;


-- Dodanie triggerów do
-- pytania_na_turniejach
begin;
-- Głowne zasady jak dodawać/updatować/usuwać pytania:
--    (numer - kolejność grania tego pytania na turnieju)
-- 1. Nie można dodać pytania, które już było na jakim kołwiek turnieju
-- 2. Dodawać można tylko pytanie o kolejnym numerze
-- 3. Przy update'cie nie może powstać sytuacja, że dwa pytania mają ten sam numer
-- 4. Przy usunięciu pytania, jeśli na turnieju obecnie nie ma pytania z taką kolejnością, 
--    to numery wszystkich pytań o wyższych numerach niż usunięte, zmniejszamy o 1

SELECT 'TWROZENIE TRIGGEROW DLA pytania_na_turniejach';

CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_juz_bylo_na_turnieju_insert()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.id_pytania IN (SELECT id_pytania FROM pytania_na_turniejach) THEN
        RAISE EXCEPTION 'Pytanie o id % było już grane. Nie można go dodac do turnieju %', NEW.id_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_juz_bylo_na_turnieju_update()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE FROM pytania_na_turniejach WHERE id_turnieju != NEW.id_turnieju AND id_pytania = NEW.id_pytania)
        OR 1 < (SELECT COUNT(*) FROM pytania_na_turniejach WHERE id_turnieju = NEW.id_turnieju AND id_pytania = NEW.id_pytania)    
    THEN
        RAISE EXCEPTION 'Pytanie o id % było już grane. Nie można go dodac do turnieju %', NEW.id_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_juz_granych_pytan1 ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_juz_granych_pytan1 BEFORE INSERT ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_juz_bylo_na_turnieju_insert();

DROP TRIGGER IF EXISTS sprawdzanie_juz_granych_pytan2 ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_juz_granych_pytan2 AFTER UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_juz_bylo_na_turnieju_update();

-- Jesli jego numer jest conajwyzej od delta wyżej niż maksymalny
CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_ma_poprawny_numer()
RETURNS TRIGGER
AS $$
BEGIN
    IF(TG_NARGS != 1) THEN
        RAISE EXCEPTION 'Niepoprawna ilość argumantów';
    END IF;

    -- RAISE NOTICE 'Tyo argumentu: %', pg_typeof(TG_ARGV[0])::oid;
    -- RAISE NOTICE 'Tyo argumentu: %', pg_typeof(TG_ARGV[0])::oid;
    -- RAISE NOTiCE 'Typ inta: %', 42::oid;
    -- IF(pg_typeof(TG_ARGV[0])::oid != 42::oid) THEN
    --     RAISE EXCEPTION 'Niepoprawny typ argumentu';
    -- END IF;

    IF NEW.numer_pytania != (
        SELECT COALESCE(MAX(numer_pytania), 0)
        FROM pytania_na_turniejach 
        WHERE id_turnieju = NEW.id_turnieju
        GROUP BY id_turnieju) + TG_ARGV[0]::INT
    THEN
        RAISE EXCEPTION 'Pytanie o id % na turnieju % ma niepoprawny numer %', NEW.id_pytania, NEW.id_turnieju, NEW.numer_pytania;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_numeru_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_numeru_pytania BEFORE INSERT ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_ma_poprawny_numer(1);


CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_ma_prawie_unikalny_numer()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT COUNT(numer_pytania) 
        FROM pytania_na_turniejach 
        WHERE id_turnieju = NEW.id_turnieju 
        AND numer_pytania = NEW.numer_pytania) > 1 
    THEN
        RAISE EXCEPTION 'Pytanie o id % na turnieju % ma niepoprawny numer %', NEW.id_pytania, NEW.id_turnieju, NEW.numer_pytania;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_prawie_unikalnosci_numeru_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_prawie_unikalnosci_numeru_pytania BEFORE UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_ma_prawie_unikalny_numer();


CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_ma_poprawny_numer_update()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.numer_pytania > (
        SELECT COALESCE(MAX(numer_pytania), 0)
        FROM pytania_na_turniejach 
        WHERE id_turnieju = NEW.id_turnieju
        GROUP BY id_turnieju)
    THEN
        RAISE EXCEPTION 'Pytanie o id % na turnieju % ma niepoprawny numer %', NEW.id_pytania, NEW.id_turnieju, NEW.numer_pytania;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_maksymalnego_numeru_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_maksymalnego_numeru_pytania BEFORE UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_ma_poprawny_numer_update();


CREATE OR REPLACE FUNCTION zmniejsz_numer_pytan()
RETURNS TRIGGER
AS $$
BEGIN
    RAISE NOTICE 'Zmniejszam numer pytania % na turnieju %', OLD.numer_pytania, OLD.id_turnieju;
    IF OLD.numer_pytania NOT IN 
        (SELECT numer_pytania 
        FROM pytania_na_turniejach 
        WHERE id_turnieju = OLD.id_turnieju) 
    THEN
        UPDATE pytania_na_turniejach
        SET numer_pytania = numer_pytania - 1
        WHERE id_turnieju = OLD.id_turnieju
        AND numer_pytania > OLD.numer_pytania;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS zmniejszanie_numerow_pytan ON pytania_na_turniejach;
CREATE TRIGGER zmniejszanie_numerow_pytan AFTER DELETE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE zmniejsz_numer_pytan();


CREATE OR REPLACE FUNCTION sprawdz_autora_pytania()
RETURNS TRIGGER
AS $$
DECLARE 
    autor_id INTEGER;
BEGIN
    autor_id := (SELECT id_autora FROM autorzy_pytan WHERE id_pytania = NEW.id_pytania);
    IF (SELECT TRUE 
        FROM sklady_w_zespolach 
        WHERE id_turnieju=NEW.id_turnieju 
        AND id_osoby=autor_id
        AND rola IN (SELECT id FROM role_zaangazowane))
    THEN
        RAISE EXCEPTION 'Autor pytania o id % jest zaangażowany w turniej o id %', NEW.id_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_autora_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_autora_pytania BEFORE INSERT OR UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_autora_pytania();

commit; 


begin;

SELECT 'TWROZENIE TRIGGEROW DLA ZMAIN/SKLADOW';

CREATE OR REPLACE FUNCTION sprawdz_czy_jest_max5_gracze()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT COUNT(*) FROM sklady_w_zespolach 
        WHERE id_zespolu = NEW.id_zespolu AND rola=1 
        AND id_turnieju=NEW.id_turnieju) > 5
    THEN
        RAISE EXCEPTION 'Zespół o id % ma już 5 graczy', NEW.id_zespolu;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_jest_max5_gracze ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_czy_jest_max5_gracze BEFORE INSERT OR UPDATE ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_jest_max5_gracze();


CREATE OR REPLACE FUNCTION sprawdz_czy_jest_max1_trener()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT COUNT(*) FROM sklady_w_zespolach 
        WHERE id_zespolu = NEW.id_zespolu AND rola=2
        AND id_turnieju=NEW.id_turnieju) > 1
    THEN
        RAISE EXCEPTION 'Zespół o id % ma już trenera', NEW.id_zespolu;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_jest_max1_trener ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_czy_jest_max1_trener BEFORE INSERT OR UPDATE ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_jest_max1_trener();


CREATE OR REPLACE FUNCTION sprawdz_czy_jest_max2_zapasowych()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT COUNT(*) FROM sklady_w_zespolach 
        WHERE id_zespolu = NEW.id_zespolu AND rola=3
        AND id_turnieju=NEW.id_turnieju) > 2
    THEN
        RAISE EXCEPTION 'Zespół o id % ma już 2 gracze zapasowe', NEW.id_zespolu;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_jest_max2_zapasowych ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_czy_jest_max2_zapasowych BEFORE INSERT OR UPDATE ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_jest_max2_zapasowych();


CREATE OR REPLACE FUNCTION sprawdz_czy_gra_w_turnieju_sklady()
RETURNs TRIGGER
AS $$
DECLARE
    moj_turniej turnieje%ROWTYPE;
BEGIN
    SELECT * INTO moj_turniej FROM turnieje WHERE id=NEW.id_turnieju;

    IF  (SELECT TRUE
         FROM sklady_w_zespolach
         WHERE id_turnieju=NEW.id_turnieju
         AND id_osoby=NEW.id_osoby
         AND id_zespolu!=NEW.id_zespolu)
         OR
        (SELECT TRUE
         FROM sklady_w_zespolach swz
         JOIN turnieje t ON swz.id_turnieju=t.id
         -- it was checked befor 
         WHERE swz.id_turnieju!=NEW.id_turnieju
         AND swz.id_osoby=NEW.id_osoby
         AND (moj_turniej.data_startu BETWEEN t.data_startu AND t.data_konca
            OR moj_turniej.data_konca BETWEEN t.data_startu AND t.data_konca)) 
        
    THEN
        RAISE EXCEPTION 'HERE';
    ELSEIF
        

        (SELECT TRUE
         FROM zmiany
         WHERE id_wchodzacego=NEW.id_osoby
         AND id_turnieju=NEW.id_turnieju) 
         
        OR

        (SELECT TRUE
         FROM zmiany z
         JOIN turnieje t ON z.id_turnieju=t.id
         -- it was checked befor WHERE z.id_turnieju!=NEW.id_turnieju
         WHERE z.id_wchodzacego=NEW.id_osoby
         AND (moj_turniej.data_startu BETWEEN t.data_startu AND t.data_konca
            OR moj_turniej.data_konca BETWEEN t.data_startu AND t.data_konca))
    THEN
        RAISE EXCEPTION 'Gracz o id % już gra w turnieju', NEW.id_osoby;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS sprawdzanie_czy_gra_w_turnieju_sklady ON sklady_w_zespolach;
-- CREATE TRIGGER sprawdzanie_czy_gra_w_turnieju__sklady BEFORE INSERT OR UPDATE ON sklady_w_zespolach
-- FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_gra_w_turnieju_sklady();

CREATE OR REPLACE FUNCTION sprawdz_autora_pytania_sklady()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE 
        FROM autorzy_pytan ap
        INNER JOIN pytania_na_turniejach pnt ON ap.id_pytania=pnt.id_pytania
        WHERE pnt.id_turnieju=NEW.id_turnieju
        AND ap.id_autora=NEW.id_osoby
        AND NEW.rola IN (SELECT id FROM role_zaangazowane))
    THEN
        RAISE EXCEPTION 'Autor % pytania jest zaangażowany w turniej o id %', NEW.id_osoby, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_autora_pytania ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_autora_pytania BEFORE INSERT OR UPDATE ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_autora_pytania_sklady();


CREATE OR REPLACE FUNCTION sprawdz_czy_zespol_istnial()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE 
        FROM zespoly 
        WHERE id=NEW.id_zespolu 
        AND data_zalozenia > (SELECT data_startu FROM turnieje WHERE id=NEW.id_turnieju))
    THEN
        RAISE EXCEPTION 'Zespół o id % nie istnial w czasie turnieju %', NEW.id_zespolu, NEW.id_turnieju;
    ELSEIF
        (SELECT TRUE
         FROM zespoly
         WHERE id=NEW.id_zespolu
         AND data_likwidacji IS NULL
         AND data_likwidacji < (SELECT data_konca FROM turnieje WHERE id=NEW.id_turnieju))
    THEN
        RAISE EXCEPTION 'Zespół o id % został już zlikwidowany kiedy truniej % odbyl sie', NEW.id_zespolu, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS sprawdzanie_istnienia_turnieju ON sklady_w_zespolach;
-- CREATE TRIGGER sprawdzanie_istnienia_turnieju BEFORE INSERT OR UPDATE ON sklady_w_zespolach
-- FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_zespol_istnial();


CREATE OR REPLACE FUNCTION sprawdz_wchodzacy_autor_pytania()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE 
        FROM autorzy_pytan ap
        INNER JOIN pytania_na_turniejach pnt ON ap.id_pytania=pnt.id_pytania
        INNER JOIN sklady_w_zespolach swz ON swz.id_zespolu=NEW.id_zespolu
        WHERE pnt.id_turnieju=NEW.id_turnieju
        AND ap.id_autora=NEW.id_wchodzacego)
    THEN
        RAISE EXCEPTION 'Autor % pytania jest zaangażowany w turniej o id %',NEW.id_osoby, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS sprawdzanie_wchodzacego_autor_pytania ON zmiany;
-- CREATE TRIGGER sprawdzanie_wchodzacego_autor_pytania BEFORE INSERT OR UPDATE ON zmiany
-- FOR EACH ROW EXECUTE PROCEDURE sprawdz_wchodzacy_autor_pytania();


CREATE OR REPLACE FUNCTION sprawdz_wczodzacy_zarejestrowany()
RETURNS TRIGGER
AS $$
BEGIN
    IF NOT EXISTS (SELECT * FROM sklady_w_zespolach
                   WHERE id_turnieju=NEW.id_turnieju AND id_osoby=NEW.id_wchodzacego AND rola=3)
    THEN
        RAISE EXCEPTION 'Osoba o id % nie jest zarejestrowana jako gracz zapasowy', NEW.id_wchodzacego;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_zapasowy_zarejestrowany ON zmiany;
CREATE TRIGGER sprawdzanie_czy_zapasowy_zarejestrowany BEFORE INSERT OR UPDATE ON zmiany
FOR EACH ROW EXECUTE PROCEDURE sprawdz_wczodzacy_zarejestrowany();


CREATE OR REPLACE FUNCTION sprawdz_wczhodzacego_zmiany()
RETURNs TRIGGER
AS $$
DECLARE
    moj_turniej turnieje%ROWTYPE;
    moj_zespol INT;
BEGIN
    SELECT * INTO moj_turniej FROM turnieje WHERE id=NEW.id_turnieju;
    SELECT id_zespolu INTO moj_zespol FROM sklady_w_zespolach WHERE id_turnieju=NEW.id_turnieju AND id_osoby=NEW.id_wchodzacego LIMIT 1;
    IF  (SELECT TRUE
         FROM sklady_w_zespolach
         WHERE id_turnieju=NEW.id_turnieju
         AND id_osoby=NEW.id_wchodzacego
         AND (rola!=3 OR id_zespolu!=moj_zespol))

        OR

        (SELECT TRUE
         FROM sklady_w_zespolach swz
         JOIN turnieje t ON swz.id_turnieju=t.id
         -- it was checked befor WHERE szw.id_turnieju!=NEW.id_turnieju
         AND swz.id_osoby=NEW.id_wchodzacego
         AND (moj_turniej.data_startu BETWEEN t.data_startu AND t.data_konca
            OR moj_turniej.data_konca BETWEEN t.data_startu AND t.data_konca)) 
        
        OR

        (SELECT TRUE
         FROM zmiany
         WHERE id_wchodzacego=NEW.id_wchodzacego
         AND id_turnieju=NEW.id_turnieju) 
         
        OR

        (SELECT TRUE
         FROM zmiany z
         JOIN turnieje t ON z.id_turnieju=t.id
         -- it was checked befor WHERE z.id_turnieju!=NEW.id_turnieju
         WHERE z.id_wchodzacego=NEW.id_wchodzacego
         AND (moj_turniej.data_startu BETWEEN t.data_startu AND t.data_konca
            OR moj_turniej.data_konca BETWEEN t.data_startu AND t.data_konca))
    THEN
        RAISE EXCEPTION 'Wchodzacy o id % już gra w turnieju', NEW.id_wchodzacego;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS sprawdzanie_czy_gra_w_turnieju_zmainy ON zmiany;
-- CREATE TRIGGER sprawdzanie_czy_gra_w_turnieju_zmainy BEFORE INSERT OR UPDATE ON zmiany
-- FOR EACH ROW EXECUTE PROCEDURE sprawdz_wczhodzacego_zmiany();


CREATE OR REPLACE FUNCTION sprawdz_zchodzacego_zmiany()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE 
        FROM sklady_w_zespolach
        WHERE id_turnieju=NEW.id_turnieju
        AND id_osoby=NEW.id_zchodzacego
        ) IS NULL
    THEN 
        RAISE EXCEPTION 'Zchodzacy o id % nie gra w turnieju o id %', NEW.id_zchodzacego, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_zchodzacy_byl_w_turnieju ON zmiany;
CREATE TRIGGER sprawdzanie_czy_zchodzacy_byl_w_turnieju BEFORE INSERT OR UPDATE ON zmiany
FOR EACH ROW EXECUTE PROCEDURE sprawdz_zchodzacego_zmiany();

commit;


begin;

SELECT 'TWROZENIE TRIGGEROW DLA poprawne odpowiedzi';

CREATE OR REPLACE FUNCTION sprawdz_numer_odpowiedzi()
RETURNS TRIGGER
AS $$
BEGIN 
    IF (SELECT TRUE FROM pytania_na_turniejach p 
        WHERE NEW.numer_pytania=p.numer_pytania AND NEW.id_turnieju=p.id_turnieju) IS NULL
    THEN
        RAISE EXCEPTION 'Pytanie o numerze % nie istnieje w turnieju o id %', NEW.numer_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_numeru_odpowiedzi ON poprawne_odpowiedzi;
CREATE TRIGGER sprawdzanie_numeru_odpowiedzi BEFORE INSERT OR UPDATE ON poprawne_odpowiedzi
FOR EACH ROW EXECUTE PROCEDURE sprawdz_numer_odpowiedzi();
commit;



COPY uczestnicy FROM STDIN DELIMITER ';' NULL 'null';
0;Blanka;Rzeźniczak;F;1984-06-20
1;Dariusz;Łyp;M;1998-07-27
2;Aurelia;Orkisz;M;2003-01-01
3;Malwina;Sarosiek;F;1990-05-26
4;Wojciech;Stanisławek;F;1967-11-07
5;Olgierd;Gałat;F;1975-08-14
6;Blanka;Zbylut;F;2003-06-22
7;Oliwier;Bujko;M;1984-07-31
8;Sebastian;Maćczak;F;1993-08-30
9;Albert;Sapała;M;1989-05-01
10;Maurycy;Soliwoda;F;1990-06-12
11;Tymon;Basista;M;2001-01-26
12;Jerzy;Ceran;F;1984-07-31
13;Tymoteusz;Ptok;M;1993-09-16
14;Oskar;Słowiak;F;2007-02-06
15;Łukasz;Rząca;M;1999-06-03
16;Rozalia;Helak;M;2011-11-10
17;Michał;Teper;F;1977-11-27
18;Maksymilian;Ziarno;F;2000-11-20
19;Filip;Pilipczuk;F;1996-12-23
20;Ryszard;Brejnak;F;2009-08-18
21;Bianka;Grotek;M;1985-03-22
22;Jeremi;Pielach;F;1992-06-07
23;Ksawery;Szkoda;F;2003-02-23
24;Igor;Lemanowicz;F;1989-07-16
25;Agnieszka;Kujda;M;1970-06-07
26;Nikodem;Prochownik;M;2004-02-14
27;Ksawery;Barteczko;M;2004-11-21
28;Maurycy;Kycia;M;1992-08-19
29;Grzegorz;Matyjas;M;1979-04-28
30;Marika;Rogal;F;1977-08-08
31;Daniel;Rajchel;M;1975-09-07
32;Przemysław;Solnica;M;1992-10-20
33;Wiktor;Obst;F;1967-08-09
34;Paweł;Zimniak;M;1976-11-14
35;Rozalia;Migoń;F;2004-05-16
36;Tola;Uliczka;F;1992-01-16
37;Konrad;Jędrasiak;M;1998-12-24
38;Apolonia;Płocharczyk;M;2010-03-24
39;Inga;Podpora;F;1965-10-12
40;Krystyna;Siekierka;F;1985-12-24
41;Liwia;Dawidek;F;1979-12-20
42;Olgierd;Geisler;F;1969-06-04
43;Miłosz;Mortka;M;1973-05-20
44;Bianka;Wikło;M;1981-07-28
45;Tobiasz;Jakoniuk;F;1984-04-10
46;Aurelia;Łudzik;M;2010-01-07
47;Emil;Mularz;M;1994-06-06
48;Bruno;Kotala;F;1970-04-14
49;Marcelina;Prokopczyk;F;1989-02-05
50;Natan;Wyroślak;M;1992-03-15
51;Sara;Gryta;F;1973-10-17
52;Mateusz;Hankiewicz;M;1976-06-23
53;Oliwier;Jałowiec;F;1975-06-16
54;Marcin;Rychel;F;1972-11-01
55;Gustaw;Gorol;M;1973-02-20
56;Franciszek;Usarek;M;1992-01-03
57;Michał;Plaskota;M;1979-02-26
58;Anastazja;Janoszka;M;2003-12-13
59;Karol;Składanek;M;1991-04-28
60;Dawid;Goss;M;1995-05-01
61;Julita;Łacina;F;1969-02-28
62;Inga;Stoch;F;1969-09-26
63;Jędrzej;Pierchała;F;2010-07-05
64;Olgierd;Sacharczuk;F;1974-09-07
65;Tymoteusz;Blaut;M;1992-10-10
66;Tadeusz;Maćczak;F;2003-01-04
67;Kornelia;Ligas;M;1998-06-16
68;Szymon;Ambrożewicz;F;1967-11-07
69;Antoni;Pacura;M;2007-10-24
70;Krystian;Smętek;M;1970-04-21
71;Fabian;Zaniewicz;M;2007-07-01
72;Jacek;Kuban;M;1967-11-24
73;Kajetan;Miśko;M;1986-01-21
74;Borys;Żakiewicz;M;1984-08-06
75;Olgierd;Krochmal;F;1984-05-29
76;Marcel;Chruszcz;M;2004-07-13
77;Alan;Parus;F;2001-02-15
78;Kaja;Pietrek;M;1979-06-29
79;Urszula;Mrozowicz;M;2004-11-13
80;Lidia;Gumienny;F;2007-09-02
81;Aurelia;Pusz;F;1977-07-10
82;Gaja;Mostek;F;1968-10-15
83;Lidia;Walasik;M;2003-05-30
84;Liwia;Zugaj;M;1966-04-14
85;Julianna;Filek;F;2001-08-09
86;Albert;Śnieg;F;1980-03-03
87;Jan;Piaseczna;M;1999-08-30
88;Mateusz;Krzysztofek;F;1976-09-24
89;Ryszard;Opioła;M;1972-09-27
90;Emil;Gęsiarz;M;1977-12-04
91;Mikołaj;Pyc;M;2009-09-24
92;Kaja;Burczak;M;1967-07-18
93;Stanisław;Gendek;F;1986-12-08
94;Gabriel;Derek;F;1979-04-14
95;Mikołaj;Suchora;F;1965-01-31
96;Ksawery;Kandzia;F;1975-12-21
97;Olgierd;Maciejko;M;1977-05-31
98;Nicole;Dziuban;M;1984-01-26
99;Kacper;Fiedoruk;M;1999-10-10
100;Dawid;Kocoł;M;1978-04-03
101;Ewelina;Parzyszek;F;1975-12-04
102;Julianna;Malon;F;1986-07-22
103;Janina;Jancewicz;M;1977-06-20
104;Karol;Bochnia;M;1978-07-03
105;Piotr;Sulich;M;1976-10-20
106;Piotr;Borzym;F;2011-10-14
107;Liwia;Tywoniuk;F;2007-12-06
108;Nikodem;Cop;M;1994-04-28
109;Adrian;Wąsek;M;1965-06-20
110;Marika;Kasak;M;1992-01-05
111;Nicole;Tadych;M;2000-12-01
112;Olga;Baum;M;1980-10-28
113;Klara;Prażmo;M;2002-08-15
114;Daniel;Łapot;M;1965-12-05
115;Rafał;Kumorek;F;1989-04-15
116;Mikołaj;Pazdan;M;2007-10-03
117;Kazimierz;Wojsa;F;2001-08-02
118;Urszula;Kunka;M;1978-11-02
119;Damian;Wardziak;M;1994-10-31
120;Kalina;Pleskot;M;2010-02-21
121;Dawid;Rymarz;F;1983-09-26
122;Anna Maria;Bakalarczyk;F;1980-06-02
123;Eliza;Smardz;F;1990-06-02
124;Julian;Bogusiewicz;F;2001-07-22
125;Sara;Zagrodnik;M;1979-10-02
126;Stefan;Chmara;M;1986-08-30
127;Wojciech;Salawa;M;2000-07-06
128;Anna Maria;Kuban;M;1968-03-02
129;Sonia;Pancerz;M;1990-02-11
130;Oliwier;Stosio;F;2003-06-17
131;Adrian;Pawlaczek;F;1998-04-14
132;Nikodem;Pietraś;M;2002-10-10
133;Juliusz;Dziewior;F;1971-07-28
134;Marcin;Gregorek;F;1987-08-24
135;Aurelia;Szybiak;F;1966-07-06
136;Nicole;Błaziak;M;1974-04-11
137;Jerzy;Piguła;M;1987-07-13
138;Melania;Raszkiewicz;F;1971-02-08
139;Jeremi;Minta;M;1979-10-16
140;Miłosz;Kieszek;M;1982-10-14
141;Nikodem;Manista;F;2003-06-14
142;Oskar;Budrewicz;F;1970-04-23
143;Leonard;Borysiewicz;F;1968-08-04
144;Elżbieta;Migała;M;1967-09-19
145;Damian;Grygorcewicz;M;2002-11-15
146;Nela;Kiryluk;F;1978-02-22
147;Kornel;Krzywonos;M;1966-02-14
148;Cezary;Morka;F;1965-01-15
149;Borys;Gołoś;M;1973-11-10
150;Radosław;Fuławka;M;1974-11-22
151;Julianna;Nyc;F;2001-02-15
152;Ewa;Maruszczyk;F;1990-08-11
153;Bartek;Bidas;M;1999-04-28
154;Rafał;Jaje;F;1975-01-25
155;Leonard;Romejko;F;1975-01-22
156;Patryk;Zapora;M;1967-04-30
157;Ada;Tórz;M;1995-01-07
158;Oskar;Drobek;M;2006-03-06
159;Dagmara;Juroszek;M;1991-01-24
160;Emil;Szmurło;F;2003-11-15
161;Sara;Suszko;M;1982-11-27
162;Wojciech;Zander;M;2004-12-28
163;Krystian;Elias;M;1987-01-19
164;Natasza;Nytko;F;2005-02-08
165;Nicole;Podsiadła;M;2007-08-29
166;Klara;Trzcionka;F;2001-05-02
167;Marika;Gawliczek;M;1984-02-05
168;Stefan;Gładka;M;1969-02-02
169;Adrian;Kotlarek;F;1998-04-17
170;Kamila;Muzyk;M;1990-01-17
171;Lidia;Wacław;M;1977-09-21
172;Marianna;Kuśka;M;1988-03-10
173;Fabian;Suszka;M;1998-02-23
174;Kalina;Pal;M;1998-05-03
175;Ada;Łaciak;M;2003-11-28
176;Marcel;Szymała;F;2005-05-05
177;Monika;Kurzyna;F;1994-12-12
178;Olga;Mikus;F;1988-11-12
179;Dagmara;Kniaź;M;2006-04-30
180;Aleks;Fronia;F;1992-04-16
181;Marek;Fita;F;1978-04-23
182;Kajetan;Apanowicz;F;1965-07-28
183;Nataniel;Kleinschmidt;M;1975-04-16
184;Sebastian;Mendyka;F;1976-08-13
185;Natan;Brodawka;F;1975-01-22
186;Leonard;Trybuś;M;1999-09-14
187;Inga;Bieleń;F;1996-06-21
188;Sonia;Karpiel;F;1990-01-08
189;Urszula;Jachimczyk;M;1966-06-07
190;Eliza;Kłysz;M;1996-03-17
191;Ignacy;Makieła;F;2011-09-21
192;Adrian;Giezek;F;2010-11-21
193;Natan;Chruszcz;M;1986-03-28
194;Jan;Teter;M;1983-09-07
195;Marika;Sopata;M;1987-05-30
196;Julian;Fuławka;M;1973-11-10
197;Kajetan;Darul;F;2001-12-18
198;Ewa;Zadka;M;1969-11-30
199;Nicole;Zięcik;F;1987-10-15
200;Lidia;Żmija;M;1973-11-27
201;Róża;Batóg;F;1973-06-18
202;Miłosz;Samoraj;F;1983-08-05
203;Blanka;Wojniak;M;1981-11-08
204;Gabriel;Judek;F;1967-06-27
205;Ada;Bukowiec;F;1982-05-25
206;Borys;Szkoda;M;2002-01-30
207;Mariusz;Pitura;M;1971-03-24
208;Anna Maria;Satora;M;1979-12-24
209;Jan;Chowaniak;M;2006-12-18
210;Szymon;Kopa;F;1990-12-03
211;Tadeusz;Piesik;F;1983-08-05
212;Damian;Futyma;M;2004-11-15
213;Michał;Łapot;F;1985-04-28
214;Agnieszka;Wendt;F;2008-10-27
215;Robert;Samol;F;1992-01-08
216;Marika;Polakiewicz;M;2009-07-08
217;Jan;Łuc;M;2010-02-22
218;Elżbieta;Doroba;M;1988-11-24
219;Nataniel;Stryjek;M;1972-10-16
220;Mateusz;Dzienis;M;1983-07-27
221;Robert;Folta;F;1985-01-04
222;Apolonia;Słabosz;M;1973-10-24
223;Maurycy;Skolik;F;1988-02-10
224;Marika;Bujko;M;2006-09-03
225;Ryszard;Szulim;F;2005-06-16
226;Alan;Megger;F;1979-08-21
227;Jakub;Pyć;M;1999-11-06
228;Dariusz;Cecot;M;1973-04-19
229;Elżbieta;Majdak;M;1992-08-19
230;Marika;Gryska;F;1983-12-19
231;Natan;Majos;M;1981-09-03
232;Kamil;Surdel;F;2005-03-10
233;Alex;Kałek;F;1978-06-30
234;Justyna;Tecław;M;2000-07-28
235;Cyprian;Frydel;F;1977-11-09
236;Stefan;Rećko;M;1986-09-23
237;Dorota;Szeszko;F;2007-09-22
238;Łukasz;Burczak;F;2007-12-13
239;Marika;Kapciak;M;1979-09-07
240;Radosław;Kornek;M;1980-06-27
241;Dawid;Strzępek;F;1980-03-03
242;Konrad;Moczko;M;1981-01-28
243;Norbert;Szulim;F;1978-04-22
244;Rozalia;Nieborak;F;1972-11-27
245;Monika;Szczepaniec;F;1965-11-22
246;Elżbieta;Larysz;M;1975-01-16
247;Piotr;Matyka;F;1991-11-06
248;Jan;Smektała;M;1998-12-22
249;Blanka;Korbel;M;1997-07-28
250;Szymon;Dejneka;M;1996-09-10
251;Marika;Zys;F;1988-02-17
252;Fryderyk;Dreszer;F;1965-01-07
253;Melania;Niemira;M;1973-07-29
254;Igor;Kopyto;M;1994-12-12
255;Justyna;Sojda;M;1971-05-29
256;Konrad;Kielich;F;2002-01-02
257;Jędrzej;Przewoźniak;F;1994-12-16
258;Cezary;Piesik;M;1991-04-27
259;Anita;Koziatek;M;1992-05-02
260;Józef;Misiuk;M;1992-11-28
261;Maurycy;Drobek;M;2001-07-17
262;Krystyna;Witko;M;1981-04-12
263;Cezary;Grzela;M;1991-04-22
264;Witold;Mały;F;2000-08-17
265;Cyprian;Żołądkiewicz;F;1981-12-03
266;Marika;Paleń;M;1967-10-13
267;Klara;Moneta;F;1970-07-15
268;Marek;Dylik;F;2009-08-13
269;Karol;Wasążnik;F;1989-02-22
270;Hubert;Serwach;M;2004-03-19
271;Leonard;Rolek;M;2006-09-01
272;Lidia;Machoń;M;1966-08-12
273;Tymoteusz;Ziniewicz;F;1999-09-09
274;Natasza;Jeżyna;M;1973-03-12
275;Janina;Frącz;M;2001-03-24
276;Bartek;Pęciak;F;1965-09-26
277;Liwia;Buksa;M;1999-11-19
278;Michał;Laszuk;M;1966-01-11
279;Olga;Skup;M;1998-02-12
280;Alan;Fitrzyk;M;1984-08-06
281;Julian;Baranowicz;M;1976-08-09
282;Cyprian;Plizga;M;1972-09-23
283;Tomasz;Lelonek;F;2000-06-20
284;Arkadiusz;Hankiewicz;M;1998-07-12
285;Nela;Stoltmann;F;2000-10-10
286;Adrian;Jonik;M;1994-02-24
287;Nicole;Pazoła;M;1974-03-14
288;Justyna;Duszczyk;M;2010-09-02
289;Leon;Maszota;F;1980-03-30
290;Ryszard;Miozga;M;1980-07-01
291;Krzysztof;Jargiło;F;1967-11-03
292;Albert;Kolber;F;1986-06-22
293;Olaf;Bartuś;F;1977-12-04
294;Kamila;Szymajda;F;1998-10-20
295;Mateusz;Gubernat;M;1976-11-16
296;Roksana;Piekacz;F;1988-06-01
297;Aniela;Łuczyk;F;1986-09-12
298;Nikodem;Sadlik;F;1981-06-07
299;Bianka;Wlizło;F;2002-08-19
\.



COPY autor FROM STDIN DELIMITER ';' NULL 'null';
0;20
1;21
2;10
3;20
4;21
5;15
6;16
7;16
8;16
9;16
10;18
11;17
12;12
13;12
14;23
15;24
16;21
17;24
18;12
19;20
20;21
21;19
22;19
23;16
24;11
25;17
26;14
27;14
28;18
29;17
200;21
201;13
202;20
203;16
204;15
205;21
206;8
207;32
208;11
209;23
\.



COPY kategorie FROM STDIN DELIMITER ',' NULL 'null';
0,Sport
1,Literatura
2,Historia
3,Geografia
4,Nauka
5,Muzyka
6,Sztuka
7,Kino
8,Polityk
9,Technologia
10,Inne
\.


COPY pytania FROM STDIN DELIMITER ';' NULL 'null';
1;Po 1582 roku, SUCH jest najczęstszym odpowiednikiem HER. SHE i SUCH zostały połączone w tytule serialu grozy w reżyserii Seana Cunninghama. Odtwórz ten tytuł składający się z dwóch słów.;Friday 13th;7
2;Program informacyjny Channel One w dniu 14 maja 2011 roku mówił o bajkowym przedstawieniu obiecanym przez organizatorów ceremonii prezentacji zegarków olimpijskich w Soczi. Zostały one zamontowane, gdy do otwarcia Olimpiady pozostało dokładnie DWADZIEŚCIA MIESIĘCY. Jakie słowa zastąpiliśmy w tekście pytania słowem "TWENTY MONTHS"?;tysiąc i jedna noc;1
3;W chińskim mieście Xian znajduje się pagoda dzikiego YIH. Według legendy pewien mnich modlił się o pomoc podczas wielkiego głodu. I niebo zesłało jedzenie dla pobożnego starca. Kilka tłustych IH wpadło prosto w jego ręce. Podobną historię opowiadał Munchausen, a w jednej z europejskich stolic postawiono im pomnik. Wymień ich imię i nazwisko.;gęsi;2
4;Budując hotel w pobliżu lotniska w Chicago, właściciele zadbali o wszelkie możliwe udogodnienia dla HER. Jednak wkrótce po zajęciu hotelu musieli zainstalować dodatkowe urządzenia, które imitowały szmer fal morskich i rzecznych, szum gałęzi i ciche wycie wiatru. Wymień EE.;izolacja akustyczna;10
5;Projektant Vadim Kibardin stworzył manipulator przeznaczony do walki z dolegliwością zwaną zespołem cieśni nadgarstka. Nazwa tego manipulatora jest taka sama jak tytuł dzieła, którego premiera odbyła się w 1874 roku. Podaj autora tego dzieła.;[Johann] Strauss;5
6;W czasach starożytnych wiele ludów świata przy pochówku oddawało SWOJE ciała. HE odróżnia motocyklistę na motocyklu sportowym, znacznie bardziej niebezpiecznym od innych motocykli, od pozostałych motocyklistów. Wymień JEJ nazwę w dwóch słowach.;pozę embrionalną;10
7;Na opakowaniu słuchawek znanego kanadyjskiego projektanta znajduje się pięć cienkich, poziomych linii równoległych do siebie. Same słuchawki są ułożone tak, aby przypominały THEY, co znajduje odzwierciedlenie w nazwie modelu. Uważa się, że THEY po raz pierwszy pojawiły się w XI wieku. Podaj jedno słowo oznaczające THEY.;noty;9
8;O NIM mówiło się w latach 20. ubiegłego wieku. ONO bylo tematem rozprawy doktorskiej, w której lekarz Caroline Sjönger Philip doszła do wniosku, że immunoalergiczna bronchopneumopatologia jest faktycznie przyczyną zgonów ludzi. Nazwij JEGO w dwóch słowach.;klątwa faraonów;2
9;Baron Robert Baden-Powell uważał, że ludność kolonii powinna być rządzona żelazną ręką, a jeśli jej siła nie zostanie zauważona, ZROBIĆ TO. Etykieta wymaga, aby mężczyzna podczas powitania zrobił TO, ale kobieta nie. Które dwa słowa zastąpiliśmy słowem ZROIC TO?;zdjąć rękawicę;2
10;Komentując porażkę Barcelony z AC Milan, portal championat.com zauważył, że Messi jakby przeniósł się do NIEGO. Inna strona nazwała EGO cudownym kwiatem chińskiej sztuki ludowej. Nazwi EGO za pomocą dwóch słów;teatr cieni;0
11;Elektroniczny alfabet dziecka autorów po naciśnięciu mówi literę, a następnie słowo na tę literę i dźwięk związany z tym słowem. Na przykład Ch - zegar, tykanie, SH - szczeniak, szczekanie. W jednym przypadku dźwięk związany z wypowiadanym słowem jest taki sam jak samo słowo i powtarza się trzykrotnie. Napisz to krótkie słowo.;echo;10
12;Kolizja dwóch samochodów w norweskim miasteczku Bjarkøy, położonym na wyspie w archipelagu Västerålen, od dawna jest omawiana w prasie i nic dziwnego. TAKI samochód i TAKA ciężarówka zderzyły się na TAKIEJ ulicy. Które słowo zastąpiliśmy słowem TAKI?;jedyny;10
13;inventore accusamus labore adipisci iusto voluptates ducimus cupiditate quam magnam ipsum consequuntur cumque excepturi distinctio harum facere ex vel minima consectetur et repellat maiores pariatur assumenda voluptatum delectus esse aliquam error quasi ad;porro;1
14;quo repudiandae voluptates deleniti architecto sit rem temporibus ex expedita eius cupiditate neque praesentium provident reprehenderit nobis in sequi quasi obcaecati exercitationem facilis doloremque maxime minima repellat molestias quaerat dignissimos repellendus recusandae omnis nulla accusantium nemo natus est distinctio ad amet cum eos;ipsa;1
15;illo atque tenetur voluptate voluptas explicabo enim cum dolor dolorum facilis culpa hic nesciunt quos vitae eum dignissimos unde amet praesentium ducimus porro quaerat possimus voluptatibus totam similique at id quae;veniam;6
16;impedit a dolor earum animi iste perferendis eligendi sapiente ullam ducimus culpa omnis veniam voluptates qui nam iure excepturi sit error neque officia obcaecati nobis necessitatibus ex illo repellendus dolorem laudantium tempora consectetur corporis accusantium quaerat alias cupiditate ut reiciendis blanditiis repudiandae non;soluta;5
17;dolorem eligendi maiores consequatur nulla sed amet nesciunt harum praesentium distinctio obcaecati at tenetur illo cupiditate dignissimos dolore quam quibusdam id aspernatur voluptates quisquam animi modi saepe soluta alias porro architecto perspiciatis ex nobis;eaque;5
18;earum nisi ut exercitationem ducimus dolore fuga vero soluta reiciendis harum eligendi eius omnis itaque ad iusto deserunt quod beatae voluptate nam alias cumque incidunt impedit accusamus totam ipsum sint recusandae modi velit enim magnam quos ratione quae quas in id autem dignissimos aperiam minima facilis rerum saepe facere suscipit;pariatur;3
19;fuga consequuntur tempora architecto illo magni odit corrupti aspernatur id perferendis tenetur similique minima delectus saepe reprehenderit suscipit dolor aliquam deserunt corporis et velit quisquam dolores cumque amet sit explicabo animi accusamus maiores doloribus eum expedita non distinctio enim eos totam quis quas at voluptatum veritatis cupiditate est;ipsam;9
20;repudiandae in ipsa accusamus deleniti suscipit rem iusto illum nisi fugit recusandae sequi odit saepe incidunt labore odio quaerat hic consectetur similique animi aperiam necessitatibus tempora sit quod nobis quae sed exercitationem impedit a accusantium officia;illo;1
21;labore adipisci iure quis fuga commodi laborum velit iusto fugiat cupiditate qui fugit ipsum esse quisquam nobis consequuntur est ut minima quibusdam et officia amet temporibus ipsam pariatur nulla exercitationem voluptatum cum nemo facere debitis corrupti distinctio in repudiandae blanditiis aliquam aut asperiores excepturi provident;voluptates;1
22;quos animi quasi nisi odio ad corporis eaque impedit deserunt magni quibusdam tenetur id voluptatibus est alias at dignissimos ipsam eum sed quisquam aut ut excepturi nulla optio aspernatur accusantium minima officiis temporibus natus cumque voluptatum iure minus neque soluta eius vero voluptatem reiciendis nostrum atque asperiores hic quia fugit;assumenda;8
23;quis unde sunt odio at cumque nisi maxime soluta quae laboriosam quod accusamus vero ratione dolor recusandae aperiam facilis distinctio voluptas velit vel sapiente nemo consequatur eius in mollitia nihil hic;culpa;3
24;suscipit quae voluptates quibusdam provident ipsa delectus voluptas autem architecto alias sunt facere optio ducimus ullam deserunt aut quis laborum unde totam est laudantium numquam quia placeat illum itaque amet corrupti ipsum vitae repudiandae tempora rem sequi dicta dolore;commodi;8
25;distinctio error non exercitationem praesentium voluptate numquam architecto corporis sint qui odit quaerat alias reiciendis repudiandae vitae molestiae necessitatibus provident rem illo recusandae atque ab eaque ut ratione eius dolorum odio dolores officiis animi quia a mollitia at iure nemo obcaecati dicta quidem sapiente modi deserunt quam;perspiciatis;0
26;cum maxime deleniti cupiditate incidunt quo soluta provident blanditiis quisquam sapiente libero consequatur temporibus repudiandae officiis aut esse delectus earum voluptatum adipisci dolorem molestiae repellat similique veritatis id illum quae saepe ipsam ducimus laudantium reiciendis dolores reprehenderit ipsa exercitationem;adipisci;0
27;eius et quisquam libero iste dolorum totam repellendus fuga veniam aut laudantium voluptatum cumque sit maiores exercitationem fugit voluptatem facere consectetur consequuntur ipsam similique neque culpa quae rem numquam magnam;deserunt;0
28;sequi alias vel quos placeat atque ratione totam fugiat ea sed commodi expedita recusandae minus et laboriosam molestiae perspiciatis quasi nisi a praesentium ab autem eius laudantium quis maxime quibusdam incidunt laborum voluptate aperiam impedit;reprehenderit;7
29;odit tenetur itaque dicta culpa assumenda quam quod impedit nisi voluptas similique sequi voluptatum corporis cupiditate quibusdam rerum quos pariatur rem officia dignissimos sint corrupti molestiae accusantium quaerat aliquid quis iusto soluta praesentium distinctio eveniet recusandae;perspiciatis;1
30;quis obcaecati laudantium ullam rem debitis dolor quo animi deleniti aperiam provident asperiores cum facilis magni quaerat ad veritatis nemo facere deserunt eos minima quae ratione tempore hic labore optio totam assumenda sequi dolore ea quas velit error alias;dicta;6
31;officiis temporibus pariatur ratione ab deserunt reprehenderit reiciendis at voluptas hic eius impedit dolore quod nihil eum porro rem est labore sapiente necessitatibus eveniet accusamus magni cum iure quaerat iusto;totam;5
32;reiciendis sequi praesentium eligendi suscipit voluptatem tenetur consequuntur corrupti quia hic similique alias ipsam laudantium quam illo aperiam porro minus excepturi dolor neque repellat tempore blanditiis magni pariatur exercitationem itaque adipisci perferendis magnam fuga fugiat odio officiis doloremque eius nisi dignissimos perspiciatis voluptatibus corporis atque omnis modi tempora repellendus;velit;10
33;tenetur facilis ipsum ab officia quia error ex saepe consequuntur ullam vel illo doloremque autem beatae minima animi aspernatur necessitatibus vitae eaque accusantium accusamus possimus debitis ipsam nobis tempora voluptatibus quos quisquam iste non magnam similique eum numquam cum temporibus recusandae delectus sit maxime;alias;8
34;illum sit et non quisquam sapiente eligendi molestias architecto ipsam in incidunt esse quidem nostrum cumque temporibus officia voluptas aliquam eveniet ut necessitatibus fugit eius dolore natus accusamus labore maxime enim beatae ex mollitia omnis molestiae;explicabo;1
35;minima tempora magnam doloribus dolor saepe quas culpa omnis doloremque deserunt quis eius mollitia laudantium illum eveniet iusto eos necessitatibus est cum delectus dolorem nostrum cumque odit veritatis consectetur provident quibusdam aut nam;vitae;6
36;voluptatibus sequi molestias earum veritatis ipsa deserunt nihil cumque ab recusandae praesentium exercitationem expedita dolorum illo excepturi quaerat odit iste modi sit minus odio animi vero facere illum sapiente aliquid ex voluptas accusantium veniam cum quasi delectus magni in debitis error quibusdam libero pariatur placeat perspiciatis voluptatum autem;praesentium;9
37;ullam cum quam vero animi nisi provident possimus atque reiciendis incidunt odit voluptatibus fugit nihil est voluptatum accusamus perspiciatis non explicabo assumenda eos a eveniet harum voluptatem aut voluptas at sint;enim;9
38;atque et voluptatum itaque quis voluptate dolor voluptas iure tenetur aliquid molestiae perspiciatis quae modi minus alias qui iusto vitae officia aut sint reprehenderit doloribus nihil tempore ullam ea laboriosam accusamus corporis quod est natus eveniet quos cum adipisci temporibus harum;qui;10
39;rerum voluptatem voluptatum a provident cumque dolorem eius necessitatibus consectetur nihil laborum maiores ipsa excepturi magnam illo iure nulla ipsam officia odit eum odio repellendus earum quisquam amet eligendi quos atque alias quia natus;dolore;10
40;quo tempora quia eos dolore nemo mollitia sed iure nulla incidunt obcaecati nam at cupiditate iusto dolor dolorum ab omnis dolores sapiente necessitatibus ullam ipsam officiis velit quibusdam minus repellat;nihil;5
41;voluptatum hic harum beatae aliquid delectus reprehenderit nisi atque facilis impedit reiciendis mollitia temporibus tempora alias nihil id quam quia omnis soluta odit doloremque accusantium blanditiis cupiditate pariatur eum ex adipisci corrupti repellendus maxime non in perferendis quasi odio quos quis illo;debitis;9
42;molestias repudiandae doloremque nihil velit dignissimos earum cum voluptate ab non pariatur id minus eos necessitatibus nobis officia nulla hic sapiente repellat et consequuntur nostrum deleniti autem officiis quas magnam aut deserunt mollitia fugit aperiam enim dolor saepe distinctio quibusdam ullam quam laudantium eum veniam exercitationem nemo corrupti quis;eveniet;8
43;doloribus voluptates eos eius esse illum repellendus a repellat atque consectetur dolore laboriosam velit consequatur ducimus hic libero ratione exercitationem delectus quaerat eligendi recusandae officiis corporis ullam minus eveniet amet;laudantium;9
44;neque inventore consequatur unde iste deleniti labore nam recusandae ipsam natus animi error pariatur debitis quas laudantium distinctio omnis reiciendis nesciunt necessitatibus atque nobis ex dolor reprehenderit eaque fugiat qui totam ea laborum minus adipisci harum;tempore;5
45;architecto commodi nemo delectus tenetur laboriosam ratione culpa mollitia soluta quas doloribus quibusdam similique perferendis aliquid amet esse repellat placeat ipsum labore quos quae voluptatum magni neque ducimus ipsam necessitatibus aliquam;quaerat;2
46;praesentium accusamus sunt placeat et eligendi autem sapiente iusto debitis ipsam blanditiis mollitia vero quis sit maiores repudiandae magnam minus eum hic consequatur vel sequi officiis culpa suscipit quisquam reprehenderit dolorum consequuntur deserunt voluptate aperiam a optio earum odit molestiae deleniti veniam;tempore;3
47;corrupti earum repellat voluptatibus ducimus accusantium rerum vel possimus consequatur quo excepturi delectus fuga vero eius ex amet inventore impedit ipsa soluta tempore quisquam odit alias numquam ipsum ullam vitae voluptas sapiente in magnam ea et quia;a;9
48;quia ipsa cumque in mollitia consequuntur minus fugit commodi tenetur eaque molestiae aliquid et nihil aspernatur assumenda enim a iusto optio est similique dolor laborum illo provident laudantium magnam tempora;tempora;10
49;reiciendis officia ducimus illo repellendus quae nihil sequi magnam alias aliquam et quia expedita id sed ipsam totam ad minima laudantium voluptas nobis at eveniet amet debitis facilis ratione ipsa accusamus nesciunt delectus autem numquam exercitationem beatae iste;adipisci;2
50;distinctio exercitationem corporis illum molestiae ipsa laudantium architecto dolores accusamus iusto consequuntur aut culpa quaerat expedita cupiditate quam consequatur animi non suscipit unde sunt corrupti accusantium dolorum commodi recusandae minima at esse assumenda doloribus delectus repudiandae totam;iste;6
51;obcaecati excepturi sapiente esse aperiam mollitia numquam eveniet eius deserunt sed in aut explicabo provident magni reprehenderit assumenda doloremque sunt sequi omnis cum fugit adipisci voluptates similique eaque impedit officia accusamus molestiae quia perferendis iure id error consequuntur ipsam;possimus;3
52;doloribus perspiciatis nobis magni repellendus adipisci eligendi earum corrupti et consequuntur aspernatur animi quidem fuga iste esse minus amet fugit eos accusamus nesciunt commodi dolor deleniti ad aut voluptas nemo cupiditate fugiat;fugiat;3
53;temporibus et dolorem exercitationem similique culpa laboriosam ipsum recusandae vel quaerat tenetur error architecto voluptatibus illo magni blanditiis corporis asperiores aliquid aliquam impedit aspernatur non provident quidem delectus veniam reiciendis ab minus corrupti labore quis quasi repudiandae sit sapiente aut odio;quasi;10
54;perspiciatis sapiente asperiores ut quae modi placeat amet veritatis itaque tenetur impedit ab corporis perferendis nulla iste ratione quam cum aperiam distinctio mollitia at quis et ullam neque a consequatur;exercitationem;9
55;officia fugit magnam veniam tempore dicta aperiam maiores sit id ipsam perspiciatis laboriosam maxime assumenda similique eius eum vero illum quidem quas voluptate vitae saepe inventore dolores esse voluptatem facere nisi rerum accusamus culpa laborum labore nulla quos velit ad;ipsam;4
56;amet eius laudantium nihil facere error ipsa doloribus illum omnis obcaecati maxime ducimus laborum autem aliquid quaerat deleniti quos sapiente quibusdam ut ea reiciendis harum doloremque sed illo animi dignissimos cum nesciunt sint recusandae aspernatur ex accusantium enim vel architecto alias blanditiis commodi incidunt placeat voluptatum earum itaque minus pariatur;architecto;2
57;exercitationem assumenda adipisci perferendis distinctio repellendus ab ducimus praesentium aspernatur dicta rem fugit voluptatem minus iure nobis dolores dignissimos eveniet esse doloremque consequuntur laboriosam ipsa alias asperiores nostrum nemo debitis obcaecati;sit;5
58;cupiditate quo quisquam porro dolor perferendis pariatur facilis neque quam delectus cum nesciunt excepturi laboriosam ipsa a repellat quia natus totam itaque quidem id voluptatem placeat sit veritatis molestias nemo velit ratione sunt assumenda tempora modi eius vero voluptates corrupti nisi praesentium saepe aspernatur beatae;et;5
59;rem nobis accusantium voluptates eius iure ipsam inventore alias a dolores eligendi at amet beatae temporibus vel aliquid aliquam facere ratione fugit aperiam animi maiores quod fugiat blanditiis voluptatum nihil modi eveniet dolorem cumque vero natus aut;quia;4
60;eveniet quas eligendi aliquid nesciunt rem doloribus expedita quasi quidem quo necessitatibus cum veritatis voluptatem voluptates consequatur debitis earum nam placeat enim accusantium illo qui labore quis id explicabo fugit atque ducimus reprehenderit natus optio odio nihil sapiente tempora iusto beatae et distinctio;voluptatem;0
61;ex animi fugiat mollitia nobis molestiae at deserunt aperiam impedit ut quisquam eaque adipisci vitae minima ad eius ipsa explicabo voluptatibus rem reprehenderit quam veniam facilis temporibus nostrum quod voluptas alias non ipsam aspernatur quos omnis quis rerum odit officia commodi cum consectetur libero dolor pariatur aliquam magnam cumque;autem;1
62;similique tempore expedita possimus voluptates ipsum at molestiae sed velit dolores dignissimos quibusdam sapiente ipsam quisquam libero laborum consectetur in quia dolorem perferendis nihil voluptatibus quod inventore laudantium eos harum dolor iste quis aliquam beatae illum mollitia iusto quidem nam architecto numquam hic;porro;7
63;sed quidem natus porro sint iusto voluptates quibusdam quam nobis voluptate ad repellat a distinctio totam deleniti rem nesciunt aut mollitia reiciendis dicta officia laborum quaerat ea fugit aliquid ab tempore nihil corporis quis eos culpa;illo;0
64;aliquam quaerat eligendi nostrum architecto eum fugiat incidunt aperiam officia aut vitae sint perspiciatis provident harum eaque id iure alias eveniet deserunt impedit delectus nesciunt quam doloribus ea placeat dicta voluptatem amet consequatur nemo nulla sapiente officiis eos non quis corrupti libero ab;quis;4
65;molestias itaque in laborum distinctio laboriosam iure consectetur voluptas ipsam dicta assumenda nemo aliquid eos optio debitis veritatis pariatur autem at praesentium iusto cupiditate nam id reiciendis ducimus magnam porro placeat sapiente hic omnis nulla officia vitae commodi enim eligendi dolorem non nisi ipsa deleniti illo exercitationem repudiandae;placeat;8
66;distinctio earum consequuntur magnam dolorum natus sit repudiandae ipsa fugiat minima non eaque saepe est ut quos temporibus pariatur numquam quas nihil similique atque delectus blanditiis excepturi fugit labore quam tempora modi quaerat quis velit;totam;9
67;quis quidem quod quibusdam non atque ut consequuntur alias eveniet ullam delectus velit doloribus temporibus voluptatem facere nobis molestias a odit facilis impedit deleniti sunt nemo nostrum harum labore dolorem eaque minus voluptatum;exercitationem;2
68;alias laborum quis beatae ad dolore eius aut doloribus perspiciatis dolorum vel dolor facere illum animi maxime non neque asperiores commodi quia esse tempora necessitatibus recusandae dignissimos vitae deserunt iusto aperiam sunt voluptatibus sit eveniet repellat tenetur quos est deleniti ex natus;recusandae;9
69;temporibus impedit illo error iste magni eius fuga ratione explicabo enim recusandae consequatur ex earum non in nam optio laboriosam fugit possimus iusto velit hic doloribus repellat suscipit ducimus dolorum fugiat expedita minima vitae libero soluta necessitatibus voluptas dolores quos;voluptate;6
70;ex labore incidunt minima veritatis libero expedita error culpa ad hic obcaecati alias vel ipsam rerum quos delectus optio eos deleniti a eveniet ducimus temporibus eaque quam eius dolorum itaque;provident;0
71;quis corrupti repellendus numquam officiis sint eos dolores sequi architecto totam aperiam doloribus quo consequatur aliquam fuga fugit libero nobis necessitatibus velit voluptas magni nostrum odio ea dolore inventore adipisci vel repellat possimus similique;quod;10
72;ducimus eius iste minus suscipit modi nobis sunt explicabo totam et soluta eligendi officia quo iusto aperiam repellendus ipsam voluptates consequatur sit similique obcaecati laborum eaque illum corporis non libero minima quisquam odit nihil;reiciendis;9
73;laboriosam suscipit illo similique nihil quod dolor minima harum vitae voluptatum voluptate mollitia rem earum facere amet provident veniam numquam officiis itaque velit doloribus accusamus porro optio incidunt sunt fugiat;quos;4
74;fuga pariatur in adipisci perspiciatis cumque commodi velit nemo laborum sapiente quam suscipit aut eaque minima enim magnam provident et deleniti qui autem voluptates praesentium exercitationem assumenda eum ipsum perferendis iste ea;error;1
75;molestias odit accusantium repudiandae minus eum cumque assumenda quisquam facere repellat nam inventore at corporis voluptatibus harum quas repellendus quidem quo hic distinctio voluptates quasi atque mollitia dolorum aspernatur autem accusamus quod;ullam;5
76;consectetur eos odit voluptas unde culpa cum quam consequuntur perferendis dolor molestias accusamus beatae quisquam vero qui dolorem quibusdam animi ratione impedit natus doloribus vitae reprehenderit at sapiente et suscipit fugit aliquam itaque placeat nulla illum consequatur hic asperiores repudiandae sunt;quam;4
77;vero voluptatem fugit voluptatum deserunt aliquid fugiat earum debitis laborum placeat voluptatibus voluptate dignissimos nesciunt dolorem quod officia necessitatibus in voluptas iste atque quo veniam quidem aperiam quis reprehenderit illum;ducimus;1
78;blanditiis voluptates suscipit unde assumenda dolores sint quas dicta recusandae labore nisi ipsa numquam aperiam beatae autem maiores mollitia maxime sed aut nostrum rerum omnis repudiandae voluptate aliquam velit minima voluptatibus expedita ea at;atque;6
79;libero aut inventore natus culpa esse modi repudiandae tempora obcaecati fugiat adipisci dignissimos error ex soluta ut nemo officiis totam atque molestias laboriosam unde dolores exercitationem consequuntur quaerat blanditiis suscipit aliquam ducimus sunt;illo;10
80;magnam corrupti fugiat placeat earum et ut vel eos adipisci molestiae itaque ratione esse temporibus minus quia sapiente ullam dolorem voluptatum facilis similique reprehenderit quasi necessitatibus id ipsam culpa tempore omnis consectetur ipsa maxime praesentium sequi hic nisi ex provident aperiam doloribus consequuntur eligendi non accusantium;porro;4
81;facere quia tempore id fugit nemo placeat quam nesciunt corrupti omnis dolorum voluptate sapiente impedit corporis molestiae culpa odio soluta tenetur eos deserunt dolores quis alias officia hic earum facilis velit consectetur quos dolorem assumenda nisi cum iure vero debitis laboriosam consequuntur laborum recusandae modi nobis cumque voluptates quod et;voluptate;8
82;rem nulla iste exercitationem cupiditate assumenda soluta totam culpa dolore ab repudiandae necessitatibus iure odio vel voluptatibus sed rerum possimus quia voluptatem eaque perferendis facilis numquam eveniet nam officiis reiciendis dolor suscipit minima magnam distinctio eius;aliquid;3
83;fugiat optio eum cumque architecto dolores corrupti veritatis est ad harum itaque aspernatur dolor excepturi magnam mollitia quae deserunt molestiae ipsam tempora recusandae adipisci esse odit sapiente reiciendis sequi soluta vero repellat id laborum dicta sunt aliquam libero dolorem iusto sint enim labore tenetur;temporibus;3
84;natus distinctio laborum quod perferendis doloremque nam eligendi sed voluptatum temporibus explicabo fugiat quas saepe porro assumenda facilis laboriosam esse sequi asperiores maxime velit animi perspiciatis voluptas expedita provident quam quo veniam eveniet nobis qui atque non reprehenderit repellendus doloribus earum ipsam inventore modi repudiandae enim omnis quos fuga vitae;error;0
85;a magni quam expedita cum eligendi sapiente doloremque fuga vel recusandae eos eaque omnis nulla officia voluptatem eum quas maxime dolores obcaecati ab temporibus enim totam laborum tempore facilis fugiat amet molestias maiores distinctio animi quaerat autem inventore;exercitationem;3
86;provident nam placeat illum illo laborum sapiente labore voluptate accusamus molestias incidunt voluptas optio tenetur consequuntur cumque dolore hic dicta rerum omnis cum assumenda in numquam quaerat veniam sint voluptatum dignissimos excepturi quidem blanditiis tempore cupiditate eos quod repellendus quisquam culpa quos;quod;4
87;animi similique delectus voluptas dignissimos ut quos consectetur repudiandae et dicta quisquam rerum odit officia dolorum dolorem libero ex ipsam maxime expedita ratione commodi sint deserunt itaque tenetur recusandae distinctio sit assumenda magni unde;unde;0
88;nemo minus laudantium corrupti harum voluptatibus expedita sint debitis impedit unde dolor voluptatem quidem ratione tenetur vero a ad modi omnis quisquam incidunt qui suscipit repellat possimus quam sapiente eveniet ut illo autem ipsa perferendis deleniti molestiae corporis ea aperiam odit iste eligendi sed;molestias;6
89;ipsa impedit debitis error inventore dolorum esse ratione beatae adipisci totam fugiat minima et sint qui voluptas autem numquam cupiditate nemo quisquam magni odio architecto at laudantium quas incidunt quis commodi optio mollitia;optio;4
90;excepturi impedit quas quae numquam tempora nobis perferendis officiis culpa possimus odio iste modi repellat delectus magnam neque tenetur totam quisquam deserunt rerum ipsa molestiae illo non ad nostrum temporibus cupiditate quos laudantium nemo velit dolores fugit vel voluptate;aperiam;2
91;necessitatibus doloribus odit vero vel voluptatem incidunt molestias illo ratione placeat harum itaque excepturi corrupti dolores nisi fuga dolorum enim eaque quasi rerum est animi architecto cumque vitae reiciendis quo;exercitationem;0
92;sit est reiciendis quae dolor sed ipsam neque facere soluta delectus assumenda eaque quod harum blanditiis qui expedita non nisi itaque voluptates iure a quas maiores fugiat veritatis repellendus velit quia;exercitationem;4
93;odit facere assumenda sint amet cumque voluptates possimus officia suscipit aut ea ad ipsam doloribus porro deleniti quos nihil et temporibus quibusdam eaque sunt quaerat dolorem modi dicta nemo veniam delectus harum perspiciatis voluptatem quia qui velit quas iusto ex nulla necessitatibus totam obcaecati eum;maxime;8
94;tempore ab magnam eos itaque rerum placeat nisi ducimus dignissimos dolor eaque sint aliquam nostrum natus tempora dolore autem assumenda inventore maiores magni alias ipsum harum vel deleniti suscipit illum labore quae non quasi libero cumque sed;quo;6
95;in laudantium suscipit nemo eligendi numquam illum magnam reprehenderit fuga recusandae ab harum porro quibusdam fugit temporibus voluptate consectetur ratione ad odio libero magni maxime molestiae natus minima officiis hic eius vitae;unde;1
96;rem nobis provident possimus harum laudantium repudiandae praesentium voluptatem perspiciatis quo cupiditate vel minus nemo expedita aut numquam corrupti modi voluptas quasi consectetur quas quos dicta in sequi debitis deserunt cumque culpa quibusdam animi enim dolores ab asperiores quis illum consequatur optio autem natus eligendi corporis dignissimos rerum saepe ipsam;ab;1
97;dolorum non autem quisquam minima ipsam eveniet sunt minus ratione debitis consequatur quae officia distinctio a suscipit quam animi saepe fugit velit asperiores cupiditate veniam iste vel in id dolor accusamus pariatur alias explicabo exercitationem cumque corporis ducimus modi blanditiis illum aperiam fuga veritatis reprehenderit;voluptatem;2
98;dignissimos porro at praesentium reprehenderit labore voluptates doloribus repellat quo aliquid quia a temporibus deserunt fuga repellendus sapiente aperiam eaque dolores quidem nostrum laborum distinctio veniam nisi recusandae eligendi non nemo voluptatem qui quam;et;7
99;expedita at repellat sed earum ullam provident labore porro esse ratione recusandae adipisci vero quam architecto animi beatae iure dolorem ipsa praesentium quibusdam reprehenderit soluta distinctio delectus odit vel maxime atque ea saepe tempora;fugiat;7
100;dignissimos molestias labore deleniti nam eligendi eaque officia delectus magnam corporis qui maiores ex neque at saepe ratione voluptas corrupti quia iusto facilis doloremque voluptatem quo repudiandae a error incidunt repellendus autem architecto similique in commodi laborum repellat eum cum voluptatum sunt;illum;2
101;ab tempora nostrum iure expedita cumque veniam ea vitae ducimus quibusdam reprehenderit alias culpa cum pariatur illo voluptatibus iste earum fugiat corporis laboriosam asperiores sed optio officia nihil animi quis temporibus corrupti sunt exercitationem quo facere suscipit architecto maiores assumenda sit dolorem;animi;6
102;id officiis quae fugit commodi quas sit eos blanditiis veritatis aut sint animi mollitia maxime beatae aspernatur adipisci quod incidunt optio labore a temporibus magnam facilis harum ea illum voluptates eligendi sunt soluta nostrum ratione iusto quam facere aliquid sequi laudantium recusandae;hic;6
103;itaque laborum iusto magni impedit asperiores doloremque nam exercitationem ab animi optio modi quaerat recusandae possimus dolorem sint vero doloribus excepturi rerum iste numquam quos aliquid voluptatum repellat laudantium magnam commodi hic voluptatem illo veritatis quidem eos quis ipsum sunt nulla eaque aliquam quasi;nisi;10
104;ut illum ipsam quibusdam mollitia dignissimos veniam fugiat voluptatum magnam recusandae hic fugit soluta perspiciatis distinctio quod repudiandae doloribus facilis aliquam voluptatibus modi vitae inventore iure consequuntur nulla repellat exercitationem quas velit repellendus sequi excepturi pariatur ipsum;animi;5
105;eum amet quam error autem recusandae officiis fuga numquam eos voluptas qui provident fugiat incidunt eius accusamus tempora quaerat pariatur iure debitis dolorem vero ullam hic accusantium odit cumque maiores quasi iusto non aliquam similique ratione porro at necessitatibus dicta reiciendis nihil aperiam asperiores commodi cupiditate architecto possimus;dolores;2
106;numquam nihil perferendis officiis blanditiis fuga tempora nulla exercitationem quam minus ex aspernatur deleniti error commodi quibusdam pariatur atque iusto esse reprehenderit vero expedita vel earum cupiditate eveniet omnis iste qui dolore praesentium aliquid similique laudantium saepe modi ducimus amet eligendi cumque unde dignissimos totam ratione;perferendis;6
107;neque libero mollitia facere rerum placeat dolores minus ut deserunt perspiciatis animi quisquam ratione cupiditate incidunt vero itaque adipisci ad vel accusamus voluptate quos asperiores omnis esse architecto obcaecati odio nisi repudiandae dicta quam dolorem voluptates;quo;9
108;autem fugit soluta aperiam nobis nihil quisquam ab adipisci tempora omnis nemo quaerat distinctio itaque velit necessitatibus corporis obcaecati suscipit nesciunt consectetur illo quidem molestias repellendus vero quae fuga iste ipsum est excepturi praesentium;sit;8
109;explicabo cum consequatur autem qui quos perspiciatis quae tenetur aperiam sapiente facere culpa molestiae obcaecati possimus ipsa unde deserunt minus soluta ipsum dolorum dolor veniam nostrum similique dicta inventore quasi sunt;ex;7
110;similique nulla asperiores voluptate quos quod ducimus perferendis illum voluptas molestiae quis officia iste id impedit ea placeat iure expedita molestias nihil quasi error nam laborum ut minima deleniti sunt iusto quibusdam ullam laboriosam consectetur odit possimus excepturi;blanditiis;4
111;non esse facere asperiores reprehenderit a porro pariatur ipsum dolore quaerat ullam sunt molestiae aliquam placeat quidem veniam hic quo neque provident maxime eum labore ad exercitationem corporis quae quibusdam atque doloremque quasi vitae fuga;maxime;5
112;sapiente commodi quaerat repudiandae corrupti numquam nobis temporibus laudantium aspernatur praesentium consectetur officiis inventore deserunt tempora ea accusamus quae eveniet possimus exercitationem ex tenetur minima voluptatum quas molestiae nihil dolor incidunt odit tempore consequatur labore iste voluptatem officia;vitae;3
113;ex in pariatur mollitia labore consequatur facere expedita ullam unde nisi assumenda fugiat cum animi et vel earum magni vero commodi dolores accusantium excepturi distinctio voluptatibus nam cupiditate iusto eos velit doloremque aut quibusdam repudiandae quam ipsa error praesentium;ullam;0
114;quidem voluptatibus commodi tempore magni aperiam minus maiores consequatur autem corrupti veniam dolores ea placeat similique porro dignissimos deserunt nulla totam perspiciatis fugiat fuga necessitatibus dolorum corporis possimus mollitia impedit consectetur obcaecati excepturi ut debitis libero doloremque ratione quaerat recusandae expedita odit;accusantium;4
115;iste corporis sunt ea magni adipisci deserunt tempora odio cumque maiores eaque dignissimos voluptatibus eos praesentium illo id facilis quo beatae similique harum voluptatem reprehenderit sit doloremque ex nobis saepe magnam quidem modi reiciendis minima molestiae dolorem recusandae in;ab;4
116;consequuntur autem saepe quod beatae laborum earum possimus corporis amet at deserunt quisquam omnis sunt ducimus rerum neque ipsam atque illo explicabo provident asperiores officia id laudantium mollitia a aliquid eligendi hic facilis dolore ipsa et incidunt quibusdam nihil dicta molestiae accusantium maxime ea;maiores;10
117;eos eveniet porro perferendis doloribus alias corporis beatae corrupti magni aliquam tenetur quam minima labore iusto dicta ex error reiciendis explicabo quibusdam delectus placeat nulla libero necessitatibus maxime cum voluptatum voluptatem sed amet pariatur tempora repudiandae quisquam excepturi natus quos itaque molestias odio exercitationem ab nesciunt iure;repellendus;2
118;nobis odio sunt adipisci quo rerum nisi temporibus doloremque a culpa hic non quasi animi eum exercitationem facere cumque nesciunt tempore fuga facilis eaque dicta sapiente iste at distinctio quas praesentium repudiandae necessitatibus laudantium in qui maxime quos provident ratione natus quod;dolorem;2
119;similique beatae sint quibusdam iure porro facere obcaecati provident totam sed voluptas neque repudiandae architecto illum ratione vitae repellendus cupiditate natus molestiae officia tempore at sunt quo itaque rerum quasi culpa libero dolorem minima dolore dolor soluta accusamus sapiente ut;nostrum;6
120;ipsam architecto assumenda earum quod magni accusantium totam exercitationem voluptatibus atque soluta modi impedit a dicta dolorum ex praesentium amet minima deleniti consequuntur laborum ab nisi et explicabo eaque nostrum asperiores omnis porro quis quos;maiores;7
121;nulla quia hic itaque veritatis sunt culpa commodi recusandae explicabo cupiditate doloribus repudiandae error ad deleniti illo doloremque autem quasi natus reiciendis architecto animi nobis eius aperiam neque reprehenderit quos ut laborum;odio;3
122;et numquam illum quasi vel repellat atque omnis error fugiat ratione suscipit illo ipsa laborum eos nesciunt iste quaerat repellendus officia unde dolor accusantium voluptatum maxime obcaecati odio eaque inventore eius totam aperiam aut iure sunt;aliquid;1
123;aspernatur magni suscipit iusto adipisci quisquam facilis veniam porro delectus modi culpa unde labore temporibus reiciendis similique ea ut ratione tempora aut nihil facere expedita maxime natus rerum officiis soluta fuga minus quas;consequatur;4
124;sed necessitatibus aperiam nobis voluptas dicta est provident expedita adipisci laudantium architecto similique maiores earum asperiores totam dignissimos iure pariatur a odio vel eligendi alias ipsa saepe eum omnis perferendis voluptatibus labore voluptate ad qui porro corrupti accusantium placeat quos quasi ratione reprehenderit cum nemo;unde;5
125;accusantium voluptatem autem nostrum at necessitatibus commodi praesentium fugiat corporis ut labore aperiam nulla ipsum cupiditate architecto consequuntur est dolor soluta repellat ea dolore molestias modi ullam libero sit illum vero dolores voluptatibus sequi voluptate quasi maxime inventore repellendus nobis ex quo hic adipisci iusto amet recusandae quod;deleniti;9
126;quibusdam explicabo repudiandae officiis similique nisi inventore molestias quam recusandae voluptatem velit rem tempora illum vel suscipit minima corporis vitae facere cupiditate quasi consectetur incidunt commodi quidem quas libero tenetur magnam fugiat dolorum minus placeat nihil enim necessitatibus;ullam;2
127;a dolor adipisci atque dicta nesciunt veritatis ullam sunt aspernatur mollitia quidem voluptates iusto cumque pariatur voluptas magni repellat ipsum voluptate commodi quo alias nam accusamus maxime temporibus placeat impedit voluptatum necessitatibus repudiandae esse recusandae;consectetur;1
128;quis distinctio illum obcaecati assumenda facere labore perspiciatis nihil dolore sunt itaque numquam repudiandae voluptates earum doloremque cum ullam nostrum expedita odit consequuntur sint ratione aspernatur architecto omnis ipsam optio iusto saepe non error commodi amet blanditiis fugiat quo eligendi neque vel quam;dignissimos;0
129;sed distinctio ipsam vero nam laboriosam laudantium mollitia itaque quam dolorem facere molestiae corporis inventore beatae repudiandae natus tempora odio omnis ducimus excepturi recusandae harum minima eaque sapiente velit suscipit temporibus nobis eum nesciunt aperiam voluptatibus quae cum sequi deleniti accusantium magnam voluptate reiciendis sunt dolore porro;officia;4
130;vero placeat exercitationem qui necessitatibus eaque quia ducimus iste dicta voluptatibus tempore porro explicabo cum in excepturi itaque nihil dolores dolorem et sit recusandae tempora nisi inventore totam expedita repellendus corporis quis eligendi;consequuntur;8
131;repudiandae dolores aliquid recusandae perspiciatis error illo esse quibusdam ullam nisi deleniti ut illum repellat rem optio itaque deserunt a accusantium molestiae cum fugiat magnam non ea velit voluptates praesentium ipsa accusamus eius architecto et vero nulla exercitationem quia expedita ducimus unde temporibus;quisquam;9
132;adipisci a quam labore reiciendis facere excepturi repellat dignissimos consectetur eos pariatur ipsam accusantium porro assumenda ratione omnis incidunt exercitationem voluptate mollitia vero facilis aliquid officia id fugiat temporibus odit aut explicabo perspiciatis rerum;officia;5
133;magni voluptate et autem tempore numquam reprehenderit facilis quisquam cupiditate non nemo sit dignissimos omnis maiores incidunt quis perferendis dolore ullam placeat quam itaque sequi architecto modi eius eaque adipisci officia recusandae cum dolorum animi voluptatum inventore aperiam quas eveniet facere praesentium laudantium;hic;1
134;nisi ratione repudiandae sed placeat pariatur eos fugit modi ipsa explicabo est vitae et unde ad alias aliquid reiciendis quam nobis distinctio cumque ducimus quaerat repellendus maiores quidem dolorum consequatur voluptas esse enim deleniti quos aperiam dicta error tempore doloremque nihil in dolores;id;3
135;temporibus beatae vel facilis similique dolor quaerat nesciunt ratione vitae voluptatum in laboriosam nam incidunt blanditiis suscipit dignissimos a commodi eaque neque omnis eius itaque et porro deleniti saepe delectus ullam ipsa harum nisi quam;perferendis;8
136;numquam provident repellat magni molestias ipsam doloremque corrupti natus dolore vero sequi ab saepe esse qui facere cum porro voluptatum aspernatur dicta magnam fuga harum nulla consequatur neque quod ut pariatur ea deleniti enim molestiae est deserunt rem nemo adipisci;placeat;3
137;eum inventore perspiciatis vel beatae magni porro iusto animi fuga at ducimus est sequi consectetur pariatur quisquam commodi modi tenetur exercitationem nesciunt architecto tempore provident placeat quaerat reiciendis recusandae excepturi incidunt veritatis laboriosam nobis;iure;4
138;aliquam nam omnis quod neque distinctio animi sequi earum impedit exercitationem eaque quisquam nulla natus accusamus saepe quaerat sunt ipsa nihil aut iure dolorum quis at dolor qui delectus assumenda consequuntur velit ea maxime magnam;similique;3
139;quo omnis nihil earum neque odio in veniam deleniti quae atque minus eum dolore doloremque dolorem animi similique velit nobis aspernatur explicabo provident nostrum architecto eligendi laudantium non voluptates facere dolorum blanditiis temporibus rem aliquid impedit voluptate unde iste ad maiores deserunt autem vero quas magnam cum nesciunt consequatur;ab;3
140;officiis alias optio nobis omnis ex rerum consequatur id ipsa quidem reiciendis animi autem recusandae dicta vitae mollitia doloremque molestiae ullam sint in ipsum quaerat illo earum iure perferendis quam minus est;animi;10
141;corrupti consequatur iure laborum hic nulla minus aperiam fuga provident nemo voluptates nisi reprehenderit eligendi fugit veniam quos at debitis blanditiis placeat eveniet quae pariatur atque dolorem iste ab dolorum;eligendi;10
142;nostrum id quasi nihil unde error ad pariatur necessitatibus nemo ullam adipisci commodi esse dolor dolorem beatae odio nesciunt ab recusandae obcaecati sequi assumenda ea iusto inventore enim doloribus vero labore consectetur dolores suscipit sit cupiditate nam delectus numquam autem atque molestias molestiae voluptatum;aliquid;8
143;corporis veniam eaque aspernatur molestias quam magni saepe reprehenderit fugiat eveniet non voluptatum modi ipsam voluptates inventore tempore perspiciatis quod sunt repudiandae perferendis ad officia tempora deleniti excepturi quos voluptatem autem ratione dolore eos dolores maxime est maiores;alias;0
144;vel eos reprehenderit reiciendis eius veritatis quos quibusdam quidem nesciunt non deleniti illo temporibus adipisci voluptas animi inventore consequatur quae quam quisquam dolorem cumque natus esse sunt repudiandae architecto error repellendus dicta eaque fuga provident ullam commodi necessitatibus laboriosam distinctio obcaecati itaque hic omnis minus;esse;10
145;alias quidem autem a velit beatae modi quasi assumenda distinctio dignissimos molestias aspernatur fugit id nesciunt ad labore repellat accusamus at quam fugiat earum neque fuga voluptatem porro omnis consectetur vel doloremque impedit maxime soluta amet aperiam voluptatum excepturi cupiditate numquam aliquid perspiciatis;earum;9
146;at dolore facere omnis ratione quam magni consequatur praesentium maiores debitis odit aperiam neque quasi dignissimos quidem ipsam ipsum molestias sapiente eveniet aliquid obcaecati animi nam autem esse molestiae dolores libero optio voluptatum nulla;quod;1
147;sed ducimus accusantium illum unde tempore est dicta nisi debitis beatae error dolore eum consequuntur explicabo quia corrupti dolorem velit officiis maiores quod nesciunt impedit itaque nihil ab laboriosam repellendus architecto earum et asperiores ullam sapiente delectus amet eius;necessitatibus;1
148;corporis blanditiis cupiditate explicabo facere quaerat possimus magnam perferendis quo eaque fuga nihil ab eligendi ea maiores tenetur quisquam quos deleniti est quidem illo voluptatum ipsum iste debitis odit mollitia molestiae veritatis aliquid repellendus ipsam eos quibusdam;obcaecati;8
149;laudantium tempore ipsum fugit eaque voluptatum laboriosam cumque iusto necessitatibus sint ullam obcaecati eos facere libero tempora voluptate consequatur minus magni dolorum excepturi nisi reiciendis sit repudiandae amet aliquam natus corrupti temporibus suscipit aperiam animi repellat optio quasi assumenda blanditiis consectetur nihil quam dignissimos facilis quia;voluptatem;1
150;ipsam sint consectetur sunt voluptas odio fugit ut eius harum deserunt magnam corporis officia sapiente quo pariatur molestias modi deleniti nobis impedit velit vero necessitatibus natus repellendus repudiandae commodi explicabo voluptatibus id architecto error nostrum illum;sapiente;5
151;necessitatibus unde nostrum fugit numquam minima veritatis beatae animi ipsum dolorum officia magnam soluta nesciunt facere saepe dolore dolorem id ducimus corporis at in est illo ab dolor itaque ratione molestias sunt quia similique nihil odio eum illum perspiciatis quam molestiae consequatur debitis doloremque doloribus;iure;5
152;voluptate ipsum quod aspernatur debitis eligendi ratione dolorem repellendus deserunt veniam quia repudiandae sapiente molestias ex recusandae mollitia magnam maxime culpa eius iusto voluptas nisi quidem sequi aperiam non reiciendis officiis vel perspiciatis;reprehenderit;10
153;provident quos deserunt fuga reiciendis ipsa iure corrupti unde quia iusto labore adipisci laboriosam sint quae odit eos atque porro est fugiat magnam id quibusdam ea autem corporis consequuntur dolor aut suscipit delectus sed eum eius ducimus possimus aspernatur;omnis;9
154;dolore maxime nostrum repellendus asperiores nam soluta repellat facere aliquid obcaecati minima ea quae non harum possimus cumque mollitia adipisci incidunt eligendi ad rerum numquam cum dolorum molestiae magni saepe commodi fugiat quod excepturi placeat nobis esse totam est dolorem tempora error;neque;3
155;quasi iure quibusdam aspernatur at consectetur eos est dolorem voluptas voluptate iste ipsam officiis similique temporibus architecto tenetur itaque totam inventore et cumque expedita molestiae possimus in molestias soluta sint praesentium recusandae doloribus numquam;eius;3
156;illo reprehenderit obcaecati repellendus eius reiciendis fuga exercitationem labore asperiores nesciunt recusandae consequuntur porro optio expedita a qui necessitatibus rerum sint autem similique dolores voluptates quis quibusdam eaque sequi aliquam maxime eligendi quisquam eos vitae facilis illum;cumque;8
157;adipisci a ullam ratione blanditiis numquam facere nostrum ab aliquam voluptate corrupti sunt optio obcaecati aperiam dolore nihil labore explicabo voluptatem temporibus perspiciatis laboriosam fugiat est at voluptates dicta aspernatur consectetur sequi quibusdam nulla doloribus animi provident;quia;1
158;adipisci minima necessitatibus pariatur exercitationem iusto aut reprehenderit ullam perspiciatis laborum corrupti ex quia numquam odit nemo sit nulla velit culpa ipsa dolorem quam non deserunt ut rerum nesciunt distinctio nostrum praesentium quas totam quo veritatis;iusto;6
159;ipsa dolore dolor impedit iste laudantium nemo distinctio corporis porro est assumenda error inventore modi natus ratione alias saepe reprehenderit aliquid tenetur nesciunt numquam amet molestias quaerat consequatur culpa magnam veniam libero ex non vitae earum excepturi minima;sit;7
160;harum ad ea doloremque tempora eaque soluta at laborum eos ipsa neque porro et consequuntur obcaecati quidem optio maxime praesentium excepturi ratione illum similique numquam est a odio debitis eius ducimus cupiditate molestiae aperiam;fugit;3
161;quo officia reprehenderit maiores ea dicta vitae expedita voluptatem sit in debitis distinctio perspiciatis autem odio voluptas nisi reiciendis non dolore libero fugiat iusto quos perferendis quas quae doloribus cumque sint commodi animi ipsam hic minima rem ut ab impedit quasi veritatis voluptate enim error facilis consequuntur nostrum unde ad;animi;0
162;eaque dolores dolore consectetur nobis minus delectus earum sapiente nihil excepturi laudantium esse ratione culpa quasi debitis rem sit suscipit veritatis magni quia necessitatibus cupiditate inventore optio at nisi officiis;illo;0
163;distinctio quam inventore esse vitae laboriosam illo blanditiis nesciunt natus vero deserunt cum ex suscipit reprehenderit amet quisquam provident ipsa temporibus id quos praesentium nostrum culpa obcaecati veniam debitis dicta hic consequatur at molestias ratione incidunt quae libero officiis eum necessitatibus;reprehenderit;9
164;assumenda numquam quae dignissimos obcaecati nulla cumque architecto facere sequi aperiam saepe praesentium quis porro quod eligendi quisquam accusamus nesciunt blanditiis laudantium fugit sunt nihil iusto sapiente eveniet nostrum et eaque cum iure cupiditate mollitia soluta repudiandae aspernatur dicta veniam similique labore autem quia ipsa itaque repellendus;doloremque;10
165;obcaecati possimus aut rem sed veniam error quos praesentium temporibus consectetur sit unde voluptatum veritatis natus laboriosam impedit aspernatur modi ipsam doloribus quibusdam soluta ad tempora quisquam ipsum eaque saepe corrupti vitae porro;repudiandae;9
166;adipisci eum voluptatibus quo nihil nostrum repellat modi sint perferendis suscipit ut reprehenderit iure ipsum voluptate vel explicabo quod facilis numquam sunt a eveniet culpa rerum maxime iusto exercitationem soluta eos vitae;quam;10
167;accusamus quasi eius accusantium id possimus quia temporibus quaerat consequatur perspiciatis labore tempore minus repellendus vitae et distinctio qui nihil praesentium odio natus aspernatur cumque assumenda ad culpa facilis nam quos quis commodi soluta eos veritatis fuga incidunt error repellat libero ipsa necessitatibus;ab;2
168;placeat aliquid possimus facere velit necessitatibus tenetur hic similique ullam eaque suscipit earum beatae qui molestias atque ratione alias numquam ex ducimus sequi ipsam aut amet rerum praesentium repellat adipisci cumque et excepturi vel ad dolores sit corporis sunt distinctio ipsa rem culpa;excepturi;7
169;cum sint ex veniam adipisci molestias reprehenderit illum animi veritatis facilis perferendis alias corporis voluptatem impedit consequatur ratione maiores aliquid reiciendis ab maxime inventore libero non eligendi labore quisquam ipsum dolores;ullam;2
170;minus illo sapiente autem at nisi praesentium ipsum nesciunt fuga id nihil veritatis earum saepe excepturi eaque nostrum quia pariatur voluptatum omnis asperiores enim quod magnam ullam dignissimos odit facere totam beatae optio animi unde tenetur consequatur vitae recusandae deleniti ipsam aperiam fugit;voluptates;4
171;blanditiis quos excepturi sunt dignissimos soluta eius quasi perspiciatis nemo voluptate eos id ea iure earum mollitia ratione labore impedit praesentium alias quas tenetur unde qui quia temporibus est fugiat cumque commodi quibusdam ut dolore fuga;velit;8
172;praesentium ut itaque quo amet mollitia quibusdam assumenda tenetur inventore sapiente eius asperiores ipsum ipsa temporibus excepturi facere odio necessitatibus quae minus explicabo error exercitationem eveniet consequuntur in voluptatibus quaerat dignissimos eaque nihil quia deleniti quasi porro labore nesciunt nemo beatae consectetur deserunt aliquid autem commodi;molestiae;4
173;qui unde fuga repellat quos esse ipsa laborum commodi aut eaque illo accusantium quam sapiente numquam ratione ad quisquam dolores dolorum ex atque maiores labore minima ducimus assumenda odio quia perspiciatis aliquam vero explicabo aliquid expedita consequuntur eligendi quibusdam doloribus non a totam impedit odit dolore amet;eligendi;1
174;officia nihil possimus maxime libero eaque et debitis illo corrupti numquam iusto facere enim inventore rem consectetur fuga vel nobis blanditiis dolor fugit aliquid tempora nemo amet nisi accusantium autem laudantium minus quo at eveniet dolorem quod repellendus sequi reiciendis;praesentium;9
175;eaque rerum quas corrupti impedit dolorum aliquam hic assumenda doloremque dolores vel numquam asperiores maxime consequatur ipsum officiis provident est ad quos minima sit sequi deleniti modi suscipit ducimus neque officia nulla ullam ab itaque atque dolor debitis;delectus;10
176;veniam nulla culpa maxime consequuntur id dolorum officiis harum expedita error sit tempore numquam autem animi architecto inventore atque laudantium eaque ad soluta aspernatur cum earum quibusdam officia vel praesentium minima ex labore et facilis pariatur saepe nesciunt odit perferendis quia deserunt libero asperiores qui perspiciatis repellendus itaque aliquid;commodi;6
177;distinctio aliquid ullam minus corrupti id quisquam veritatis accusamus excepturi nemo tempore quaerat voluptate possimus repudiandae aut vitae esse labore laborum facilis facere illo voluptas officiis obcaecati libero quos culpa impedit itaque vel consectetur commodi optio dolor iure rerum sequi iste voluptatibus quidem odio;tenetur;9
178;placeat repudiandae maiores a molestias corrupti doloremque architecto enim autem at facere voluptas eligendi labore aliquid porro aliquam ea sunt odit ratione nostrum illum vel rem nisi reprehenderit velit dignissimos qui hic nam magni ipsa adipisci corporis nobis quisquam repellendus minima maxime deserunt voluptatibus;facilis;2
179;quos error expedita eaque saepe tempora recusandae at minus ratione sed laborum veniam commodi aliquid iusto fugiat architecto aperiam aspernatur quaerat omnis ipsum reprehenderit adipisci voluptatibus culpa ullam dolore nisi non esse eius nemo officia ut necessitatibus dolorem voluptate beatae quod consectetur a mollitia nesciunt consequuntur possimus perferendis qui;ea;5
180;debitis minima corrupti deleniti porro ullam vitae cupiditate suscipit facilis neque consectetur eum dolore maiores totam asperiores a saepe magni aspernatur enim provident delectus nobis fugit mollitia nihil culpa animi blanditiis corporis;fugiat;9
181;sed delectus nam culpa sunt iste totam explicabo fugit excepturi nulla nemo animi reiciendis maxime ipsum in facilis harum exercitationem tenetur amet modi non ad eligendi omnis ipsa quae aliquam eos dolorum voluptates corporis;cum;2
182;deleniti quasi enim non tempora pariatur consectetur sapiente porro officia quam fugit nesciunt dolorum mollitia itaque eaque modi id distinctio nobis animi repellendus voluptatibus maiores unde similique dolor asperiores quas magnam magni facilis doloribus autem quisquam voluptatum adipisci sunt nemo veniam incidunt soluta;repudiandae;2
183;excepturi iste perferendis ex laboriosam dolorem quo sint numquam veniam neque voluptates non incidunt unde accusantium saepe ut libero assumenda explicabo harum delectus consequuntur esse sed distinctio voluptatem aperiam blanditiis adipisci vero nemo error labore in deleniti officia nam consequatur;eos;10
184;necessitatibus placeat praesentium vero accusamus dolore blanditiis non voluptatibus voluptas veniam dolor natus hic cumque esse nisi nemo officiis dicta corporis veritatis itaque ex incidunt fugiat nostrum doloremque debitis beatae fuga dolores illum voluptatum saepe sit assumenda eos distinctio facere;recusandae;1
185;magnam quaerat magni odit dicta voluptas quidem perferendis temporibus voluptatem rerum tempora vero necessitatibus minus deleniti alias laboriosam sequi quos architecto repudiandae fugit consequuntur ratione eos rem provident quis vitae molestias debitis tenetur ab minima ut inventore ullam placeat optio neque labore aperiam incidunt reiciendis;quisquam;2
186;nemo aspernatur velit cumque voluptatibus porro dolores odio nisi quas accusamus qui quasi possimus nesciunt sequi eaque consectetur eligendi voluptates voluptate natus cum est incidunt commodi ad dolore aliquam harum animi itaque laboriosam error minus optio;rem;0
187;repudiandae temporibus amet odit voluptatum enim molestias tempora alias corrupti obcaecati fuga repellat nam sequi at ullam officiis nostrum cupiditate asperiores eius ad minima autem consectetur deserunt aspernatur dolores recusandae harum iusto suscipit fugiat modi quasi doloremque atque quis perspiciatis cum velit laudantium blanditiis tenetur necessitatibus;nihil;2
188;expedita eligendi est quo blanditiis consectetur earum repellendus quibusdam vero harum omnis debitis similique suscipit ut commodi ipsum hic unde eum exercitationem magni eveniet aliquid quisquam non aspernatur dolores asperiores dicta ad temporibus iste animi obcaecati accusantium labore in sequi nihil ex culpa pariatur ab inventore recusandae;fugiat;8
189;harum molestiae praesentium fuga quaerat cum neque consequuntur dolore ipsa sed rerum dolores laboriosam enim corrupti excepturi repellendus nihil voluptates doloremque a ducimus vero asperiores necessitatibus ullam dolorum error reiciendis omnis voluptatem repellat qui libero amet laborum sit labore debitis;esse;2
190;perspiciatis cupiditate doloribus dignissimos blanditiis architecto ea maxime velit adipisci repellendus ipsum earum saepe sapiente accusantium corrupti fugit officia magni at dolore commodi dolorum sit molestias aperiam iusto inventore eveniet ex quaerat tenetur amet laborum minima ducimus voluptatum incidunt quod sequi itaque aspernatur assumenda veniam quae quo veritatis vel;porro;3
191;itaque expedita laudantium repellendus modi facere commodi odit quod dolorem fuga sed iusto consequuntur adipisci ipsa perspiciatis consectetur debitis eos nisi temporibus non dolor possimus praesentium veritatis delectus asperiores repudiandae at dignissimos inventore nihil ea soluta;possimus;4
192;aut rem ad est ducimus enim beatae ullam adipisci dicta sint eum sequi reiciendis neque eligendi illo officia dolorem incidunt perspiciatis alias quibusdam cumque et aspernatur voluptas consequuntur dolorum ratione corporis sit expedita iste nesciunt ab recusandae corrupti nemo rerum ea sapiente pariatur mollitia omnis quo eveniet excepturi modi perferendis;quidem;8
193;sequi exercitationem doloremque maxime eum omnis corrupti temporibus reprehenderit illo quo nostrum voluptate laborum velit inventore nesciunt eos rerum numquam earum molestias labore impedit assumenda ipsa sit perferendis saepe porro perspiciatis neque cupiditate quod explicabo facilis eius modi quis magnam pariatur rem quaerat;quis;2
194;quae ullam nobis deserunt expedita blanditiis quis architecto nostrum nulla nesciunt ipsam vel nemo cupiditate suscipit reprehenderit soluta sunt minima iste magnam odio nihil distinctio similique optio deleniti fuga voluptate sequi ratione nam iusto dolores quasi qui eum temporibus quaerat consectetur laborum nisi vero excepturi quibusdam;perferendis;6
195;facilis quia minus ex est quas tempore consequatur perspiciatis illum quibusdam fuga sunt fugit dolorum id possimus quos cum incidunt veniam deleniti quisquam necessitatibus quaerat voluptatem eos enim inventore pariatur accusamus qui ipsum eaque voluptates obcaecati esse saepe omnis odio nam;aliquam;0
196;eos nulla nostrum laborum quos iusto laboriosam corporis molestiae maxime reiciendis ut rerum vero animi laudantium explicabo dicta repellendus minus mollitia asperiores molestias ullam et eius hic ex qui eveniet quae nesciunt praesentium sapiente perferendis quia doloribus commodi;molestias;3
197;quidem nam explicabo est sapiente quod reprehenderit qui soluta nihil voluptatum deserunt totam doloribus beatae vel pariatur natus ea et voluptates optio nulla iusto doloremque ipsam sequi magni repellendus dolorem consectetur adipisci at molestias ipsa aliquid sunt asperiores neque fuga quos quibusdam;aspernatur;2
198;nulla ut vero excepturi optio itaque nobis pariatur quasi dolores error distinctio ex mollitia harum quisquam veritatis molestias rem explicabo autem aspernatur recusandae placeat enim non quo veniam beatae quidem aliquam voluptatem nam eligendi quia dolorum odio delectus ipsum esse sequi doloremque sapiente neque;qui;9
199;corrupti voluptates iure est dicta veritatis illo eveniet asperiores earum et eum porro minima dolorum totam non quam harum reprehenderit corporis quod aut fugiat delectus accusamus aspernatur ut incidunt tempora a error;enim;0
200;cum mollitia dolor veritatis iure consequuntur in eveniet esse laudantium corporis id expedita possimus repudiandae minus ex libero sequi quaerat similique hic numquam quae dignissimos enim eligendi beatae perferendis deleniti neque praesentium exercitationem obcaecati alias dicta sunt iste non impedit saepe sapiente perspiciatis dolores;sint;2
201;eaque blanditiis iste quia tempora cumque ab dignissimos minima quae quasi asperiores voluptate nostrum commodi neque magni numquam consequuntur eveniet ad unde sunt aut quam nihil impedit minus exercitationem nesciunt voluptatum voluptatem molestias reprehenderit incidunt quis expedita autem saepe;asperiores;3
202;deleniti sed a aliquid laudantium recusandae repudiandae eligendi dolorem accusantium iste commodi minima ducimus doloremque consequuntur nisi adipisci corporis impedit omnis consequatur delectus nemo quod et atque quo ipsum error;blanditiis;3
203;rem blanditiis esse quis optio tempora molestiae odit tenetur eius voluptate perferendis alias nihil totam quibusdam itaque aut natus iste voluptatibus ipsum numquam ea porro quidem autem asperiores cum in;a;10
204;reiciendis totam iusto similique enim natus eaque exercitationem odio sed cumque voluptas cum tempore eum ipsa quisquam nobis ducimus blanditiis qui unde fugiat aspernatur doloremque porro suscipit in eveniet cupiditate placeat officiis accusantium sint dignissimos eius ad facere veritatis saepe perferendis quasi magnam temporibus quos deserunt recusandae a soluta;veniam;9
205;maiores nulla delectus dolores consequatur illum debitis eligendi distinctio reprehenderit pariatur officiis totam obcaecati cum exercitationem porro earum quam molestias laudantium necessitatibus molestiae at similique quis saepe nesciunt rerum ipsum quia inventore asperiores veritatis voluptates provident minus impedit sed quisquam animi;sequi;3
206;cupiditate eos doloribus error eum voluptatem distinctio debitis ratione maxime a repudiandae optio quos eaque neque accusamus iure in velit porro rerum explicabo iste consequuntur molestias sunt nostrum aspernatur laboriosam beatae tenetur atque minus voluptates veniam incidunt laborum quisquam officiis perspiciatis consequatur illo id excepturi aliquam soluta;autem;4
207;dolores distinctio eveniet iusto harum inventore porro nisi quia id sint necessitatibus eum adipisci repellat ad eligendi sapiente aliquid totam quaerat molestias earum alias eos aut doloremque veniam laborum mollitia modi non recusandae nostrum deleniti illum voluptate dicta quasi minus expedita;voluptas;3
208;iure consequuntur cupiditate sunt numquam voluptate porro odio culpa suscipit ab dolore delectus sequi at corrupti dolorum ipsam molestiae soluta ex dignissimos sint temporibus ea fugiat consectetur eum neque laborum;placeat;3
209;excepturi soluta ipsam quaerat adipisci dolorem itaque libero sapiente numquam beatae hic natus minus ducimus labore repudiandae dolores id vel debitis est atque tempore at quidem quae cumque rem voluptatum recusandae consequuntur;fugiat;4
210;dolor necessitatibus rem quidem incidunt iste consequatur doloribus nisi at tenetur inventore vitae minima facilis eaque eos officia reiciendis veritatis ex repudiandae consequuntur aperiam omnis alias culpa nihil debitis corrupti mollitia nam quisquam natus temporibus adipisci ab porro accusamus excepturi dolore exercitationem;porro;7
211;nisi reiciendis impedit exercitationem quos quas voluptatum nulla iure consequatur ab reprehenderit nihil temporibus dolores deleniti dolor at voluptatibus et minima quisquam provident quam ratione ad soluta dolorem accusamus architecto culpa rerum excepturi ea voluptate veritatis consequuntur aspernatur adipisci a tenetur numquam ex cupiditate esse fugit commodi ullam;doloremque;8
212;facere consequatur itaque facilis dolor eos molestias dolorem sit dolore nisi eaque enim aspernatur placeat hic iusto harum deleniti impedit veritatis pariatur nam saepe est voluptate laborum eligendi assumenda vitae eveniet vero autem rerum doloremque omnis adipisci;consectetur;10
213;nulla non quae qui voluptas quis illum pariatur laudantium eos explicabo tempora ut sint eius eveniet consequatur ea cupiditate quibusdam odit laboriosam voluptate commodi cum recusandae quam nobis quisquam eaque fugit dolor dicta hic ab accusantium maxime dolores magnam quaerat repellendus rem aliquam nam architecto doloribus cumque sit saepe dolore;vitae;5
214;consectetur nemo ipsa illo quasi accusantium repellat reprehenderit ratione atque cum numquam similique tempora dolores quibusdam doloribus unde necessitatibus eligendi dignissimos voluptatibus aliquid dolor modi nisi vero impedit eum ad omnis alias sed excepturi officia amet;doloribus;1
215;repellendus temporibus quisquam fuga doloremque ea odio nemo dolorum provident tempora modi adipisci harum voluptas nihil facilis unde maxime dicta iusto labore ducimus doloribus amet repellat est totam voluptate eius ratione pariatur minima sit debitis non quae hic suscipit laborum;reprehenderit;3
216;molestiae rem recusandae quod deleniti aperiam voluptatem modi perferendis impedit accusantium tempore odio numquam voluptatibus veritatis autem neque delectus blanditiis ad quo sunt explicabo saepe amet unde sapiente illum aut;distinctio;9
217;voluptatibus cupiditate facilis quo dolorum rerum provident libero iure alias rem in cumque ad ullam ipsa ab illum vitae praesentium quas minima iste animi natus amet nihil voluptate autem repellendus impedit consectetur quos suscipit enim laudantium veritatis qui odio optio nulla sit quia nobis vero hic aliquid;vel;9
218;doloribus eaque porro voluptates expedita esse distinctio dolore eos debitis minima dolorum dicta deleniti iusto odit vel at inventore provident est sit mollitia vero neque illo soluta eum nulla non sapiente;sapiente;4
219;provident quo dolor sed cupiditate accusantium excepturi sint officiis nulla rerum rem magnam quos fuga repellat nostrum ut nobis cum perferendis velit ipsam recusandae tenetur quia error consequuntur explicabo nemo a veniam harum vel amet deleniti;id;7
220;quia debitis eum sequi molestias magni ratione maxime recusandae illum blanditiis itaque quasi saepe ullam error quae qui veritatis voluptatibus maiores praesentium ex autem quibusdam iusto quidem iure aliquam cupiditate cumque voluptatum quas;sed;1
221;error ad voluptates nobis esse adipisci aut saepe at maiores animi non optio minima quae repellat aspernatur assumenda ex ipsum praesentium unde possimus earum quod accusamus voluptas temporibus deleniti vero vitae modi numquam;veniam;2
222;odio iure qui laborum fugiat ducimus minima quisquam voluptatem maxime perspiciatis ea earum eaque nemo quaerat beatae quos quibusdam ad eos nam amet repellat officiis delectus corporis iste obcaecati blanditiis incidunt non voluptatibus pariatur quas laboriosam assumenda possimus;ullam;10
223;explicabo laudantium sapiente veritatis expedita aspernatur pariatur voluptate aut at optio sed placeat qui vel culpa ipsum deleniti eius soluta velit nemo quo est animi harum iusto libero alias nisi ut obcaecati odio cumque dolor veniam ducimus accusantium;commodi;7
224;in nisi ab vero corrupti eum perspiciatis amet quo quas voluptate explicabo possimus ea temporibus quibusdam quam deserunt a deleniti reprehenderit eius itaque accusamus voluptates sed non autem voluptatibus nobis quisquam doloribus illum nulla similique officia earum tenetur nihil totam voluptatem esse atque repudiandae;nulla;4
225;maiores pariatur sint nulla ea asperiores accusamus omnis deleniti corporis magni atque blanditiis laboriosam ullam voluptate dolore earum fugiat repudiandae commodi aspernatur architecto enim id delectus iusto animi ipsam vel adipisci perspiciatis itaque quia illo rem quos;sunt;6
226;tempora eius vel deleniti iure dolorum repudiandae natus similique libero illum quaerat reiciendis tenetur necessitatibus illo ducimus nisi accusamus ut alias fuga ipsa ipsam accusantium possimus consequuntur facilis labore optio pariatur iusto dolores perspiciatis odit ex;reprehenderit;7
227;aspernatur nihil facere vero exercitationem magnam adipisci cupiditate quae aliquid labore ipsum hic aliquam unde ad voluptatum molestiae quia dicta at accusantium quaerat expedita iusto rerum voluptatibus doloremque praesentium omnis consectetur ipsa velit porro minus qui animi similique eligendi dolorem nam illum;corrupti;0
228;vero vel labore quasi recusandae velit cum et optio exercitationem repudiandae perferendis aspernatur suscipit cupiditate reiciendis eveniet provident molestiae incidunt modi totam aliquid pariatur quo in aliquam illum quam accusantium sint sequi iusto unde soluta officia saepe;labore;7
229;maxime officiis incidunt provident earum dolores eligendi officia quaerat suscipit id voluptatem corrupti a est consectetur dicta vitae dolore ipsa non sint similique fuga magni harum enim libero consequuntur excepturi blanditiis et vel animi minus natus porro quod;modi;10
230;quod inventore dolorem labore omnis quasi aliquam amet voluptate quis rerum quisquam hic nihil provident laboriosam ducimus ipsam harum quia odit aut adipisci eum animi obcaecati laborum quibusdam eligendi asperiores suscipit nostrum;explicabo;3
231;nobis consectetur illum hic placeat laudantium necessitatibus magnam ipsam vel rem porro atque labore laboriosam sapiente perspiciatis officia consequatur praesentium repellendus quaerat ullam eius ipsa eos modi culpa nemo explicabo quas aperiam rerum dignissimos quibusdam asperiores numquam sunt saepe vero nisi dicta error repudiandae cumque quidem;ut;0
232;similique deleniti nobis unde asperiores reprehenderit doloribus dolor natus pariatur magnam et aliquid veritatis sapiente laboriosam provident laudantium corporis quas eveniet explicabo sequi ullam in nisi enim ipsam voluptatibus nam modi voluptas fugit reiciendis corrupti iste non illum alias error quia consequatur;recusandae;9
233;corrupti enim explicabo esse soluta id neque tempora earum deserunt quo consequatur eius doloremque ullam unde ducimus saepe fuga iusto sapiente magnam quas pariatur officia dolores nostrum laboriosam cupiditate qui sit vero voluptatum tempore ab;nostrum;4
234;velit ipsam expedita dolorem non sint quia dolores eum eius ullam recusandae nulla laudantium atque incidunt consequuntur sapiente explicabo cupiditate accusamus doloribus est voluptate beatae repudiandae neque possimus fuga amet in molestias deserunt impedit voluptatem quae nostrum error eligendi itaque voluptates sit a laboriosam;saepe;6
235;deserunt reprehenderit harum voluptate iste ipsa id autem molestias quaerat veritatis deleniti totam molestiae aliquam magnam ab voluptatem illo dolore aspernatur asperiores facilis impedit cum earum illum enim unde optio nesciunt tempora sunt;voluptatum;1
236;ipsam officiis recusandae rerum delectus autem quas tenetur laudantium explicabo similique magni iusto reprehenderit nisi cum possimus blanditiis cupiditate labore optio praesentium magnam earum fugit quod voluptatem totam dolorem ab voluptatum consequatur quisquam nostrum enim;dolore;5
237;a harum tenetur eum incidunt vero dolores delectus nihil ipsa corporis facere aliquid praesentium similique reprehenderit itaque fuga aliquam autem sint architecto saepe ea quos magni mollitia asperiores et ratione voluptatum tempore modi quisquam;accusamus;8
238;error fugit iste ullam ipsa id soluta sit dignissimos praesentium numquam blanditiis esse quaerat neque repellat commodi animi quas culpa nulla dolore voluptatum eum alias fuga at quos eaque architecto cumque maiores nam ipsam iusto rem iure sunt expedita beatae quibusdam saepe non earum accusamus;sit;7
239;eveniet exercitationem quam explicabo et eos error atque deleniti doloremque ipsa eum ducimus minus dicta ut suscipit architecto consequatur asperiores harum commodi obcaecati quae labore natus autem dolores veritatis quos omnis rem ad accusamus eligendi ex debitis voluptas temporibus nobis similique fugiat sapiente quas;esse;2
240;voluptatem numquam saepe sint odio odit eaque quo facilis quidem voluptates sapiente porro voluptate alias aut non natus at dolor impedit quibusdam fugit suscipit laudantium doloremque soluta eius itaque ad et molestias distinctio laborum iste dicta omnis praesentium in;placeat;1
241;sit nobis praesentium nesciunt nostrum dolor ullam amet quod vitae commodi illo est dicta quidem facilis odit delectus maxime repellendus reprehenderit pariatur odio incidunt eius ab inventore cupiditate debitis nulla consequuntur omnis veritatis obcaecati explicabo expedita labore;quae;0
242;alias esse repudiandae harum doloribus modi eaque accusamus illum quod error culpa dolorum accusantium recusandae eius vero deleniti incidunt magnam autem cupiditate reprehenderit qui iusto sint sed porro reiciendis tempore maxime temporibus et;blanditiis;6
243;dolorem doloremque doloribus sunt mollitia expedita reprehenderit eos aperiam consectetur perferendis nisi ipsam voluptates laborum soluta molestiae sit fuga veniam eligendi tempora minima magni enim qui nesciunt incidunt nobis odio dignissimos numquam rerum animi unde facilis nulla voluptas distinctio facere consequatur totam ea ex dolore porro quae temporibus quis ut;provident;2
244;dolorem excepturi ducimus labore reiciendis porro eum doloribus delectus officiis ipsa quasi eaque laudantium quam debitis velit est beatae nisi nobis ad neque doloremque illum voluptatem unde aspernatur omnis fugiat obcaecati voluptatum praesentium sequi repellat culpa enim reprehenderit;soluta;10
245;sunt quos labore tempora ab corrupti eveniet libero quo voluptatem quia itaque accusantium quisquam magni cum distinctio dolores earum a ea placeat voluptates odio deleniti saepe repellendus laborum suscipit amet eaque;ducimus;4
246;cupiditate minus dignissimos saepe cum earum officiis et officia placeat error deserunt molestiae rem perferendis quidem assumenda eligendi veritatis esse sequi fugiat incidunt velit enim eos sit quas ex provident aspernatur ipsum omnis impedit maiores iure corporis voluptas soluta ullam quis pariatur excepturi odit temporibus necessitatibus;dolorem;10
247;maxime at ab iusto veritatis dolorem cupiditate possimus quaerat recusandae tempora facere hic eveniet voluptates optio harum quasi est corporis saepe aspernatur debitis expedita architecto ducimus maiores perferendis ex nesciunt necessitatibus explicabo reiciendis nam animi commodi quod nostrum delectus voluptatum;exercitationem;5
248;quis accusantium tempore commodi deserunt dolores veritatis harum architecto odit iure provident veniam illum eum ipsam eveniet aspernatur quisquam nisi distinctio at officia sint atque assumenda sed quo molestias quia suscipit praesentium sapiente ducimus deleniti nobis quaerat pariatur nemo cupiditate eaque;est;8
249;ab vitae quisquam dolore adipisci maiores suscipit minus deleniti assumenda iusto officiis accusantium fugiat voluptate aperiam sit quo laudantium facilis commodi vel recusandae nemo neque est cupiditate sunt voluptatum maxime laborum iure dolorum delectus veritatis omnis dolorem voluptatibus illo repudiandae consectetur eum animi qui ullam deserunt;nostrum;1
250;dolore nostrum delectus distinctio eum facere recusandae tempore tenetur suscipit dolorem veritatis optio beatae ut animi at id quia veniam quaerat incidunt possimus dolor aspernatur temporibus quam exercitationem pariatur ullam voluptas fugit illo praesentium velit;facere;8
251;quae nam minus aliquid natus cum repellendus doloribus eius alias amet itaque voluptatum ipsam ea culpa error maxime animi repellat molestiae maiores enim tempore nihil ducimus neque saepe vitae soluta dicta quia eveniet veritatis dolores harum dolorum aut labore magni molestias;magni;9
252;esse cupiditate eius adipisci exercitationem ullam repellendus atque id delectus iure quae consequatur distinctio nobis blanditiis labore dolores quo quis repellat recusandae perferendis consequuntur voluptatibus iste quasi amet nihil ad corrupti voluptatum a dolorem;dicta;1
253;quae sunt cupiditate esse officia repudiandae dolorem provident veniam repellat eius sapiente fugit ipsam nesciunt minima dignissimos nisi eaque perferendis aliquid molestias nobis omnis tempore at voluptatem mollitia soluta deserunt excepturi est quam doloribus eveniet dolores dolore aliquam assumenda incidunt voluptatibus exercitationem quaerat ex sed quod;deserunt;5
254;repellendus maiores sunt minima explicabo ad tempore fugit asperiores beatae expedita hic ipsam accusamus vitae neque aperiam fugiat at inventore repudiandae quod dolor vero magnam ex quis harum perspiciatis magni error natus porro quisquam illo;quisquam;3
255;eveniet vero fugit unde illum sapiente tempora molestiae officia nihil cupiditate ipsa praesentium molestias temporibus incidunt blanditiis corrupti vitae commodi mollitia odit voluptatibus natus ipsam deleniti repellat velit recusandae ducimus ab porro quis eaque dolore rerum deserunt nostrum architecto iusto eum autem error totam doloremque rem dolor veniam numquam;vero;10
256;ipsum iure laudantium impedit praesentium saepe maxime id vero numquam expedita perspiciatis aspernatur eius laboriosam dolor sint consequuntur dicta perferendis minima aliquid quia sequi delectus officiis voluptate velit eos molestiae maiores nesciunt repellat autem minus hic qui non cum nihil explicabo placeat voluptas tempora quaerat;vel;8
257;debitis corrupti sit repellendus optio cum nihil nostrum officiis consequatur rerum delectus consequuntur fugiat recusandae vero quos ut quia error voluptates architecto nulla pariatur nobis magni alias dolore odio atque;dolorum;0
258;ipsam quibusdam exercitationem necessitatibus inventore ea doloribus earum iure odio asperiores eveniet maxime qui sunt consectetur tempora repellendus minima neque blanditiis sit tenetur dolore ex nostrum deleniti unde quas expedita;eveniet;9
259;temporibus error adipisci assumenda esse accusantium voluptatum alias doloremque necessitatibus sit ea voluptates quia itaque earum laudantium sed vero harum consequuntur odio quidem doloribus beatae illo consequatur similique repellendus fugit modi sequi nemo;eaque;2
260;officia saepe quia sit animi incidunt tempore alias itaque adipisci repellendus quisquam iste omnis est eveniet odio at vel tenetur odit hic possimus exercitationem vero fugit a amet fugiat atque impedit ullam reprehenderit quae reiciendis voluptatem quasi et dolores modi dolorum id voluptatum magni praesentium rem quaerat nobis molestiae;beatae;8
261;asperiores ex rerum provident officiis quod officia est debitis laudantium repellendus enim corrupti eligendi voluptatum nulla beatae dolores doloribus et necessitatibus quas accusamus quo perferendis inventore voluptate sapiente omnis natus eaque veniam at;inventore;4
262;molestiae porro delectus sequi et culpa laboriosam fuga doloribus incidunt quisquam reprehenderit aut dolorum rem ex cupiditate voluptas corrupti rerum praesentium pariatur accusantium optio beatae explicabo sunt quae ipsum laudantium vitae alias ab autem totam illo blanditiis odio nobis nemo aliquam quibusdam asperiores;sed;0
263;recusandae tempore error alias animi repellendus modi maiores labore fugit magni minima dignissimos hic harum accusantium laborum quaerat soluta minus perspiciatis eum nobis consequatur cumque velit adipisci molestiae sequi non quasi;sunt;6
264;in perferendis maxime totam esse praesentium necessitatibus libero eos iure veniam reprehenderit impedit dolor consequuntur rem qui quaerat possimus facere dignissimos quidem dolorem labore distinctio repellat molestias corrupti inventore sunt est accusantium;maxime;6
265;ducimus quidem nulla optio consequuntur magnam dolore voluptate consequatur unde maiores possimus omnis recusandae fugiat at quae suscipit qui mollitia quasi tempore amet nihil delectus officia dolor reprehenderit quia obcaecati eaque officiis culpa vitae exercitationem doloribus et maxime id deleniti debitis nisi;ex;7
266;aperiam cupiditate eaque natus dolore repudiandae facilis vitae minima nihil officia molestiae quos id similique earum ullam hic rerum labore amet atque totam voluptatibus reprehenderit quod non tempora quaerat iusto possimus eveniet fugit dolorum;quia;10
267;tenetur expedita rem sunt quam autem alias blanditiis sed est tempore mollitia delectus molestias eos in repudiandae vel vero voluptate magni debitis corporis quibusdam velit nihil voluptatem nulla aperiam ea adipisci aspernatur voluptatibus repellat exercitationem;placeat;10
268;dolor animi ipsa sed impedit quam delectus nam minus aperiam dolores odit illo ipsum praesentium magni amet nulla adipisci illum in repellendus aspernatur modi ad temporibus similique voluptate ex quas error officiis quia sapiente sint;consequatur;6
269;ab ipsa eligendi facilis recusandae velit nam itaque hic obcaecati nisi aut distinctio optio similique magni dolore ipsum totam debitis veritatis error doloremque perferendis reiciendis modi dolorem deleniti doloribus ex alias fuga iste;suscipit;9
270;dicta earum corporis perferendis explicabo inventore quibusdam itaque assumenda voluptates eius perspiciatis eveniet exercitationem similique nisi a maxime suscipit molestiae repudiandae illum ex voluptas possimus nemo soluta ipsa voluptatibus harum;praesentium;6
271;culpa repellat natus adipisci in unde minima eaque recusandae blanditiis aspernatur libero autem exercitationem et voluptatibus cupiditate fuga dolore architecto quam sequi consequuntur quasi voluptatum cumque tempore quis molestiae tempora repudiandae quibusdam labore eveniet corporis corrupti sint aliquid ratione quas alias eius fugiat laborum iste;quisquam;8
272;beatae possimus natus quis qui quia deserunt sed provident repudiandae saepe libero dolor reprehenderit consequuntur nulla tempora est omnis praesentium corrupti nam fuga expedita ex magnam quos dolore porro officia iure quam maxime animi asperiores;maiores;6
273;maiores reprehenderit quia libero saepe ex voluptates non facere iusto vel modi cum alias praesentium quisquam quod minima numquam dolorem officia itaque architecto quam autem repellendus enim at veritatis perferendis rem eaque voluptatibus sunt tenetur aliquid dolore magnam fugiat natus consequatur nulla nobis excepturi commodi;nihil;9
274;omnis praesentium ipsum tempore magni nostrum illo quidem natus eveniet perferendis ullam dignissimos ipsa officiis amet reiciendis nam fugiat sed deleniti rerum dolorum non atque eius beatae nemo quae blanditiis adipisci ducimus eum pariatur assumenda temporibus odio itaque molestiae at nisi accusantium voluptatibus cumque;unde;2
275;nam ad est explicabo molestias sed velit quas nulla veniam similique aspernatur quibusdam ducimus cum dolorum quo debitis hic accusantium ab magnam magni nisi mollitia et dolores fugiat id officia dicta tempore animi temporibus veritatis excepturi;totam;5
276;voluptates sit reprehenderit vero perspiciatis magni ab quos sed dicta ea ut omnis accusantium commodi molestias quam sapiente quo eveniet tempore eaque doloribus laudantium mollitia aperiam voluptate repellendus illum facilis sequi porro quod in ullam distinctio error;ad;7
277;suscipit iure odio ipsam voluptates quod explicabo autem eum reprehenderit magnam natus nesciunt laudantium error repudiandae blanditiis maiores dicta velit omnis harum quasi architecto cum dolorem facilis placeat laborum beatae praesentium excepturi in distinctio quia nam;nisi;3
278;non accusantium labore asperiores nostrum quod ipsam odit iste nulla exercitationem sequi sit atque quibusdam est temporibus excepturi reiciendis eligendi placeat facere earum molestias repellendus consectetur sunt autem veritatis eaque quas aliquid;neque;9
279;iste excepturi voluptatum rerum asperiores laudantium officia repudiandae quas nisi incidunt sequi quos adipisci aut eos eius quod harum eveniet similique quia fuga hic quae voluptate saepe nulla exercitationem itaque ut vel at quibusdam facere aspernatur ducimus unde laboriosam placeat praesentium;totam;3
280;veniam enim magni mollitia porro expedita tempora suscipit debitis totam id delectus placeat reprehenderit consectetur earum ex ea beatae atque natus ullam nisi odit molestias deleniti maxime nihil deserunt vel blanditiis itaque iusto perferendis eum ipsa fugit hic iure labore ratione dolorum repellendus;odio;4
281;veritatis illo esse cumque necessitatibus fugiat non quibusdam ullam rem obcaecati eius corrupti a ducimus quis omnis dicta laborum porro asperiores aliquid dolores corporis repellendus blanditiis quisquam explicabo ipsum reprehenderit sapiente officia;praesentium;2
282;ipsa inventore ipsam optio ea magnam expedita explicabo culpa enim id consequatur minima animi nihil repellendus natus amet eligendi quasi blanditiis doloremque nesciunt beatae aliquid quos sit atque est fuga ducimus numquam laudantium maxime distinctio aliquam tenetur dicta maiores nostrum exercitationem aperiam;alias;0
283;perferendis a nesciunt quaerat vero veritatis cumque quis laboriosam minima est recusandae dicta sequi accusantium ducimus odio unde numquam aspernatur in placeat aliquid nisi mollitia laudantium facere libero ipsum officia dolorem doloremque esse et sit magni itaque aperiam enim commodi;omnis;2
284;adipisci mollitia porro officiis maxime iste perferendis hic sapiente ratione nihil quia delectus labore alias eos cumque debitis modi fuga possimus facere animi pariatur qui quidem est unde quaerat aut exercitationem placeat ab ad;adipisci;4
285;soluta in at omnis veniam asperiores optio id dolore nostrum a esse commodi tempora exercitationem cupiditate culpa eius dicta et ea vel iusto voluptate ullam harum maxime voluptatum eum amet distinctio dolor quia adipisci repellendus quisquam mollitia architecto consequatur suscipit inventore quibusdam quam aspernatur;culpa;7
286;corrupti odit alias inventore architecto ea delectus earum eveniet dicta incidunt quas sit repellendus doloribus ullam quisquam similique repellat sunt dolor nisi aut officia excepturi neque id optio porro quasi distinctio aliquam nesciunt consectetur facere rerum minus at est dolorem;repellendus;6
287;dolorum facere cumque sint accusantium pariatur delectus reiciendis officia corporis distinctio consequatur tenetur odio illum qui hic eligendi amet voluptas sequi eveniet error perferendis aut tempora aliquam accusamus ratione aperiam aspernatur impedit blanditiis recusandae porro doloribus ea maxime quidem maiores non;maiores;10
288;at aspernatur cumque autem dolorum asperiores hic veritatis alias quos facere repellat non odio iure temporibus omnis dolore porro a fuga nihil laborum voluptatibus in esse minima laboriosam excepturi repudiandae veniam vel ipsa architecto;ut;2
289;sed at numquam velit sit molestiae neque reprehenderit fugiat illo magnam minus atque saepe culpa enim nihil aperiam ea incidunt cupiditate laborum minima accusantium dignissimos voluptas voluptatibus voluptate dolor dolorem veritatis porro accusamus esse quidem ullam omnis quia expedita libero repellendus ab corrupti repudiandae sequi mollitia;soluta;7
290;unde possimus adipisci voluptatum quam numquam sunt mollitia assumenda amet illum accusantium similique nam ad id nobis natus corporis sapiente atque voluptatibus iusto recusandae modi voluptas libero sequi ullam itaque eos eligendi rerum at tempore;eaque;1
291;pariatur officia magnam assumenda laboriosam tempore perspiciatis reiciendis ratione nostrum veritatis cumque iste vero inventore corporis libero harum blanditiis itaque iusto ea eaque dolores qui tempora consequatur illum quis fuga sed asperiores nihil architecto non debitis similique ipsam tenetur expedita praesentium;voluptatibus;3
292;similique voluptatum reprehenderit eius autem perferendis tenetur quisquam sequi eaque in voluptas molestias minus incidunt blanditiis dolorum hic doloribus adipisci rerum reiciendis a nemo deserunt error nihil voluptates fuga omnis provident maiores unde illo;doloribus;0
293;veniam amet harum fugiat minus nam debitis incidunt dicta quis quam facere dolorem ullam dolores tempora laboriosam adipisci repellendus veritatis repellat esse repudiandae corrupti illum autem sequi fugit deleniti soluta ducimus exercitationem;quo;4
294;voluptatibus saepe ipsa eius corporis voluptates natus ipsum accusamus sunt dolor sit facilis rem temporibus ratione eaque soluta officiis exercitationem ad eveniet beatae cum assumenda quas amet odit labore aliquam velit accusantium quam illum necessitatibus magnam suscipit ea hic;alias;4
295;natus nulla earum eum doloribus laborum quibusdam dolores ullam assumenda esse illum amet harum inventore quisquam reiciendis aperiam quo vel tempore incidunt ut aliquam ipsam quas hic voluptatum sed perspiciatis error tenetur nemo;quae;5
296;dolor assumenda at suscipit distinctio nemo tempore enim esse nisi id possimus similique vitae illo ea ipsam accusantium sed dicta labore error eaque nam voluptatibus officia accusamus facere laboriosam magni voluptatem asperiores aperiam doloribus officiis earum laudantium quia obcaecati a dolorem consectetur exercitationem ad beatae expedita aspernatur;cupiditate;4
297;iste repellat iure quasi odio debitis qui molestias dicta voluptate blanditiis assumenda animi molestiae accusamus dolorem similique ratione distinctio a saepe at eum culpa vero facere inventore esse quod modi ducimus dignissimos;ut;0
298;praesentium beatae voluptatum dolor fugit totam possimus veritatis porro hic ad accusantium omnis et fuga quia fugiat ullam corrupti error nostrum enim earum aliquam at reiciendis adipisci sunt dicta ea iure explicabo ipsa magnam minus quaerat;nam;9
299;voluptatem ea error cupiditate necessitatibus omnis eum repudiandae amet dignissimos sint fuga commodi nostrum recusandae blanditiis eaque odit praesentium vitae sit expedita quasi earum quas quae quod nulla officiis rerum a facere maxime perferendis vero nisi labore fugit accusamus reiciendis magnam;veritatis;2
300;cupiditate porro fuga animi ducimus facere natus adipisci inventore impedit eos corrupti ipsa in et quos eaque sequi eligendi quibusdam necessitatibus possimus illo fugiat iusto doloribus amet soluta dignissimos nulla cum nemo perferendis laborum optio omnis esse est qui;odit;7
301;eveniet ipsa eum dolorum voluptas fugiat sed iusto ipsam beatae labore qui vel vitae harum eaque in repellat eligendi quam repellendus dignissimos facilis tempore ducimus placeat officiis distinctio cum omnis nobis tenetur delectus a mollitia minus velit dolore maiores optio esse quidem blanditiis consequuntur nulla similique numquam;natus;2
302;atque autem soluta ex excepturi corporis mollitia provident quas vero cupiditate neque minus aliquid recusandae molestiae impedit voluptatem dolorum fugiat delectus quis velit perspiciatis eveniet dolorem dignissimos fugit sint ea rerum alias exercitationem at;aliquid;4
303;commodi illo adipisci consequatur rem nobis at sequi quasi ipsa temporibus necessitatibus praesentium culpa deleniti veritatis modi ad cumque assumenda voluptas eveniet quaerat illum recusandae maiores quas omnis numquam asperiores enim nisi saepe eligendi blanditiis alias reprehenderit dolor magnam odit ipsam distinctio tempore error ut nesciunt libero;eos;2
304;hic ipsa id facere totam mollitia minima dolore doloremque natus voluptatum a tempora magni voluptatem reiciendis earum maxime soluta accusantium aliquid temporibus deserunt commodi quidem tenetur dignissimos iure adipisci repudiandae sequi iste velit sit unde vel accusamus voluptate ea consectetur ex dolor alias animi praesentium ullam architecto consequuntur deleniti;cupiditate;8
305;repellat eveniet nisi maiores ducimus consequuntur harum fuga asperiores repellendus dolores magni voluptatem aliquam ipsam sint libero veniam dicta est quod ad optio dignissimos suscipit minus reprehenderit blanditiis fugit quam beatae voluptatibus aperiam rerum ex perspiciatis quidem molestias voluptas corrupti laboriosam;voluptate;8
306;tempore nulla vitae fuga aspernatur incidunt odit tenetur modi eius eum ea molestiae ipsum id reiciendis voluptate voluptas placeat alias officia rerum nostrum doloribus corporis sapiente laudantium quia maiores pariatur ullam sit commodi ratione accusantium neque odio mollitia error quaerat ducimus;excepturi;8
307;excepturi quibusdam rem exercitationem sed asperiores voluptatibus commodi enim fuga voluptatem quis ipsum eligendi obcaecati dolorum accusamus blanditiis dolores provident consequatur eos explicabo possimus beatae ut nam voluptatum numquam sequi eius tempora ad illo iste quo voluptates laboriosam temporibus necessitatibus qui vel in quaerat quidem voluptate;quia;8
308;totam quibusdam sunt exercitationem a ex consequuntur eligendi at quia eaque autem fuga officiis minima laudantium quasi deleniti nam quae dolore nisi enim tenetur inventore blanditiis illum iusto ducimus recusandae obcaecati quas similique vero natus quaerat iste tempora sapiente sint doloremque quidem;pariatur;4
309;rerum sit delectus culpa natus distinctio eveniet iusto voluptates magni vel qui ducimus eum necessitatibus nam aliquam nostrum porro quo quidem aperiam reprehenderit voluptatem dolores minima facilis autem debitis odio voluptas enim incidunt esse quae;esse;4
310;debitis alias atque illum suscipit tempora reiciendis dolor ex veritatis fugit facere accusantium totam aliquam reprehenderit dolore officia quasi consequuntur minima voluptate eius tempore adipisci eligendi sunt doloribus itaque dignissimos dolorem aperiam sequi amet cumque quaerat quis fugiat temporibus nostrum et mollitia laudantium quam eos ad laborum porro;in;10
311;vel officia vero nihil incidunt repellendus dignissimos amet modi odit rerum quis aspernatur et provident excepturi obcaecati eius ratione quae expedita enim ullam aperiam debitis corporis dicta at sunt beatae ipsa ducimus sed eligendi totam atque porro facere nostrum tempora sint cum non;enim;9
312;aliquid deserunt soluta at quisquam cum cupiditate nam rem enim explicabo et voluptates praesentium facere earum dolor quod minima facilis ducimus odio vitae doloremque dolorum accusamus tempora incidunt laudantium autem dicta necessitatibus animi ipsam maiores eius beatae repudiandae temporibus architecto;sapiente;7
313;quo at nam quis hic molestiae aspernatur minima iure ea aliquid repudiandae minus magni sint in iusto veritatis voluptatem cum corporis inventore ratione repellendus modi deserunt eius doloribus accusamus quod obcaecati ad cupiditate illo sequi aperiam facilis rerum;reiciendis;4
314;magnam praesentium officia expedita quos illum minima veniam non culpa placeat accusamus et laudantium iure consequatur rerum quas dignissimos quae deserunt voluptatibus amet perferendis quo illo dolorem dolor explicabo numquam cupiditate aut quisquam accusantium incidunt reiciendis ratione reprehenderit;odio;6
315;nam explicabo nisi architecto modi obcaecati adipisci laudantium veniam eaque accusamus eum fugiat amet assumenda aut nulla voluptate ducimus delectus ratione tempora qui perferendis beatae animi iste officiis voluptatibus quaerat facere voluptatum possimus temporibus voluptatem nesciunt mollitia eos illum praesentium autem enim cupiditate quam dolores;laboriosam;8
316;error magni necessitatibus quasi neque culpa consequatur quidem molestias cum officiis natus recusandae harum numquam reprehenderit sint et ad explicabo sequi eum fugit accusamus vero officia dolorem veniam nihil unde quo corrupti possimus quia doloremque repellendus quis architecto optio doloribus nisi exercitationem suscipit voluptatum temporibus quibusdam;debitis;4
317;laudantium nemo itaque corrupti quas nam mollitia sit assumenda doloribus eaque quo debitis enim ducimus est quaerat sequi a excepturi provident consequuntur illo eum ut porro nostrum perferendis maxime alias ad corporis voluptatem ipsa facere obcaecati cumque eligendi officiis error;vero;7
318;laboriosam fuga beatae sint quaerat officiis eius dolorum voluptatem quis quos modi fugit distinctio saepe accusamus alias repellendus nemo libero nihil consequuntur voluptate sequi cupiditate dignissimos pariatur reiciendis aliquid aut consectetur expedita eos maiores culpa;accusamus;3
319;amet porro reiciendis voluptate earum aliquam vero quidem dolore saepe ipsam error natus suscipit rerum perferendis placeat adipisci nostrum nemo nihil ea praesentium obcaecati similique laudantium reprehenderit corrupti provident excepturi vel deserunt at eligendi;odit;8
320;dolore culpa officia earum eaque eveniet voluptas pariatur iure obcaecati excepturi id nostrum consequuntur ipsum voluptate ex laborum delectus nesciunt libero exercitationem voluptatum facere aut ipsa consequatur laudantium totam porro beatae dignissimos facilis impedit dolorem perspiciatis;sed;0
321;ea quos tempora explicabo repellat incidunt quidem facere ex eius unde error deleniti rem deserunt suscipit quibusdam sed fugiat nihil quaerat facilis nemo tempore ad nisi reprehenderit mollitia est cum veniam magni provident dolorem id placeat delectus veritatis perferendis eaque maxime;laudantium;2
322;laborum vero minima cum velit neque deleniti culpa itaque quod quaerat nemo sequi eos reprehenderit numquam libero consequatur delectus aperiam iusto consequuntur quibusdam expedita magni amet ipsam provident deserunt veniam cupiditate ipsa dolore sapiente eum aspernatur quia minus corrupti repellat illo excepturi aut cumque dicta ut necessitatibus enim saepe;id;7
323;velit autem deserunt quibusdam ratione eaque atque eum tenetur ullam consectetur tempora quasi perspiciatis libero corrupti ab eius quia dolore dolorum soluta repudiandae voluptatibus aspernatur earum esse veniam sapiente impedit necessitatibus iste rerum minima repellendus quos cumque asperiores et ea commodi neque harum ipsum est quod a corporis voluptatem laborum;ad;2
324;similique quibusdam in facere animi magnam sapiente alias voluptatibus obcaecati dignissimos quasi sit nihil ad rem corrupti voluptates assumenda asperiores ducimus officiis dolore iusto delectus eveniet corporis reiciendis molestiae accusamus deserunt enim quas incidunt doloremque exercitationem optio aut harum voluptatum recusandae labore eaque;optio;4
325;quasi deleniti distinctio ipsam at officiis provident numquam earum adipisci accusamus fugit aperiam consequatur similique ratione asperiores totam rem eveniet ullam optio maiores aliquam praesentium aliquid id non harum sint repellat ipsa cum quae neque enim unde qui ad hic inventore reprehenderit cupiditate officia;ad;3
326;aliquid saepe nemo eveniet dicta amet quaerat voluptatum reiciendis in beatae non est quos modi rerum expedita recusandae earum similique deleniti suscipit labore quod repudiandae atque aspernatur consectetur et delectus nesciunt velit molestiae tempora commodi architecto quas excepturi magni possimus totam quasi cupiditate aliquam quisquam;rerum;10
327;consequatur fugit enim nihil est id esse similique accusamus nam rerum suscipit molestiae porro culpa ducimus ipsum sapiente facilis natus adipisci soluta ipsa repellendus molestias laboriosam beatae officiis rem in quos quas ad delectus pariatur velit nemo placeat ullam tempore cupiditate fugiat necessitatibus aliquam sunt;libero;7
328;repellat fugit assumenda id quas ullam voluptate totam saepe minus itaque doloremque consectetur ea sunt explicabo quos culpa a sint mollitia soluta impedit perspiciatis quod cumque suscipit unde est corporis sed ducimus incidunt ad ex doloribus quasi dolore rem molestias magnam officiis sequi distinctio eligendi similique at;delectus;9
329;magnam vel dolorem architecto alias quis soluta a placeat sit necessitatibus modi numquam facilis minima ad facere provident maiores laudantium neque id ab doloremque quasi quod illum culpa dolore voluptatum earum distinctio temporibus veritatis quia nostrum nemo;deserunt;3
330;veritatis voluptate ut minima reprehenderit repellat est adipisci quae aut fugit cumque laudantium assumenda harum fugiat iure dolores hic recusandae rerum consequatur eligendi corrupti voluptates inventore perferendis doloribus reiciendis nemo aliquid aperiam exercitationem excepturi animi;quaerat;0
331;voluptates dolore sit nesciunt nihil nemo praesentium quasi sequi accusantium rerum excepturi ea aperiam in necessitatibus dolor animi qui facilis consequuntur cupiditate corrupti aut dolorum consequatur natus obcaecati totam exercitationem sunt;ab;0
332;illo dolorum vitae nostrum ut fuga adipisci recusandae assumenda accusantium eligendi animi enim iure maiores labore reprehenderit hic ullam eius consequuntur odit dignissimos minima facilis dicta rerum repudiandae est veritatis incidunt deserunt quisquam alias placeat magnam debitis et omnis optio iusto eveniet fugit earum veniam blanditiis sapiente;consequatur;10
333;similique sunt dicta non modi excepturi corrupti facere at adipisci reprehenderit maxime aliquid tenetur earum iste minima dolore ex enim laboriosam molestias perferendis ipsum porro tempora rem quae vel autem magni vitae deleniti atque fugiat incidunt minus unde beatae architecto repudiandae;ut;6
334;ex eius deleniti eum praesentium accusantium id sit maxime recusandae nam exercitationem minus laudantium dicta vel aperiam inventore quae natus optio unde ipsum commodi molestiae distinctio incidunt molestias saepe reiciendis earum quos accusamus sed libero odio sequi explicabo voluptatum perspiciatis eligendi adipisci officiis veritatis facilis quas nisi ab expedita est;eum;2
335;impedit sapiente quaerat quasi suscipit culpa officiis pariatur id blanditiis obcaecati possimus aperiam reiciendis debitis iste consectetur neque expedita et asperiores commodi eius natus minima veniam voluptatem illo ipsum quos cupiditate tempore voluptatum ad;ad;9
336;cumque consequuntur iste tempore eligendi sed molestiae soluta vel dicta praesentium expedita esse cupiditate quae officia ullam odit voluptas tenetur ex natus iusto velit voluptatibus saepe officiis cum provident inventore exercitationem alias a neque necessitatibus quia rerum;ullam;2
337;veritatis obcaecati esse molestiae consectetur maxime nemo commodi quod quae nostrum ratione ab nobis quam voluptatem provident magnam perferendis animi quasi eius libero sint asperiores enim qui hic assumenda repellendus pariatur dolorum possimus quo reprehenderit repellat amet architecto;natus;2
338;blanditiis tempore excepturi distinctio veniam cupiditate culpa unde cumque fugiat eum alias autem officia dolore a libero ipsam ut sit reprehenderit mollitia nemo quis eligendi asperiores vitae vel architecto corporis;iure;8
339;tempore cum soluta excepturi cumque explicabo dolorem architecto accusamus similique consequatur eos earum quod adipisci ad esse dolorum beatae animi numquam sit dignissimos totam alias blanditiis nemo minus fugit sint ducimus nihil quos sed repellendus deserunt eum asperiores ex;esse;1
340;officia error dolorem tempore dolorum magnam maxime repellat facere voluptas a ullam ipsa consequuntur inventore accusamus corporis ab sint doloribus perferendis ut quibusdam blanditiis ad laudantium dolor alias ea pariatur delectus;quam;0
341;neque quisquam voluptatibus delectus quidem suscipit quaerat tempore accusamus minima aperiam fugit architecto vitae vero tenetur repellendus beatae adipisci quibusdam eveniet est numquam alias mollitia modi quam dolorem iste nesciunt voluptas;commodi;5
342;earum esse ipsum nulla delectus voluptates eaque ratione ea repellat blanditiis reprehenderit perspiciatis quae quidem saepe necessitatibus perferendis eveniet provident vero assumenda molestias deserunt doloribus magni voluptatibus nisi autem ab porro quaerat expedita omnis illo laboriosam quis a corporis beatae dolore voluptate quisquam odio nam eligendi qui officia sapiente;animi;7
343;doloremque ea quisquam dolor sint officia perferendis vel maiores aut quae nihil molestias error itaque illo laudantium ullam sapiente quia dolorem facilis cumque nemo odio exercitationem blanditiis rem consequatur quis illum architecto tempora beatae necessitatibus provident quam inventore cum;consequuntur;8
344;error culpa sunt molestias beatae delectus sequi animi ad quidem harum possimus mollitia aperiam dolore ea laborum ab ut odio ullam quisquam veritatis veniam alias voluptatem dicta quia deserunt dolorem adipisci non repellendus enim reiciendis nulla voluptates repellat magnam eum explicabo cum;voluptates;10
345;adipisci iusto nihil iste provident odio rem facilis vitae temporibus consequuntur optio omnis aperiam maxime doloribus magni fugit at labore quaerat odit soluta enim libero ullam expedita unde modi illum distinctio fugiat architecto quas explicabo dolorem sint nisi;debitis;6
346;soluta aliquid obcaecati iusto quidem deserunt impedit quibusdam id voluptatem distinctio dicta temporibus provident voluptatibus inventore fugit blanditiis pariatur quasi beatae dignissimos modi esse placeat illum delectus tempore sunt ut qui cum eaque enim aperiam adipisci mollitia aspernatur;dolor;5
347;aliquam illum culpa magni dolor natus soluta perferendis ab quam unde vitae facere eum earum iste impedit eveniet quibusdam vero tempora voluptatibus eligendi voluptatem velit sequi similique cupiditate libero dolorem laudantium dolore laboriosam at optio quidem minus corporis;totam;2
348;minus quos aperiam porro fugit voluptas alias expedita blanditiis deserunt accusamus corrupti natus architecto libero eum odit asperiores harum laboriosam sit consequuntur recusandae nemo inventore est aliquid voluptates placeat doloribus fugiat velit tempora iste provident neque corporis in;vitae;6
349;commodi ut natus aspernatur dolorum tenetur molestiae numquam nostrum odio error ad id temporibus ducimus consectetur saepe optio nihil nobis laudantium iure distinctio voluptas ipsam sapiente neque maiores ipsa animi eaque mollitia eligendi maxime illum nam rerum officiis magnam nemo voluptatem modi accusamus pariatur illo quaerat repellat quae;minus;5
350;labore ipsam fugit ducimus architecto minima eaque voluptates cum amet ut molestiae debitis quo obcaecati dignissimos fuga consequuntur sapiente ad itaque voluptate laboriosam perferendis quidem asperiores dicta impedit inventore aliquam veniam sunt iste repellat quam nulla nemo distinctio repellendus dolorum velit;blanditiis;0
351;delectus molestiae eveniet neque vitae doloribus vel laborum odio voluptatem quidem in ullam doloremque est magnam deleniti veritatis debitis fugit voluptas rem ea distinctio perferendis expedita totam veniam natus necessitatibus quasi pariatur minima dolore animi incidunt ducimus excepturi inventore et quas numquam impedit eius enim culpa;sed;4
352;nemo distinctio nesciunt quasi facilis repellat saepe eum quo possimus perspiciatis voluptatum ipsam quas tempore cupiditate eaque ducimus minima nobis labore quisquam vero fugit inventore optio atque quam modi quae sunt autem quis numquam tempora similique voluptates laboriosam debitis;porro;1
353;eveniet voluptatibus perferendis facilis odit dolores qui at inventore dolorum tempora atque similique alias magni animi quae quaerat modi minima autem earum saepe fugiat laboriosam quibusdam cumque sequi laudantium laborum architecto tempore natus harum reiciendis excepturi nobis ab sunt;hic;2
354;debitis qui neque hic reprehenderit voluptatum eius error impedit nihil dignissimos quod vel laboriosam dolorum tenetur veritatis delectus mollitia nostrum quaerat quia commodi enim vitae dolor omnis unde ipsum sint quam laudantium praesentium similique a rem eveniet placeat labore;delectus;9
355;voluptas hic quo aliquid ab deserunt quidem est tenetur aut vitae debitis nisi esse non libero saepe quos illo quasi eveniet ex ipsa nesciunt cum deleniti vero at laborum impedit error rerum adipisci magnam id nostrum unde nemo ea delectus optio a quae perferendis eos cumque sunt eius;ut;2
356;debitis praesentium doloremque sed voluptatum tempore accusamus aut sint deleniti enim soluta nostrum in reiciendis magni tempora incidunt similique laboriosam voluptatibus quis aspernatur repudiandae dignissimos at dicta non molestias reprehenderit est sit repellat excepturi doloribus nihil harum nisi deserunt ipsam porro hic nobis illo dolorem necessitatibus iure alias;deleniti;7
357;ducimus sequi autem expedita itaque adipisci nisi tempore eveniet dolorum aperiam reiciendis molestias quibusdam magnam quaerat veniam sed error necessitatibus minus sit pariatur deserunt magni enim quasi fuga amet temporibus aut illum beatae officia sapiente esse vel aliquam quis commodi blanditiis iusto;quo;0
358;tempora animi esse illo autem accusantium illum incidunt numquam quis hic libero tempore quod quas dicta recusandae veniam consequatur dolores sit velit id harum ducimus dolor aperiam facilis magnam a perferendis in minus;rerum;8
359;aperiam voluptatem dolor deserunt accusantium culpa aspernatur quo beatae optio quis animi qui quam magnam iste assumenda obcaecati saepe necessitatibus tempora cumque voluptas reprehenderit amet eius officia soluta repellendus totam libero illum cum tenetur dolore perspiciatis impedit exercitationem quia placeat est laboriosam nam;est;10
360;culpa distinctio ratione aliquam et architecto magni adipisci harum laborum sapiente dolorem eligendi quibusdam molestiae eveniet dolorum nihil amet facilis vel magnam rerum aspernatur minima enim neque voluptatum dolor dolores cumque possimus iusto explicabo officiis deserunt eum placeat assumenda odit nobis laboriosam tempore;rerum;6
361;dolorum illo ipsa voluptate saepe quod atque est accusamus quo quia quam esse ut sequi repellat porro laborum ducimus iure vitae libero commodi odit perferendis sed accusantium ab explicabo architecto rerum error dignissimos nobis dolore distinctio;veritatis;8
362;veritatis fugiat natus praesentium nesciunt amet aliquam quos optio vitae illum vero omnis error iure sint nisi assumenda officia dolores soluta pariatur aspernatur possimus saepe eaque eveniet facilis nihil qui quas laborum magnam maxime culpa esse repudiandae quidem dolorum voluptas;voluptate;2
363;aperiam molestias officia tempore laboriosam unde ad nemo soluta necessitatibus vero corporis fugit ex consectetur obcaecati excepturi beatae in voluptatibus temporibus blanditiis sequi labore perspiciatis sunt voluptatem non eos velit aliquam placeat omnis hic id culpa assumenda ipsam voluptate alias;adipisci;9
364;deserunt commodi ducimus tenetur soluta molestiae inventore dolores obcaecati aut consequatur repudiandae illum temporibus eius hic recusandae voluptate officia veritatis sequi itaque dolor modi eum ipsa fuga accusantium magnam vero asperiores corporis consequuntur;dicta;2
365;molestiae nihil officia laborum assumenda repudiandae eius ipsum illo eos repellendus sequi quod aperiam iste nostrum nam ex explicabo quia voluptatum rerum cupiditate alias eum cumque deserunt consequuntur aut fugiat tenetur adipisci nulla;suscipit;3
366;tenetur expedita aut libero sapiente ab fugiat distinctio mollitia tempora ipsa soluta officia possimus perferendis inventore voluptatibus laboriosam consequatur minus dicta similique ad deserunt architecto dolores sint sed ipsam dolorum quia officiis facilis quaerat ea magnam praesentium at placeat vel quidem dolore est molestiae accusantium numquam nulla quibusdam commodi quos;quibusdam;7
367;officia eius natus iste possimus perferendis est voluptate esse id veniam asperiores aut ratione rerum nam incidunt in corporis aperiam nesciunt ea non nisi culpa tenetur minus amet consequatur reiciendis facilis officiis;deleniti;4
368;blanditiis rerum id quae assumenda earum cumque unde soluta dolorem saepe facilis excepturi veritatis aliquid voluptas incidunt quasi quisquam a ullam quam atque temporibus autem vero tempora voluptatem iste velit deleniti cupiditate dolorum accusamus eius officiis sit nobis aperiam quas animi ipsam eos vel tempore commodi;odio;3
369;velit illum ullam explicabo necessitatibus voluptatem assumenda nesciunt commodi doloremque quidem ad similique eos minus saepe eligendi officia blanditiis temporibus sed debitis aut quos pariatur rem magnam soluta aliquam quis vitae hic adipisci dolore dolorum recusandae;vitae;3
370;magnam iusto tempora nihil aperiam quo veniam temporibus non modi officia sapiente quas dolorem saepe quibusdam pariatur quia adipisci ipsum inventore voluptate eligendi incidunt ad voluptates quaerat ratione sunt itaque assumenda aliquam ea provident architecto rem debitis minus eveniet similique veritatis minima;perspiciatis;4
371;distinctio laudantium placeat et officia quaerat delectus atque labore repudiandae perspiciatis eligendi nihil suscipit eveniet cum amet quo harum qui doloremque ut quia pariatur enim numquam illo facilis modi ipsa consectetur eius optio ipsum fugiat nisi quis asperiores vel maiores aliquam est voluptas saepe dolor totam nam dolore;veritatis;7
372;neque ipsa aperiam deserunt tempore quasi reprehenderit assumenda optio earum quidem officiis pariatur vero dolorem quaerat maxime totam aut fugit reiciendis quam alias amet corrupti adipisci quae animi ad illum officia asperiores distinctio doloremque ipsam;nemo;7
373;excepturi quas laborum blanditiis earum aliquam consectetur laboriosam natus nostrum accusamus deleniti corrupti enim voluptatum repudiandae ipsum necessitatibus at optio iste eos soluta officia totam tempore ea libero ducimus minima beatae ad dolorum mollitia quam corporis rem similique porro;aperiam;2
374;commodi quidem explicabo molestiae qui perspiciatis vitae soluta illum magnam distinctio expedita ea porro harum deleniti dolorum id esse nesciunt quasi numquam sunt consequuntur deserunt molestias quod sit repellat eum alias voluptas modi;obcaecati;1
375;quae temporibus quasi unde reprehenderit inventore sunt eligendi voluptatibus sint ullam possimus architecto deleniti vel modi facilis nobis eveniet dolores iusto minima similique maxime exercitationem quo ut vitae veritatis quod quam;omnis;10
376;accusantium sequi illum reprehenderit repellendus nihil pariatur temporibus commodi laudantium fugit aperiam sint fuga officiis velit totam deleniti illo culpa error debitis libero eius nemo odio quo voluptatibus laboriosam perspiciatis deserunt aliquam corrupti quasi at a dicta rerum ipsum omnis natus voluptate necessitatibus;debitis;10
377;excepturi libero deserunt qui earum eaque commodi explicabo at assumenda beatae itaque sapiente quo repellendus consectetur expedita quasi modi numquam in totam odit facilis mollitia ab ut doloribus iste ex voluptates obcaecati veniam voluptatem sequi harum voluptas illum quibusdam velit perferendis provident;velit;10
378;adipisci harum inventore dolore voluptatem ad consequuntur facere sit labore exercitationem laudantium ducimus quam culpa reiciendis hic necessitatibus quas laborum provident delectus rerum aperiam minus nulla eum iure magni suscipit debitis vero velit deleniti blanditiis repellat;fugit;1
379;dolore vero deleniti ipsam excepturi possimus maiores necessitatibus minus eligendi dicta voluptatem in unde ad optio soluta ratione quas dolorum laudantium facere quis error tenetur quo ex aperiam repellendus consequatur alias debitis inventore doloremque consectetur asperiores atque itaque reprehenderit explicabo enim placeat fugiat distinctio;enim;3
380;dolorem porro sequi accusamus perferendis commodi ea repellendus provident cumque fugit quia debitis quas veritatis similique totam pariatur nihil iure deleniti suscipit architecto velit rerum voluptatibus corrupti maxime animi voluptatum est incidunt soluta neque consectetur quae perspiciatis magni culpa molestias facilis modi sapiente ut quidem ipsa enim dignissimos;ullam;2
381;vitae quae doloribus a reprehenderit sed accusamus assumenda excepturi veritatis iste esse nihil at voluptas fuga nam numquam enim magni velit iusto ab eum veniam debitis placeat ullam non quo reiciendis corrupti animi quis et molestiae labore sunt voluptatum praesentium dolorum aspernatur;enim;6
382;magni iure voluptatum a odio architecto laudantium obcaecati repellendus eos excepturi aut at quidem mollitia in illum atque quasi ipsa consectetur delectus quod labore rerum odit ad voluptas praesentium culpa minima iste quibusdam quaerat nostrum dolore esse;earum;3
383;porro commodi reiciendis iure perspiciatis labore tempora saepe culpa laboriosam iusto voluptatem harum necessitatibus inventore dolores unde aliquid et repudiandae sunt earum fugit eaque animi maxime consequatur ducimus quibusdam illum non rerum totam enim mollitia rem repellat sit provident quae recusandae accusantium libero dolor corporis doloribus dicta atque ad;molestias;5
384;vero alias consequuntur placeat quae debitis laboriosam quis quos vitae temporibus quibusdam exercitationem quam iusto recusandae eligendi fuga voluptate corrupti est molestiae similique mollitia reiciendis fugit repudiandae dolore illo impedit reprehenderit nesciunt ut voluptatibus cupiditate doloremque amet earum consequatur voluptates consectetur ipsa aspernatur;unde;8
385;quis tempora facere iure minima laborum nobis pariatur eaque earum magni saepe libero consequatur reiciendis perferendis maxime exercitationem rem fugit soluta asperiores enim temporibus impedit sed ratione ducimus quod molestias dolorem porro fugiat vero amet similique sequi deserunt corrupti atque;consequatur;2
386;autem exercitationem itaque tempore aspernatur voluptas eos vel maxime illo deleniti sapiente expedita repellat corporis molestias illum adipisci eum voluptatum impedit fugit minus nemo dignissimos nulla quasi quis eveniet ipsum quia iusto quibusdam quaerat ullam mollitia praesentium nesciunt obcaecati ipsa totam quam nobis ad vero iure explicabo nihil;id;7
387;atque commodi corporis cupiditate accusamus minima modi sunt vel maxime temporibus sed eos odit cumque eveniet deleniti recusandae soluta quae illum itaque explicabo facere in a ullam facilis suscipit incidunt nisi quibusdam excepturi ut velit magnam esse quia perspiciatis consequatur;rerum;5
388;ut neque laudantium voluptatum quidem vero nemo dolores quasi et aperiam deserunt tenetur magnam explicabo excepturi voluptates dolor assumenda officiis sunt animi pariatur odit veniam distinctio molestiae id ea molestias itaque suscipit fugiat facilis odio provident alias officia aliquid accusamus aliquam temporibus magni possimus illo beatae consectetur cumque ex;facilis;5
389;error ipsum id natus beatae possimus iure quo voluptatum ab cumque consequatur corporis nemo vitae unde animi voluptatibus quos sapiente consequuntur veniam excepturi corrupti optio reiciendis ea amet odio adipisci qui atque veritatis laudantium sequi voluptatem rem quod tempora autem deleniti ut placeat voluptates;placeat;10
390;ut molestiae obcaecati rerum perspiciatis temporibus ducimus voluptatum quisquam dolores ex voluptatibus culpa unde vitae enim placeat exercitationem atque amet dicta quia pariatur deleniti reprehenderit dolorum ad nemo possimus nisi quos esse corporis;sint;7
391;eveniet dolorem perspiciatis laborum dolore reiciendis recusandae voluptatem harum pariatur molestiae obcaecati eius exercitationem soluta possimus illum minus est sapiente id dignissimos laboriosam inventore nam ab voluptatum non quos hic earum dolorum ut molestias beatae quisquam consequatur ipsa nobis architecto;magni;5
392;quasi asperiores ipsa consequatur quisquam corrupti maxime ratione placeat autem in doloremque id quidem assumenda praesentium quo mollitia inventore voluptas optio eaque voluptatem veritatis deleniti architecto laudantium cumque nostrum rerum;aut;1
393;deserunt at expedita quia porro alias unde aut quisquam obcaecati molestias corrupti omnis quas id recusandae quaerat sit numquam ea praesentium accusantium fuga error assumenda maxime ipsa reiciendis voluptatem repellendus qui nisi fugiat ad cupiditate aperiam;assumenda;1
394;dolorem laudantium nesciunt beatae illum nobis consequuntur unde ad commodi possimus nemo deleniti ab ex exercitationem dolore laborum voluptatem neque labore accusantium molestiae architecto inventore recusandae laboriosam eaque harum eveniet quibusdam asperiores voluptatum voluptate dolores quod;placeat;5
395;tempore porro dolore error eveniet ipsam facilis eaque praesentium ratione hic deserunt minima minus cumque ea doloribus nemo illum nostrum esse numquam illo deleniti consequatur pariatur voluptatum reprehenderit quaerat quam eum at reiciendis vitae voluptatibus perferendis ut enim quasi;repudiandae;6
396;obcaecati hic quasi nostrum aliquid cumque magni soluta quis cupiditate laudantium voluptatibus accusantium voluptas voluptatem sunt consequuntur minus suscipit aliquam totam aperiam amet sequi doloribus maiores quibusdam reprehenderit est quaerat ipsum;cumque;9
397;ipsum quos velit id perspiciatis rerum fuga eum aliquid sit suscipit unde commodi qui maxime animi saepe iusto illo blanditiis et facilis error quae corrupti impedit expedita fugit cum nobis sunt at dolore ut dicta laboriosam veniam accusantium rem;ad;2
398;voluptatem iure id quod vitae temporibus tempore debitis consequuntur suscipit illum repellendus aspernatur eius dignissimos enim voluptas sint at saepe repellat qui omnis doloremque dicta accusamus libero mollitia dolores exercitationem quas delectus tenetur labore velit sequi officiis praesentium quibusdam fugit perspiciatis deserunt alias eveniet soluta a esse dolorem adipisci ducimus;nisi;10
399;officiis labore eum earum et harum autem vel ut necessitatibus cum aspernatur aliquid quod sed corrupti veritatis voluptatum voluptatem recusandae molestias blanditiis deleniti enim cupiditate repellendus quam accusamus consequuntur beatae numquam exercitationem nihil facilis velit mollitia sint est fugiat porro ducimus tenetur expedita;laudantium;0
400;culpa sequi neque repellendus quia vitae non enim praesentium suscipit similique ipsam dolores pariatur optio dicta rem repudiandae consequuntur tempora corporis iusto magni aut recusandae voluptatem illo facilis animi nemo autem totam;accusantium;1
401;quae quas quis culpa aliquam sapiente natus tenetur libero magnam sunt quasi illo quia repellendus perspiciatis tempore maxime eum ducimus labore accusamus distinctio ullam esse enim ipsa laboriosam mollitia dolore illum placeat;eaque;9
402;tempora repudiandae sapiente assumenda aut praesentium delectus perspiciatis corporis perferendis quisquam omnis ipsa error ducimus fuga nesciunt a minus obcaecati voluptas esse pariatur mollitia ut nam cupiditate ea ab rem cumque libero iure ipsum atque saepe ipsam;error;2
403;esse hic aspernatur quia unde sit non obcaecati consectetur quibusdam earum similique incidunt dolor adipisci dolores debitis laborum rem fuga dicta ratione natus itaque quo tenetur at nostrum est cupiditate aperiam voluptatem inventore laudantium optio repellendus ullam dignissimos impedit laboriosam accusantium ipsa qui ut officiis;voluptatibus;2
404;magni nulla magnam natus voluptatum dignissimos doloremque fugiat maiores nisi at maxime accusantium excepturi voluptas quos laudantium eaque eveniet ex odit quaerat cumque ea nihil earum inventore rerum porro blanditiis facere id assumenda facilis placeat corporis quibusdam eius sunt veniam voluptatibus quas;perferendis;7
405;totam ipsa sit eum numquam possimus officiis fuga sunt illum et odit temporibus ex fugit dolorum sapiente nobis blanditiis nam accusantium quisquam minima reiciendis aut nihil id omnis ipsum deserunt dolorem facere aspernatur eos ullam doloribus magnam consectetur beatae;incidunt;0
406;a ullam voluptate accusantium omnis repudiandae non vero voluptatem iste dolor harum molestias hic quis voluptatum quam reiciendis reprehenderit quas sunt commodi ex laboriosam ducimus quisquam libero atque quae ut aperiam modi possimus ad veniam maxime suscipit sapiente explicabo iure;dolorem;2
407;debitis tempora repellendus quisquam recusandae nulla saepe consequuntur quam quis animi reprehenderit harum libero porro itaque totam voluptate pariatur necessitatibus eum delectus nostrum mollitia velit inventore odio aut provident maxime fugit dolorum aperiam cum placeat molestias magnam a voluptatibus corporis;sint;4
408;esse accusamus explicabo fuga facere qui eum adipisci vitae tenetur nesciunt illo modi autem praesentium placeat ipsum ea totam perspiciatis ipsam veniam numquam reprehenderit repellendus porro necessitatibus quo repudiandae nulla sapiente omnis beatae quos ab quas voluptatum consectetur voluptates error animi magni sunt odio quis;enim;6
409;ratione cum nostrum dolores enim unde expedita molestiae minus ex numquam asperiores modi ab consectetur explicabo accusantium at neque ea fugiat corporis obcaecati in nesciunt iure eum veniam maxime quisquam praesentium adipisci vero officiis dolorum delectus veritatis quod nam eligendi consequuntur aliquam eveniet ipsum alias beatae aspernatur similique quam;quia;8
410;perferendis corporis repellendus labore atque non quidem iusto amet itaque dolores minus modi eaque sit qui mollitia temporibus debitis molestiae eligendi odit dolorum numquam laboriosam culpa ratione repudiandae nesciunt fugiat accusantium esse in quam;officia;5
411;atque porro sapiente autem ducimus magni ex minus architecto similique et distinctio quae nihil optio laborum ipsa deserunt suscipit accusamus corrupti minima corporis tempore ipsum sint doloribus veniam facere non excepturi eos ab fuga ea unde assumenda quibusdam expedita dolor odit voluptatibus voluptatem quisquam dolores nemo blanditiis reprehenderit inventore animi;temporibus;4
412;praesentium dolores facere sit iusto atque doloribus illo molestiae asperiores vel vero ab earum quos soluta exercitationem cum magnam assumenda expedita porro aut omnis deserunt inventore suscipit consectetur ex accusamus laborum;iste;6
413;nulla error ipsa reprehenderit id ipsam animi eligendi rem in voluptatum officiis exercitationem non quos natus expedita magnam enim deleniti officia deserunt mollitia illum inventore ut quae quisquam repellat dolore dignissimos esse;harum;2
414;inventore quisquam velit omnis hic molestiae quo corrupti doloribus impedit tempore animi amet soluta voluptatibus distinctio error maiores aperiam eveniet accusamus nihil mollitia totam reiciendis qui corporis perferendis adipisci aliquam architecto culpa enim atque nesciunt blanditiis neque dolor;exercitationem;4
415;aliquam veniam quam architecto temporibus distinctio assumenda omnis ipsum ea ut eius a ab perferendis non doloribus deserunt alias hic incidunt dolorum mollitia quos consequuntur dicta iste at nemo nesciunt reprehenderit quidem dolore est sunt maxime optio;maiores;2
416;doloremque quae iusto ipsa voluptates officia labore numquam aliquam tempore excepturi perspiciatis enim beatae cumque amet officiis laborum dolores in aperiam veniam consequuntur autem reprehenderit ab rerum provident velit ratione temporibus sed iste;itaque;1
417;odit adipisci repellendus eum aliquam numquam mollitia voluptatum tenetur deserunt eveniet nobis non dignissimos consequuntur expedita accusamus error ipsam corrupti animi illo voluptatem explicabo inventore iste vitae provident aspernatur illum minus neque veritatis delectus possimus velit optio et praesentium ea natus ab ullam corporis facere;sint;3
418;eos reprehenderit unde optio magni neque molestiae voluptatem libero repellendus quas ducimus ratione accusantium commodi quae explicabo eius architecto aspernatur id fugit quibusdam quos placeat voluptate ex consequuntur nemo sed cupiditate eaque facere;fuga;3
419;recusandae voluptates corporis ad magnam necessitatibus voluptate eaque reiciendis natus deleniti delectus omnis asperiores laborum enim sit eum debitis iusto praesentium quasi obcaecati tenetur nemo vero provident incidunt dolores quae officia exercitationem accusantium voluptatem a labore dolore nihil qui sed veniam;sint;10
420;maiores iusto reprehenderit aut cupiditate fuga quibusdam expedita consequatur voluptate at dicta aliquam incidunt nostrum alias perspiciatis vitae saepe architecto tempore doloribus inventore officia neque qui corrupti ullam odio debitis possimus;culpa;3
421;iste repellendus temporibus accusamus possimus sit voluptatem qui ad unde ipsa natus veniam ab deleniti voluptatibus minus quisquam debitis obcaecati quos non provident ipsum dolores hic ullam omnis perferendis vero pariatur beatae inventore quam itaque nam officia laborum ea atque exercitationem ratione;soluta;1
422;tenetur perferendis corrupti ad ut numquam minima assumenda nobis asperiores repellendus provident ducimus dignissimos deleniti consectetur ratione eveniet adipisci quisquam repellat iste sit recusandae nihil atque nam quod similique doloribus at possimus a labore optio cumque veniam eius magnam maiores sapiente;veniam;4
423;molestias voluptatibus quisquam impedit quam labore necessitatibus corporis laboriosam fuga temporibus facere itaque iusto cum eaque quia officiis magnam distinctio quod nulla corrupti eum facilis voluptates error sed non modi laudantium magni aspernatur consequatur earum quidem dolor saepe totam perferendis maiores repellat omnis repellendus odio accusantium ab;odit;8
424;tempora dignissimos voluptatum nihil mollitia quos exercitationem doloremque ab nostrum vel excepturi nemo odit placeat ipsum rerum itaque deleniti accusamus optio modi corrupti qui soluta ut cupiditate fugit cumque quae facilis provident eos repellat aperiam expedita doloribus;corporis;7
425;obcaecati reprehenderit et beatae quam cumque excepturi ex doloribus inventore hic nulla mollitia nihil officiis unde suscipit fugit doloremque iusto quisquam voluptas accusantium quod voluptatum corrupti consequuntur possimus at eveniet soluta ipsa saepe velit voluptate rerum expedita quos molestiae quas ducimus quibusdam natus sed id quaerat sunt architecto totam distinctio;labore;9
426;illo possimus molestias odio nisi quo optio ducimus tempore repudiandae repellendus sint nulla adipisci reiciendis debitis cupiditate reprehenderit explicabo maxime quae nesciunt doloremque iure voluptate unde molestiae alias perferendis error illum vel quia harum at dicta dolores fuga mollitia cum asperiores est deleniti;veniam;8
427;odio adipisci vero repellat inventore sequi maiores assumenda ratione totam saepe eaque ex maxime architecto iste rem delectus facilis eos neque harum obcaecati tenetur facere quibusdam dolores explicabo molestias alias dolorum possimus accusantium dolorem corrupti quam eius quia;debitis;6
428;illo doloremque fugit est hic molestias ullam deleniti magnam nesciunt ad voluptate omnis corrupti repellendus obcaecati dolore alias dolorem magni nobis laboriosam reprehenderit atque asperiores assumenda tempora ut molestiae officia deserunt dolores ab;libero;2
429;minima magnam animi blanditiis reprehenderit quaerat perferendis unde quod laborum nemo impedit tempore iste earum sunt eveniet expedita minus asperiores recusandae exercitationem id pariatur tenetur ab cumque consequatur obcaecati aspernatur corrupti quia quam optio praesentium suscipit repudiandae velit delectus enim architecto qui est deleniti veniam totam quo autem;iste;9
430;corrupti rerum sequi ut aliquam unde sint ipsam ullam mollitia repellat dicta quam repudiandae nam omnis cumque delectus laudantium alias totam quod eos harum nesciunt magnam placeat accusamus nulla assumenda aperiam repellendus facere beatae velit commodi earum molestiae;quia;4
431;quasi aperiam veritatis nobis mollitia dolore enim harum nam ea nesciunt qui eligendi ipsam dolor voluptas dolores adipisci voluptate asperiores voluptates aliquam reiciendis repellat molestias doloremque delectus aliquid dignissimos ab repudiandae temporibus hic libero velit;molestiae;6
432;ipsa inventore laboriosam nisi veniam cupiditate accusantium repellendus maiores esse perferendis sequi tempora facilis voluptatem alias quaerat non eveniet aperiam id similique quas eos magni itaque velit sit aliquid ea amet possimus voluptatibus dignissimos in harum dolorum;id;4
433;facilis exercitationem et culpa perspiciatis vero iste accusantium debitis impedit at in corrupti dolores adipisci aliquid libero natus facere eligendi quae ducimus dicta itaque officia molestiae vitae accusamus dolor laboriosam quam aspernatur illum praesentium vel quis deserunt soluta necessitatibus ipsum suscipit nisi explicabo totam odit;suscipit;8
434;perferendis magnam voluptas consectetur nam maxime et sunt ullam quo sint asperiores cumque odio quaerat aliquid eligendi similique doloribus beatae illum accusantium animi quod autem vero placeat officiis voluptate in;sapiente;1
435;eveniet porro et repellat unde praesentium numquam maxime provident omnis quod enim quos aspernatur pariatur eum in obcaecati ullam quo asperiores ab nobis vel consectetur accusantium molestiae totam dicta sed eligendi dignissimos dolore optio exercitationem quasi mollitia laborum cum ratione iusto dolorem quas explicabo alias quae necessitatibus;molestias;4
436;officiis fugit aliquid non dolores magni eaque molestias molestiae repellat quos dignissimos nostrum eum soluta alias iure perspiciatis fuga blanditiis ipsam et dolorem quis a sit officia quidem facilis maiores impedit sequi cumque autem est culpa mollitia suscipit libero commodi totam omnis consequuntur nulla quo cupiditate sapiente;consectetur;3
437;aspernatur molestias non impedit ea corrupti odio temporibus quae illum soluta dolorem fugit excepturi aperiam deleniti magnam voluptate quidem suscipit dolorum dignissimos culpa laboriosam error harum velit aut dicta repellendus eos doloribus ipsa earum fugiat officia doloremque repellat a cum quo;nemo;0
438;esse sint rem illum repellat minima obcaecati nisi perspiciatis est dolor nam nihil iste sit et similique asperiores sequi provident id nostrum atque quos totam veniam ducimus accusantium deleniti ex voluptates harum facilis dignissimos nulla earum ipsa error unde minus at ipsam maxime vitae cumque numquam molestiae;quia;1
439;magni et labore est laborum nam illo architecto exercitationem accusamus voluptates ipsum beatae maxime quidem libero ex delectus deleniti adipisci excepturi similique numquam vero eius iste ab officiis dolorum sit alias quam facere perferendis enim facilis doloribus vel quo maiores;veritatis;1
440;explicabo est facere cupiditate quae eos distinctio omnis voluptatum repellat ipsum officiis vel necessitatibus quidem non quo adipisci placeat exercitationem suscipit illo corrupti reiciendis at molestias quasi illum ullam sequi vero natus eum possimus rem hic veniam magni voluptas quis reprehenderit beatae;necessitatibus;9
441;omnis cum hic accusamus nesciunt quas facilis odio sapiente rerum amet dolores reprehenderit ipsam deserunt architecto tempore dolorem qui quis nemo nostrum exercitationem aut ad ducimus dolorum quasi esse delectus aliquam non fuga velit iure voluptatibus;voluptatibus;3
442;nulla temporibus dolor laborum eveniet in vitae quas perspiciatis deserunt saepe rem consequatur commodi similique distinctio voluptates aliquid beatae ex deleniti officia inventore accusamus odit sunt aperiam esse mollitia maxime fugit quod;magni;2
443;cum nam voluptas quos reiciendis temporibus quisquam quaerat itaque officiis voluptatem laborum distinctio possimus quae sed ipsam animi perferendis placeat veniam facere aspernatur praesentium explicabo provident corporis ex sunt quas dolore maxime odio molestias velit est dolores esse cumque incidunt quibusdam ducimus;molestiae;0
444;quisquam exercitationem consequuntur error sint ullam dolorem ipsum pariatur nobis expedita ex iste quo nemo architecto rerum molestias provident mollitia praesentium est iure earum minima quam laudantium qui voluptatibus ipsam quis;asperiores;9
445;aperiam eaque expedita repellat assumenda nulla ipsam dolorum natus maiores incidunt praesentium iste ratione cumque tenetur eos soluta voluptatem enim necessitatibus velit molestiae minus dolorem nam error modi fugiat quo laboriosam ab ipsum obcaecati earum adipisci nisi;deleniti;0
446;voluptate in recusandae fugit ea officia dolores praesentium impedit cum corrupti dolore deserunt consectetur veritatis nihil doloribus quo laudantium voluptatibus ullam hic asperiores rerum delectus earum odit atque quidem assumenda repellat tenetur maxime similique dolorem iste reprehenderit esse amet omnis soluta sequi consequuntur ratione;quisquam;9
447;officia aliquid fugit dolor ullam nesciunt excepturi animi molestias exercitationem quis labore doloribus non rem ipsam quae a sint voluptas voluptates dicta molestiae consectetur quas mollitia saepe perspiciatis dolorum incidunt dolore voluptatibus eius;architecto;2
448;facilis non praesentium esse sunt libero voluptatum dolorum harum aut ab ipsam iusto tenetur necessitatibus numquam saepe laudantium ratione accusantium aliquam earum voluptatibus molestias iure soluta quos vel dolores tempore;corporis;0
449;dolore et ducimus temporibus sapiente eius dolores perferendis modi iure magni adipisci error dolorem earum pariatur voluptas facilis deleniti sequi assumenda vitae neque doloribus at tenetur explicabo ad mollitia alias possimus quas commodi omnis laborum atque velit deserunt itaque ab labore quasi placeat aliquam natus minus tempore nam accusantium illo;doloremque;6
450;asperiores sapiente accusantium saepe ex vero accusamus itaque sequi doloremque beatae tempore facere laborum perspiciatis obcaecati debitis minima aliquam laudantium nemo adipisci cupiditate quibusdam quae placeat velit magnam aliquid a eligendi hic aspernatur voluptatem dignissimos doloribus architecto repellendus maiores ullam illum id repudiandae incidunt fuga cumque ducimus quod possimus voluptatibus;sequi;9
451;distinctio iste illum voluptas mollitia sequi quam sed temporibus tenetur quo corporis similique sapiente veniam et perferendis tempore sunt repudiandae esse quae voluptatum quas eligendi repellat deleniti excepturi autem cupiditate quaerat eveniet reiciendis necessitatibus dolorum doloribus impedit fugit amet quisquam quibusdam vel dolore saepe voluptatem velit;culpa;7
452;modi beatae quos voluptate corrupti nesciunt excepturi aperiam velit laborum doloremque adipisci assumenda incidunt molestiae consequatur delectus explicabo minus repellat sint pariatur saepe atque ab reiciendis deserunt libero tempore et facilis corporis dolorum ducimus quam vero sunt;aperiam;9
453;cumque vero esse unde est sequi officia voluptate excepturi tenetur eos voluptatum nemo nihil suscipit voluptas laborum consectetur veritatis facilis beatae et nulla repellat dolore quo reiciendis omnis reprehenderit molestiae voluptatibus enim quasi sunt corrupti tempore quia praesentium culpa perspiciatis eaque dolorum;id;10
454;natus saepe quod atque fuga beatae sed aliquid eveniet totam recusandae nesciunt iusto dicta voluptate tempora voluptatum porro accusamus nisi eius iure illum eum ipsum iste hic doloremque unde possimus est ex;soluta;4
455;harum atque fuga at porro facilis tenetur ad nulla autem recusandae earum illo reprehenderit provident aspernatur culpa exercitationem quam sit repudiandae excepturi cupiditate incidunt explicabo quaerat laudantium omnis ipsum eligendi unde ullam totam ipsa delectus inventore mollitia;corporis;7
456;laborum suscipit esse laboriosam architecto reprehenderit amet quisquam quae reiciendis veritatis aperiam voluptatum praesentium corrupti labore ea animi recusandae maiores nulla placeat fugit voluptate sapiente vel neque unde officia excepturi facere vero eveniet;voluptate;6
457;architecto consectetur magni porro quaerat sapiente nostrum numquam ratione harum corporis rerum maiores est recusandae voluptatibus doloribus ducimus corrupti eligendi assumenda itaque qui ab dicta optio iure dignissimos ipsam eveniet fugiat non odit libero;veritatis;9
458;aspernatur sapiente quidem adipisci debitis ipsam molestias asperiores dolorum in tempora inventore recusandae culpa harum ducimus sed numquam rerum at quas obcaecati libero aperiam dignissimos laudantium dolore minima distinctio blanditiis facere id corporis doloribus quae eveniet a expedita illo rem modi dicta labore nisi autem nesciunt ad voluptate accusantium;dolorum;9
459;voluptatibus eum iste porro obcaecati cum dicta quae sed assumenda temporibus mollitia labore ipsam voluptatem ut quam excepturi suscipit soluta quibusdam tempora quasi rerum repudiandae alias natus quis sapiente in nesciunt nostrum odit earum esse nulla magnam deserunt numquam maiores quia hic architecto non omnis odio voluptates sunt sequi amet;laboriosam;4
460;fugit sequi maiores amet odit quibusdam repellendus ipsam nobis deleniti molestiae distinctio iusto non laboriosam tempora quod harum ea laborum quisquam enim incidunt corporis voluptate delectus culpa labore nihil mollitia numquam possimus;recusandae;0
461;beatae autem odio vel nihil quo minima repellendus iste nam ullam suscipit quas voluptatibus accusamus cupiditate vero explicabo alias repudiandae expedita voluptates aut atque ex optio eveniet iure dignissimos quia;ipsa;0
462;sunt magni commodi sapiente fugiat voluptatum cum porro ipsum quasi eaque adipisci consequuntur quam sed inventore officiis quibusdam nemo dolor dolores nihil alias ducimus doloremque modi aliquam quae dolorem temporibus iste et maiores quia incidunt distinctio tempore culpa obcaecati architecto;fugit;2
463;non accusantium quisquam neque at voluptatibus maiores consequuntur magnam harum illum modi nisi eos iste in doloremque accusamus deleniti beatae ratione quis earum minus iusto quae necessitatibus aliquam animi fuga sint voluptatem dolore suscipit dignissimos autem cumque libero dolorum quos laborum aspernatur ab voluptatum repellat odio quidem itaque;at;6
464;commodi aliquam tempore dolore ullam voluptatem quia et aperiam quis voluptate eaque earum soluta molestias dolorum debitis delectus nesciunt vel placeat explicabo eius quod temporibus excepturi perferendis beatae accusantium pariatur hic atque blanditiis perspiciatis repudiandae fugit non iusto corrupti nostrum aspernatur in maxime ipsam recusandae voluptates dicta veritatis animi doloribus;cumque;7
465;a repellendus sint nam accusamus eum perspiciatis esse asperiores aut suscipit voluptatibus porro officiis in maxime impedit rerum expedita delectus nesciunt perferendis ab distinctio aspernatur consectetur excepturi mollitia dolore atque recusandae animi error nisi;repellat;5
466;velit quis quos soluta facere esse eum exercitationem tempora distinctio cum nobis magnam eligendi enim recusandae dolor ad dolores nam a atque ipsa rerum fugit explicabo repudiandae ipsam quidem corporis mollitia consequuntur illum cumque provident inventore;neque;3
467;excepturi ullam consequuntur vel iusto beatae quam explicabo itaque consectetur nisi dignissimos aliquam exercitationem dolores similique impedit quidem esse fuga assumenda quisquam nobis facere iste quae veritatis earum harum tempore placeat temporibus id dolore libero modi quod facilis ratione quos accusamus voluptatum officia quis et molestias maiores ea;alias;7
468;beatae tempora rem harum totam nisi magni atque est modi amet pariatur suscipit eligendi et delectus exercitationem at fugit labore deserunt voluptatum vitae maiores iure facere nulla veniam eveniet odio;velit;4
469;expedita iusto odit facere error magni nulla vel quasi reiciendis sint sapiente fuga doloribus a alias facilis at voluptates dolore possimus nemo neque similique quae amet architecto sed nisi libero pariatur repellendus perferendis temporibus deserunt molestiae asperiores eveniet laborum ducimus animi;itaque;9
470;placeat illo sed iure autem magnam quibusdam deleniti dignissimos saepe nisi voluptate nostrum doloremque cumque fugit mollitia minima corrupti delectus fuga ad assumenda consectetur incidunt eum reiciendis culpa officiis tempora voluptatibus iusto cupiditate eos porro quaerat deserunt commodi repellat similique rem veritatis laboriosam ipsa voluptas;amet;10
471;ex tenetur eligendi provident ratione adipisci officia iure accusantium eaque accusamus tempore laborum minima excepturi vero aut aliquid molestiae perspiciatis veniam aperiam animi quaerat nesciunt fugiat debitis numquam facere assumenda dignissimos sed officiis nemo maxime error nulla vitae quis corporis iusto ullam ab quo dolores;repellendus;4
472;sequi consequuntur explicabo officia adipisci aut quibusdam accusantium exercitationem dignissimos illum ratione voluptatem asperiores accusamus inventore mollitia provident laudantium labore corporis praesentium unde sapiente harum architecto aliquam veritatis excepturi facere ipsa consequatur voluptatibus pariatur odio porro incidunt cupiditate aspernatur quaerat;dolorem;10
473;voluptates quaerat expedita eveniet animi mollitia praesentium nisi doloremque nemo quia explicabo veniam voluptate illum quisquam vero amet minima rem quod blanditiis fugiat assumenda in laboriosam ipsam ex tempore dolorem voluptatibus perferendis repellendus a corporis adipisci quae quas repellat doloribus ut accusamus modi ad;enim;10
474;voluptates omnis vero labore consequuntur magni cupiditate amet quibusdam dolorem dolore eligendi dignissimos in eaque magnam velit quidem repellat nostrum sunt incidunt aut nisi exercitationem et modi sint non fugiat maxime adipisci;at;0
475;sint laboriosam reiciendis ab pariatur saepe aspernatur impedit corrupti possimus veniam nulla doloribus obcaecati cumque reprehenderit tempore rem distinctio neque voluptatum fuga soluta autem quae dolor consectetur consequatur iure repudiandae sunt est voluptatibus rerum laborum assumenda minima facere quaerat id eaque asperiores fugit accusantium ipsam voluptas maiores velit;minima;4
476;nulla sequi ratione illum ullam laborum aliquid ab velit commodi veniam optio officiis officia alias placeat labore quidem harum quibusdam vel non qui quos assumenda asperiores rerum sapiente repellendus quas soluta ipsum;commodi;0
477;culpa magnam repellendus obcaecati ipsum ab totam excepturi doloremque unde enim fugit odit earum accusantium modi cumque in incidunt sunt nemo reprehenderit nisi repellat voluptatibus illo dignissimos facilis distinctio tempora animi fugiat beatae omnis aliquid voluptate repudiandae temporibus nesciunt vitae explicabo officia delectus quas porro asperiores;cupiditate;3
478;aliquid laboriosam perferendis aliquam minima alias nihil laudantium vero error harum corporis iure dicta recusandae natus culpa praesentium odio sunt consequuntur quam ipsam atque exercitationem quis iste cupiditate quia earum ducimus suscipit provident eligendi repudiandae doloribus possimus quasi itaque est consequatur;nihil;7
479;quasi officiis animi odit amet a excepturi blanditiis nobis laboriosam asperiores culpa ad eveniet accusantium optio ullam illo eaque ut corrupti totam natus magni quas aperiam dolorum cum aliquid sapiente id commodi qui beatae adipisci minus iusto nulla unde distinctio placeat repellat atque officia magnam delectus ipsa;labore;9
480;blanditiis odit optio quibusdam ea laboriosam architecto beatae modi neque mollitia quos rem quisquam illo repellendus dolore in consequatur est placeat quo ratione corporis nemo at ad nobis quidem voluptatum id voluptate nisi sequi nulla unde impedit iste accusamus;nihil;2
481;voluptate ea quae excepturi voluptatum animi maxime nobis rem dolores nihil voluptatem dignissimos reiciendis corporis nulla facere adipisci blanditiis delectus iste reprehenderit soluta veniam repellat laborum deleniti quos fuga unde doloremque eligendi vitae cupiditate aliquid repudiandae modi;nesciunt;7
482;quos illum perferendis rerum veniam iste facere excepturi repudiandae illo magnam officia minus nesciunt quo velit delectus dignissimos aut harum quis iure vel repellendus dolore iusto quasi sapiente modi laborum deleniti fugiat;repellendus;1
483;nobis consequatur quo vitae provident modi debitis inventore architecto at necessitatibus eveniet magnam commodi eum consectetur hic maxime alias numquam aliquam asperiores libero ipsum facere illum quisquam in eligendi dicta;fuga;8
484;esse libero facere iusto qui debitis illum deleniti sit praesentium voluptas explicabo totam doloribus pariatur obcaecati architecto quod sint a adipisci omnis unde iure aliquam eius facilis similique eos reiciendis tenetur amet dolorum dolorem impedit deserunt;corporis;2
485;quo facilis velit possimus consequuntur aut maxime esse error obcaecati aperiam dicta aspernatur autem dignissimos cum corrupti ad aliquid est eum quae saepe consectetur adipisci necessitatibus voluptatibus magni nulla quia accusamus impedit quidem nesciunt reiciendis;velit;9
486;itaque voluptas similique ducimus suscipit deserunt doloremque accusantium ullam accusamus non tenetur ipsam qui praesentium porro cupiditate natus quaerat saepe iste ut reprehenderit sit recusandae a sint sequi quam eligendi id quae neque autem possimus debitis alias error laudantium rem cum minima tempore corrupti odit blanditiis excepturi rerum incidunt earum;ipsam;5
487;repudiandae in est asperiores esse dignissimos voluptas quia eum minima a nisi magni fugit voluptatum cupiditate tempora tempore nostrum iusto autem nulla ipsam repellendus soluta sequi aut quis voluptate sit unde fuga adipisci;aut;4
488;quis laboriosam facilis incidunt sint sit vero molestiae doloribus dolore impedit sunt unde optio esse ratione aspernatur tenetur aut sequi architecto minus dolor eius illo possimus officiis perspiciatis commodi ipsam accusamus deleniti amet natus deserunt reprehenderit exercitationem in dolorem earum alias ipsa molestias nam obcaecati voluptate;doloribus;2
489;ex earum dolorem in sequi officia corrupti provident accusamus eius et veniam odio voluptatem laborum quia fugit ratione totam repellendus explicabo quibusdam magnam corporis velit ducimus quos excepturi deleniti sed;quam;2
490;maiores dolorem perferendis laudantium facilis iste explicabo atque placeat itaque odio et iure quisquam quibusdam a alias quasi laborum ducimus impedit soluta reprehenderit voluptatum iusto voluptate in voluptatibus illo eos excepturi expedita sequi doloremque;atque;5
491;nobis architecto porro optio error quibusdam eveniet nulla quis dignissimos ut id laudantium aspernatur ullam fugit exercitationem quos ab ex perferendis praesentium deserunt nemo accusamus repudiandae numquam molestias maxime consectetur reiciendis illum sit totam;cupiditate;7
492;perspiciatis nostrum libero voluptatem optio vel aliquam a molestiae corporis hic delectus veritatis minima ex possimus cupiditate soluta deserunt magnam animi reprehenderit numquam voluptatum earum eos temporibus assumenda voluptas eligendi aut ipsa quam accusantium;voluptatum;6
493;aliquam eum eaque itaque velit consequatur ipsa blanditiis provident quod fugit dicta eius non reiciendis culpa expedita temporibus pariatur rem rerum adipisci tenetur debitis aperiam nisi incidunt neque qui quo obcaecati ipsum iure sint consectetur est beatae molestiae quas dignissimos illum enim dolor aut necessitatibus quisquam reprehenderit;quidem;1
494;quasi atque reiciendis necessitatibus placeat iste laboriosam ex odit accusamus possimus ipsam fugit molestiae eveniet neque soluta voluptates porro aut illo eaque mollitia vitae ratione similique deleniti blanditiis perferendis tenetur repudiandae eius suscipit esse fugiat nihil molestias incidunt libero a tempora ipsum quibusdam;libero;7
495;esse eveniet amet omnis placeat corrupti sit dolorum veniam culpa cupiditate et delectus cum debitis voluptatibus minus itaque recusandae libero sunt quod reprehenderit perferendis provident porro quidem in cumque ea nam perspiciatis veritatis magni vel quia tempora autem totam consectetur maxime nisi minima soluta odio quaerat;obcaecati;4
496;nulla labore aut officia voluptates reiciendis eveniet autem laboriosam vitae accusantium consequuntur praesentium at aliquid eos iusto harum incidunt libero dolore deserunt ab voluptate iure culpa consectetur consequatur amet temporibus quisquam molestias error quam nemo nam minima non eum;odit;1
497;neque facere odio molestiae voluptas ipsa aspernatur ex nulla culpa aliquam corporis voluptatibus corrupti quidem nemo assumenda quo nam sed voluptate atque natus perspiciatis minus dolores incidunt praesentium eaque autem vero quae distinctio ea temporibus laboriosam itaque quia dicta et iusto doloremque velit hic;tempore;7
498;mollitia sequi enim aperiam corporis autem voluptate asperiores molestiae laudantium recusandae similique officiis quasi quos quod dolorum tempore perspiciatis veritatis ad et distinctio dolore illum ex dolor eaque numquam eius cumque quae facere temporibus voluptates adipisci error nam quis est quibusdam commodi;illo;6
499;animi vel aliquam corporis mollitia quod commodi necessitatibus dolorem dolor dolorum sapiente consequuntur architecto magni molestiae sequi dignissimos sed porro at quibusdam eos dicta delectus eaque soluta ut iusto enim itaque error voluptatem beatae illo adipisci modi eius assumenda id quos quas magnam ad iure tenetur;corporis;1
500;deserunt esse doloremque quo perferendis corporis consectetur debitis hic tenetur maxime atque veritatis harum deleniti exercitationem voluptate vitae sunt nisi tempora molestias ratione accusantium minima neque natus facilis alias itaque officiis odit voluptatibus dolor nesciunt nihil id nobis omnis dolores;temporibus;4
501;adipisci culpa cupiditate excepturi eaque sint aspernatur harum unde officia quibusdam eveniet optio veniam ut in minus numquam enim error nulla ipsum itaque accusantium cumque sapiente odit amet vitae impedit et saepe beatae quas quisquam quia;a;7
502;fuga modi sequi necessitatibus minus labore natus maxime perspiciatis itaque laudantium ea quae molestiae ipsam quis vitae optio magnam quam odio ipsum possimus exercitationem officia in deserunt voluptate dolorum impedit assumenda pariatur quibusdam corporis a nulla magni harum nostrum accusamus porro explicabo facilis asperiores inventore provident alias ullam fugiat;sed;2
503;nulla odio a fugit dicta atque natus inventore minus dolores recusandae modi delectus maxime iure fugiat quo error esse nemo necessitatibus voluptate repudiandae minima veritatis et libero voluptatibus qui enim quas maiores adipisci animi doloremque vitae asperiores provident laudantium soluta eos ad quaerat ab iusto vel cupiditate;voluptatem;5
504;tenetur quae sapiente architecto suscipit ducimus animi aliquam ipsa harum iure consequatur beatae deserunt asperiores nemo minima mollitia cumque quibusdam nesciunt a nisi ratione odit dolorem ipsam at odio saepe quo sit veritatis in fuga quia eum dignissimos eveniet;maxime;2
505;illum nam fugiat dolores nobis consequatur provident possimus vero maiores optio vel voluptatem architecto perferendis debitis id necessitatibus in illo iste aperiam animi rem alias laborum aut similique porro voluptatum facere consequuntur sequi eum obcaecati earum facilis suscipit ab placeat rerum et corrupti explicabo molestiae quo;iure;10
506;velit minus quasi temporibus ad vero corporis in incidunt dignissimos doloremque suscipit itaque ipsa perspiciatis tenetur quae cum aut animi accusantium vel maxime nesciunt magnam ex sequi dolorem maiores nihil aspernatur porro saepe numquam;vero;7
507;tempore ut ipsum accusantium voluptate consequuntur fuga autem ex illo laborum dolorem ad quasi ratione inventore ullam cumque itaque reprehenderit voluptas quod blanditiis quo animi commodi nostrum tempora ab cum neque nam et placeat dignissimos quos expedita reiciendis doloribus incidunt rerum amet voluptates praesentium sint unde;quidem;7
508;reprehenderit voluptas consequatur minima sunt praesentium veritatis commodi temporibus quisquam delectus alias reiciendis maiores illum ut provident accusantium distinctio sapiente nobis sit vel minus tempora animi velit est similique laudantium vitae excepturi tenetur magni;assumenda;0
509;natus quae voluptates saepe alias laudantium labore possimus culpa tenetur atque tempore aspernatur obcaecati itaque beatae consectetur architecto at vel doloribus ipsam modi ad unde provident dolor perferendis iusto voluptas non animi aperiam voluptatibus eveniet deserunt nulla quasi fuga adipisci autem enim placeat veniam expedita incidunt;quis;3
510;consectetur quisquam nihil et magnam ut cumque eos laborum repellat rem porro ab laboriosam suscipit unde fugiat inventore repellendus nesciunt nemo laudantium magni aspernatur explicabo exercitationem sequi voluptate blanditiis enim earum odio corporis odit perferendis iure ea quibusdam maiores;eos;9
511;nihil eum hic dolores quod ad delectus dolore tenetur ratione blanditiis exercitationem in assumenda obcaecati voluptate minus velit aliquam libero rerum qui beatae doloribus sit quis a expedita necessitatibus explicabo ex voluptatibus aperiam similique consequuntur;facere;1
512;eaque obcaecati impedit alias fugiat vel reiciendis laborum asperiores aliquam et sit saepe rerum hic veritatis architecto aperiam nobis earum quisquam aspernatur molestias dolorem quia quis qui debitis cumque quam atque temporibus voluptates quibusdam assumenda incidunt nihil;pariatur;8
513;voluptas molestias optio possimus mollitia sit inventore odio amet dolores ratione nulla quasi ad eaque atque itaque vero ipsum suscipit consequatur rem explicabo vitae dolore iusto assumenda corrupti qui quo molestiae;tempore;9
514;rerum explicabo totam debitis voluptatem similique corrupti rem quae hic amet suscipit repellat facilis cupiditate ipsam dolor impedit repudiandae tempora saepe odio necessitatibus veritatis est eum ipsa autem in laborum perspiciatis corporis modi distinctio labore dignissimos mollitia harum aut libero soluta exercitationem;omnis;10
515;illo ipsum perspiciatis molestiae obcaecati maiores nulla at dolor aut iste corrupti impedit culpa repudiandae reprehenderit est non modi cumque numquam excepturi voluptates facilis quidem molestias eaque nobis libero pariatur in nostrum eligendi;consequuntur;9
516;vel eaque voluptatum porro nisi ab architecto sit molestias corporis odio earum perferendis voluptatem ducimus deserunt fugit dolorum tempora aliquid quas laboriosam adipisci harum impedit in nam nemo libero modi distinctio officiis qui repellendus eum dolores omnis voluptas;sit;2
517;magnam obcaecati praesentium similique eligendi fugit distinctio sequi vel suscipit nam quis pariatur ad iste animi dolorem fuga at dicta delectus ex necessitatibus nostrum magni perferendis labore repellendus nisi deleniti explicabo voluptate rerum eius ipsum;ducimus;5
518;ullam tempore nostrum amet voluptates libero ab cumque exercitationem eum labore enim dolore quod nesciunt impedit quaerat atque fugit quasi sunt est molestias iure nihil quis aperiam magnam ipsum accusantium in velit similique eos vel error sequi deserunt laboriosam aut quas commodi;accusamus;10
519;adipisci nisi quia rerum quidem sed eius nihil ab assumenda autem ut facere delectus aperiam modi atque natus possimus sequi accusantium id dolores cupiditate ea voluptatem est voluptatum nostrum minus corporis dicta vel repellat nobis obcaecati earum explicabo corrupti doloremque;molestias;9
520;voluptate dolorum a esse minus voluptatum eos voluptatem nobis facilis eius tempora quia error quas distinctio consequatur autem numquam modi rerum ullam beatae similique sit officiis repellendus cumque labore fugiat iure ducimus laudantium;cum;6
521;quidem eum suscipit illum nulla assumenda magni ad culpa distinctio nostrum voluptatibus non commodi ullam autem magnam aperiam perferendis necessitatibus asperiores aliquid voluptates repellat velit officiis deserunt natus nesciunt consequuntur in reprehenderit delectus pariatur sunt mollitia corrupti accusantium sit ratione cumque aspernatur nihil maiores eveniet;repellendus;4
522;ratione magni expedita neque molestias ipsa consequuntur culpa earum nulla quidem voluptatum voluptates velit ad omnis architecto praesentium commodi voluptas aperiam sapiente veniam atque tempora labore deleniti veritatis dolorem reprehenderit necessitatibus alias molestiae odio ipsam vitae vel itaque modi accusantium sed libero aspernatur delectus pariatur;quibusdam;6
523;earum accusamus illo nulla reprehenderit debitis et repellendus quasi itaque inventore consequuntur quod unde aspernatur quibusdam saepe autem porro perspiciatis dicta soluta harum hic nemo fuga quam ea mollitia similique deserunt deleniti dolores magni temporibus odio incidunt velit corrupti nesciunt optio facilis tempora sit omnis distinctio assumenda;velit;4
524;quidem laboriosam voluptatum et numquam maxime distinctio non iste quae illo odit ipsa culpa obcaecati quia ratione recusandae beatae aut debitis suscipit fuga explicabo provident voluptates cupiditate labore ea facere itaque ullam dignissimos vel sed optio enim nihil;neque;0
525;molestiae nihil cupiditate fugiat perferendis eos praesentium accusamus quasi maiores quis fugit corrupti facilis illum rerum incidunt ea maxime inventore dignissimos asperiores mollitia aliquam accusantium impedit laboriosam ad ducimus nostrum cumque suscipit dolorem dolore exercitationem itaque aliquid commodi deleniti sunt aperiam eveniet cum labore reiciendis recusandae;nemo;2
526;mollitia iste odit impedit facilis quasi nam itaque optio enim quas dicta placeat ex neque tenetur autem est blanditiis fuga tempore at voluptatibus odio magni voluptate rem rerum dignissimos repellat ipsa omnis eum laboriosam excepturi non in facere hic quam soluta fugit sapiente commodi debitis ad;minus;5
527;dignissimos explicabo quae eveniet non veritatis aliquam nemo eligendi ipsum modi quis laborum sint adipisci repellendus atque impedit cum dolor numquam repellat facilis obcaecati aspernatur amet inventore ratione tenetur a ea rem omnis animi magnam doloremque neque suscipit ducimus vero voluptatibus totam sit repudiandae minus aliquid officiis corrupti culpa;quasi;10
528;in est consequatur excepturi natus ipsa ullam sequi asperiores explicabo quis at nobis atque esse impedit fugiat optio officia voluptates laborum veritatis molestias sed tempora delectus officiis tenetur vel neque harum adipisci eum provident nesciunt consectetur eveniet modi nihil eos error dolor repudiandae quia ratione ut dolorem labore corporis;ab;7
529;minus ducimus natus mollitia veniam soluta id provident tempora magni dolorem esse nesciunt architecto quaerat maiores iste labore vero aperiam quod quo iure voluptas quos perferendis atque beatae rem nam fuga quibusdam ipsam totam repellat;perspiciatis;7
530;maxime laborum aperiam quod iste molestiae sed reiciendis laboriosam consequatur perspiciatis deserunt amet voluptate voluptatibus et animi nisi nulla cumque corrupti at est officiis quam inventore nam sint quis sit cum dignissimos ratione autem beatae;sit;5
531;repellendus assumenda iure quis fugiat vero suscipit voluptate reprehenderit perferendis quas tempora maiores quidem ipsum vitae velit ipsa in sit quisquam voluptas saepe ratione incidunt neque expedita eligendi ad sequi doloribus et;harum;4
532;sed rerum quidem illo ab nostrum id magnam sunt praesentium quibusdam nisi corrupti voluptates libero distinctio nihil natus veniam quo quia dicta saepe molestiae velit explicabo quod dignissimos magni ducimus et sequi eius;provident;3
533;cum eaque tempora necessitatibus facilis consequuntur modi quaerat cumque iusto a consectetur possimus pariatur nemo placeat tempore ad distinctio laudantium saepe omnis numquam in ipsum nesciunt at vitae magni debitis aliquam minima mollitia dolorum dolore ipsam nobis nisi voluptate;voluptates;6
534;distinctio dolorum itaque ea quam cupiditate rerum et quas deleniti provident obcaecati ullam nihil ad vitae doloribus consectetur odit autem enim voluptatem quidem error velit quibusdam libero dignissimos sapiente repellat possimus recusandae dolor quod debitis adipisci consequatur voluptatum qui unde quos expedita labore numquam incidunt harum;quia;3
535;maxime consequatur exercitationem excepturi voluptas ad repellat fugit eaque praesentium atque at placeat optio magnam repudiandae quam dolorum fugiat vel ipsam cumque aliquam temporibus provident ab dolores numquam quae tempora sit quo libero asperiores explicabo;earum;8
536;minima omnis ab molestias sed mollitia nemo delectus modi quo sequi reiciendis natus exercitationem tenetur ex quae nisi temporibus quibusdam ad assumenda aliquam sapiente iusto maxime ut similique neque nesciunt eveniet architecto doloribus porro suscipit itaque repudiandae aut quam magnam vitae accusantium rem corrupti;blanditiis;6
537;perspiciatis tenetur facere dolor illum laborum error saepe cumque nostrum accusamus id similique ut quibusdam eligendi nemo quas vero dolore nihil ipsum repudiandae nobis laudantium delectus molestiae temporibus blanditiis suscipit laboriosam quis deleniti nulla neque rem quo nam commodi odit omnis accusantium minus;illo;9
538;omnis dolores illum voluptatibus ratione tenetur commodi dignissimos sunt aperiam aut iusto incidunt nostrum corporis blanditiis delectus praesentium eos asperiores aliquam porro cupiditate accusamus nobis iste enim ad dolore nisi totam impedit tempore fugiat laborum reiciendis molestias voluptas;magni;9
539;expedita veritatis eius dolorem eos fugiat beatae harum non autem reiciendis culpa laudantium laborum pariatur cumque suscipit quidem cupiditate quas rem nam tempora sed distinctio possimus ad magnam unde eaque perferendis alias assumenda rerum id voluptatum;distinctio;9
540;dolorum blanditiis omnis unde repellendus tenetur ut impedit labore voluptatum maiores neque vero itaque aspernatur explicabo doloremque maxime at ex ipsam exercitationem quia cumque nesciunt porro magnam odit numquam harum enim;nemo;4
541;laboriosam est quam iste cumque eligendi asperiores inventore officiis tempore ipsum ullam maiores nihil illum deleniti necessitatibus iusto temporibus tenetur cupiditate odio architecto molestias quis minima recusandae fuga possimus dolor et labore nisi quae incidunt debitis corrupti autem odit at ratione quo tempora sequi laborum reprehenderit ipsa velit voluptatum;dolore;8
542;at minima modi inventore repudiandae consectetur nemo assumenda ad quos laboriosam eum vero molestiae doloribus recusandae obcaecati perferendis quaerat suscipit voluptatem doloremque voluptate autem animi incidunt quasi explicabo nesciunt pariatur;culpa;2
543;doloribus architecto consequatur ducimus eos deserunt placeat earum quos quas cum officiis labore quod repudiandae debitis maiores voluptatem aspernatur necessitatibus impedit autem obcaecati ipsam quasi itaque totam quo nam adipisci assumenda quisquam;eveniet;0
544;praesentium nisi saepe odio officia cupiditate neque sed quia dicta voluptatum voluptas error deleniti odit officiis alias magni eveniet accusamus assumenda iste et quidem aut cum tenetur temporibus dignissimos qui fuga;quibusdam;1
545;quibusdam nesciunt consectetur laboriosam saepe ex in harum obcaecati quae esse doloremque molestias repellat cupiditate nihil mollitia nobis cum illo modi suscipit eveniet sit dignissimos maxime voluptatibus doloribus dolore odio natus quam earum explicabo maiores necessitatibus voluptatum;dolorum;5
546;nisi natus neque debitis corrupti explicabo omnis doloremque id quia accusantium facilis doloribus quae inventore vitae eaque at odit quasi sint rerum optio ullam fuga consectetur exercitationem maiores dolore voluptatem officia totam quam nam error amet laboriosam hic sed iste;molestias;5
547;amet accusamus hic earum aliquid aliquam ullam officiis eligendi itaque eos veritatis suscipit error incidunt iste esse corrupti consequuntur alias voluptate placeat illum nam commodi autem assumenda modi soluta laboriosam veniam ab voluptates voluptatibus ut iusto facere sed dolorum dolores vel cumque nostrum atque;veniam;0
548;exercitationem voluptatum impedit voluptate culpa autem similique provident excepturi cum rem veritatis vel tenetur tempora explicabo et quod fuga amet numquam optio aspernatur praesentium rerum earum sequi molestias neque officia quisquam suscipit magnam consequuntur quas ut;debitis;5
549;libero aliquam soluta inventore amet impedit laudantium fuga porro voluptas possimus a commodi illo dignissimos assumenda earum minima animi ratione quam expedita veniam repudiandae molestias aliquid quas odit dolorem voluptatem quasi obcaecati consectetur et doloribus sapiente nostrum reprehenderit nobis explicabo quidem ducimus velit dolore illum repellat;laborum;1
550;iusto nulla ab laborum iste ipsam non cum vel fugiat suscipit incidunt minima laudantium totam ea illum debitis quod accusamus tempore nam earum laboriosam ut ad illo optio dignissimos sequi pariatur facilis qui praesentium omnis corporis eligendi libero expedita accusantium voluptas a id maxime reiciendis veritatis vero ipsa;quasi;8
551;repudiandae repellat inventore rerum id ullam sequi ducimus ad a mollitia explicabo corporis quaerat quia asperiores quos esse optio nihil iste praesentium ipsam eos quam libero commodi laudantium deserunt temporibus totam ex in laboriosam expedita architecto neque delectus molestias aliquid cum nemo veniam ipsa illo quod earum suscipit fuga possimus;quae;3
552;veniam quo accusantium dicta dolorem nobis ullam sed consequuntur ex omnis voluptates excepturi molestiae quae odit voluptatem eum perferendis suscipit harum est esse quam temporibus cumque totam explicabo fugiat ducimus iusto;molestias;6
553;distinctio enim quod aliquam qui minima aut omnis neque quae saepe voluptatibus deleniti quisquam cumque illum facere possimus odit quidem error dolorem consequatur voluptates quaerat deserunt illo iure tenetur animi repellendus quis sint hic dolor inventore suscipit natus id libero commodi doloribus perspiciatis;labore;4
554;consequatur natus quasi autem impedit earum doloribus enim quisquam nisi odio possimus explicabo commodi eius nam dicta culpa iure quas aut molestiae distinctio inventore repudiandae itaque et similique eaque soluta temporibus veritatis repellendus quam dolor tempore omnis modi eligendi minus esse dolores doloremque aliquid blanditiis necessitatibus voluptatum sit ipsum iusto;vero;6
555;sequi officiis repellat dolorum temporibus necessitatibus pariatur eveniet dolore reiciendis quos animi ut omnis debitis iusto impedit libero beatae nesciunt sit voluptatibus iure vero consequuntur recusandae quod sapiente cumque amet culpa repudiandae enim at consectetur eius alias nam neque qui quo labore nostrum minima optio veritatis;earum;10
556;quidem ex facere perspiciatis esse nostrum voluptatum rerum consequuntur error architecto laboriosam autem officiis nobis sit totam aspernatur atque doloribus temporibus numquam odit voluptate debitis nihil dolorem omnis ut alias;aut;0
557;assumenda quaerat dolore consequuntur atque quas deserunt suscipit sapiente beatae placeat ea veritatis inventore officia eius tempora laudantium sequi repudiandae animi maxime eos voluptas provident consectetur facere voluptatum dolor similique maiores consequatur necessitatibus;hic;0
558;consequatur eos aliquid accusantium neque culpa dolorum earum sit soluta ea possimus expedita minima facilis libero ullam adipisci quaerat excepturi aliquam tempora ratione sequi magni quam numquam sint quod placeat voluptate magnam nisi ad laudantium quae aperiam;minus;8
559;distinctio earum maiores iste nobis vitae vero omnis error ipsum repellat praesentium cum aliquid fugiat eveniet rem eos laudantium quis ut recusandae libero corrupti fugit ab necessitatibus voluptate ea beatae veniam excepturi debitis unde;eveniet;1
560;ab ex nihil doloremque deserunt numquam quasi accusantium assumenda earum quia repudiandae porro expedita blanditiis beatae alias officiis est dignissimos tempora quam odit distinctio dicta fugiat sapiente vero commodi consequatur illum tempore ipsum praesentium voluptatum debitis eos ea ipsam sequi aliquam voluptas;eligendi;7
561;reiciendis molestias impedit nostrum sit officia recusandae voluptatum pariatur optio itaque eligendi totam amet earum incidunt soluta maiores veritatis sequi cupiditate quidem nobis consectetur eum laborum rerum similique reprehenderit magni repellat iure provident odio laboriosam ea minima asperiores deleniti aliquid mollitia et tempora nihil nisi repudiandae quia consequuntur facilis;obcaecati;2
562;aliquam voluptatem repudiandae maiores ut sint amet minima corrupti et culpa sunt tempora illo doloremque tenetur deleniti accusantium nihil voluptates explicabo consectetur nostrum quisquam cupiditate ipsa qui quas nam maxime magnam rerum necessitatibus placeat dolorem nulla;obcaecati;3
563;asperiores praesentium quaerat laborum maxime non cum distinctio veritatis eum harum facere quod fugiat dolores consequatur vel amet iure porro soluta blanditiis voluptas ad explicabo accusantium sed velit possimus necessitatibus qui veniam earum tempore odit nostrum nemo autem magni natus ipsa rerum ex nulla fugit perspiciatis tenetur;unde;8
564;molestiae sapiente ullam magnam ea libero quibusdam asperiores maxime officiis consectetur possimus reprehenderit modi delectus labore recusandae porro deserunt exercitationem rerum praesentium dolorem dolorum blanditiis voluptatibus omnis voluptate fuga neque eius nisi expedita odio ipsam iste vel eos at hic deleniti natus;praesentium;4
565;magni maxime nam officia nobis facere at nulla animi tempore quae quos ea fugit maiores reiciendis veritatis ullam eaque laboriosam unde iste dolores voluptate pariatur cupiditate dolorum impedit aliquid repudiandae recusandae dolore debitis suscipit repellendus perferendis repellat quas quidem aspernatur aut quasi eveniet quia consequuntur odio hic iusto eum sed;nulla;9
566;eaque ullam assumenda rerum repellat omnis maiores officia vitae totam soluta eos eveniet amet mollitia ut expedita culpa in numquam magni reprehenderit beatae quod facere excepturi voluptate id et autem doloremque tenetur dolor recusandae provident odio praesentium nihil laudantium ipsum hic cumque temporibus aliquid;ullam;5
567;id unde doloribus quidem alias sint enim voluptatum odit iste aut maxime sed harum quaerat quae doloremque explicabo assumenda nam sequi provident veniam necessitatibus commodi nihil distinctio qui cumque cum consequuntur accusamus fuga laudantium sit blanditiis perspiciatis aliquid molestias amet eveniet excepturi voluptate veritatis cupiditate atque quo illo in;quam;5
568;voluptatum repellendus necessitatibus doloremque perferendis fugiat ipsa veritatis facilis earum alias soluta saepe quibusdam totam illo quaerat dolorem corporis autem vero sint aspernatur vitae vel laboriosam pariatur recusandae officiis unde placeat ipsam;et;0
569;nisi laborum enim fugit incidunt ut mollitia obcaecati necessitatibus vero nesciunt quibusdam natus beatae assumenda delectus nam culpa sed vitae voluptatibus voluptatum similique praesentium eos facere distinctio minima consequuntur veritatis deleniti consequatur fugiat eveniet ratione libero dicta eaque iusto;reiciendis;1
570;ad quasi ipsa ab nam deleniti labore tempore officiis blanditiis minima maxime quo facere repellat sint modi necessitatibus recusandae officia vel ipsum dolorem quisquam obcaecati iste nesciunt voluptates earum saepe;quaerat;9
571;necessitatibus totam placeat accusamus quas nemo vitae labore facere a modi sed ea impedit possimus enim ullam illo fuga vel atque recusandae nobis minus corrupti ducimus quam amet consectetur deserunt;iure;7
572;culpa iure atque omnis eos nostrum facilis reprehenderit dolorum fuga illum fugit minus sequi voluptatum nobis consequuntur ratione corrupti beatae unde pariatur voluptate blanditiis vitae nisi voluptatibus sed porro magnam a sint dolorem harum nemo;maiores;4
573;reprehenderit ipsa iste illo aliquid inventore dolores dolor modi quis distinctio mollitia numquam quod nisi quas maxime atque molestiae commodi harum repellendus rerum quo unde laudantium vitae ad sequi temporibus quae neque ratione officiis necessitatibus officia obcaecati voluptates voluptate veritatis aperiam consequuntur ullam debitis adipisci non blanditiis;consequuntur;4
574;veniam libero recusandae adipisci voluptatum quos reiciendis delectus exercitationem laudantium architecto obcaecati tempora sit dolorem atque ut fuga quas culpa ad quam et numquam vel doloremque dolorum sequi autem eius vero distinctio soluta odio quisquam molestias velit voluptatibus cum facere explicabo error blanditiis illo facilis minus nesciunt mollitia ea harum;velit;4
575;impedit minus autem sit expedita illo molestiae eaque dicta dignissimos error asperiores quisquam veniam ratione pariatur et in nihil dolore deserunt dolorem eius modi sequi odit inventore sapiente minima delectus aliquid doloribus id beatae ipsum saepe quia;commodi;8
576;deserunt consequatur molestias earum quibusdam possimus aut modi nesciunt quisquam ipsum incidunt facere hic atque fugiat iusto inventore ad eius delectus eaque expedita corrupti illo iste dolorem obcaecati blanditiis nulla perspiciatis consectetur magni tempore illum placeat exercitationem debitis assumenda accusantium praesentium ipsam saepe voluptas iure aperiam;suscipit;9
577;atque fugiat cumque numquam nostrum sapiente nesciunt ab consequatur impedit pariatur mollitia assumenda quaerat at aliquam sint natus ut quis delectus sequi ratione possimus repellendus omnis similique eius neque dolore perspiciatis eos enim;quidem;4
578;reiciendis libero consectetur odio iure illo minus magnam incidunt architecto omnis deserunt dolorem quibusdam atque accusantium rem repellat perspiciatis ipsa autem mollitia voluptates earum rerum saepe et ipsum fuga nobis eius voluptatibus;reiciendis;6
579;consectetur quod voluptas quaerat rem eaque veritatis laboriosam nostrum aspernatur temporibus nisi delectus neque labore sint tempora ut et sunt officia iure quos dolore nulla perferendis similique eos saepe cupiditate harum cum suscipit ipsa;eaque;3
580;repellendus laborum atque voluptatem qui quaerat molestiae fuga placeat modi totam magni perferendis temporibus unde mollitia iusto delectus ullam nesciunt commodi provident eligendi tempora consequatur suscipit libero non eaque quos similique repudiandae maiores minima explicabo reiciendis ipsum numquam illo sapiente vitae consectetur adipisci laboriosam;necessitatibus;4
581;adipisci ipsum soluta at eum sed voluptatem ullam cupiditate itaque obcaecati nulla molestias aperiam incidunt error minima illo nostrum nihil facere enim quia eligendi earum neque in nam nesciunt officia provident architecto praesentium;repellendus;5
582;repudiandae unde incidunt recusandae tempore fugiat harum magnam quidem placeat aut natus odit nisi libero dolores quod suscipit illo et numquam nulla assumenda atque explicabo excepturi consectetur nobis eum minus debitis sed sunt aspernatur necessitatibus iure officiis ipsum;soluta;8
583;dignissimos natus nihil aut totam reprehenderit quis accusantium aliquam fugiat numquam aliquid molestias ut dicta accusamus quod id soluta doloribus quibusdam voluptatum veritatis error nam atque dolores sit quia placeat saepe eum modi reiciendis assumenda hic nemo adipisci perspiciatis;a;2
584;tenetur enim veniam magnam optio quam porro voluptate aperiam natus architecto temporibus nesciunt illum non iure excepturi assumenda nostrum officia expedita eveniet officiis adipisci saepe dignissimos maiores earum esse quis illo deserunt itaque quasi commodi animi;repellendus;9
585;molestias repellendus quisquam odio dignissimos quam tenetur provident quibusdam perspiciatis ratione fuga consequatur laboriosam hic fugit a amet nihil molestiae obcaecati harum sunt inventore architecto porro omnis voluptates quos dolore eaque quo quia rem nostrum sequi vel modi similique explicabo qui;at;8
586;pariatur fuga doloribus modi alias similique laudantium ad cupiditate tempore magni maxime esse molestiae possimus voluptatibus totam magnam aliquid voluptates sed tenetur rem facilis quod nisi consequatur nihil repellat dolorem ipsum culpa rerum aut porro aperiam fugit sint omnis quo suscipit quas eaque;nemo;6
587;ex repellendus ipsa harum tempora excepturi numquam laboriosam deserunt dolorum quibusdam enim adipisci officiis cum fugit modi assumenda laudantium amet exercitationem esse quaerat voluptatibus ea tenetur vel accusamus quas voluptas maxime ratione magnam minima at corrupti eaque omnis voluptatum iusto;repellat;7
588;doloribus reprehenderit necessitatibus dignissimos harum commodi tenetur minus a alias perferendis consectetur possimus amet nemo quo molestias ratione sed rerum error porro voluptatibus beatae odit corrupti pariatur sapiente tempora repellat quibusdam eveniet quam aut fugit soluta assumenda veritatis explicabo rem mollitia numquam;quam;10
589;placeat reiciendis unde dolorem nihil odit fugit voluptates quo numquam aspernatur enim aliquam voluptas laborum doloremque in corporis voluptate excepturi totam libero accusantium eveniet praesentium quas debitis et aut rem alias sit quisquam quasi odio modi aliquid sunt perspiciatis ut optio molestiae facilis nisi commodi ullam temporibus iusto officia sapiente;delectus;10
590;ratione quae quibusdam laudantium tempora neque modi mollitia aspernatur optio similique nihil perspiciatis necessitatibus odit dolores quidem deleniti enim numquam incidunt nulla debitis ipsa ducimus omnis quaerat itaque magni cumque totam;alias;7
591;tempora natus ab esse recusandae quis veniam quidem nobis deleniti corporis at explicabo nostrum cumque vitae doloremque adipisci sequi enim veritatis vel commodi perspiciatis vero eum autem quos ad nulla labore nam velit impedit libero exercitationem accusantium;voluptatem;9
592;asperiores aspernatur itaque cum quibusdam voluptate saepe consequatur corrupti velit quae perferendis nemo illo veniam quod quis dolores consectetur commodi ad odit facere eaque minima error ea accusamus qui delectus sed ratione sequi pariatur eius dolorem ipsam deleniti minus dolorum natus obcaecati repellendus iure magnam ex vel porro quia;tempora;7
593;numquam odit repudiandae sapiente vero exercitationem voluptas aliquam omnis veritatis illo perspiciatis adipisci delectus soluta tempore repellat nesciunt rem fuga sunt cumque voluptate quibusdam libero ratione consectetur ut temporibus excepturi cum laborum ullam ipsum eos minima dignissimos hic possimus voluptates quo nisi similique reiciendis harum laudantium veniam quos doloribus magni;ut;2
594;labore debitis minima fuga quo quisquam maxime rerum illum officiis obcaecati nam exercitationem officia eligendi nulla corporis doloremque placeat repellat impedit soluta vitae tenetur aliquid excepturi temporibus perferendis corrupti consectetur possimus laboriosam;accusantium;2
595;rem qui impedit iure eius velit natus dolore ipsam odio distinctio vero laboriosam quaerat magni architecto asperiores commodi sint totam adipisci suscipit assumenda animi consequatur nemo facere excepturi magnam voluptas consectetur mollitia amet itaque consequuntur veniam sed ullam quia similique enim minima possimus quis exercitationem expedita vel;vitae;9
596;corporis magnam mollitia porro asperiores commodi pariatur praesentium quas maxime ad debitis dolor quod doloribus soluta autem ipsum ex nemo inventore nihil tempore suscipit itaque sequi incidunt rem quidem sapiente temporibus sunt laboriosam et natus alias ab modi accusamus;nam;5
597;enim ipsa veniam amet saepe porro quas tempore corporis exercitationem blanditiis rem in magni facilis similique numquam reprehenderit expedita ab excepturi incidunt asperiores laudantium illo sint molestias inventore natus libero veritatis accusantium consequuntur doloremque;unde;5
598;eos ullam quod commodi molestiae id eius nisi nesciunt doloremque minima ea quibusdam exercitationem illo nemo aperiam minus consequuntur maxime fuga ut dolore provident sequi deserunt aspernatur voluptate enim rem obcaecati veritatis temporibus tempore;ipsam;5
599;labore dolorem eius illo architecto officia animi expedita officiis debitis velit optio perspiciatis error consequatur rerum suscipit natus laudantium neque deleniti eos unde provident nostrum quis repudiandae vel quasi modi necessitatibus libero totam at atque enim ipsa quibusdam minima impedit nam est numquam esse culpa similique ut saepe accusantium dolores;at;9
600;minus veniam cupiditate voluptas cumque distinctio officia voluptates dicta iusto ipsam eum consequuntur earum esse harum atque sunt ducimus excepturi sint pariatur deleniti dolor beatae aliquid officiis quod neque at omnis praesentium accusamus ratione in odit expedita explicabo quisquam facere inventore vero eos;quam;10
601;nam cupiditate minus dolor eveniet quae inventore ratione rem commodi quaerat error hic ab quas modi fugiat ducimus assumenda officiis unde magni asperiores odio animi alias nulla neque veniam delectus deleniti possimus excepturi sapiente sequi similique sed eos;tenetur;5
602;tempore necessitatibus ad qui vero facilis perferendis quibusdam quis asperiores pariatur eligendi officiis corporis numquam magnam tenetur nostrum facere eos a ratione rem culpa molestiae quidem adipisci delectus neque sit assumenda hic praesentium iste aperiam recusandae fugiat dolorum aliquid totam nisi iure voluptas quisquam;nobis;6
603;doloremque cumque facilis assumenda explicabo error incidunt minima quae nesciunt corporis facere quas harum amet porro autem vitae quam impedit dolores non excepturi consectetur repudiandae asperiores dolor ut rem illum pariatur possimus;dignissimos;4
604;officiis autem sequi provident sed quas dolorum aliquid magnam deserunt rem tempora porro praesentium quia quam inventore consectetur quibusdam sit reiciendis sunt aspernatur minima consequuntur maxime debitis illo laudantium dolores;dolor;9
605;ratione fuga minima minus sapiente velit alias numquam molestias quis quod tempore quisquam placeat odio ab dignissimos incidunt aspernatur necessitatibus distinctio commodi eius doloribus dolore fugit aliquid rem dolorem asperiores iusto et consectetur mollitia consequuntur obcaecati ipsa ex eos doloremque sequi ad quas suscipit;reprehenderit;0
606;quaerat laboriosam vitae officia dolores iure quis natus earum hic vel impedit cumque quod accusantium in magnam labore commodi possimus molestias sapiente soluta distinctio repellat excepturi saepe architecto adipisci sequi facilis a aspernatur nisi velit magni voluptatibus nobis dolorum praesentium doloribus maxime nostrum ab totam;non;9
607;veritatis quibusdam voluptatibus sit magni dignissimos impedit accusantium reprehenderit rem dolorem beatae ipsum sunt quidem alias obcaecati ad expedita illum numquam iste corrupti vitae quos voluptatum aut reiciendis deleniti quod vel;optio;5
608;iste id molestias adipisci qui obcaecati assumenda vel beatae harum modi recusandae magnam voluptatem autem fugiat delectus necessitatibus fugit libero aspernatur exercitationem distinctio numquam velit maxime quis quo eius debitis consectetur dolores voluptas;possimus;6
609;rerum ab omnis consequuntur ex laudantium eaque dolore placeat quis accusantium delectus minima quisquam voluptas nemo magnam alias similique quibusdam sint eum dicta consequatur id hic facere obcaecati eligendi quasi cum pariatur perspiciatis numquam optio quae totam reprehenderit ducimus vero aspernatur non;blanditiis;2
610;laborum nobis eveniet odit voluptatibus enim accusantium magni dicta assumenda maxime perspiciatis magnam provident nam sit nulla repellat ad dolor neque sequi tempora ducimus recusandae temporibus ipsum ut ea consequatur voluptatum dolorum soluta;atque;9
611;distinctio eos fugit laborum reiciendis aperiam minus voluptatum harum dolorum facilis amet illum tenetur ducimus fuga esse quos modi cumque eaque commodi nam ad similique quidem libero autem sit minima ipsum totam eveniet nobis deleniti recusandae soluta at sed quod vero;ad;5
612;quidem autem nihil placeat libero quas voluptatem expedita repellendus eos fuga ducimus aut inventore eaque perferendis impedit obcaecati molestias aliquid quos dolores quo quam cupiditate dolorum dignissimos itaque qui vero consequatur blanditiis ipsum sapiente asperiores sit dolore;voluptas;8
613;facere id ipsa earum itaque repudiandae eos nisi unde tempora eius harum totam sint veniam iure necessitatibus doloribus cupiditate atque magni laborum dolores quidem voluptatum laudantium explicabo enim esse deserunt temporibus doloremque blanditiis animi aliquid inventore et porro quia excepturi molestias quod;esse;5
614;qui earum voluptatem cum fuga distinctio nulla sunt rerum nobis veniam dolores nostrum repellat odio consectetur est totam natus odit explicabo obcaecati aut deserunt ex necessitatibus quos harum quaerat eos aperiam fugit laborum mollitia quisquam dicta tenetur aliquid aliquam modi placeat reprehenderit sit enim;sapiente;0
615;cupiditate unde temporibus rerum eos itaque labore harum illum exercitationem doloribus at cumque fuga quasi iusto dicta veritatis numquam optio culpa enim eum dolores aut eligendi reprehenderit earum tempore porro commodi repellendus libero dolorum doloremque quas ipsam expedita sequi consequuntur facere odio blanditiis quae;doloribus;1
616;quaerat ipsum eum dolor eius exercitationem nulla porro perferendis odit cumque consequatur quod pariatur sit laboriosam beatae neque itaque minus ut et reprehenderit recusandae atque maxime adipisci totam quia reiciendis illum cupiditate ratione voluptas veniam eligendi facere optio quam ea corrupti;ab;8
617;iusto deserunt illum doloribus tempora perspiciatis veniam rem aut optio quae dolor corrupti maxime itaque cum repellat natus quod repellendus similique nesciunt eveniet non recusandae provident placeat sapiente odio quo illo sint vel hic neque temporibus cumque laudantium sed consequatur nemo molestiae ipsum;reiciendis;8
618;architecto adipisci molestias commodi possimus veritatis reiciendis aspernatur magni earum saepe officiis nostrum numquam quis dolor totam laborum perferendis nam alias nisi unde eveniet fugiat deleniti sunt iusto ratione minima placeat eligendi consequuntur dolorum consequatur natus neque quos praesentium;necessitatibus;9
619;totam suscipit officia quo ab vel sit cum delectus rerum doloremque accusantium reprehenderit soluta ratione itaque recusandae illo sequi neque minima velit voluptatibus quas consectetur nam ipsa maiores alias dicta quibusdam consequatur cupiditate aliquam error eius blanditiis quod;eligendi;1
620;ullam culpa iure voluptates saepe velit quod quibusdam ut quasi nam molestiae labore et similique nesciunt corporis ratione rerum quos nisi aperiam minus facere necessitatibus ea voluptas iste tenetur illo dolores quidem cum nulla autem eaque corrupti consequatur delectus sapiente possimus ab illum animi dicta;earum;8
621;cum magnam dignissimos asperiores animi quibusdam veniam reprehenderit nemo a tenetur ab dolorem placeat quisquam exercitationem fugit alias aut ipsa nobis illum facilis maiores qui incidunt aspernatur odit saepe repellat et voluptate ea eaque expedita ut commodi;optio;1
622;reprehenderit dolorum molestias delectus consequatur quibusdam perferendis nesciunt cum est commodi iusto ad sed dolorem natus eligendi voluptates non voluptas excepturi nulla omnis magni impedit aut assumenda rem similique aliquam laudantium quam cupiditate porro ex voluptate;doloremque;1
623;minima harum fuga sint quaerat aliquam adipisci consequuntur delectus tempore dolore voluptatibus ab dolor perferendis corporis hic distinctio praesentium beatae repudiandae alias voluptate accusamus blanditiis neque mollitia illo assumenda cum odio minus optio similique accusantium natus architecto quibusdam animi cupiditate unde;dolores;0
624;nihil obcaecati temporibus quos ipsa voluptatem culpa magni cumque provident alias tenetur dignissimos omnis soluta aliquam quam corporis iure earum consequatur aliquid ullam unde veritatis reprehenderit pariatur eligendi rem error iusto deserunt blanditiis minima maxime asperiores;consectetur;4
625;nam enim odio deleniti non sapiente libero exercitationem commodi reprehenderit vel hic architecto tenetur dolore in quis suscipit nemo ullam tempore repellat dolorem nostrum velit doloremque labore consectetur ipsum voluptatibus explicabo odit cum nisi id fugiat repudiandae molestias et alias delectus esse;nulla;7
626;aperiam quasi a distinctio aliquid consequatur aliquam facere sunt culpa quisquam amet perspiciatis consectetur nesciunt eveniet tempore sint eum dignissimos alias dolor molestiae omnis nisi rerum optio accusamus veniam nemo facilis reiciendis illo temporibus reprehenderit officia repellat nihil cum ullam quidem ducimus odio vitae quos eius minus atque commodi praesentium;officia;7
627;animi est perspiciatis quibusdam distinctio quas ab quae reiciendis placeat suscipit quidem iure veniam tempora assumenda modi rem aspernatur fugit voluptate cumque ipsa corrupti minus itaque eius recusandae fuga obcaecati sit magni atque;officiis;6
628;sequi suscipit assumenda modi fuga provident accusantium dignissimos aspernatur animi aut expedita aperiam quo laudantium repudiandae quas vitae dicta blanditiis molestias hic nam sed id at natus velit repellendus dolore ducimus reiciendis incidunt doloremque maxime voluptatum quia amet cum rem in;cupiditate;10
629;debitis voluptatum in id numquam quo libero rem asperiores assumenda itaque aut labore cum officiis consequatur porro eligendi necessitatibus quidem ea perspiciatis praesentium esse architecto vitae exercitationem harum doloremque sed mollitia quasi ad recusandae tenetur eius;ipsum;4
630;iusto laborum totam a numquam vero nostrum vel saepe accusamus sit magnam non architecto ducimus aspernatur iste autem officiis molestias dicta hic voluptates voluptas mollitia eaque quaerat officia illum nemo quas unde error inventore velit illo atque debitis placeat obcaecati harum labore consequatur nisi minima ex laudantium;quaerat;9
631;ullam dolorem facere ad consequuntur nam quia distinctio sequi sed cumque qui in dolorum aspernatur possimus veritatis quos numquam praesentium voluptate quae ratione amet voluptates aliquam error recusandae repellat voluptatem accusantium cupiditate ipsum nostrum eius blanditiis officiis nobis autem consequatur ab enim ex;fugit;1
632;provident est voluptatibus accusamus amet consequatur pariatur sit labore asperiores totam doloremque ipsa earum vitae maxime praesentium fugiat odio quo sint esse illum tempora aliquam non suscipit tenetur laboriosam quas ullam eius debitis fugit obcaecati eveniet incidunt cupiditate optio laborum sapiente sequi minus alias consectetur delectus unde;recusandae;1
633;sint possimus atque architecto consectetur distinctio in neque incidunt fugit id tempore beatae odit ex quas voluptatem sapiente laudantium odio explicabo facilis labore accusantium vel amet est repellendus et reiciendis quos dolores;veritatis;7
634;ea voluptas minima sit officia perspiciatis mollitia ut a placeat aspernatur nisi dolorum eum quaerat numquam accusantium magnam quibusdam soluta autem nulla quo rerum atque optio laboriosam ab nostrum similique neque provident excepturi libero;possimus;9
635;labore temporibus placeat eos minus quidem fugiat debitis magnam minima optio praesentium possimus ad molestias quibusdam fugit libero adipisci maxime nostrum numquam alias corporis aut neque dolorum a deserunt tenetur ipsum sed odio tempore quo voluptate ullam expedita dignissimos;corporis;10
636;eligendi rerum cumque quasi sed facere omnis illo obcaecati ipsa similique asperiores incidunt delectus quas quibusdam dolorem rem ea sunt vitae ut voluptas possimus a vero vel reprehenderit illum sint corporis nulla atque laboriosam ratione suscipit accusantium repudiandae tempore animi tempora maxime eos hic accusamus;officiis;10
637;corrupti aperiam ducimus tempore dolores odit dignissimos facilis neque beatae iusto laboriosam libero delectus eveniet ad voluptatibus ipsum omnis minus adipisci odio aut corporis quis unde quam hic perferendis repellendus non doloremque optio eligendi illo cupiditate quibusdam tempora ut numquam sint nam voluptatum expedita commodi itaque nulla fuga soluta atque;cum;5
638;natus veritatis quas repudiandae quo suscipit velit iure a commodi neque laudantium officia facilis quis ipsum aperiam maiores fugit odio dignissimos enim ipsam quaerat autem itaque aut soluta illum accusamus aliquam deserunt sequi ducimus saepe porro labore dolorem;aspernatur;4
639;consectetur illo placeat saepe fugit maxime facere voluptate reprehenderit sunt praesentium earum totam in nam nemo repellat magni suscipit similique omnis vero perspiciatis aut unde ex eius porro repellendus quod quaerat fuga hic aliquid ullam corrupti labore dignissimos;quisquam;9
640;adipisci dolorem quam quasi ex sapiente quod officia eaque nesciunt recusandae error molestiae quo reprehenderit excepturi ipsam sint quibusdam corrupti necessitatibus mollitia expedita velit placeat dignissimos omnis itaque fugiat nulla voluptatibus laborum aperiam tempore cum eos illum esse eum repellat earum tempora facilis rem natus;reiciendis;1
641;sit vitae soluta tempora culpa optio recusandae et alias temporibus ut possimus dolore excepturi magni sapiente quibusdam quos voluptate itaque inventore voluptates similique accusantium nihil placeat maxime repudiandae reiciendis dignissimos magnam eveniet exercitationem minima ea quis enim;maiores;5
642;deleniti adipisci labore fugiat error libero neque molestias officia omnis quaerat hic nesciunt eos rerum vitae inventore voluptas quisquam veniam perspiciatis ut dolorum consectetur enim cum possimus repellendus distinctio ullam perferendis magni impedit tenetur pariatur sunt consequatur eligendi minus;tempore;8
643;explicabo dolore autem quibusdam veniam error esse aliquid similique ipsam sed cupiditate quaerat omnis distinctio corrupti doloribus aperiam harum maxime qui possimus totam animi cumque tenetur inventore quia voluptatum placeat obcaecati nulla perspiciatis doloremque voluptate dicta nisi libero rem nostrum unde in accusantium;repudiandae;2
644;possimus laborum quasi delectus laboriosam vitae deserunt porro repudiandae rem odio numquam eaque similique quod nihil eligendi molestiae obcaecati sunt fugit a doloremque voluptatem animi non cum corporis fugiat nobis accusamus et recusandae enim qui quos eveniet officiis harum odit dolor distinctio;iusto;8
645;possimus reprehenderit nemo earum asperiores nam magni cumque blanditiis ratione consequatur rerum hic vero sunt iusto error suscipit dolore iste facilis quis quod est architecto sequi quisquam quia sapiente ab eligendi accusamus qui necessitatibus sed minima neque esse tempora ipsum cupiditate dolorem autem obcaecati;eos;7
646;eaque cum neque explicabo nam est qui architecto cupiditate ut fugit mollitia porro illum possimus tenetur necessitatibus aperiam illo distinctio deserunt nemo veniam sed perferendis laborum totam voluptas natus laboriosam magni quaerat hic;dolore;8
647;id nulla incidunt ut suscipit minus eveniet quos nam libero quibusdam voluptates aliquam praesentium consequuntur illo et illum assumenda deleniti eligendi culpa doloremque deserunt quisquam eum beatae quia fugit sed neque dolore debitis ipsum laboriosam;aliquam;9
648;odit vero dicta ipsa exercitationem assumenda nobis nesciunt perspiciatis ullam laudantium iusto aperiam quam rem libero voluptatibus vel placeat quos ut at fuga aut molestias totam esse minima consequatur deleniti eum animi aliquid ducimus labore architecto accusantium mollitia delectus numquam;quo;0
649;vitae sunt at labore nisi dolorem incidunt fuga vero doloremque iste est quo explicabo ipsa ut eaque amet autem eligendi dignissimos accusamus neque distinctio harum laboriosam odio atque assumenda ea aliquam similique earum aspernatur minima enim dolores eos recusandae;accusamus;4
650;voluptatem quo doloribus iusto enim recusandae corrupti ullam illum harum sunt incidunt perspiciatis distinctio quaerat sequi magni ut minus officiis animi nemo voluptate mollitia unde architecto a voluptatum numquam temporibus nesciunt sapiente culpa molestias repudiandae eos aspernatur quas similique omnis eaque possimus;dicta;3
651;quibusdam ad numquam placeat pariatur dolorum exercitationem nesciunt maxime quas qui porro dolorem reprehenderit id libero tenetur quam rem distinctio consequatur iste repellendus autem voluptas magnam provident quasi natus at totam tempora laudantium mollitia inventore iusto quae suscipit voluptates perferendis cupiditate temporibus eos culpa;earum;5
652;asperiores error natus sit facere dolore aut deleniti velit optio vero nostrum quasi perspiciatis debitis fugiat dolor totam distinctio officiis sed officia sapiente unde consequuntur hic perferendis culpa excepturi beatae nobis dicta vel dolorem laborum;veritatis;5
653;est obcaecati accusamus quidem quod reprehenderit magni assumenda quia iure officiis natus repellat nulla sequi nam veniam omnis dignissimos enim ea nisi praesentium sint odit dolores porro atque libero itaque ipsum fuga eum eos dolorum hic odio quos explicabo;accusamus;6
654;suscipit placeat odit nulla reprehenderit veritatis incidunt hic corporis cumque praesentium quidem in necessitatibus excepturi amet aperiam sed perspiciatis nobis laboriosam at eius impedit repudiandae vitae fugiat nihil exercitationem ducimus ipsum officia harum iure aspernatur vero fuga itaque error dolorum dolor illum laudantium laborum asperiores tempora minima alias magni consequatur;repudiandae;4
655;ipsam atque tempora recusandae ipsa deleniti sed iure eos non sequi doloremque maiores repudiandae quia soluta saepe velit qui hic nam temporibus similique vel at dolore nesciunt eligendi dolor ea modi voluptate eum doloribus totam consequatur laborum harum commodi quidem alias voluptates consectetur;asperiores;8
656;reprehenderit fugiat eos similique iste quia aliquam eaque nisi culpa libero optio dolorem recusandae dolorum numquam corrupti ea totam soluta dolores perferendis beatae vitae animi accusantium adipisci sint at ad veniam deleniti quod ullam;id;9
657;aspernatur quod sint commodi architecto corporis aliquid doloremque atque dolorum explicabo praesentium eligendi vero pariatur adipisci exercitationem fugit incidunt hic magni perferendis quam eius voluptate inventore beatae totam nobis veritatis reprehenderit;quam;9
658;illum odio nisi itaque repellendus doloribus voluptatem suscipit sint ducimus ipsa culpa corrupti tempora consequatur quibusdam nostrum similique quas totam quae aut id nobis exercitationem praesentium voluptates adipisci distinctio fuga dolorum dolore eos;accusantium;7
659;maxime minus blanditiis culpa perspiciatis laborum facere eveniet corporis officiis eum eligendi magni dolore similique cupiditate nisi fugiat impedit ab fuga ipsam officia sint dolorum magnam tenetur vero dicta ratione beatae a id excepturi labore obcaecati atque nemo distinctio quam facilis sapiente reprehenderit cumque mollitia quos;temporibus;2
660;sunt perspiciatis voluptas odio repudiandae officia corrupti molestias dicta accusantium laboriosam autem natus et incidunt sequi temporibus placeat quo esse vero impedit aliquid quasi maiores illo laudantium quia officiis enim deserunt distinctio similique sapiente dolor sed;numquam;2
661;sed unde esse voluptatem fugit sapiente quod et optio recusandae enim aliquid eaque itaque doloribus assumenda cum nam error consequatur omnis provident a sequi earum doloremque iure nemo excepturi quos praesentium laborum aspernatur repellat totam fuga velit at veniam repudiandae voluptatibus accusamus corrupti maxime distinctio explicabo;laudantium;10
662;esse eaque ipsum blanditiis aliquid vel atque fugit nisi maxime asperiores quia eum quod voluptas corrupti voluptatum consequuntur saepe eveniet placeat nemo aliquam hic ad totam deleniti incidunt molestias reiciendis deserunt ipsa adipisci eos ratione porro modi vitae expedita qui sint praesentium dolor;dolorum;6
663;cumque dolorem quas veritatis facere minus aperiam unde temporibus quis eligendi maxime explicabo illum reiciendis nihil error alias maiores a molestiae minima neque deserunt dolorum dolor dicta totam cupiditate id qui;aperiam;0
664;optio in eius quod molestiae illo saepe facilis pariatur aperiam sapiente soluta harum cupiditate et iusto sint ex consequuntur blanditiis aspernatur dolorem fugit nostrum sit unde quaerat quasi nulla deleniti;eveniet;3
665;facilis laudantium fugiat aliquid qui debitis minus quis accusamus distinctio praesentium minima neque architecto esse quas voluptate consectetur illo eos quia quisquam recusandae ex saepe pariatur veritatis fuga vitae voluptatum;maiores;6
666;magnam sit suscipit repellendus soluta recusandae iusto pariatur distinctio blanditiis amet nam expedita error voluptatum quaerat repellat labore esse ipsam corporis dolore voluptate autem accusantium accusamus molestiae explicabo ad minus fugit fuga consectetur saepe praesentium delectus obcaecati odio iure asperiores laboriosam totam atque;in;6
667;accusamus labore deleniti itaque ut error blanditiis hic molestias perferendis earum distinctio repellat numquam mollitia at eligendi ea fugit ducimus nobis fugiat eaque aut minima nam aspernatur magnam sit ex voluptas nulla quo incidunt quam est inventore aperiam officiis cum vel beatae enim minus soluta atque corrupti optio vitae;repellat;8
668;provident quis corporis maxime cupiditate perferendis alias eos voluptatum aspernatur voluptatibus magnam laboriosam rem illum saepe dolores expedita labore qui perspiciatis quos eaque pariatur facere unde commodi ea porro vitae velit non hic dicta itaque ex ipsam nesciunt praesentium nam;natus;8
669;quia nisi asperiores consequuntur nulla praesentium dolorum corporis perferendis nemo ut blanditiis ipsa velit vel ad hic reprehenderit sapiente provident reiciendis autem error incidunt pariatur esse voluptatum recusandae qui perspiciatis nesciunt molestias mollitia;tempora;6
670;a unde cupiditate odio ad asperiores libero blanditiis laudantium vitae ipsum sunt fugiat quas expedita quibusdam labore cum accusamus omnis quaerat similique laborum repellat neque consequuntur pariatur sint quia accusantium dolorem commodi nemo beatae est reiciendis quis obcaecati saepe voluptate rem atque debitis autem maxime temporibus maiores doloribus;praesentium;9
671;doloribus assumenda sunt alias delectus numquam exercitationem debitis odit eos illo at maxime necessitatibus sed temporibus quas voluptatibus itaque earum consequuntur magnam blanditiis tempora rem facilis expedita animi distinctio facere velit quisquam ex eum dolorum tempore minus laborum porro voluptatem;ipsa;5
672;maxime dolore corrupti alias sunt fugit nemo odit repellat atque vero ad necessitatibus recusandae voluptatem tenetur illum reprehenderit adipisci illo beatae tempora excepturi est nulla iste sed consequuntur natus aliquid delectus error minima ab ea consectetur quia autem in eius deleniti explicabo deserunt sapiente nisi voluptate odio soluta;ipsum;2
673;iure odit natus sint illum illo inventore rerum aliquam esse excepturi maiores deleniti nam aut rem deserunt quisquam ut quidem suscipit reprehenderit cupiditate at laborum reiciendis dicta sit quaerat omnis laboriosam vel voluptatibus necessitatibus enim beatae;pariatur;1
674;iusto fuga iste corporis sed sequi impedit repellendus est facilis distinctio doloribus alias quisquam delectus autem expedita veritatis animi possimus earum modi officiis vitae deleniti commodi quis numquam laudantium obcaecati illum totam quia laborum cupiditate odio porro a ratione vel;ullam;7
675;labore magni nesciunt aut culpa tempora inventore sapiente dicta nam quidem eos officia delectus nihil consequuntur aperiam placeat mollitia maxime fugit error magnam in fuga assumenda odit fugiat laborum vitae et commodi sint impedit nisi laudantium optio perferendis voluptatibus suscipit;nulla;5
676;accusantium fuga recusandae et ab dicta nisi facere soluta itaque laboriosam excepturi earum corporis minus quidem consequatur quae porro quaerat tempore voluptatibus blanditiis quibusdam libero facilis at dolore ipsum quam fugit provident mollitia perspiciatis voluptates consectetur incidunt aspernatur;labore;8
677;veritatis architecto voluptas autem enim voluptates quae dolore soluta in saepe officiis sunt exercitationem minima cumque pariatur placeat odit iure similique nam eligendi porro quam quia excepturi maiores harum magnam beatae officia expedita fuga unde veniam provident ipsum repudiandae hic consectetur neque et ea eius animi;nobis;6
678;quisquam eligendi excepturi incidunt neque quas odit quasi similique odio aperiam molestiae magnam id nobis nostrum itaque recusandae quam velit sunt molestias et porro dolorum asperiores eos voluptate explicabo sint laboriosam commodi animi expedita cum iure dignissimos nulla optio a temporibus modi repudiandae illo culpa perferendis iusto ipsa cumque aut;dolor;6
679;similique fugit tempora consequatur iusto pariatur facere magnam repellendus blanditiis obcaecati fuga sapiente dolorem perferendis architecto odio porro a provident voluptates quidem earum exercitationem dicta consectetur eaque facilis doloribus quisquam voluptas tempore ipsum laudantium ullam;dignissimos;6
680;velit ipsum maxime ratione provident voluptatem hic vitae in et tempora vero magni dolorem fugit quidem veritatis blanditiis pariatur atque ipsa consequatur aliquid aperiam aspernatur quo obcaecati id labore aliquam earum nobis perspiciatis dolore voluptas veniam corrupti nemo dolores sit sint dicta optio nihil accusantium delectus quis modi;minus;9
681;laborum cupiditate debitis maxime fugiat molestiae non quidem modi quasi fugit ut ipsa unde nihil repudiandae voluptas officia voluptatem veniam veritatis dolorum nobis similique eum voluptates asperiores tenetur voluptatum facere totam hic sapiente aliquam ex esse atque ab est eveniet ea quas natus deserunt labore odio obcaecati;error;4
682;minus id quod consequuntur inventore a maxime assumenda omnis voluptas labore voluptatum porro iure adipisci deleniti magnam eveniet praesentium sunt dolorem ipsam doloremque eos nisi voluptatem alias impedit commodi saepe incidunt dolore velit ad ducimus quisquam aliquid ullam asperiores totam laudantium voluptatibus dolorum qui quibusdam;enim;0
683;dignissimos maxime cupiditate pariatur consequatur repudiandae aperiam optio cum deleniti minima quas tenetur odio inventore ipsum cumque perspiciatis accusantium rem voluptates voluptas labore distinctio quod officia consequuntur obcaecati possimus corrupti repellendus quo quisquam;consectetur;5
684;inventore totam cumque magni quam doloremque nisi minima ab amet quas laborum tempora quod tempore molestias tenetur debitis quaerat optio excepturi autem repellat nam dolores velit quae aliquid dolorem libero repudiandae aliquam impedit suscipit illo natus aspernatur ut delectus vel perferendis expedita fugiat modi similique fugit ipsa accusantium laudantium earum;eveniet;10
685;delectus temporibus aperiam quia qui et pariatur tenetur tempore accusamus sed neque rem facilis vel a itaque vero alias beatae cupiditate iusto soluta error reprehenderit perspiciatis veniam blanditiis quos nemo aut consectetur placeat doloremque exercitationem sint fugit nam perferendis recusandae totam odio;repellat;7
686;nostrum ipsam quo distinctio eius iure ad consequuntur suscipit iste accusantium enim a adipisci sint optio ipsa magni ea qui eaque odit voluptates numquam libero pariatur dolores cum animi vitae asperiores id vero doloremque;illum;7
687;minus vitae ducimus sed in mollitia tenetur quaerat iste hic reiciendis placeat rem sit non incidunt labore officia accusantium nostrum nobis earum obcaecati quia libero recusandae voluptatibus commodi optio consequatur ex ratione;esse;7
688;totam maxime magni quibusdam tenetur inventore quis laboriosam dolorem sunt quisquam fugit quo cum ad illo voluptate incidunt eligendi reprehenderit provident aperiam adipisci impedit nobis autem veritatis optio dignissimos enim ratione unde facere assumenda sapiente cumque asperiores neque repellat nihil nostrum repellendus doloremque at nemo vitae deserunt necessitatibus;voluptate;0
689;magni iusto tenetur est id a deserunt laborum itaque veritatis dolores inventore ut sequi quibusdam vero labore facere tempora ipsum omnis quam vel dignissimos sit voluptate ullam cumque aliquam doloribus molestias enim beatae quos provident cupiditate atque laboriosam sed suscipit placeat earum amet;expedita;0
690;molestias ipsa velit labore id porro minus nesciunt libero quo saepe architecto nisi molestiae excepturi earum possimus laborum consequuntur ipsam recusandae aut sapiente eveniet explicabo veritatis non debitis tenetur aspernatur itaque cupiditate repellendus eum alias fugiat blanditiis ipsum dolorum commodi nam;pariatur;10
691;officiis soluta nihil iste accusantium doloribus expedita recusandae ducimus commodi consequuntur beatae aliquam vel modi vitae sed harum dicta enim voluptates rerum quas vero quaerat mollitia delectus molestiae deserunt a error dolor magni;dolorum;7
692;ipsam nemo voluptate obcaecati odit delectus corrupti unde recusandae ducimus temporibus illo dolor sequi doloribus consequatur exercitationem quos aspernatur illum itaque ullam iste quae sint culpa perspiciatis possimus facilis non saepe nobis assumenda repellat eius voluptatem a;reprehenderit;0
693;reiciendis excepturi ab ipsam quos fuga molestias nisi eius exercitationem molestiae qui assumenda labore dignissimos vel animi modi eveniet beatae sapiente consequatur officiis consectetur natus eaque itaque dicta quam nostrum corrupti;esse;4
694;repellendus error quos nihil nam modi illum soluta sed molestias earum accusantium possimus deleniti dignissimos odit dolore distinctio officia consectetur enim eum culpa tenetur vero quo quod sequi nulla quas quae obcaecati ratione inventore numquam eius aut aperiam quisquam consequatur voluptatibus officiis veritatis corporis saepe;dolor;3
695;incidunt itaque recusandae fuga error saepe consequuntur molestias eveniet accusantium aliquid ipsam possimus hic consectetur sapiente debitis a nam nesciunt nulla in similique repellat magnam omnis praesentium minus ea minima animi id tempora dolor quam ad illum optio asperiores atque inventore qui beatae placeat numquam;reiciendis;9
696;magni quaerat in quidem distinctio iste odio dolore explicabo ab eum voluptatum accusamus numquam reprehenderit expedita veritatis quo eligendi laudantium maiores ea itaque debitis quas facilis tempore quasi assumenda nihil deserunt nulla accusantium nostrum soluta aliquam deleniti et asperiores est id consequatur qui sit pariatur aut quod eius;tempora;7
697;id amet natus illum libero fuga quibusdam iusto quis hic numquam eligendi debitis eum quas repellendus est consectetur accusantium totam quod expedita aut atque velit quam consequuntur pariatur ipsum in ullam a molestias dolores repellat magni saepe nemo necessitatibus consequatur sequi perferendis optio tempore sed quaerat obcaecati officiis;alias;0
698;repellendus nobis sint ut rem adipisci sunt amet aperiam omnis temporibus laborum dolorem maxime quae atque repellat ex dolore placeat unde libero vel doloribus fugit qui earum cupiditate quod neque corporis;deleniti;3
699;optio voluptas exercitationem dolorum voluptatem veritatis quas delectus neque ad itaque quis esse quisquam provident beatae consequatur sint sed laudantium nam odit velit cumque tempora fugit debitis eaque vitae recusandae porro aliquid atque accusamus iusto repellendus ex minus voluptatibus enim distinctio qui quibusdam omnis ut sapiente laboriosam assumenda;aliquam;6
700;itaque nobis autem iusto sequi repellat molestiae similique accusamus necessitatibus labore quibusdam et officia praesentium non culpa esse cupiditate ipsa maiores magni exercitationem doloribus mollitia repellendus animi quos dicta expedita beatae voluptatem deserunt sunt odit natus numquam quis in porro voluptas corrupti veniam;quibusdam;9
\.



COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';
204;1
21;2
4;3
207;4
25;5
202;6
207;7
25;8
20;9
10;10
5;11
2;12
15;13
10;14
13;15
204;16
4;17
18;18
8;19
205;20
22;21
14;22
8;23
11;24
209;25
207;26
8;27
209;28
9;29
17;30
26;31
205;32
5;33
1;34
16;35
204;36
22;37
20;38
2;39
1;40
26;41
18;42
27;43
26;44
14;45
22;46
28;47
21;48
14;49
17;50
17;51
29;52
16;53
200;54
11;55
28;56
26;57
4;58
200;59
10;60
23;61
14;62
28;63
7;64
23;65
28;66
0;67
200;68
9;69
209;70
0;71
25;72
2;73
6;74
17;75
11;76
26;77
205;78
206;79
1;80
1;81
19;82
15;83
15;84
1;85
0;86
16;87
22;88
201;89
9;90
208;91
21;92
12;93
14;94
15;95
18;96
29;97
3;98
9;99
202;100
202;101
14;102
204;103
9;104
6;105
26;106
204;107
5;108
24;109
24;110
19;111
202;112
14;113
4;114
201;115
16;116
12;117
20;118
7;119
17;120
202;121
207;122
25;123
13;124
17;125
200;126
16;127
205;128
11;129
208;130
22;131
207;132
17;133
17;134
25;135
16;136
20;137
207;138
14;139
5;140
3;141
206;142
206;143
10;144
14;145
3;146
0;147
20;148
24;149
9;150
17;151
24;152
23;153
7;154
11;155
207;156
20;157
0;158
17;159
10;160
9;161
207;162
6;163
15;164
11;165
209;166
26;167
208;168
209;169
15;170
204;171
1;172
8;173
19;174
204;175
2;176
0;177
209;178
20;179
0;180
202;181
209;182
3;183
12;184
17;185
16;186
202;187
4;188
10;189
21;190
0;191
209;192
27;193
15;194
20;195
19;196
23;197
20;198
208;199
28;200
25;201
3;202
209;203
202;204
11;205
2;206
203;207
28;208
1;209
25;210
6;211
206;212
8;213
24;214
29;215
28;216
207;217
29;218
19;219
15;220
14;221
3;222
27;223
20;224
5;225
205;226
205;227
25;228
24;229
27;230
1;231
14;232
3;233
200;234
200;235
1;236
204;237
28;238
10;239
26;240
5;241
21;242
25;243
1;244
203;245
205;246
0;247
13;248
20;249
18;250
20;251
17;252
200;253
18;254
27;255
3;256
16;257
8;258
20;259
4;260
17;261
7;262
202;263
209;264
5;265
25;266
16;267
207;268
15;269
208;270
28;271
3;272
10;273
14;274
8;275
0;276
200;277
28;278
13;279
205;280
200;281
9;282
8;283
201;284
208;285
201;286
29;287
23;288
28;289
20;290
11;291
208;292
29;293
21;294
209;295
3;296
9;297
8;298
203;299
203;300
201;301
8;302
207;303
200;304
8;305
27;306
209;307
17;308
14;309
200;310
207;311
209;312
209;313
4;314
203;315
6;316
29;317
7;318
8;319
209;320
5;321
17;322
0;323
5;324
2;325
19;326
10;327
11;328
6;329
0;330
17;331
207;332
206;333
209;334
19;335
27;336
28;337
203;338
24;339
3;340
22;341
203;342
22;343
202;344
27;345
208;346
10;347
6;348
207;349
13;350
15;351
201;352
3;353
22;354
7;355
15;356
200;357
25;358
205;359
205;360
22;361
28;362
19;363
20;364
20;365
205;366
27;367
19;368
1;369
4;370
203;371
206;372
21;373
13;374
16;375
14;376
15;377
26;378
203;379
27;380
10;381
17;382
207;383
11;384
3;385
16;386
204;387
9;388
9;389
11;390
19;391
3;392
24;393
7;394
202;395
12;396
24;397
10;398
6;399
0;400
18;401
4;402
20;403
201;404
18;405
22;406
0;407
12;408
201;409
21;410
205;411
7;412
201;413
4;414
13;415
19;416
4;417
18;418
14;419
0;420
203;421
15;422
15;423
21;424
203;425
16;426
14;427
26;428
15;429
26;430
29;431
2;432
6;433
15;434
14;435
29;436
0;437
16;438
1;439
3;440
9;441
27;442
202;443
21;444
1;445
202;446
19;447
200;448
208;449
21;450
21;451
21;452
11;453
7;454
7;455
207;456
207;457
25;458
13;459
21;460
207;461
11;462
23;463
204;464
19;465
209;466
6;467
4;468
7;469
6;470
204;471
21;472
201;473
13;474
16;475
22;476
29;477
205;478
7;479
17;480
5;481
5;482
23;483
19;484
1;485
200;486
2;487
208;488
25;489
14;490
7;491
6;492
14;493
23;494
21;495
15;496
0;497
205;498
203;499
28;500
22;501
10;502
201;503
23;504
15;505
205;506
207;507
1;508
15;509
207;510
4;511
209;512
0;513
205;514
7;515
19;516
19;517
29;518
9;519
17;520
17;521
201;522
18;523
12;524
14;525
9;526
22;527
6;528
202;529
14;530
3;531
19;532
205;533
15;534
202;535
12;536
21;537
206;538
28;539
8;540
4;541
25;542
4;543
11;544
209;545
13;546
19;547
7;548
205;549
10;550
17;551
8;552
20;553
29;554
200;555
203;556
205;557
22;558
203;559
11;560
7;561
209;562
28;563
204;564
29;565
204;566
8;567
207;568
4;569
16;570
207;571
200;572
26;573
11;574
16;575
29;576
29;577
29;578
209;579
20;580
10;581
207;582
18;583
20;584
18;585
203;586
9;587
200;588
207;589
17;590
10;591
29;592
28;593
25;594
206;595
12;596
1;597
12;598
3;599
4;600
4;601
5;602
27;603
27;604
202;605
207;606
11;607
205;608
16;609
202;610
5;611
202;612
207;613
24;614
5;615
24;616
22;617
23;618
200;619
23;620
4;621
9;622
3;623
19;624
15;625
14;626
23;627
16;628
0;629
17;630
13;631
27;632
2;633
6;634
202;635
3;636
23;637
204;638
0;639
1;640
207;641
14;642
201;643
1;644
28;645
25;646
16;647
23;648
16;649
23;650
207;651
1;652
15;653
200;654
12;655
19;656
22;657
18;658
1;659
202;660
207;661
3;662
10;663
200;664
207;665
15;666
22;667
22;668
6;669
1;670
208;671
207;672
26;673
10;674
207;675
5;676
2;677
209;678
26;679
13;680
20;681
12;682
21;683
4;684
6;685
15;686
22;687
25;688
200;689
12;690
21;691
205;692
8;693
204;694
23;695
17;696
203;697
209;698
16;699
4;700
\.



COPY miejscowosci FROM STDIN DELIMITER ',' NULL 'null';
0,Mielec
1,Marki
2,Pszczyna
3,Zabrze
4,Augustów
5,Inowrocław
6,Zamość
7,Lubartów
8,Elbląg
9,Tychy
10,Warszawa
11,Łaziska Górne
12,Nowa Ruda
13,Jastrzębie-Zdrój
14,Warszawa
15,Lubliniec
16,Gorlice
17,Rzeszów
18,Bełchatów
19,Opole
\.


COPY adresy FROM STDIN DELIMITER ',' NULL 'null';
0,0,Asnyka,44-563,34,30
1,1,Jeżynowa,94-451,39,55
2,2,Szczęśliwa,55-293,20,9
3,3,Bukowa,16-929,5,6
4,4,Kościelna,52-283,19,35
5,5,Malinowa,59-974,13,77
6,6,Lipowa,81-824,9,51
7,7,Tulipanowa,49-901,29,24
8,8,Zacisze,81-804,9,40
9,9,Porzeczkowa,16-992,11,13
10,10,Żeglarska,28-998,7,89
11,11,Południowa,48-378,24,63
12,12,Srebrna,86-466,36,34
13,13,Niepodległości,50-543,22,67
14,14,Tulipanowa,65-229,30,63
15,15,Handlowa,62-218,30,95
16,16,Majowa,24-561,7,93
17,17,Podgórna,04-926,38,27
18,18,Cedrowa,34-403,13,34
19,19,Stroma,28-860,36,94
\.



COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';
0;list moment;neque enim consectetur aut error;2015-11-11;2017-10-15;1
1;klient chłop;nam obcaecati fuga quis illo;1987-03-05;2014-07-02;2
2;odzież plemię;iure necessitatibus quas quibusdam obcaecati;2001-02-01;2013-10-03;1
3;szereg ogromny;consectetur molestias minus pariatur ut;2001-01-29;2018-10-18;2
4;charakterystyczny budowla;culpa suscipit asperiores est perspiciatis;1989-10-21;2021-10-15;4
5;zdarzenie niezwykły;nam minus provident voluptates quibusdam;2007-10-22;2014-08-27;3
6;szwedzki kościelny;nobis provident dolore itaque nulla;1995-09-03;1999-11-14;4
7;błąd widok;commodi nam veritatis veniam quod;1989-08-12;2001-03-28;1
8;scena teoria;ullam vitae laborum pariatur id;1965-01-21;2008-06-25;0
9;pieniądz płaski;at quos error quis ex;1996-04-29;2003-01-12;2
10;Afryka dzieło;aut est optio tempore perspiciatis;2013-06-27;2021-05-15;0
11;katolicki urządzenie;neque pariatur autem inventore iste;2008-03-31;2019-11-01;0
12;pomagać kontrola;iure consectetur veritatis ipsum tempore;2019-12-10;2021-07-25;1
13;pracować brzeg;odio ipsam cupiditate ad quod;2001-02-19;2005-12-23;0
14;usuwać słowacki;fuga ea enim perferendis rem;1981-03-11;2005-08-26;4
15;wykonać dobrze;hic atque est inventore omnis;1994-10-30;2003-12-18;3
16;wino natychmiast;exercitationem expedita asperiores quibusdam dolores;1996-02-28;2018-12-23;3
17;niewielki czynić;nobis nam officia similique dignissimos;1981-11-20;1996-12-28;2
18;film kolacja;itaque omnis porro sapiente obcaecati;1975-07-03;2006-06-14;2
19;dokładny stworzyć;facilis at reprehenderit temporibus error;2022-10-15;2023-04-25;2
\.



COPY typy_kar FROM STDIN DELIMITER ',' NULL 'null';
0,spoznienie
1,zle zachowanie
2,niesportywna gra
\.


COPY zespoly FROM STDIN DELIMITER ';' NULL 'null';
0;Natus Vincere;2000-02-25;null
1;Troche matematykow;2018-04-20;null
2;Reakcja lancuchowa;2010-03-17;null
3;Wszechmocne jajko;2015-11-11;null
4;Klasyczni klauny;1990-02-28;1999-07-26
5;Mama ile;2013-11-25;null
6;Znajdować się korona;1994-02-18;null
7;Włożyć gazeta;2022-12-19;null
8;Zatrzymać grupa;2009-03-15;null
9;Układ bieg;1987-04-16;null
10;Specjalny fotografia;1997-10-10;null
11;7 Afryka;1985-06-25;null
12;Przyjaźń zimny;1989-07-11;null
13;Kochać okno;2021-06-18;null
14;Umiejętność wcześnie;2000-03-11;2021-07-18
15;Młody relacja;1991-09-28;2001-11-03
16;Skała zrozumieć;1993-10-08;null
17;Robić strumień;2007-11-07;null
18;Wrogi wzdłuż;2007-09-12;null
19;Pełny jeżeli;2021-04-12;null
\.


COPY "role" FROM STDIN DELIMITER ' ' NULL 'null';
0 kapitan
1 uczestnik
2 trener
3 gracz_zapasowy
\.


COPY sklady_w_zespolach FROM STDIN DELIMITER ';' NULL 'null';
98;17;0;0
253;17;0;1
255;17;0;1
13;17;0;1
93;17;0;1
5;17;0;1
163;5;0;0
208;5;0;1
49;5;0;1
171;5;0;1
273;5;0;1
260;5;0;1
105;5;0;2
222;11;0;0
108;11;0;1
114;11;0;1
227;11;0;1
235;11;0;1
224;11;0;1
196;11;0;3
107;16;0;0
18;16;0;1
37;16;0;1
299;16;0;1
187;16;0;1
233;16;0;1
191;16;0;3
234;15;0;0
167;15;0;1
252;15;0;1
144;15;0;1
136;15;0;1
62;15;0;1
141;15;0;3
251;15;0;3
129;3;0;0
248;3;0;1
57;3;0;1
63;3;0;1
173;3;0;1
280;3;0;1
184;3;0;2
179;3;0;3
213;3;0;3
44;13;0;0
78;13;0;1
47;13;0;1
6;13;0;1
247;13;0;1
64;13;0;1
81;13;0;2
202;13;0;3
156;13;0;3
41;9;0;0
68;9;0;1
169;9;0;1
240;9;0;1
99;9;0;1
135;9;0;1
40;9;0;2
0;8;0;0
159;8;0;1
38;8;0;1
151;8;0;1
185;8;0;1
158;8;0;1
67;8;0;2
238;18;0;0
243;18;0;1
192;18;0;1
246;18;0;1
29;18;0;1
46;18;0;1
145;18;0;3
276;18;0;3
249;0;0;0
42;0;0;1
193;0;0;1
21;0;0;1
75;0;0;1
188;0;0;1
264;0;0;2
83;0;0;3
90;0;0;3
292;12;0;0
279;12;0;1
294;12;0;1
34;12;0;1
212;12;0;1
119;12;0;1
113;12;0;2
140;12;0;3
226;12;0;3
86;14;0;0
118;14;0;1
274;14;0;1
237;14;0;1
228;14;0;1
256;14;0;1
130;14;0;2
287;10;0;0
89;10;0;1
85;10;0;1
271;10;0;1
220;10;0;1
242;10;0;1
117;10;0;2
221;10;0;3
153;10;0;3
137;7;0;0
293;7;0;1
115;7;0;1
33;7;0;1
296;7;0;1
69;7;0;1
262;7;0;3
189;15;1;0
296;15;1;1
91;15;1;1
45;15;1;1
229;15;1;1
256;15;1;1
119;15;1;3
35;15;1;3
259;1;1;0
95;1;1;1
2;1;1;1
128;1;1;1
140;1;1;1
217;1;1;1
181;1;1;2
287;1;1;3
78;6;1;0
44;6;1;1
37;6;1;1
40;6;1;1
148;6;1;1
104;6;1;1
269;6;1;2
194;6;1;3
234;6;1;3
86;13;1;0
280;13;1;1
247;13;1;1
232;13;1;1
147;13;1;1
164;13;1;1
105;13;1;3
254;16;1;0
62;16;1;1
65;16;1;1
295;16;1;1
143;16;1;1
272;16;1;1
100;16;1;3
258;16;1;3
153;4;1;0
271;4;1;1
262;4;1;1
275;4;1;1
55;4;1;1
58;4;1;1
22;2;1;0
261;2;1;1
17;2;1;1
131;2;1;1
273;2;1;1
120;2;1;1
137;2;1;2
283;2;1;3
88;2;1;3
265;19;1;0
110;19;1;1
236;19;1;1
73;19;1;1
171;19;1;1
124;19;1;1
72;19;1;3
87;5;2;0
283;5;2;1
185;5;2;1
148;5;2;1
124;5;2;1
145;5;2;1
184;10;2;0
38;10;2;1
76;10;2;1
52;10;2;1
269;10;2;1
88;10;2;1
188;10;2;2
39;10;2;3
65;10;2;3
267;6;2;0
75;6;2;1
299;6;2;1
23;6;2;1
116;6;2;1
37;6;2;1
85;6;2;2
164;6;2;3
96;3;2;0
40;3;2;1
289;3;2;1
141;3;2;1
255;3;2;1
104;3;2;1
263;3;2;2
168;8;2;0
278;8;2;1
194;8;2;1
246;8;2;1
82;8;2;1
162;8;2;1
292;8;2;3
44;14;2;0
102;14;2;1
32;14;2;1
63;14;2;1
62;14;2;1
111;14;2;1
152;14;2;2
24;7;2;0
150;7;2;1
271;7;2;1
101;7;2;1
143;7;2;1
235;7;2;1
191;11;2;0
135;11;2;1
251;11;2;1
136;11;2;1
203;11;2;1
197;11;2;1
281;11;2;2
123;11;2;3
92;12;2;0
120;12;2;1
236;12;2;1
239;12;2;1
199;12;2;1
47;12;2;1
253;12;2;3
84;12;2;3
67;0;2;0
99;0;2;1
60;0;2;1
144;0;2;1
234;0;2;1
277;0;2;1
259;4;2;0
242;4;2;1
252;4;2;1
279;4;2;1
45;4;2;1
159;4;2;1
53;4;2;3
264;4;2;3
260;2;2;0
113;2;2;1
173;2;2;1
265;2;2;1
238;2;2;1
54;2;2;1
119;2;2;3
287;2;2;3
178;18;2;0
230;18;2;1
169;18;2;1
179;18;2;1
237;18;2;1
160;18;2;1
266;18;2;3
81;15;2;0
155;15;2;1
20;15;2;1
190;15;2;1
86;15;2;1
245;15;2;1
107;17;2;0
70;17;2;1
74;17;2;1
293;17;2;1
72;17;2;1
244;17;2;1
127;17;2;2
108;17;2;3
170;17;2;3
254;9;2;0
249;9;2;1
50;9;2;1
49;9;2;1
219;9;2;1
212;9;2;1
59;9;2;2
176;1;2;0
221;1;2;1
114;1;2;1
285;1;2;1
243;1;2;1
48;1;2;1
15;1;2;3
157;19;2;0
211;19;2;1
42;19;2;1
213;19;2;1
248;19;2;1
132;19;2;1
196;19;2;3
97;19;2;3
223;13;2;0
71;13;2;1
274;13;2;1
117;13;2;1
296;13;2;1
34;13;2;1
80;16;2;0
126;16;2;1
175;16;2;1
112;16;2;1
36;16;2;1
64;16;2;1
100;16;2;2
241;16;2;3
146;16;2;3
127;3;3;0
288;3;3;1
170;3;3;1
58;3;3;1
226;3;3;1
160;3;3;1
295;3;3;2
216;3;3;3
230;3;3;3
155;11;3;0
66;11;3;1
217;11;3;1
53;11;3;1
172;11;3;1
137;11;3;1
147;4;3;0
83;4;3;1
57;4;3;1
234;4;3;1
159;4;3;1
227;4;3;1
294;4;3;2
42;4;3;3
189;4;3;3
92;14;3;0
175;14;3;1
46;14;3;1
120;14;3;1
183;14;3;1
31;14;3;1
178;14;3;3
142;12;3;0
69;12;3;1
198;12;3;1
233;12;3;1
130;12;3;1
247;12;3;1
168;12;3;3
286;9;3;0
90;9;3;1
224;9;3;1
138;9;3;1
133;9;3;1
228;9;3;1
56;9;3;3
219;17;3;0
157;17;3;1
223;17;3;1
148;17;3;1
96;17;3;1
240;17;3;1
114;17;3;3
134;17;3;3
249;19;3;0
110;19;3;1
86;19;3;1
151;19;3;1
95;19;3;1
268;19;3;1
277;19;3;2
104;2;3;0
139;2;3;1
271;2;3;1
106;2;3;1
263;2;3;1
117;2;3;1
278;2;3;2
41;2;3;3
113;2;3;3
51;5;3;0
6;5;3;1
246;5;3;1
10;5;3;1
206;5;3;1
250;5;3;1
74;5;3;2
194;5;3;3
237;5;3;3
296;10;3;0
129;10;3;1
65;10;3;1
63;10;3;1
15;10;3;1
270;10;3;1
50;10;3;2
214;8;3;0
61;8;3;1
275;8;3;1
153;8;3;1
97;8;3;1
252;8;3;1
108;8;3;2
284;13;3;0
211;13;3;1
243;13;3;1
180;13;3;1
181;13;3;1
116;13;3;1
200;13;3;3
186;13;3;3
64;15;3;0
67;15;3;1
146;15;3;1
215;15;3;1
161;15;3;1
167;15;3;1
100;15;3;2
293;15;3;3
16;6;3;0
193;6;3;1
145;6;3;1
77;6;3;1
141;6;3;1
45;6;3;1
101;6;3;2
192;6;3;3
239;6;3;3
203;0;3;0
111;0;3;1
24;0;3;1
79;0;3;1
218;0;3;1
255;0;3;1
40;0;3;3
80;0;3;3
262;1;3;0
196;1;3;1
241;1;3;1
88;1;3;1
276;1;3;1
32;1;3;1
81;1;3;3
99;3;4;0
97;3;4;1
234;3;4;1
58;3;4;1
274;3;4;1
184;3;4;1
114;5;4;0
19;5;4;1
272;5;4;1
214;5;4;1
118;5;4;1
175;5;4;1
131;5;4;3
193;7;4;0
87;7;4;1
264;7;4;1
294;7;4;1
33;7;4;1
155;7;4;1
242;7;4;3
215;7;4;3
206;18;4;0
51;18;4;1
220;18;4;1
27;18;4;1
291;18;4;1
284;18;4;1
147;18;4;3
190;4;4;0
30;4;4;1
229;4;4;1
123;4;4;1
255;4;4;1
295;4;4;1
86;4;4;2
40;12;4;0
174;12;4;1
180;12;4;1
105;12;4;1
138;12;4;1
96;12;4;1
57;12;4;2
24;12;4;3
66;11;4;0
276;11;4;1
202;11;4;1
113;11;4;1
135;11;4;1
195;11;4;1
134;11;4;2
119;11;4;3
37;9;4;0
116;9;4;1
104;9;4;1
244;9;4;1
32;9;4;1
101;9;4;1
36;9;4;3
56;9;4;3
129;1;4;0
67;1;4;1
249;1;4;1
201;1;4;1
185;1;4;1
76;1;4;1
55;1;4;2
252;1;4;3
0;14;4;0
64;14;4;1
237;14;4;1
132;14;4;1
281;14;4;1
153;14;4;1
126;10;4;0
282;10;4;1
259;10;4;1
75;10;4;1
179;10;4;1
140;10;4;1
127;10;4;2
151;8;4;0
212;8;4;1
226;8;4;1
298;8;4;1
192;8;4;1
228;8;4;1
240;13;4;0
117;13;4;1
227;13;4;1
158;13;4;1
42;13;4;1
280;13;4;1
102;13;4;2
267;13;4;3
260;13;4;3
148;15;4;0
137;15;4;1
248;15;4;1
232;15;4;1
211;15;4;1
191;15;4;1
62;15;4;2
254;15;4;3
297;17;4;0
210;17;4;1
177;17;4;1
246;17;4;1
59;17;4;1
41;17;4;1
183;17;4;2
263;17;4;3
238;17;4;3
165;0;4;0
54;0;4;1
89;0;4;1
290;0;4;1
285;0;4;1
7;0;4;1
278;0;4;2
208;0;4;3
251;0;4;3
160;16;4;0
47;16;4;1
168;16;4;1
79;16;4;1
139;16;4;1
45;16;4;1
279;16;4;3
275;16;4;3
94;2;4;0
261;2;4;1
72;2;4;1
34;2;4;1
50;2;4;1
199;2;4;1
154;2;4;3
110;2;4;3
172;12;5;0
16;12;5;1
117;12;5;1
184;12;5;1
147;12;5;1
210;12;5;1
128;12;5;2
255;12;5;3
13;19;5;0
212;19;5;1
50;19;5;1
165;19;5;1
256;19;5;1
2;19;5;1
12;3;5;0
155;3;5;1
133;3;5;1
176;3;5;1
185;3;5;1
291;3;5;1
243;6;5;0
277;6;5;1
261;6;5;1
115;6;5;1
98;6;5;1
51;6;5;1
30;6;5;2
162;6;5;3
114;6;5;3
182;4;5;0
59;4;5;1
86;4;5;1
7;4;5;1
231;4;5;1
275;4;5;1
97;4;5;3
130;15;5;0
228;15;5;1
66;15;5;1
163;15;5;1
282;15;5;1
283;15;5;1
42;5;5;0
105;5;5;1
219;5;5;1
94;5;5;1
296;5;5;1
60;5;5;1
124;5;5;3
158;5;5;3
156;11;5;0
269;11;5;1
292;11;5;1
40;11;5;1
93;11;5;1
198;11;5;1
280;11;5;3
81;11;5;3
58;16;5;0
35;16;5;1
187;16;5;1
186;16;5;1
138;16;5;1
148;16;5;1
189;16;5;2
79;10;5;0
279;10;5;1
235;10;5;1
253;10;5;1
146;10;5;1
52;10;5;1
122;10;5;2
129;10;5;3
196;7;5;0
240;7;5;1
247;7;5;1
48;7;5;1
252;7;5;1
170;7;5;1
96;7;5;2
264;7;5;3
222;1;5;0
169;1;5;1
285;1;5;1
289;1;5;1
99;1;5;1
62;1;5;1
266;1;5;3
166;8;5;0
216;8;5;1
249;8;5;1
82;8;5;1
106;8;5;1
276;8;5;1
238;8;5;2
26;9;5;0
92;9;5;1
151;9;5;1
56;9;5;1
294;9;5;1
75;9;5;1
192;14;5;0
120;14;5;1
104;14;5;1
143;14;5;1
121;14;5;1
41;14;5;1
214;14;5;3
118;14;5;3
103;0;5;0
161;0;5;1
215;0;5;1
159;0;5;1
76;0;5;1
233;0;5;1
91;18;6;0
257;18;6;1
295;18;6;1
88;18;6;1
103;18;6;1
125;18;6;1
156;18;6;2
217;18;6;3
227;18;6;3
216;8;6;0
65;8;6;1
195;8;6;1
294;8;6;1
152;8;6;1
250;8;6;1
285;8;6;3
206;8;6;3
209;9;6;0
111;9;6;1
260;9;6;1
258;9;6;1
95;9;6;1
41;9;6;1
244;9;6;2
241;4;6;0
105;4;6;1
140;4;6;1
72;4;6;1
277;4;6;1
39;4;6;1
13;4;6;2
168;4;6;3
286;4;6;3
48;15;6;0
281;15;6;1
226;15;6;1
96;15;6;1
297;15;6;1
282;15;6;1
132;15;6;2
139;15;6;3
267;7;6;0
193;7;6;1
75;7;6;1
271;7;6;1
80;7;6;1
42;7;6;1
63;7;6;2
27;7;6;3
50;13;6;0
93;13;6;1
198;13;6;1
61;13;6;1
254;13;6;1
273;13;6;1
210;13;6;3
228;17;6;0
261;17;6;1
194;17;6;1
59;17;6;1
219;17;6;1
213;17;6;1
90;17;6;2
280;3;6;0
255;3;6;1
46;3;6;1
165;3;6;1
135;3;6;1
12;3;6;1
287;3;6;3
197;3;6;3
115;18;7;0
120;18;7;1
259;18;7;1
179;18;7;1
112;18;7;1
35;18;7;1
279;6;7;0
69;6;7;1
56;6;7;1
5;6;7;1
255;6;7;1
273;6;7;1
206;6;7;3
159;6;7;3
26;2;7;0
33;2;7;1
286;2;7;1
161;2;7;1
188;2;7;1
213;2;7;1
210;2;7;2
236;2;7;3
267;2;7;3
14;17;7;0
43;17;7;1
121;17;7;1
292;17;7;1
20;17;7;1
2;17;7;1
87;17;7;3
261;17;7;3
257;10;7;0
92;10;7;1
225;10;7;1
140;10;7;1
281;10;7;1
170;10;7;1
151;10;7;2
274;10;7;3
164;4;7;0
199;4;7;1
223;4;7;1
262;4;7;1
36;4;7;1
287;4;7;1
101;4;7;2
195;4;7;3
147;4;7;3
264;11;7;0
216;11;7;1
57;11;7;1
295;11;7;1
150;11;7;1
77;11;7;1
220;1;7;0
175;1;7;1
118;1;7;1
183;1;7;1
214;1;7;1
186;1;7;1
254;1;7;2
104;1;7;3
152;1;7;3
32;9;7;0
100;9;7;1
285;9;7;1
275;9;7;1
24;9;7;1
111;9;7;1
93;9;7;2
72;9;7;3
248;9;7;3
211;0;7;0
298;0;7;1
167;0;7;1
154;0;7;1
222;0;7;1
227;0;7;1
59;15;7;0
250;15;7;1
230;15;7;1
168;15;7;1
217;15;7;1
84;15;7;1
234;12;7;0
68;12;7;1
142;12;7;1
44;12;7;1
65;12;7;1
132;12;7;1
160;12;7;3
260;13;7;0
280;13;7;1
246;13;7;1
215;13;7;1
191;13;7;1
244;13;7;1
247;13;7;3
52;13;7;3
181;14;7;0
81;14;7;1
242;14;7;1
91;14;7;1
117;14;7;1
12;14;7;1
78;14;7;3
204;16;7;0
10;16;7;1
122;16;7;1
19;16;7;1
296;16;7;1
178;16;7;1
94;16;7;2
106;16;7;3
146;16;7;3
89;8;7;0
245;8;7;1
149;8;7;1
90;8;7;1
113;8;7;1
34;8;7;1
8;3;7;0
239;3;7;1
235;3;7;1
137;3;7;1
38;3;7;1
126;3;7;1
96;17;8;0
134;17;8;1
91;17;8;1
49;17;8;1
252;17;8;1
41;17;8;1
173;17;8;3
52;17;8;3
34;6;8;0
183;6;8;1
222;6;8;1
239;6;8;1
213;6;8;1
12;6;8;1
133;8;8;0
46;8;8;1
185;8;8;1
61;8;8;1
31;8;8;1
138;8;8;1
198;8;8;2
248;8;8;3
66;8;8;3
197;9;8;0
153;9;8;1
223;9;8;1
189;9;8;1
247;9;8;1
152;9;8;1
196;9;8;2
261;5;8;0
104;5;8;1
143;5;8;1
72;5;8;1
250;5;8;1
243;5;8;1
54;5;8;2
237;5;8;3
114;5;8;3
39;0;8;0
210;0;8;1
242;0;8;1
145;0;8;1
195;0;8;1
291;0;8;1
122;0;8;3
2;3;8;0
120;3;8;1
191;3;8;1
147;3;8;1
36;3;8;1
254;3;8;1
217;3;8;2
73;3;8;3
262;14;8;0
76;14;8;1
86;14;8;1
165;14;8;1
235;14;8;1
125;14;8;1
238;4;8;0
98;4;8;1
65;4;8;1
214;4;8;1
45;4;8;1
48;4;8;1
116;4;8;3
92;12;8;0
136;12;8;1
80;12;8;1
256;12;8;1
231;12;8;1
271;12;8;1
174;12;8;2
32;12;8;3
42;15;8;0
181;15;8;1
44;15;8;1
139;15;8;1
236;15;8;1
111;15;8;1
294;15;8;3
119;15;8;3
141;10;8;0
115;10;8;1
27;10;8;1
286;10;8;1
155;10;8;1
62;10;8;1
172;10;8;2
128;16;8;0
35;16;8;1
211;16;8;1
249;16;8;1
97;16;8;1
84;16;8;1
241;1;8;0
159;1;8;1
204;1;8;1
78;1;8;1
5;1;8;1
67;1;8;1
135;1;8;3
255;1;8;3
220;2;8;0
68;2;8;1
19;2;8;1
290;2;8;1
9;2;8;1
280;2;8;1
95;2;8;2
240;2;8;3
154;6;9;0
48;6;9;1
80;6;9;1
180;6;9;1
111;6;9;1
189;6;9;1
245;6;9;2
232;3;9;0
23;3;9;1
91;3;9;1
125;3;9;1
212;3;9;1
116;3;9;1
153;3;9;2
36;3;9;3
127;13;9;0
41;13;9;1
283;13;9;1
55;13;9;1
167;13;9;1
42;13;9;1
213;14;9;0
99;14;9;1
49;14;9;1
211;14;9;1
33;14;9;1
65;14;9;1
224;14;9;2
221;12;9;0
96;12;9;1
130;12;9;1
196;12;9;1
38;12;9;1
162;12;9;1
219;12;9;2
121;12;9;3
107;12;9;3
76;1;9;0
276;1;9;1
208;1;9;1
204;1;9;1
43;1;9;1
93;1;9;1
239;19;9;0
137;19;9;1
257;19;9;1
275;19;9;1
144;19;9;1
102;19;9;1
165;19;9;2
85;10;9;0
225;10;9;1
74;10;9;1
139;10;9;1
123;10;9;1
278;10;9;1
280;10;9;2
255;6;10;0
275;6;10;1
108;6;10;1
99;6;10;1
121;6;10;1
152;6;10;1
143;6;10;2
234;6;10;3
285;7;10;0
210;7;10;1
251;7;10;1
170;7;10;1
131;7;10;1
15;7;10;1
299;7;10;2
95;7;10;3
277;7;10;3
225;12;10;0
78;12;10;1
159;12;10;1
172;12;10;1
180;12;10;1
232;12;10;1
237;12;10;2
75;12;10;3
140;16;10;0
205;16;10;1
242;16;10;1
42;16;10;1
280;16;10;1
2;16;10;1
80;16;10;3
181;19;10;0
118;19;10;1
44;19;10;1
46;19;10;1
228;19;10;1
135;19;10;1
112;19;10;2
101;2;10;0
247;2;10;1
295;2;10;1
194;2;10;1
48;2;10;1
264;2;10;1
296;17;10;0
219;17;10;1
14;17;10;1
119;17;10;1
183;17;10;1
53;17;10;1
129;17;10;2
297;4;10;0
269;4;10;1
243;4;10;1
68;4;10;1
218;4;10;1
57;4;10;1
109;4;10;2
185;4;10;3
282;4;10;3
272;15;10;0
33;15;10;1
216;15;10;1
252;15;10;1
134;15;10;1
246;15;10;1
162;15;10;3
289;15;10;3
96;5;10;0
147;5;10;1
148;5;10;1
166;5;10;1
18;5;10;1
294;5;10;1
231;5;10;3
67;5;10;3
83;1;10;0
178;1;10;1
137;1;10;1
91;1;10;1
87;1;10;1
50;1;10;1
235;1;10;2
71;1;10;3
203;1;10;3
189;9;10;0
226;9;10;1
223;9;10;1
263;9;10;1
160;9;10;1
85;9;10;1
120;9;10;3
278;0;10;0
193;0;10;1
72;0;10;1
106;0;10;1
204;0;10;1
257;0;10;1
290;0;10;2
298;0;10;3
60;0;10;3
41;11;10;0
256;11;10;1
164;11;10;1
265;11;10;1
236;11;10;1
286;11;10;1
144;11;10;2
266;3;10;0
167;3;10;1
139;3;10;1
20;3;10;1
84;3;10;1
58;3;10;1
126;3;10;2
7;13;10;0
38;13;10;1
211;13;10;1
161;13;10;1
104;13;10;1
262;13;10;1
122;13;10;3
45;13;10;3
190;8;10;0
142;8;10;1
276;8;10;1
241;8;10;1
215;8;10;1
230;8;10;1
288;8;10;2
245;8;10;3
268;18;10;0
212;18;10;1
49;18;10;1
102;18;10;1
115;18;10;1
88;18;10;1
195;18;10;2
259;10;10;0
209;10;10;1
30;10;10;1
43;10;10;1
56;10;10;1
61;10;10;1
100;10;10;2
11;10;10;3
283;10;10;3
141;14;10;0
199;14;10;1
125;14;10;1
69;14;10;1
70;14;10;1
233;14;10;1
182;14;10;2
62;14;10;3
198;14;10;3
36;6;11;0
210;6;11;1
170;6;11;1
251;6;11;1
229;6;11;1
143;6;11;1
68;10;11;0
248;10;11;1
151;10;11;1
211;10;11;1
237;10;11;1
238;10;11;1
122;1;11;0
53;1;11;1
80;1;11;1
12;1;11;1
267;1;11;1
154;1;11;1
264;1;11;2
128;15;11;0
91;15;11;1
7;15;11;1
216;15;11;1
189;15;11;1
187;15;11;1
194;2;11;0
119;2;11;1
259;2;11;1
129;2;11;1
242;2;11;1
162;2;11;1
179;2;11;3
241;2;11;3
3;17;11;0
98;17;11;1
32;17;11;1
60;17;11;1
160;17;11;1
64;17;11;1
77;17;11;3
76;18;11;0
56;18;11;1
49;18;11;1
35;18;11;1
28;18;11;1
85;18;11;1
1;18;11;2
164;18;11;3
115;18;11;3
158;13;11;0
156;13;11;1
71;13;11;1
182;13;11;1
26;13;11;1
73;13;11;1
166;19;11;0
247;19;11;1
203;19;11;1
148;19;11;1
174;19;11;1
249;19;11;1
159;14;11;0
253;14;11;1
256;14;11;1
240;14;11;1
181;14;11;1
233;14;11;1
284;14;11;2
231;14;11;3
226;5;11;0
109;5;11;1
215;5;11;1
58;5;11;1
0;5;11;1
67;5;11;1
46;5;11;3
101;5;12;0
41;5;12;1
75;5;12;1
61;5;12;1
282;5;12;1
4;5;12;1
160;5;12;2
294;5;12;3
130;5;12;3
76;0;12;0
103;0;12;1
250;0;12;1
79;0;12;1
262;0;12;1
197;0;12;1
59;0;12;2
118;13;12;0
67;13;12;1
66;13;12;1
187;13;12;1
219;13;12;1
276;13;12;1
224;13;12;2
55;13;12;3
233;13;12;3
191;19;12;0
171;19;12;1
132;19;12;1
184;19;12;1
88;19;12;1
288;19;12;1
89;7;12;0
172;7;12;1
284;7;12;1
48;7;12;1
25;7;12;1
134;7;12;1
142;7;12;3
290;7;12;3
135;9;12;0
71;9;12;1
39;9;12;1
22;9;12;1
28;9;12;1
287;9;12;1
277;9;12;2
33;9;12;3
119;9;12;3
51;2;12;0
263;2;12;1
237;2;12;1
8;2;12;1
283;2;12;1
292;2;12;1
110;2;12;2
173;2;12;3
21;2;12;3
215;12;12;0
19;12;12;1
168;12;12;1
239;12;12;1
116;12;12;1
286;12;12;1
167;12;12;2
108;6;12;0
40;6;12;1
230;6;12;1
92;6;12;1
127;6;12;1
53;6;12;1
30;8;12;0
176;8;12;1
249;8;12;1
70;8;12;1
293;8;12;1
149;8;12;1
43;8;12;3
179;14;12;0
115;14;12;1
244;14;12;1
175;14;12;1
234;14;12;1
80;14;12;1
157;14;12;2
181;15;12;0
163;15;12;1
210;15;12;1
169;15;12;1
95;15;12;1
243;15;12;1
113;15;12;3
196;15;12;3
15;16;12;0
269;16;12;1
11;16;12;1
46;16;12;1
125;16;12;1
87;16;12;1
214;4;12;0
141;4;12;1
204;4;12;1
207;4;12;1
189;4;12;1
97;4;12;1
270;4;12;2
193;4;12;3
77;10;12;0
190;10;12;1
226;10;12;1
251;10;12;1
63;10;12;1
56;10;12;1
85;3;12;0
266;3;12;1
256;3;12;1
64;3;12;1
264;3;12;1
146;3;12;1
248;3;12;2
274;3;12;3
240;11;12;0
124;11;12;1
78;11;12;1
232;11;12;1
86;11;12;1
258;11;12;1
227;18;12;0
111;18;12;1
112;18;12;1
159;18;12;1
133;18;12;1
49;18;12;1
198;18;12;3
121;18;12;3
248;14;13;0
31;14;13;1
131;14;13;1
55;14;13;1
214;14;13;1
32;14;13;1
65;14;13;2
250;14;13;3
282;6;13;0
203;6;13;1
125;6;13;1
39;6;13;1
48;6;13;1
274;6;13;1
154;6;13;2
36;6;13;3
175;7;13;0
84;7;13;1
205;7;13;1
287;7;13;1
256;7;13;1
245;7;13;1
87;7;13;3
234;7;13;3
197;8;13;0
164;8;13;1
5;8;13;1
243;8;13;1
295;8;13;1
126;8;13;1
94;8;13;3
74;8;13;3
52;17;13;0
143;17;13;1
47;17;13;1
112;17;13;1
293;17;13;1
167;17;13;1
50;17;13;2
77;11;13;0
242;11;13;1
268;11;13;1
189;11;13;1
172;11;13;1
284;11;13;1
170;2;13;0
68;2;13;1
272;2;13;1
117;2;13;1
100;2;13;1
67;2;13;1
270;16;13;0
255;16;13;1
179;16;13;1
238;16;13;1
103;16;13;1
139;16;13;1
45;19;13;0
254;19;13;1
129;19;13;1
281;19;13;1
61;19;13;1
271;19;13;1
30;19;13;2
180;19;13;3
146;18;13;0
136;18;13;1
202;18;13;1
24;18;13;1
85;18;13;1
7;18;13;1
291;18;13;2
80;18;13;3
298;18;13;3
115;9;13;0
132;9;13;1
120;9;13;1
3;9;13;1
266;9;13;1
173;9;13;1
147;9;13;3
273;4;13;0
269;4;13;1
110;4;13;1
299;4;13;1
157;4;13;1
222;4;13;1
230;4;13;2
41;5;13;0
66;5;13;1
69;5;13;1
191;5;13;1
98;5;13;1
289;5;13;1
260;14;14;0
156;14;14;1
35;14;14;1
165;14;14;1
50;14;14;1
230;14;14;1
105;3;14;0
137;3;14;1
159;3;14;1
145;3;14;1
97;3;14;1
149;3;14;1
24;2;14;0
152;2;14;1
129;2;14;1
29;2;14;1
232;2;14;1
278;2;14;1
128;2;14;2
40;2;14;3
125;2;14;3
210;15;14;0
181;15;14;1
221;15;14;1
183;15;14;1
99;15;14;1
59;15;14;1
109;15;14;2
57;15;14;3
117;10;14;0
239;10;14;1
206;10;14;1
147;10;14;1
36;10;14;1
124;10;14;1
65;10;14;3
30;10;14;3
106;4;14;0
20;4;14;1
54;4;14;1
162;4;14;1
69;4;14;1
227;4;14;1
166;4;14;3
151;8;14;0
141;8;14;1
247;8;14;1
237;8;14;1
281;8;14;1
274;8;14;1
146;8;14;3
33;8;14;3
256;12;14;0
176;12;14;1
295;12;14;1
77;12;14;1
294;12;14;1
78;12;14;1
61;12;14;3
70;12;14;3
213;6;14;0
22;6;14;1
184;6;14;1
193;6;14;1
259;6;14;1
262;6;14;1
165;18;15;0
138;18;15;1
80;18;15;1
127;18;15;1
151;18;15;1
61;18;15;1
113;18;15;2
252;18;15;3
93;18;15;3
122;11;15;0
35;11;15;1
280;11;15;1
172;11;15;1
45;11;15;1
294;11;15;1
238;11;15;3
144;14;15;0
105;14;15;1
180;14;15;1
142;14;15;1
210;14;15;1
119;14;15;1
278;16;15;0
50;16;15;1
256;16;15;1
14;16;15;1
170;16;15;1
159;16;15;1
290;16;15;3
111;9;15;0
205;9;15;1
213;9;15;1
30;9;15;1
198;9;15;1
130;9;15;1
232;9;15;3
134;17;15;0
274;17;15;1
17;17;15;1
67;17;15;1
283;17;15;1
286;17;15;1
265;17;15;2
69;3;15;0
146;3;15;1
231;3;15;1
132;3;15;1
227;3;15;1
246;3;15;1
49;12;15;0
191;12;15;1
212;12;15;1
88;12;15;1
289;12;15;1
166;12;15;1
269;12;15;2
29;12;15;3
128;6;15;0
16;6;15;1
1;6;15;1
19;6;15;1
215;6;15;1
222;6;15;1
255;6;15;2
214;13;15;0
34;13;15;1
124;13;15;1
100;13;15;1
178;13;15;1
147;13;15;1
175;13;15;2
184;13;15;3
218;7;15;0
158;7;15;1
253;7;15;1
157;7;15;1
56;7;15;1
68;7;15;1
187;7;15;2
12;7;15;3
73;7;15;3
197;5;16;0
120;5;16;1
198;5;16;1
233;5;16;1
24;5;16;1
94;5;16;1
83;5;16;3
118;2;16;0
77;2;16;1
108;2;16;1
152;2;16;1
299;2;16;1
259;2;16;1
107;18;16;0
188;18;16;1
15;18;16;1
245;18;16;1
106;18;16;1
112;18;16;1
253;18;16;2
113;18;16;3
192;16;16;0
130;16;16;1
49;16;16;1
75;16;16;1
288;16;16;1
262;16;16;1
19;16;16;2
148;16;16;3
219;16;16;3
93;14;16;0
121;14;16;1
256;14;16;1
229;14;16;1
293;14;16;1
190;14;16;1
211;14;16;3
227;1;16;0
275;1;16;1
294;1;16;1
33;1;16;1
67;1;16;1
212;1;16;1
282;11;16;0
214;11;16;1
71;11;16;1
230;11;16;1
0;11;16;1
276;11;16;1
157;11;16;3
281;11;16;3
281;18;17;0
233;18;17;1
158;18;17;1
4;18;17;1
165;18;17;1
205;18;17;1
126;18;17;2
276;3;17;0
161;3;17;1
241;3;17;1
168;3;17;1
189;3;17;1
108;3;17;1
114;3;17;2
221;5;17;0
249;5;17;1
244;5;17;1
49;5;17;1
259;5;17;1
174;5;17;1
254;5;17;2
258;5;17;3
138;6;17;0
151;6;17;1
179;6;17;1
232;6;17;1
250;6;17;1
176;6;17;1
91;6;17;2
86;6;17;3
203;2;17;0
145;2;17;1
237;2;17;1
131;2;17;1
140;2;17;1
163;2;17;1
160;2;17;2
84;2;17;3
42;2;17;3
192;4;17;0
92;4;17;1
31;4;17;1
275;4;17;1
116;4;17;1
26;4;17;1
230;4;17;2
36;11;17;0
177;11;17;1
15;11;17;1
107;11;17;1
171;11;17;1
217;11;17;1
83;11;17;2
105;0;17;0
113;0;17;1
149;0;17;1
253;0;17;1
247;0;17;1
52;0;17;1
30;0;17;2
67;0;17;3
218;19;17;0
73;19;17;1
178;19;17;1
119;19;17;1
157;19;17;1
117;19;17;1
64;19;17;2
136;7;17;0
68;7;17;1
78;7;17;1
143;7;17;1
208;7;17;1
44;7;17;1
197;13;17;0
48;13;17;1
51;13;17;1
293;13;17;1
129;13;17;1
153;13;17;1
21;9;17;0
120;9;17;1
2;9;17;1
155;9;17;1
40;9;17;1
278;9;17;1
235;9;17;2
195;9;17;3
242;9;17;3
134;15;17;0
251;15;17;1
295;15;17;1
72;15;17;1
150;15;17;1
268;15;17;1
38;15;17;3
170;15;17;3
224;10;17;0
266;10;17;1
7;10;17;1
148;10;17;1
109;10;17;1
162;10;17;1
220;10;17;3
130;8;17;0
239;8;17;1
144;8;17;1
63;8;17;1
246;8;17;1
137;8;17;1
6;8;17;2
99;8;17;3
118;8;17;3
271;1;17;0
211;1;17;1
210;1;17;1
41;1;17;1
142;1;17;1
101;1;17;1
283;1;17;2
74;1;17;3
270;1;17;3
69;16;17;0
81;16;17;1
61;16;17;1
112;16;17;1
180;16;17;1
219;16;17;1
59;16;17;3
214;17;17;0
273;17;17;1
222;17;17;1
17;17;17;1
199;17;17;1
227;17;17;1
50;17;17;2
103;17;17;3
36;9;18;0
132;9;18;1
12;9;18;1
266;9;18;1
123;9;18;1
219;9;18;1
207;9;18;2
216;3;18;0
99;3;18;1
199;3;18;1
265;3;18;1
38;3;18;1
16;3;18;1
297;3;18;3
244;3;18;3
258;16;18;0
80;16;18;1
9;16;18;1
140;16;18;1
83;16;18;1
168;16;18;1
269;16;18;2
139;14;18;0
164;14;18;1
84;14;18;1
253;14;18;1
170;14;18;1
229;14;18;1
282;14;18;3
176;11;18;0
157;11;18;1
193;11;18;1
111;11;18;1
233;11;18;1
40;11;18;1
150;17;18;0
71;17;18;1
187;17;18;1
81;17;18;1
146;17;18;1
125;17;18;1
95;17;18;2
65;18;18;0
237;18;18;1
103;18;18;1
298;18;18;1
162;18;18;1
272;18;18;1
69;18;18;2
45;18;18;3
192;18;18;3
195;12;18;0
155;12;18;1
227;12;18;1
41;12;18;1
173;12;18;1
257;12;18;1
221;7;18;0
215;7;18;1
156;7;18;1
214;7;18;1
128;7;18;1
263;7;18;1
277;7;18;3
281;7;18;3
163;6;18;0
226;6;18;1
120;6;18;1
177;6;18;1
51;6;18;1
76;6;18;1
186;5;18;0
116;5;18;1
72;5;18;1
180;5;18;1
280;5;18;1
194;5;18;1
31;5;18;2
142;2;18;0
112;2;18;1
105;2;18;1
35;2;18;1
33;2;18;1
5;2;18;1
61;2;18;2
60;2;18;3
47;2;18;3
291;13;18;0
158;13;18;1
209;13;18;1
85;13;18;1
287;13;18;1
39;13;18;1
107;13;18;3
131;6;19;0
252;6;19;1
110;6;19;1
58;6;19;1
213;6;19;1
234;6;19;1
112;13;19;0
28;13;19;1
64;13;19;1
115;13;19;1
133;13;19;1
135;13;19;1
29;13;19;3
105;10;19;0
197;10;19;1
6;10;19;1
259;10;19;1
153;10;19;1
206;10;19;1
49;10;19;2
56;11;19;0
136;11;19;1
241;11;19;1
178;11;19;1
232;11;19;1
176;11;19;1
70;11;19;2
215;11;19;3
166;0;19;0
272;0;19;1
41;0;19;1
149;0;19;1
2;0;19;1
118;0;19;1
21;0;19;2
140;8;19;0
68;8;19;1
33;8;19;1
123;8;19;1
172;8;19;1
199;8;19;1
265;8;19;3
171;8;19;3
283;4;19;0
130;4;19;1
221;4;19;1
196;4;19;1
273;4;19;1
36;4;19;1
90;4;19;3
278;2;19;0
60;2;19;1
183;2;19;1
225;2;19;1
52;2;19;1
194;2;19;1
255;2;19;2
281;2;19;3
228;1;19;0
146;1;19;1
48;1;19;1
274;1;19;1
142;1;19;1
284;1;19;1
282;1;19;2
103;1;19;3
55;1;19;3
45;15;19;0
11;15;19;1
74;15;19;1
114;15;19;1
160;15;19;1
51;15;19;1
82;15;19;2
251;12;19;0
109;12;19;1
50;12;19;1
69;12;19;1
290;12;19;1
204;12;19;1
239;12;19;2
226;12;19;3
165;17;19;0
159;17;19;1
237;17;19;1
94;17;19;1
219;17;19;1
227;17;19;1
89;17;19;3
271;17;19;3
1;14;19;0
262;14;19;1
224;14;19;1
289;14;19;1
180;14;19;1
13;14;19;1
59;14;19;3
253;7;19;0
233;7;19;1
299;7;19;1
134;7;19;1
42;7;19;1
10;7;19;1
43;7;19;2
169;7;19;3
256;9;19;0
155;9;19;1
264;9;19;1
144;9;19;1
170;9;19;1
200;9;19;1
175;9;19;2
210;18;19;0
38;18;19;1
81;18;19;1
65;18;19;1
161;18;19;1
76;18;19;1
102;18;19;2
53;18;19;3
266;18;19;3
100;16;19;0
280;16;19;1
250;16;19;1
80;16;19;1
78;16;19;1
37;16;19;1
\.


COPY kary_dla_zespolow FROM STDIN DELIMITER ';' NULL 'null';
2;2;0
1;2;0
0;4;1
\.


COPY nagrody FROM STDIN DELIMITER ',' NULL 'null';
0,peiniędzy
1,bilety do kina
2,nagroda od sponosorow
\.


COPY nagrody_w_turniejach FROM STDIN DELIMITER ';' NULL 'null';
0;0;1
2;0;2
1;0;3
2;1;1
0;1;2
1;1;3
\.


COPY zmiany FROM STDIN DELIMITER ';' NULL 'null';
0;114;196;14
0;187;191;4
0;167;141;9
0;62;251;5
0;248;179;18
0;173;213;9
0;6;202;17
0;247;156;11
0;192;145;3
0;46;276;17
0;193;83;23
0;75;90;19
0;279;140;3
0;212;226;22
0;220;221;3
0;271;16;13
0;85;153;19
0;69;262;11
1;91;119;22
1;296;35;10
1;95;287;5
1;104;194;7
1;40;234;10
1;164;105;11
1;143;100;16
1;62;258;11
1;131;283;3
1;17;88;14
1;171;3;21
1;110;72;17
2;52;39;9
2;269;65;1
2;116;164;17
2;278;292;21
2;251;123;15
2;236;253;1
2;120;84;3
2;242;53;21
2;45;264;2
2;265;119;13
2;173;287;13
2;169;266;23
2;244;108;1
2;70;170;17
2;114;15;7
2;42;196;17
2;213;97;21
2;36;241;13
2;126;3;7
2;175;146;15
3;288;216;16
3;58;230;5
3;234;42;1
3;227;189;2
3;183;202;23
3;175;208;18
3;120;22;16
3;46;178;23
3;198;168;3
3;228;56;2
3;157;114;13
3;96;202;3
3;223;134;5
3;263;41;6
3;106;113;8
3;10;194;13
3;6;237;3
3;116;200;5
3;181;186;22
3;167;293;11
3;45;192;17
3;77;239;14
3;111;40;10
3;24;80;11
3;276;81;8
4;272;131;18
4;87;242;8
4;155;215;3
4;291;147;20
4;174;24;20
4;195;204;18
4;135;119;23
4;32;36;4
4;244;56;2
4;185;252;15
4;227;267;19
4;42;260;19
4;137;254;9
4;210;263;13
4;246;238;12
4;7;208;21
4;54;251;9
4;139;279;5
4;47;275;15
4;34;154;18
4;199;110;18
5;147;255;4
5;277;162;16
5;261;114;3
5;231;97;22
5;296;124;17
5;219;158;23
5;93;280;17
5;198;81;22
5;235;202;15
5;253;129;7
5;247;264;23
5;289;266;5
5;143;214;6
5;104;118;10
6;103;217;11
6;125;227;10
6;152;285;14
6;250;206;1
6;277;168;23
6;105;286;21
6;282;139;23
6;193;27;10
6;273;210;18
6;12;287;6
6;135;197;16
7;56;206;14
7;273;159;20
7;188;236;4
7;286;267;15
7;2;87;10
7;43;261;21
7;281;274;16
7;223;195;15
7;36;147;5
7;118;104;20
7;186;152;14
7;275;72;9
7;285;9;15
7;111;248;9
7;132;160;2
7;244;247;3
7;215;52;15
7;117;78;1
7;296;106;7
7;178;146;5
8;134;0;3
8;252;173;14
8;91;52;1
8;61;248;5
8;138;201;4
8;46;66;22
8;143;237;16
8;72;114;11
8;291;122;12
8;191;73;13
8;214;28;20
8;65;116;20
8;80;21;15
8;271;32;13
8;111;294;6
8;236;119;9
8;204;135;23
8;78;255;18
8;9;240;13
9;116;36;14
9;38;121;17
9;196;107;13
10;121;234;2
10;251;95;10
10;15;277;7
10;232;75;15
10;205;202;12
10;42;80;6
10;218;185;4
10;243;3;21
10;269;282;15
10;252;162;2
10;216;289;19
10;18;231;19
10;147;67;4
10;137;71;8
10;178;203;2
10;223;120;22
10;106;298;3
10;72;60;9
10;262;122;10
10;161;45;14
10;241;245;9
10;209;11;19
10;43;283;13
10;70;62;12
10;125;198;23
11;129;179;23
11;259;241;1
11;32;77;10
11;56;19;21
11;35;164;10
11;28;115;17
11;233;231;9
11;109;46;12
12;4;294;17
12;282;130;23
12;219;55;14
12;276;233;20
12;172;142;14
12;48;290;14
12;71;33;15
12;28;119;8
12;292;173;7
12;283;21;7
12;70;43;11
12;210;113;8
12;243;196;17
12;207;193;15
12;256;274;21
12;159;198;23
12;49;121;9
13;131;250;18
13;48;36;15
13;245;87;12
13;256;234;7
13;5;94;15
13;126;207;13
13;295;74;1
13;61;180;20
13;202;80;16
13;136;20;5
13;7;298;22
13;266;147;19
14;129;28;2
14;232;40;19
14;152;23;12
14;278;125;16
14;59;25;1
14;181;57;21
14;147;65;8
14;36;30;12
14;20;166;21
14;281;146;9
14;237;33;18
14;176;61;12
14;294;70;8
15;138;252;14
15;127;93;6
15;45;238;9
15;50;290;11
15;30;232;16
15;289;6;10
15;191;29;23
15;124;184;3
15;68;12;5
15;253;73;6
16;120;83;22
16;15;113;6
16;75;148;16
16;262;219;9
16;293;211;3
16;230;157;18
16;214;281;8
17;49;258;2
17;179;86;15
17;237;84;22
17;131;42;12
17;253;67;12
17;155;195;3
17;120;242;13
17;150;18;22
17;72;38;23
17;268;170;19
17;266;220;14
17;63;99;18
17;246;118;16
17;101;74;9
17;210;270;22
17;112;59;8
17;199;103;13
18;99;297;8
18;38;14;6
18;199;244;12
18;170;282;15
18;237;45;9
18;298;192;20
18;215;277;15
18;156;281;8
18;35;60;14
18;112;47;3
18;158;107;17
19;64;29;18
19;178;215;5
19;199;265;16
19;123;171;8
19;196;90;14
19;52;281;19
19;142;103;6
19;146;55;9
19;50;226;20
19;94;89;3
19;159;271;21
19;180;22;18
19;289;59;12
19;299;169;10
19;161;53;12
19;76;266;9
\.


COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';
0;507;1
0;371;2
0;428;3
0;547;4
0;262;5
0;599;6
0;43;7
0;656;8
0;40;9
0;358;10
0;244;11
0;385;12
0;116;13
0;261;14
0;24;15
0;171;16
0;203;17
0;123;18
0;133;19
0;368;20
0;699;21
0;692;22
0;253;23
0;139;24
0;134;25
0;206;26
0;419;27
0;682;28
0;581;29
0;584;30
0;556;31
0;588;32
0;511;33
0;633;34
0;193;35
0;230;36
1;273;1
1;97;2
1;229;3
1;695;4
1;94;5
1;464;6
1;413;7
1;629;8
1;548;9
1;538;10
1;18;11
1;179;12
1;307;13
1;359;14
1;583;15
1;420;16
1;167;17
1;53;18
1;263;19
1;478;20
1;33;21
1;388;22
1;211;23
1;578;24
1;93;25
1;140;26
1;615;27
1;460;28
1;149;29
1;525;30
1;526;31
1;436;32
1;180;33
1;61;34
1;183;35
1;620;36
2;674;1
2;382;2
2;612;3
2;394;4
2;412;5
2;341;6
2;267;7
2;489;8
2;255;9
2;438;10
2;519;11
2;347;12
2;515;13
2;432;14
2;535;15
2;376;16
2;79;17
2;175;18
2;318;19
2;399;20
2;384;21
2;225;22
2;54;23
2;662;24
2;336;25
2;101;26
2;217;27
2;254;28
2;600;29
2;191;30
2;683;31
2;561;32
2;640;33
2;603;34
2;688;35
2;544;36
3;447;1
3;115;2
3;567;3
3;449;4
3;366;5
3;518;6
3;73;7
3;223;8
3;364;9
3;49;10
3;58;11
3;221;12
3;531;13
3;276;14
3;681;15
3;610;16
3;552;17
3;678;18
3;258;19
3;673;20
3;122;21
3;516;22
3;96;23
3;21;24
3;308;25
3;236;26
3;560;27
3;119;28
3;99;29
3;305;30
3;383;31
3;491;32
3;31;33
3;161;34
3;302;35
3;190;36
4;424;1
4;549;2
4;331;3
4;553;4
4;202;5
4;132;6
4;245;7
4;554;8
4;283;9
4;609;10
4;275;11
4;165;12
4;597;13
4;321;14
4;194;15
4;648;16
4;410;17
4;690;18
4;572;19
4;596;20
4;663;21
4;72;22
4;104;23
4;617;24
4;418;25
4;375;26
4;693;27
4;500;28
4;16;29
4;468;30
4;527;31
4;555;32
4;666;33
4;357;34
4;677;35
4;459;36
5;529;1
5;20;2
5;508;3
5;319;4
5;465;5
5;348;6
5;90;7
5;274;8
5;301;9
5;69;10
5;514;11
5;250;12
5;433;13
5;687;14
5;562;15
5;403;16
5;55;17
5;414;18
5;36;19
5;111;20
5;689;21
5;502;22
5;550;23
5;247;24
5;635;25
5;151;26
5;166;27
5;59;28
5;81;29
5;314;30
5;667;31
5;144;32
5;342;33
5;160;34
5;423;35
5;467;36
6;641;1
6;563;2
6;505;3
6;74;4
6;462;5
6;29;6
6;492;7
6;355;8
6;293;9
6;543;10
6;86;11
6;387;12
6;568;13
6;226;14
6;625;15
6;32;16
6;30;17
6;44;18
6;557;19
6;239;20
6;309;21
6;89;22
6;66;23
6;270;24
6;642;25
6;188;26
6;672;27
6;353;28
6;78;29
6;294;30
6;103;31
6;346;32
6;539;33
6;234;34
6;220;35
6;592;36
7;651;1
7;243;2
7;141;3
7;664;4
7;200;5
7;208;6
7;630;7
7;452;8
7;344;9
7;252;10
7;454;11
7;17;12
7;297;13
7;52;14
7;585;15
7;488;16
7;178;17
7;621;18
7;377;19
7;162;20
7;360;21
7;56;22
7;534;23
7;64;24
7;605;25
7;13;26
7;373;27
7;657;28
7;209;29
7;310;30
7;128;31
7;475;32
7;649;33
7;569;34
7;632;35
7;528;36
8;85;1
8;124;2
8;404;3
8;616;4
8;169;5
8;323;6
8;422;7
8;70;8
8;185;9
8;291;10
8;573;11
8;164;12
8;362;13
8;439;14
8;647;15
8;333;16
8;50;17
8;582;18
8;51;19
8;685;20
8;469;21
8;232;22
8;298;23
8;365;24
8;654;25
8;317;26
8;197;27
8;292;28
8;579;29
8;402;30
8;340;31
8;233;32
8;351;33
8;48;34
8;381;35
8;407;36
9;395;1
9;57;2
9;231;3
9;676;4
9;490;5
9;19;6
9;466;7
9;172;8
9;631;9
9;126;10
9;696;11
9;541;12
9;497;13
9;474;14
9;279;15
9;613;16
9;23;17
9;192;18
9;498;19
9;295;20
9;198;21
9;520;22
9;398;23
9;45;24
9;4;25
9;38;26
9;41;27
9;574;28
9;429;29
9;522;30
9;150;31
9;686;32
9;189;33
9;238;34
9;409;35
9;455;36
10;675;1
10;598;2
10;27;3
10;343;4
10;159;5
10;345;6
10;611;7
10;483;8
10;156;9
10;3;10
10;187;11
10;540;12
10;127;13
10;125;14
10;400;15
10;380;16
10;416;17
10;147;18
10;643;19
10;570;20
10;440;21
10;212;22
10;406;23
10;87;24
11;601;1
11;75;2
11;397;3
11;163;4
11;390;5
11;482;6
11;60;7
11;35;8
11;210;9
11;65;10
11;326;11
11;580;12
11;665;13
11;614;14
11;542;15
11;352;16
11;619;17
11;565;18
11;653;19
11;15;20
11;306;21
11;280;22
11;451;23
11;14;24
12;680;1
12;608;2
12;224;3
12;120;4
12;697;5
12;626;6
12;536;7
12;533;8
12;437;9
12;411;10
12;477;11
12;338;12
12;284;13
12;427;14
12;523;15
12;98;16
12;415;17
12;199;18
12;396;19
12;623;20
12;499;21
12;281;22
12;315;23
12;408;24
13;363;1
13;137;2
13;435;3
13;471;4
13;289;5
13;517;6
13;485;7
13;361;8
13;524;9
13;153;10
13;594;11
13;512;12
13;372;13
13;157;14
13;8;15
13;503;16
13;332;17
13;68;18
13;71;19
13;39;20
13;312;21
13;268;22
13;370;23
13;463;24
14;628;1
14;700;2
14;228;3
14;184;4
14;34;5
14;277;6
14;627;7
14;495;8
14;484;9
14;205;10
14;182;11
14;425;12
14;63;13
14;269;14
14;95;15
14;457;16
14;91;17
14;100;18
14;513;19
14;607;20
14;11;21
14;196;22
14;25;23
14;6;24
15;622;1
15;2;2
15;107;3
15;586;4
15;12;5
15;105;6
15;7;7
15;109;8
15;374;9
15;470;10
15;558;11
15;637;12
15;350;13
15;481;14
15;328;15
15;155;16
15;168;17
15;154;18
15;602;19
15;595;20
15;421;21
15;121;22
15;249;23
15;272;24
16;694;1
16;138;2
16;62;3
16;334;4
16;285;5
16;659;6
16;10;7
16;300;8
16;77;9
16;296;10
16;473;11
16;316;12
16;506;13
16;320;14
16;441;15
16;551;16
16;260;17
16;106;18
16;638;19
16;652;20
16;444;21
16;108;22
16;278;23
16;241;24
17;82;1
17;235;2
17;698;3
17;448;4
17;339;5
17;237;6
17;259;7
17;501;8
17;213;9
17;335;10
17;67;11
17;37;12
17;117;13
17;576;14
17;658;15
17;510;16
17;532;17
17;5;18
17;113;19
17;494;20
17;401;21
17;587;22
17;143;23
17;546;24
18;84;1
18;480;2
18;644;3
18;431;4
18;356;5
18;329;6
18;322;7
18;379;8
18;327;9
18;222;10
18;446;11
18;392;12
18;590;13
18;215;14
18;47;15
18;634;16
18;22;17
18;173;18
18;472;19
18;458;20
18;290;21
18;650;22
18;566;23
18;130;24
19;204;1
19;214;2
19;417;3
19;118;4
19;545;5
19;354;6
19;679;7
19;430;8
19;330;9
19;26;10
19;246;11
19;181;12
19;9;13
19;174;14
19;170;15
19;405;16
19;257;17
19;110;18
19;152;19
19;46;20
19;207;21
19;195;22
19;509;23
19;265;24
\.


COPY poprawne_odpowiedzi FROM STDIN DELIMITER ';' NULL 'null';
0;0;4
0;0;8
0;0;9
0;0;11
0;0;14
0;0;15
0;0;16
0;0;18
0;0;19
0;0;24
0;0;26
0;0;27
0;0;28
0;0;29
0;0;30
0;0;31
0;0;32
0;0;33
0;0;34
0;0;35
0;1;1
0;1;2
0;1;3
0;1;6
0;1;7
0;1;9
0;1;12
0;1;16
0;1;17
0;1;19
0;1;21
0;1;25
0;1;29
0;1;32
0;1;33
0;1;34
0;2;1
0;2;6
0;2;11
0;2;13
0;2;14
0;2;15
0;2;17
0;2;21
0;2;22
0;2;23
0;2;24
0;2;25
0;2;26
0;2;27
0;2;31
0;2;32
0;2;33
0;2;35
0;2;36
0;3;6
0;3;7
0;3;8
0;3;9
0;3;10
0;3;16
0;3;17
0;3;19
0;3;20
0;3;21
0;3;23
0;3;25
0;3;26
0;3;27
0;3;32
0;3;33
0;3;35
0;4;2
0;4;9
0;4;14
0;4;15
0;4;17
0;4;22
0;4;23
0;4;25
0;4;26
0;4;30
0;4;31
0;4;33
0;4;36
1;0;1
1;0;3
1;0;4
1;0;9
1;0;10
1;0;11
1;0;12
1;0;13
1;1;1
1;1;2
1;1;3
1;1;5
1;1;6
1;1;9
1;1;11
1;1;12
1;1;14
1;2;1
1;2;3
1;2;4
1;2;5
1;2;6
1;2;12
1;2;13
1;3;3
1;3;5
1;3;6
1;3;7
1;3;11
1;3;13
1;3;14
1;4;7
1;4;9
1;4;10
\.


COPY organizacja FROM STDIN DELIMITER ';' NULL 'null';
0;31;UJ
1;30;UE
\.
