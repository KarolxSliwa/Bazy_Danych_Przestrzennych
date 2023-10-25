-- Tworzenie bazy danych "firma"
CREATE DATABASE firma;


-- Dodawanie schematu "ksiegowosc"
CREATE SCHEMA ksiegowosc;
COMMENT ON SCHEMA ksiegowosc IS 'Schemat do przechowywania danych z działu księgowości.';

-- Tworzenie tabeli "pracownicy"
CREATE TABLE ksiegowosc.pracownicy (
    id_pracownika SERIAL PRIMARY KEY,
    imie VARCHAR(255),
    nazwisko VARCHAR(255),
    adres TEXT,
    telefon VARCHAR(20)
);
COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela przechowująca informacje o pracownikach.';

-- Tworzenie tabeli "godziny"
CREATE TABLE ksiegowosc.godziny (
    id_godziny SERIAL PRIMARY KEY,
    data DATE,
    liczba_godzin INT,
    id_pracownika INT,
    FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika)
);
COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela przechowująca informacje o godzinach pracy pracowników.';

-- Tworzenie tabeli "pensja"
CREATE TABLE ksiegowosc.pensja (
    id_pensji SERIAL PRIMARY KEY,
    stanowisko VARCHAR(255),
    kwota NUMERIC(10, 2)
);
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela przechowująca informacje o pensjach pracowników.';

-- Tworzenie tabeli "premia"
CREATE TABLE ksiegowosc.premia (
    id_premii SERIAL PRIMARY KEY,
    rodzaj VARCHAR(255),
    kwota NUMERIC(10, 2)
);
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela przechowująca informacje o premiach pracowników.';

-- Tworzenie tabeli "wynagrodzenie"
CREATE TABLE ksiegowosc.wynagrodzenie (
    id_wynagrodzenia SERIAL PRIMARY KEY,
    data DATE,
    id_pracownika INT,
    id_godziny INT,
    id_pensji INT,
    id_premii INT,
    FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika),
    FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny),
    FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja(id_pensji),
    FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premia(id_premii)
);
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela przechowująca informacje o wynagrodzeniach pracowników.';



-- Wypełnienie tabeli "pracownicy"
INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) 
VALUES
    ('Jan', 'Kowalski', 'ul. a 1', '123-456-789'),
    ('Anna', 'Nowak', 'ul. b 2', '987-654-321'),
    ('Marek', 'Jankowski', 'ul. c 3', '111-222-333'),
    ('Ewa', 'Kowalczyk', 'ul. d 4', '444-555-666'),
    ('Piotr', 'Mazurek', 'ul. e 5', '777-888-999'),
    ('Katarzyna', 'Wisniewska', 'ul. f 6', '222-333-444'),
    ('Robert', 'Zielinski', 'ul. g 7', '555-666-777'),
    ('Monika', 'Lis', 'ul. h 8', '888-999-000'),
    ('Wojciech', 'Wozniak', 'ul. i 9', '111-222-333'),
    ('Iwona', 'Kaminska', 'ul. j 10', '999-888-777');

-- Wypełnienie tabeli "godziny"
INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika)
VALUES
    ('2023-01-01', 160, 1),
    ('2023-01-01', 170, 2),
    ('2023-01-02', 180, 3),
    ('2023-01-02', 150, 4),
    ('2023-01-03', 155, 5),
    ('2023-01-03', 165, 6),
    ('2023-01-04', 175, 7),
    ('2023-01-04', 185, 8),
    ('2023-01-05', 195, 9),
    ('2023-01-05', 160, 10);

-- Wypełnienie tabeli "pensja"
INSERT INTO ksiegowosc.pensja (stanowisko, kwota)
VALUES
    ('Kierownik', 3000),
    ('Specjalista', 2500),
    ('Pracownik fizyczny', 2000),
    ('Analityk', 2800),
    ('Kierownik', 3100),
    ('Specjalista', 2600),
    ('Pracownik fizyczny', 2100),
    ('Analityk', 2900),
    ('Kierownik', 3200),
    ('Specjalista', 2700);

-- Wypełnienie tabeli "premia"
INSERT INTO ksiegowosc.premia (rodzaj, kwota)
VALUES
    ('Dodatkowa premia', 500),
    ('Brak premii', 0),
    ('Brak premii', 0),
    ('Dodatkowa premia', 600),
    ('Brak premii', 0),
    ('Dodatkowa premia', 550),
    ('Dodatkowa premia', 700),
    ('Brak premii', 0),
    ('Brak premii', 0),
    ('Dodatkowa premia', 750);

-- Wypełnienie tabeli "wynagrodzenie"
INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii)
VALUES
    ('2023-01-01', 1, 1, 1, 1),
    ('2023-01-01', 2, 2, 2, 2),
    ('2023-01-02', 3, 3, 3, 3),
    ('2023-01-02', 4, 4, 4, 4),
    ('2023-01-03', 5, 5, 5, 5),
    ('2023-01-03', 6, 6, 6, 6),
    ('2023-01-04', 7, 7, 7, 7),
    ('2023-01-04', 8, 8, 8, 8),
    ('2023-01-05', 9, 9, 9, 9),
    ('2023-01-05', 10, 10, 10, 10);
	
	
-- a 
	
	SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;
	
-- b

	SELECT w.id_pracownika
	FROM ksiegowosc.wynagrodzenie w
	JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
	WHERE p.kwota > 1000;



-- c

	SELECT p.id_pracownika
	FROM ksiegowosc.pracownicy p
	LEFT JOIN ksiegowosc.premia pr ON p.id_pracownika = pr.id_premii
	WHERE pr.id_premii IS NULL AND p.id_pracownika IN (
    SELECT id_pracownika FROM ksiegowosc.pensja WHERE kwota > 2000
	)	


-- d

	SELECT * FROM ksiegowosc.pracownicy WHERE imie LIKE 'J%';


-- e

	SELECT * FROM ksiegowosc.pracownicy WHERE nazwisko LIKE '%n%' AND imie LIKE '%a';


-- f

	SELECT imie, nazwisko, (g.liczba_godzin - 160) AS nadgodziny
	FROM ksiegowosc.pracownicy p
	JOIN ksiegowosc.godziny g ON p.id_pracownika = g.id_pracownika;

-- g

	SELECT imie, nazwisko
	FROM ksiegowosc.pracownicy p
	JOIN ksiegowosc.pensja pen ON p.id_pracownika = pen.id_pensji
	WHERE pen.kwota BETWEEN 1500 AND 3000;

-- h
	
	SELECT imie, nazwisko
	FROM ksiegowosc.pracownicy p
	JOIN ksiegowosc.godziny g ON p.id_pracownika = g.id_pracownika
	LEFT JOIN ksiegowosc.premia pr ON p.id_pracownika = pr.id_premii
	WHERE g.liczba_godzin > 160 AND pr.id_premii IS NULL;

-- i 

	SELECT imie, nazwisko, pen.kwota AS pensja
	FROM ksiegowosc.pracownicy p
	JOIN ksiegowosc.pensja pen ON p.id_pracownika = pen.id_pensji
	ORDER BY pen.kwota;

-- j

	SELECT imie, nazwisko, pen.kwota AS pensja, pr.kwota AS premia
	FROM ksiegowosc.pracownicy p
	JOIN ksiegowosc.pensja pen ON p.id_pracownika = pen.id_pensji
	LEFT JOIN ksiegowosc.premia pr ON p.id_pracownika = pr.id_premii
	ORDER BY pen.kwota DESC, pr.kwota DESC;

-- k 

	SELECT stanowisko, COUNT(*) AS liczba_pracownikow
	FROM ksiegowosc.pensja
	GROUP BY stanowisko;


-- l

	SELECT stanowisko, AVG(kwota) AS srednia_pensja, MIN(kwota) AS minimalna_pensja, MAX(kwota) AS maksymalna_pensja
	FROM ksiegowosc.pensja
	WHERE stanowisko = 'Kierownik'
	GROUP BY stanowisko;

-- m

	SELECT SUM(p.kwota) AS suma_wynagrodzen
	FROM ksiegowosc.pensja p
	JOIN ksiegowosc.wynagrodzenie w ON p.id_pensji = w.id_pensji;

-- n 

	SELECT stanowisko, SUM(p.kwota) AS suma_wynagrodzen
	FROM ksiegowosc.pensja p
	GROUP BY stanowisko;

-- o 

	SELECT p.stanowisko, COUNT(pr.id_premii) AS liczba_premii
	FROM ksiegowosc.pensja p
	LEFT JOIN ksiegowosc.premia pr ON p.id_pensji = pr.id_premii
	GROUP BY p.stanowisko;


-- p 

	DELETE FROM ksiegowosc.pracownicy
	WHERE id_pracownika IN (
    SELECT w.id_pracownika
    FROM ksiegowosc.wynagrodzenie w
    JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
    WHERE p.kwota < 1200
	)




