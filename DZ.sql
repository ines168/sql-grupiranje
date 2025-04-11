--7. Ispišite nazive svih kategorija i pokraj svake napišite koliko potkategorija je u njoj.
SELECT k.Naziv, COUNT(*) AS BrojPotkategorija 
FROM Potkategorija AS pk INNER JOIN Kategorija AS k ON pk.KategorijaID=k.IDKategorija
GROUP BY k.Naziv

--8. Ispišite nazive svih kategorija i pokraj svake napišite koliko proizvoda je u njoj.
SELECT k.Naziv AS Kategorija, COUNT(*) AS BrojProizvoda 
FROM Potkategorija AS pk INNER JOIN Kategorija AS k ON pk.KategorijaID=k.IDKategorija
INNER JOIN Proizvod as p ON p.PotkategorijaID=pk.IDPotkategorija
GROUP BY k.Naziv

--9. Ispišite sve različite cijene proizvoda i napišite koliko proizvoda ima svaku cijenu.
SELECT CijenaBezPDV , COUNT(*) AS BrojProizvoda FROM Proizvod
GROUP BY CijenaBezPDV

--10.Ispišite koliko je računa izdano koje godine.
SELECT YEAR(DatumIzdavanja) AS Godina, COUNT(*) AS BrojRacuna FROM Racun
GROUP BY YEAR(DatumIzdavanja)

--11. Ispišite brojeve svih račune izdane kupcu 377 i pokraj svakog ispišite ukupnu cijenu po svim stavkama.
SELECT r.BrojRacuna, p.Naziv AS Stavka, s.UkupnaCijena
FROM Racun AS r INNER JOIN Stavka as s ON r.IDRacun=s.RacunID
INNER JOIN Proizvod AS p ON p.IDProizvod=s.ProizvodID
WHERE KupacID=377
GROUP BY r.BrojRacuna, p.Naziv, s.UkupnaCijena

--ukupna cijena računa
SELECT r.BrojRacuna, SUM(s.UkupnaCijena) AS UkupnaCijena
FROM Racun AS r INNER JOIN Stavka as s ON r.IDRacun=s.RacunID
INNER JOIN Proizvod AS p ON p.IDProizvod=s.ProizvodID
WHERE KupacID=377
GROUP BY r.BrojRacuna

--12. Ispišite nazive svih potkategorija koje sadržavaju više od 10 proizvoda.
SELECT pk.Naziv, COUNT(*) AS BrojProizvoda
FROM Proizvod AS p INNER JOIN Potkategorija AS pk ON p.PotkategorijaID=pk.IDPotkategorija
GROUP BY pk.Naziv
HAVING COUNT(*)>10

--13. Ispišite ukupno zarađene iznose i broj prodanih primjeraka za svaki od ikad prodanih proizvoda.
SELECT p.Naziv, SUM(s.Kolicina) AS ProdanihPrimjeraka, SUM(s.UkupnaCijena) AS Zarada
FROM Proizvod AS p INNER JOIN Stavka AS s ON p.IDProizvod=s.ProizvodID 
GROUP BY p.Naziv

--14. Ispišite ukupno zarađene iznose za svaki od proizvoda koji je prodan u više od 2000 primjeraka.
SELECT p.Naziv, SUM(s.Kolicina) AS ProdanihPrimjeraka, SUM(s.UkupnaCijena) AS Zarada
FROM Proizvod AS p INNER JOIN Stavka AS s ON p.IDProizvod=s.ProizvodID 
GROUP BY p.Naziv
HAVING SUM(s.Kolicina)>2000

--15. Ispišite ukupno zarađene iznose za svaki od proizvoda koji je prodan u više od 2.000 primjeraka ili je zaradio više od 2.000.000 dolara.
SELECT p.Naziv, SUM(s.Kolicina) AS ProdanihPrimjeraka, SUM(s.UkupnaCijena) AS Zarada
FROM Proizvod AS p INNER JOIN Stavka AS s ON p.IDProizvod=s.ProizvodID 
GROUP BY p.Naziv
HAVING SUM(s.Kolicina)>2000 AND SUM(s.UkupnaCijena)>2000000


--1. Ispišite sve potkategorije i za svaku ispišite broj proizvoda u njoj.
SELECT Naziv,
	(SELECT COUNT(*) AS BrojProizvoda FROM Proizvod WHERE IDPotkategorija=PotkategorijaID)
FROM Potkategorija

--2. Riješite prethodni zadatak pomoću spajanja.
SELECT pk.Naziv, COUNT(*) AS BrojProizvoda 
FROM Potkategorija AS pk INNER JOIN Proizvod AS p ON pk.IDPotkategorija=p.PotkategorijaID
GROUP BY pk.Naziv;

--3. Ispišite sve kategorije i za svaku ispišite broj proizvoda u njoj.
SELECT k.Naziv AS Kategorija, 
	(SELECT COUNT(*) FROM Proizvod AS p WHERE p.PotkategorijaID IN 
		(SELECT pk.IDPotkategorija FROM Potkategorija AS pk WHERE pk.IDPotkategorija=k.IDKategorija)
	) AS BrojProizvoda
FROM Kategorija AS k

--4. Ispišite sve proizvode i pokraj svakog ispišite zarađeni iznos, od najboljih prema lošijim.
SELECT Naziv, 
	(SELECT SUM(s.UkupnaCijena) FROM Stavka AS s WHERE IDProizvod=s.ProizvodID) AS Zarada
FROM Proizvod
ORDER BY Zarada DESC

--5. Dohvatite sve proizvode, uz svaki proizvod ispišite prosječnu cijenu svih proizvoda 
--te razliku prosječne cijene svih proizvoda i cijene tog proizvoda. U obzir uzmite samo proizvode s cijenom većom od nule.
SELECT Naziv, CijenaBezPDV,
	(SELECT AVG(CijenaBezPDV) FROM Proizvod WHERE CijenaBezPDV > 0) AS Prosjek,
	CijenaBezPDV-(SELECT AVG(CijenaBezPDV) FROM Proizvod WHERE CijenaBezPDV > 0) AS Razlika
FROM Proizvod
WHERE CijenaBezPDV > 0

--6. Dohvatite imena i prezimena 5 komercijalista koji su izdali najviše računa.
SELECT TOP (5) Ime, Prezime, 
	(SELECT COUNT(*)  FROM Racun WHERE KomercijalistID=IDKomercijalist) AS BrojRacuna
FROM Komercijalist
ORDER BY BrojRacuna DESC

--7. Dohvatite imena i prezimena 5 najboljih komercijalista po broju realiziranih računa te uz svakog dohvatite i iznos prodane robe.
SELECT TOP (5) Ime, Prezime, 
	(SELECT COUNT(*) FROM Racun WHERE KomercijalistID=IDKomercijalist) AS BrojRacuna,
	(SELECT SUM(UkupnaCijena) FROM Stavka AS s WHERE s.RacunID IN 
		(SELECT r.IDRacun FROM Racun AS r WHERE r.KomercijalistID=IDKomercijalist)
	) AS ProdaniIznos
FROM Komercijalist
ORDER BY BrojRacuna DESC

--8. Dohvatite sve boje proizvoda. Uz svaku boju pomoću podupita dohvatite broj proizvoda u toj boji.
SELECT DISTINCT p1.Boja ,
	(SELECT COUNT(*) FROM Proizvod AS p2 WHERE p1.Boja=p2.Boja) AS BrojProizvoda
FROM Proizvod AS p1
WHERE p1.Boja IS NOT NULL

--9. Dohvatite imena i prezimena svih kupaca iz Frankfurta i uz svakog ispišite broj računa koje je platio karticom, od višeg prema nižem.
SELECT Ime, Prezime,
	(SELECT COUNT(*) FROM Racun AS r WHERE IDKupac=r.KupacID AND r.KreditnaKarticaID IS NOT NULL) AS BrojRacuna
FROM Kupac
WHERE GradID=
	(SELECT IDGrad FROM Grad WHERE Naziv='Frankfurt')
ORDER BY BrojRacuna DESC

--10. Vratite sve proizvode čija je cijena pet ili više puta veća od prosjeka.
SELECT * FROM Proizvod AS p
WHERE p.CijenaBezPDV>
	5*(SELECT AVG(CijenaBezPDV) FROM Proizvod)

--11. Vratite sve proizvode koji su prodavani, ali u količini manjoj od 5.
SELECT Naziv
FROM Proizvod
WHERE IDProizvod IN
	(SELECT ProizvodID FROM Stavka WHERE Kolicina<5)

SELECT p.Naziv
FROM Proizvod AS p
WHERE p.IDProizvod IN
	(SELECT s.ProizvodID FROM Stavka AS s WHERE 
		(SELECT SUM(s2.Kolicina) FROM Stavka AS s2 WHERE s2.ProizvodID=p.IDProizvod)<5
	)

SELECT 
    p.Naziv
FROM Proizvod p
WHERE (
    SELECT SUM(s.Kolicina)
    FROM Stavka s
    WHERE s.ProizvodID = p.IDProizvod
) < 5
AND EXISTS (
    SELECT 1
    FROM Stavka s
    WHERE s.ProizvodID = p.IDProizvod
);
--12. Vratite sve proizvode koji nikad nisu prodani:
--* Pomoću IN ili NOT IN
--* Pomoću EXISTS ili NOT EXISTS
--* Pomoću spajanja
SELECT * 
FROM Proizvod 
WHERE IDProizvod NOT IN 
	(SELECT ProizvodID FROM Stavka )

SELECT * 
FROM Proizvod
WHERE NOT EXISTS
  (SELECT * FROM Stavka AS s WHERE s.ProizvodID=IDProizvod)

SELECT * FROM Proizvod AS p LEFT JOIN Stavka AS s ON p.IDProizvod = s.ProizvodID
WHERE s.ProizvodID IS NULL

--13. Vratite količinu zarađenog novca za svaku boju proizvoda.
--NE ZNAM
SELECT p.Boja,
	(SELECT SUM(s.UkupnaCijena) FROM Stavka AS s WHERE s.ProizvodID
	) AS Zarada
FROM Proizvod AS p

--JOIN
SELECT p.Boja,
       SUM(s.UkupnaCijena) AS Zarada
FROM Proizvod p
JOIN Stavka s ON p.IDProizvod = s.ProizvodID
GROUP BY p.Boja;


--14. Vratite količinu zarađenog novca za svaku boju proizvoda, ali samo za one boje koje su zaradile više od 20.000.000.
--NE ZNAM

--JOIN
SELECT p.Boja,
       SUM(s.UkupnaCijena) AS Zarada
FROM Proizvod p
JOIN Stavka s ON p.IDProizvod = s.ProizvodID
GROUP BY p.Boja
HAVING SUM(s.UkupnaCijena)>20000000


--15. Vratiti sve proizvode koji imaju dodijeljenu potkategoriju i koji su prodani u količini većoj od 5000. Uz svaki proizvod vratiti prodanu količinu i naziv kategorije.
SELECT Naziv, 
	(SELECT SUM(s.Kolicina) FROM Stavka AS s WHERE s.ProizvodID=IDProizvod) AS ProdanaKolicina,
	(SELECT k.Naziv FROM Kategorija AS k WHERE k.IDKategorija=
		(SELECT KategorijaID FROM Potkategorija WHERE IDPotkategorija=PotkategorijaID)
	) AS Kategorija
FROM Proizvod
WHERE PotkategorijaID IS NOT NULL AND 
	(SELECT SUM(s.Kolicina) FROM Stavka AS s WHERE s.ProizvodID=IDProizvod)>5000