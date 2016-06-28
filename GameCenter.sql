DROP TABLE game;
DROP TABLE usernames;
DROP TABLE score;
DROP TABLE rating;
DROP TABLE comments;

CREATE TABLE game (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(30),
  author VARCHAR2(30),
  date_added DATE, 
  urladdress VARCHAR2(200)
);

CREATE TABLE usernames (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(30) NOT NULL,
  password VARCHAR2(30) NOT NULL,
  email VARCHAR2(50), 
  date_registered DATE NOT NULL 
);

CREATE TABLE score (
  id INT NOT NULL PRIMARY KEY,
  id_game INT, 
  id_user INT,
  FOREIGN KEY(id_game) REFERENCES game(id),
  FOREIGN KEY(id_user) REFERENCES usernames(id),
  score NUMBER(10) NOT NULL 
);

CREATE TABLE rating (
  id_game INT REFERENCES game(id), 
  id_user INT REFERENCES usernames(id),
  PRIMARY KEY (id_game, id_user),
  rating INT NOT NULL,
  CHECK (rating > 0 AND rating < 6)
);

CREATE TABLE comments (
  id INT NOT NULL PRIMARY KEY,
  id_game INT, 
  id_user INT,
  FOREIGN KEY(id_game) REFERENCES game(id),
  FOREIGN KEY(id_user) REFERENCES usernames(id),
  comments VARCHAR2(200)
);

CREATE SEQUENCE ids START WITH 1 INCREMENT BY 1;
DROP SEQUENCE ids;

INSERT INTO GAME VALUES (ids.NEXTVAL, 'Minesweeper', 'Lisiak', '15.06.2016', 'minesweeper.lisiak.sk');
INSERT INTO GAME VALUES (ids.NEXTVAL, 'Kamene', 'Lisiak', '20.06.2016', 'kamene.lisiak.sk');
INSERT INTO GAME VALUES (ids.NEXTVAL, 'FIFA', 'EAGames', '12.03.2016', 'fifa.eagames.com');
INSERT INTO GAME VALUES (ids.NEXTVAL, 'Doom', 'Killer', '15.02.1995', 'doom.killer.com');
INSERT INTO GAME VALUES (ids.NEXTVAL, 'Prince of Persia', 'BestGames', '20.02.1991', 'prince.bestgames.com');

SELECT * FROM game;

INSERT INTO USERNAMES VALUES (ids.NEXTVAL, 'Joe', 'berg', 'joe@gmail.com', '28/06/2016');
INSERT INTO USERNAMES VALUES (ids.NEXTVAL, 'Sam', 'jackson', 'sam.jackson@gmail.com', '28.06.2016');
INSERT INTO USERNAMES VALUES (ids.NEXTVAL, 'TvojaManka', 'rytmaus', 'tvojamanka@icloud.com', '28.06.2016');
INSERT INTO USERNAMES VALUES (ids.NEXTVAL, 'razzer', 'julius', '', '28.06.2016');
INSERT INTO USERNAMES VALUES (ids.NEXTVAL, 'peter.s', 'kaviarenslavia', 'stasak@centrum.sk', '28.06.2016');
INSERT INTO USERNAMES VALUES (ids.NEXTVAL, 'anglickykapitan', 'brexit', 'outof@eu.eu', '25.06.2016');

SELECT * FROM USERNAMES;

INSERT INTO SCORE VALUES (ids.NEXTVAL, 1, 6, 2000);
INSERT INTO SCORE VALUES (ids.NEXTVAL, 2, 7, 12998);
INSERT INTO SCORE VALUES (ids.NEXTVAL, 2, 6, 22);
INSERT INTO SCORE VALUES (ids.NEXTVAL, 3, 6, 854);
INSERT INTO SCORE VALUES (ids.NEXTVAL, 4, 7, 214);
INSERT INTO SCORE VALUES (ids.NEXTVAL, 4, 8, 2);
INSERT INTO SCORE VALUES (ids.NEXTVAL, 4, 9, 16855);

SELECT * FROM SCORE;

INSERT INTO RATING VALUES (1, 6, 4);
INSERT INTO RATING VALUES (2, 7, 1);
INSERT INTO RATING VALUES (3, 6, 3);
INSERT INTO RATING VALUES (4, 7, 2);
INSERT INTO RATING VALUES (4, 8, 5);
INSERT INTO RATING VALUES (4, 9, 1);

SELECT * FROM RATING;

INSERT INTO COMMENTS VALUES (ids.NEXTVAL, 1, 6, 'very nice UI');
INSERT INTO COMMENTS VALUES (ids.NEXTVAL, 2, 7, 'crap');
INSERT INTO COMMENTS VALUES (ids.NEXTVAL, 3, 6, 'nice, but average');
INSERT INTO COMMENTS VALUES (ids.NEXTVAL, 4, 7, 'less than average game');
INSERT INTO COMMENTS VALUES (ids.NEXTVAL, 4, 8, 'best game ever');
INSERT INTO COMMENTS VALUES (ids.NEXTVAL, 4, 9, 'bullshit game');

SELECT * FROM COMMENTS;

/*
1.       Zoznam hr��ov utrieden� pod�a d�tumu registr�cie
2.       Zoznam hier
3.       Zoznam hier s koment�rmi a menami pou��vate�ov
4.       Hr�� s najdlh��m menom
5.       Zoznam hier, ktor� nehral nikto (nemaj� z�znam v Score)
6.       Zoznam pou��vate�ov, ktor� nehodnotili �iadnu hru
7.       Zoznam pou��vate�ov, ktor� nehodnotili jednu konkr�tnu hru (napr. Minesweeper)
8.       Po�et hier, po�et hr��ov, po�et koment�rov, po�et hodnoten�
9.       Najstar�ia hra
10.   Zoznam hier s ich priemern�m ratingom a po�tom hodnoten�
11.   Najviac komentovan� hry
12.   Zoznam hr��ov s ich po�tom hran�m hier a celkov�m sk�re, ktor� nahrali 
13.   Meno hr��a, ktor� hral naposledy hru
14.   Po�et koment�rov pre najob��benej�iu hru
15.   Men� hr��ov s po�tom koment�rov, ktor� pridali k hr�m
*/

/*1.       Zoznam hr��ov utrieden� pod�a d�tumu registr�cie*/
CREATE VIEW Select01 AS
SELECT NAME, DATE_REGISTERED FROM USERNAMES ORDER BY DATE_REGISTERED;

/*2.       Zoznam hier*/
CREATE VIEW Select02 AS
SELECT NAME FROM GAME;

/*3.       Zoznam hier s koment�rmi a menami pou��vate�ov*/
CREATE VIEW Select03 AS
SELECT g.NAME AS Game, c.COMMENTS, u.NAME AS Username FROM GAME g
  JOIN COMMENTS c ON g.ID = c.ID_GAME
  JOIN USERNAMES u ON c.ID_USER = u.ID 
  ORDER BY g.NAME;

/*4.       Hr�� s najdlh��m menom*/
CREATE VIEW Select04 AS
SELECT NAME FROM USERNAMES WHERE length(NAME) = (SELECT MAX(length(name)) FROM USERNAMES);

/*5.       Zoznam hier, ktor� nehral nikto (nemaj� z�znam v Score)*/
CREATE VIEW Select05 AS
SELECT g.NAME FROM GAME g LEFT JOIN SCORE s ON g.ID = s.ID_GAME 
  WHERE s.ID_GAME IS NULL;

/*6.       Zoznam pou��vate�ov, ktor� nehodnotili �iadnu hru*/
CREATE VIEW Select06 AS
SELECT u.NAME FROM USERNAMES u LEFT JOIN RATING r ON u.ID = r.ID_USER
  WHERE r.ID_USER IS NULL;

/*7.       Zoznam pou��vate�ov, ktor� nehodnotili jednu konkr�tnu hru (napr. Minesweeper)*/
CREATE VIEW Select07 AS
SELECT 
  u.NAME 
FROM USERNAMES u 
WHERE 
  u.ID != 
  (SELECT 
    c.ID_USER 
  FROM COMMENTS c 
    JOIN GAME g ON c.ID_GAME = g.ID 
  WHERE g.NAME = 'Minesweeper');
  
/*8.       Po�et hier, po�et hr��ov, po�et koment�rov, po�et hodnoten�*/
CREATE VIEW Select08 AS
SELECT * FROM 
(SELECT COUNT(*) AS GamesCount FROM GAME) NATURAL JOIN
(SELECT COUNT(*) AS UsersCount FROM USERNAMES) NATURAL JOIN
(SELECT COUNT(*) AS CommentsCount FROM COMMENTS) NATURAL JOIN
(SELECT COUNT(*) AS RatingCount FROM RATING);
  
/*9.       Najstar�ia hra*/
CREATE VIEW Select09 AS
SELECT NAME FROM GAME WHERE DATE_ADDED = (SELECT MIN(DATE_ADDED) FROM GAME);

/*10.   Zoznam hier s ich priemern�m ratingom a po�tom hodnoten�*/
CREATE VIEW Select10 AS
SELECT g.NAME, 
(SELECT AVG(r.RATING) FROM RATING r WHERE r.ID_GAME = g.ID) AS AVGRating, 
(SELECT COUNT(*) FROM RATING r WHERE r.ID_GAME = g.ID) AS RATING_COUNT 
FROM GAME g;

/*11.   Najviac komentovan� hry*/
CREATE VIEW no_of_comments AS 
SELECT 
  g.NAME, 
  (SELECT COUNT(*) FROM COMMENTS c WHERE c.ID_GAME = g.ID) AS no_of_comments 
FROM Game g;
CREATE VIEW Select11 AS
SELECT * FROM NO_OF_COMMENTS noc 
WHERE noc.NO_OF_COMMENTS = (SELECT MAX(no_of_comments.NO_OF_COMMENTS) FROM no_of_comments);

/*12.   Zoznam hr��ov s ich po�tom hran�m hier a celkov�m sk�re, ktor� nahrali*/
CREATE VIEW Select12 AS
SELECT 
  u.NAME, 
  (SELECT COUNT(*) FROM SCORE s WHERE s.ID_USER = u.ID) AS GameCount,
  (SELECT SUM(sc.SCORE) FROM SCORE sc WHERE sc.id_user = u.id) AS TotalScore 
FROM USERNAMES u;

/*13.   Meno hr��a, ktor� hral naposledy hru*/
CREATE VIEW Select13 AS
SELECT NAME 
  FROM USERNAMES 
  WHERE ID = (SELECT SCORE.ID_USER FROM SCORE WHERE score.id = (SELECT MAX(id) FROM SCORE));
  
/*14.   Po�et koment�rov pre najob��benej�iu hru*/
CREATE VIEW avgRatings AS 
SELECT g.name, g.id, (SELECT AVG(r.rating) FROM RATING r WHERE r.ID_GAME = g.ID) AS AvgRating FROM game g;
CREATE VIEW maxRatings AS
SELECT name, id, AVGRATING FROM AVGRATINGS WHERE AVGRATING = (SELECT MAX(AVGRATING) FROM AVGRATINGS);
CREATE VIEW Select14 AS
SELECT m.name, (SELECT COUNT(c.comments) FROM COMMENTS c WHERE c.ID_GAME = m.ID) AS no_of_comments FROM maxratings m;

/*15.   Men� hr��ov s po�tom koment�rov, ktor� pridali k hr�m*/
CREATE VIEW Select15 AS
SELECT 
  u.NAME, 
  (SELECT COUNT(*) FROM COMMENTS c WHERE c.ID_USER = u.ID) AS NO_OF_COMMENTS 
FROM USERNAMES u;
