
USE master;
GO

DROP DATABASE IF EXISTS FootballGraph;
GO

CREATE DATABASE FootballGraph;
GO

USE FootballGraph;
GO


CREATE TABLE Player
(
    id          INT          NOT NULL PRIMARY KEY,
    name        NVARCHAR(80) NOT NULL,
    position    NVARCHAR(10) NOT NULL,   
    birth_year  INT          NOT NULL,
    nationality NVARCHAR(40) NOT NULL
) AS NODE;
GO


CREATE TABLE Club
(
    id           INT          NOT NULL PRIMARY KEY,
    name         NVARCHAR(80) NOT NULL,
    country      NVARCHAR(40) NOT NULL,
    founded_year INT          NOT NULL
) AS NODE;
GO


CREATE TABLE Country
(
    id            INT          NOT NULL PRIMARY KEY,
    name          NVARCHAR(40) NOT NULL,
    confederation NVARCHAR(20) NOT NULL  
) AS NODE;
GO


CREATE TABLE TransferredTo
(
    transfer_date    DATE         NOT NULL,
    fee_million_eur  DECIMAL(8,2) NOT NULL,   
    contract_years   INT          NOT NULL,
    transfer_type    NVARCHAR(15) NOT NULL     
) AS EDGE;
GO


CREATE TABLE ClubFromCountry
(
    since_year INT NOT NULL
) AS EDGE;
GO


CREATE TABLE PlayerNationality
(
    caps          INT NOT NULL,     
    goals_for_nat INT NOT NULL      
) AS EDGE;
GO


ALTER TABLE TransferredTo
ADD CONSTRAINT EC_TransferredTo CONNECTION (Player TO Club);
GO

ALTER TABLE ClubFromCountry
ADD CONSTRAINT EC_ClubFromCountry CONNECTION (Club TO Country);
GO

ALTER TABLE PlayerNationality
ADD CONSTRAINT EC_PlayerNationality CONNECTION (Player TO Country);
GO




INSERT INTO Player (id, name, position, birth_year, nationality) VALUES
(1,  N'Lionel Messi',        N'FWD', 1987, N'Argentina'),
(2,  N'Cristiano Ronaldo',   N'FWD', 1985, N'Portugal'),
(3,  N'Neymar Jr',           N'FWD', 1992, N'Brazil'),
(4,  N'Kylian Mbappe',       N'FWD', 1998, N'France'),
(5,  N'Luis Suarez',         N'FWD', 1987, N'Uruguay'),
(6,  N'Sergio Ramos',        N'DEF', 1986, N'Spain'),
(7,  N'Thiago Silva',        N'DEF', 1984, N'Brazil'),
(8,  N'Sergio Busquets',     N'MID', 1988, N'Spain'),
(9,  N'Angel Di Maria',      N'MID', 1988, N'Argentina'),
(10, N'Zlatan Ibrahimovic',  N'FWD', 1981, N'Sweden'),
(11, N'Gareth Bale',         N'FWD', 1989, N'Wales'),
(12, N'Edinson Cavani',      N'FWD', 1987, N'Uruguay');
GO


INSERT INTO Club (id, name, country, founded_year) VALUES
(1,  N'FC Barcelona',         N'Spain',    1899),
(2,  N'Real Madrid',          N'Spain',    1902),
(3,  N'Paris Saint-Germain',  N'France',   1970),
(4,  N'Manchester United',    N'England',  1878),
(5,  N'Juventus',             N'Italy',    1897),
(6,  N'AC Milan',             N'Italy',    1899),
(7,  N'Inter Miami',          N'USA',      2018),
(8,  N'Al-Nassr',             N'Saudi Arabia', 1955),
(9,  N'Tottenham Hotspur',    N'England',  1882),
(10, N'Santos FC',            N'Brazil',   1912);
GO


INSERT INTO Country (id, name, confederation) VALUES
(1,  N'Spain',         N'UEFA'),
(2,  N'France',        N'UEFA'),
(3,  N'England',       N'UEFA'),
(4,  N'Italy',         N'UEFA'),
(5,  N'USA',           N'CONCACAF'),
(6,  N'Saudi Arabia',  N'AFC'),
(7,  N'Brazil',        N'CONMEBOL'),
(8,  N'Argentina',     N'CONMEBOL'),
(9,  N'Portugal',      N'UEFA'),
(10, N'Uruguay',       N'CONMEBOL');
GO

SELECT * FROM Player;
SELECT * FROM Club;
SELECT * FROM Country;
GO



INSERT INTO TransferredTo ($from_id, $to_id, transfer_date, fee_million_eur, contract_years, transfer_type)
VALUES

((SELECT $node_id FROM Player WHERE id = 1), (SELECT $node_id FROM Club WHERE id = 1),
 '2004-06-01',   0.00, 4, N'free'),       
((SELECT $node_id FROM Player WHERE id = 1), (SELECT $node_id FROM Club WHERE id = 3),
 '2021-08-10',   0.00, 2, N'free'),
((SELECT $node_id FROM Player WHERE id = 1), (SELECT $node_id FROM Club WHERE id = 7),
 '2023-07-15',   0.00, 3, N'free'),


((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Club WHERE id = 4),
 '2003-08-12',  12.24, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Club WHERE id = 2),
 '2009-07-01',  94.00, 6, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Club WHERE id = 5),
 '2018-07-10', 100.00, 4, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Club WHERE id = 4),
 '2021-08-31',  15.00, 2, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Club WHERE id = 8),
 '2023-01-01',   0.00, 2, N'free'),


((SELECT $node_id FROM Player WHERE id = 3), (SELECT $node_id FROM Club WHERE id = 10),
 '2009-03-07',   0.00, 5, N'free'),
((SELECT $node_id FROM Player WHERE id = 3), (SELECT $node_id FROM Club WHERE id = 1),
 '2013-06-03',  57.00, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 3), (SELECT $node_id FROM Club WHERE id = 3),
 '2017-08-03', 222.00, 5, N'purchase'),


((SELECT $node_id FROM Player WHERE id = 4), (SELECT $node_id FROM Club WHERE id = 3),
 '2017-08-31', 180.00, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 4), (SELECT $node_id FROM Club WHERE id = 2),
 '2024-07-01',   0.00, 5, N'free'),


((SELECT $node_id FROM Player WHERE id = 5), (SELECT $node_id FROM Club WHERE id = 1),
 '2014-07-11',  82.30, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 5), (SELECT $node_id FROM Club WHERE id = 7),
 '2024-01-01',   0.00, 1, N'free'),


((SELECT $node_id FROM Player WHERE id = 6), (SELECT $node_id FROM Club WHERE id = 2),
 '2005-09-08',  27.00, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 6), (SELECT $node_id FROM Club WHERE id = 3),
 '2021-07-08',   0.00, 2, N'free'),


((SELECT $node_id FROM Player WHERE id = 7), (SELECT $node_id FROM Club WHERE id = 6),
 '2009-01-01',  10.00, 4, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 7), (SELECT $node_id FROM Club WHERE id = 3),
 '2012-07-14',  42.00, 5, N'purchase'),


((SELECT $node_id FROM Player WHERE id = 8), (SELECT $node_id FROM Club WHERE id = 1),
 '2008-07-01',   0.00, 4, N'free'),
((SELECT $node_id FROM Player WHERE id = 8), (SELECT $node_id FROM Club WHERE id = 7),
 '2023-07-15',   0.00, 2, N'free'),


((SELECT $node_id FROM Player WHERE id = 9), (SELECT $node_id FROM Club WHERE id = 2),
 '2010-07-01',  25.00, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 9), (SELECT $node_id FROM Club WHERE id = 4),
 '2014-08-26',  75.00, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 9), (SELECT $node_id FROM Club WHERE id = 3),
 '2015-08-06',  63.00, 4, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 9), (SELECT $node_id FROM Club WHERE id = 5),
 '2022-07-08',   0.00, 1, N'free'),


((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Club WHERE id = 5),
 '2004-07-31',  16.00, 4, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Club WHERE id = 1),
 '2009-07-27',  69.50, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Club WHERE id = 6),
 '2010-08-28',  24.00, 3, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Club WHERE id = 3),
 '2012-07-17',  20.00, 4, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Club WHERE id = 4),
 '2016-07-01',   0.00, 1, N'free'),


((SELECT $node_id FROM Player WHERE id = 11), (SELECT $node_id FROM Club WHERE id = 9),
 '2007-05-25',  10.00, 4, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 11), (SELECT $node_id FROM Club WHERE id = 2),
 '2013-09-01', 100.80, 6, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 11), (SELECT $node_id FROM Club WHERE id = 9),
 '2020-09-19',   0.00, 1, N'loan'),


((SELECT $node_id FROM Player WHERE id = 12), (SELECT $node_id FROM Club WHERE id = 3),
 '2013-07-16',  64.50, 5, N'purchase'),
((SELECT $node_id FROM Player WHERE id = 12), (SELECT $node_id FROM Club WHERE id = 4),
 '2020-10-05',   0.00, 1, N'free');
GO


INSERT INTO ClubFromCountry ($from_id, $to_id, since_year)
VALUES
((SELECT $node_id FROM Club WHERE id = 1),  (SELECT $node_id FROM Country WHERE id = 1), 1899),
((SELECT $node_id FROM Club WHERE id = 2),  (SELECT $node_id FROM Country WHERE id = 1), 1902),
((SELECT $node_id FROM Club WHERE id = 3),  (SELECT $node_id FROM Country WHERE id = 2), 1970),
((SELECT $node_id FROM Club WHERE id = 4),  (SELECT $node_id FROM Country WHERE id = 3), 1878),
((SELECT $node_id FROM Club WHERE id = 5),  (SELECT $node_id FROM Country WHERE id = 4), 1897),
((SELECT $node_id FROM Club WHERE id = 6),  (SELECT $node_id FROM Country WHERE id = 4), 1899),
((SELECT $node_id FROM Club WHERE id = 7),  (SELECT $node_id FROM Country WHERE id = 5), 2018),
((SELECT $node_id FROM Club WHERE id = 8),  (SELECT $node_id FROM Country WHERE id = 6), 1955),
((SELECT $node_id FROM Club WHERE id = 9),  (SELECT $node_id FROM Country WHERE id = 3), 1882),
((SELECT $node_id FROM Club WHERE id = 10), (SELECT $node_id FROM Country WHERE id = 7), 1912);
GO


INSERT INTO PlayerNationality ($from_id, $to_id, caps, goals_for_nat)
VALUES
((SELECT $node_id FROM Player WHERE id = 1),  (SELECT $node_id FROM Country WHERE id = 8),  189, 112),
((SELECT $node_id FROM Player WHERE id = 2),  (SELECT $node_id FROM Country WHERE id = 9),  212, 130),
((SELECT $node_id FROM Player WHERE id = 3),  (SELECT $node_id FROM Country WHERE id = 7),  128,  79),
((SELECT $node_id FROM Player WHERE id = 4),  (SELECT $node_id FROM Country WHERE id = 2),   86,  48),
((SELECT $node_id FROM Player WHERE id = 5),  (SELECT $node_id FROM Country WHERE id = 10), 142,  69),
((SELECT $node_id FROM Player WHERE id = 6),  (SELECT $node_id FROM Country WHERE id = 1),  180,  23),
((SELECT $node_id FROM Player WHERE id = 7),  (SELECT $node_id FROM Country WHERE id = 7),  113,   7),
((SELECT $node_id FROM Player WHERE id = 8),  (SELECT $node_id FROM Country WHERE id = 1),  143,   2),
((SELECT $node_id FROM Player WHERE id = 9),  (SELECT $node_id FROM Country WHERE id = 8),  144,  31),
((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Country WHERE id = 1),  122,  62),  
((SELECT $node_id FROM Player WHERE id = 11), (SELECT $node_id FROM Country WHERE id = 3),  111,  41),  
((SELECT $node_id FROM Player WHERE id = 12), (SELECT $node_id FROM Country WHERE id = 10), 136,  58);
GO


PRINT N'=== 5.1. Все клубы Месси (история его трансферов) ===';
SELECT  p.name                AS Player,
        c.name                AS Club,
        t.transfer_date,
        t.fee_million_eur,
        t.transfer_type
FROM    Player p, TransferredTo t, Club c
WHERE   MATCH(p-(t)->c)
  AND   p.name = N'Lionel Messi'
ORDER BY t.transfer_date;
GO


PRINT N'=== 5.2. Игроки, игравшие хотя бы в одном клубе вместе с Месси ===';
SELECT DISTINCT
        p1.name AS Messi,
        c.name  AS CommonClub,
        p2.name AS Teammate
FROM    Player p1, TransferredTo t1, Club c,
        TransferredTo t2, Player p2
WHERE   MATCH(p1-(t1)->c<-(t2)-p2)
  AND   p1.name = N'Lionel Messi'
  AND   p2.name <> N'Lionel Messi'
ORDER BY Teammate, CommonClub;
GO


PRINT N'=== 5.3. Игроки, игравшие в клубе СВОЕЙ страны (по гражданству) ===';
SELECT DISTINCT
        p.name      AS Player,
        c.name      AS Club,
        co.name     AS Country
FROM    Player p, TransferredTo t, Club c,
        ClubFromCountry cf, Country co,
        PlayerNationality pn
WHERE   MATCH(p-(t)->c-(cf)->co AND p-(pn)->co)
ORDER BY co.name, p.name;
GO


PRINT N'=== 5.4. Все трансферы во французские клубы (сортировка по сумме) ===';
SELECT  p.name                       AS Player,
        c.name                       AS Club,
        co.name                      AS Country,
        t.fee_million_eur            AS Fee_M_EUR,
        t.transfer_date
FROM    Player p, TransferredTo t, Club c,
        ClubFromCountry cf, Country co
WHERE   MATCH(p-(t)->c-(cf)->co)
  AND   co.name = N'France'
ORDER BY t.fee_million_eur DESC;
GO


PRINT N'=== 5.5. Игроки, которые играли в клубах, где играл Роналду ===';
SELECT DISTINCT
        p2.name AS Player,
        p2.nationality,
        c.name  AS ClubSharedWithRonaldo
FROM    Player p1, TransferredTo t1, Club c,
        TransferredTo t2, Player p2
WHERE   MATCH(p1-(t1)->c<-(t2)-p2)
  AND   p1.name = N'Cristiano Ronaldo'
  AND   p2.name <> N'Cristiano Ronaldo'
ORDER BY c.name, p2.name;
GO


PRINT N'=== 5.6. Игроки-легионеры (играли в клубе чужой страны) ===';
SELECT DISTINCT
        p.name      AS Player,
        co_p.name   AS PlayerCountry,
        c.name      AS Club,
        co_c.name   AS ClubCountry
FROM    Player p, PlayerNationality pn, Country co_p,
        TransferredTo t, Club c,
        ClubFromCountry cf, Country co_c
WHERE   MATCH(co_p<-(pn)-p-(t)->c-(cf)->co_c)
  AND   co_p.name <> co_c.name
ORDER BY p.name, c.name;
GO


PRINT N'=== 6.1. SHORTEST_PATH с "+": сеть клубов вокруг Месси ===';
SELECT  p1.name                                                        AS StartPlayer,
        STRING_AGG(c.name, N' -> ') WITHIN GROUP (GRAPH PATH)          AS ClubChain,
        LAST_VALUE(c.name)         WITHIN GROUP (GRAPH PATH)           AS LastClub,
        COUNT(c.name)              WITHIN GROUP (GRAPH PATH)           AS Steps
FROM    Player p1,
        TransferredTo  FOR PATH AS t,
        Club           FOR PATH AS c
WHERE   MATCH(SHORTEST_PATH(p1(-(t)->c)+))
  AND   p1.name = N'Lionel Messi';
GO


PRINT N'=== 6.2. SHORTEST_PATH с {1,n}: цепочки длиной 1..4 от Неймара ===';
SELECT  p1.name                                                        AS StartPlayer,
        STRING_AGG(c.name, N' -> ') WITHIN GROUP (GRAPH PATH)          AS Path,
        LAST_VALUE(c.name)         WITHIN GROUP (GRAPH PATH)           AS DestinationClub,
        COUNT(c.name)              WITHIN GROUP (GRAPH PATH)           AS PathLength
FROM    Player p1,
        TransferredTo  FOR PATH AS t,
        Club           FOR PATH AS c
WHERE   MATCH(SHORTEST_PATH(p1(-(t)->c){1,4}))
  AND   p1.name = N'Neymar Jr';
GO


PRINT N'=== 6.3. Кратчайший путь от Cavani до клуба Inter Miami через сеть трансферов ===';
WITH Paths AS (
    SELECT  p1.name                                                    AS Player,
            STRING_AGG(c.name, N' -> ') WITHIN GROUP (GRAPH PATH)      AS Path,
            LAST_VALUE(c.name)         WITHIN GROUP (GRAPH PATH)       AS LastClub,
            COUNT(c.name)              WITHIN GROUP (GRAPH PATH)       AS Steps
    FROM    Player p1,
            TransferredTo FOR PATH AS t,
            Club          FOR PATH AS c
    WHERE   MATCH(SHORTEST_PATH(p1(-(t)->c)+))
      AND   p1.name = N'Edinson Cavani'
)
SELECT *
FROM   Paths
WHERE  LastClub = N'Inter Miami';
GO
