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
    IF (NEW.numer_pytania != (
        SELECT COALESCE(MAX(numer_pytania), 0)
        FROM pytania_na_turniejach
        WHERE id_turnieju = NEW.id_turnieju
        GROUP BY id_turnieju) + TG_ARGV[0]::INT)
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
        AND id_turnieju=NEW.id_turnieju) >= 5 THEN
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
        AND id_turnieju=NEW.id_turnieju) >= 1 THEN
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
        AND id_turnieju=NEW.id_turnieju) >= 2 THEN
        RAISE EXCEPTION 'Zespół o id % ma już 2 gracze zapasowe', NEW.id_zespolu;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_jest_max2_zapasowych ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_czy_jest_max2_zapasowych BEFORE INSERT ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_jest_max2_zapasowych();


CREATE OR REPLACE FUNCTION sprawdz_czy_jest_max2_zapasowych()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT COUNT(*) FROM sklady_w_zespolach
        WHERE id_zespolu = NEW.id_zespolu AND rola=3
        AND id_turnieju=NEW.id_turnieju) >= 2+TG_ARGV[0]::INT THEN
        RAISE EXCEPTION 'Zespół o id % ma już 2 gracze zapasowe', NEW.id_zespolu;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_czy_jest_max2_zapasowych ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_czy_jest_max2_zapasowych BEFORE INSERT ON sklady_w_zespolach
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
         -- it was checked befor WHERE szw.id_turnieju!=NEW.id_turnieju
         AND swz.id_osoby=NEW.id_osoby
         AND (moj_turniej.data_startu BETWEEN t.data_startu AND t.data_konca
            OR moj_turniej.data_konca BETWEEN t.data_startu AND t.data_konca))

        OR

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

DROP TRIGGER IF EXISTS sprawdzanie_czy_gra_w_turnieju_sklady ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_czy_gra_w_turnieju__sklady BEFORE INSERT OR UPDATE ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_gra_w_turnieju_sklady();

CREATE OR REPLACE FUNCTION sprawdz_autora_pytania_sklady()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE
        FROM autorzy_pytan ap
        INNER JOIN pytania_na_turniejach pnt ON ap.id_pytania=pnt.id_pytania
        WHERE pnt.id_turnieju=NEW.id_turnieju
        AND ap.id_autora=NEW.id_osoby
        AND rola IN (SELECT id FROM role_zaangazowane))
    THEN
        RAISE EXCEPTION 'Autor % pytania o id % jest zaangażowany w turniej o id %',NEW.id_osoby, NEW.id_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_autora_pytania ON sklady_w_zespolach;
CREATE TRIGGER sprawdzanie_autora_pytania BEFORE INSERT OR UPDATE ON sklady_w_zespolach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_autora_pytania_sklady();


CREATE OR REPLACE FUNCTION sprawdz_wchodzacy_autor_pytania()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT TRUE
        FROM autorzy_pytan ap
        INNER JOIN pytania_na_turniejach pnt ON ap.id_pytania=pnt.id_pytania
        WHERE pnt.id_turnieju=NEW.id_turnieju
        AND ap.id_autora=NEW.id_wchodzacego
        AND rola IN (SELECT id FROM role_zaangazowane))
    THEN
        RAISE EXCEPTION 'Autor % pytania o id % jest zaangażowany w turniej o id %',NEW.id_osoby, NEW.id_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_wchodzacego_autor_pytania ON zmiany;
CREATE TRIGGER sprawdzanie_wchodzacego_autor_pytania BEFORE INSERT OR UPDATE ON zmiany
FOR EACH ROW EXECUTE PROCEDURE sprawdz_wchodzacy_autor_pytania();


CREATE OR REPLACE FUNCTION sprawdz_wczodzacy_zarejestrowany()
RETURNS TRIGGER
AS $$
BEGIN
    IF NOT EXISTS (SELECT * FROM ososklady_w_zespolachby
                   WHERE id_turnieju=NEW.id_turnieju AND id_osoby=NEW.id_wchodzacego AND rola=3) THEN
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
BEGIN
    SELECT * INTO moj_turniej FROM turnieje WHERE id=NEW.id_turnieju;

    IF  (SELECT TRUE
         FROM sklady_w_zespolach
         WHERE id_turnieju=NEW.id_turnieju
         AND id_osoby=NEW.id_wchodzacego
         AND id_zespolu!=NEW.id_zespolu)

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

DROP TRIGGER IF EXISTS sprawdzanie_czy_gra_w_turnieju_zmainy ON zmiany;
CREATE TRIGGER sprawdzanie_czy_gra_w_turnieju_zmainy BEFORE INSERT OR UPDATE ON zmiany
FOR EACH ROW EXECUTE PROCEDURE sprawdz_wczhodzacego_zmiany();


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
