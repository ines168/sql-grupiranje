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