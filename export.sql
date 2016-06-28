--------------------------------------------------------
--  File created - Utorok-júna-28-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence IDS
--------------------------------------------------------

   CREATE SEQUENCE  "GAMECENTER"."IDS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table COMMENTS
--------------------------------------------------------

  CREATE TABLE "GAMECENTER"."COMMENTS" 
   (	"ID" NUMBER(*,0), 
	"ID_GAME" NUMBER(*,0), 
	"ID_USER" NUMBER(*,0), 
	"COMMENTS" VARCHAR2(200 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GAME
--------------------------------------------------------

  CREATE TABLE "GAMECENTER"."GAME" 
   (	"ID" NUMBER(*,0), 
	"NAME" VARCHAR2(30 BYTE), 
	"AUTHOR" VARCHAR2(30 BYTE), 
	"DATE_ADDED" DATE, 
	"URLADDRESS" VARCHAR2(200 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table RATING
--------------------------------------------------------

  CREATE TABLE "GAMECENTER"."RATING" 
   (	"ID_GAME" NUMBER(*,0), 
	"ID_USER" NUMBER(*,0), 
	"RATING" NUMBER(*,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table SCORE
--------------------------------------------------------

  CREATE TABLE "GAMECENTER"."SCORE" 
   (	"ID" NUMBER(*,0), 
	"ID_GAME" NUMBER(*,0), 
	"ID_USER" NUMBER(*,0), 
	"SCORE" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table USERNAMES
--------------------------------------------------------

  CREATE TABLE "GAMECENTER"."USERNAMES" 
   (	"ID" NUMBER(*,0), 
	"NAME" VARCHAR2(30 BYTE), 
	"PASSWORD" VARCHAR2(30 BYTE), 
	"EMAIL" VARCHAR2(50 BYTE), 
	"DATE_REGISTERED" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for View AVGRATINGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."AVGRATINGS" ("NAME", "ID", "AVGRATING") AS 
  SELECT g.name, g.id, (SELECT AVG(r.rating) FROM RATING r WHERE r.ID_GAME = g.ID) AS AvgRating FROM game g;
--------------------------------------------------------
--  DDL for View MAXRATINGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."MAXRATINGS" ("NAME", "ID", "AVGRATING") AS 
  SELECT name, id, AVGRATING FROM AVGRATINGS WHERE AVGRATING = (SELECT MAX(AVGRATING) FROM AVGRATINGS);
--------------------------------------------------------
--  DDL for View NO_OF_COMMENTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."NO_OF_COMMENTS" ("NAME", "NO_OF_COMMENTS") AS 
  SELECT g.NAME, (SELECT COUNT(*) FROM COMMENTS c WHERE c.ID_GAME = g.ID) AS no_of_comments FROM Game g;
--------------------------------------------------------
--  DDL for View SELECT01
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT01" ("NAME", "DATE_REGISTERED") AS 
  SELECT NAME, DATE_REGISTERED FROM USERNAMES ORDER BY DATE_REGISTERED;
--------------------------------------------------------
--  DDL for View SELECT02
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT02" ("NAME") AS 
  SELECT NAME FROM GAME;
--------------------------------------------------------
--  DDL for View SELECT03
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT03" ("GAME", "COMMENTS", "USERNAME") AS 
  SELECT g.NAME AS Game, c.COMMENTS, u.NAME AS Username FROM GAME g
  JOIN COMMENTS c ON g.ID = c.ID_GAME
  JOIN USERNAMES u ON c.ID_USER = u.ID 
  ORDER BY g.NAME;
--------------------------------------------------------
--  DDL for View SELECT04
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT04" ("NAME") AS 
  SELECT NAME FROM USERNAMES WHERE length(NAME) = (SELECT MAX(length(name)) FROM USERNAMES);
--------------------------------------------------------
--  DDL for View SELECT05
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT05" ("NAME") AS 
  SELECT g.NAME FROM GAME g LEFT JOIN SCORE s ON g.ID = s.ID_GAME 
  WHERE s.ID_GAME IS NULL;
--------------------------------------------------------
--  DDL for View SELECT06
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT06" ("NAME") AS 
  SELECT u.NAME FROM USERNAMES u LEFT JOIN RATING r ON u.ID = r.ID_USER
  WHERE r.ID_USER IS NULL;
--------------------------------------------------------
--  DDL for View SELECT07
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT07" ("NAME") AS 
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
--------------------------------------------------------
--  DDL for View SELECT08
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT08" ("GAMESCOUNT", "USERSCOUNT", "COMMENTSCOUNT", "RATINGCOUNT") AS 
  SELECT "GAMESCOUNT","USERSCOUNT","COMMENTSCOUNT","RATINGCOUNT" FROM 
(SELECT COUNT(*) AS GamesCount FROM GAME) NATURAL JOIN
(SELECT COUNT(*) AS UsersCount FROM USERNAMES) NATURAL JOIN
(SELECT COUNT(*) AS CommentsCount FROM COMMENTS) NATURAL JOIN
(SELECT COUNT(*) AS RatingCount FROM RATING);
--------------------------------------------------------
--  DDL for View SELECT09
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT09" ("NAME") AS 
  SELECT NAME FROM GAME WHERE DATE_ADDED = (SELECT MIN(DATE_ADDED) FROM GAME);
--------------------------------------------------------
--  DDL for View SELECT10
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT10" ("NAME", "AVGRATING", "RATING_COUNT") AS 
  SELECT g.NAME, 
(SELECT AVG(r.RATING) FROM RATING r WHERE r.ID_GAME = g.ID) AS AVGRating, 
(SELECT COUNT(*) FROM RATING r WHERE r.ID_GAME = g.ID) AS RATING_COUNT 
FROM GAME g;
--------------------------------------------------------
--  DDL for View SELECT11
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT11" ("NAME", "NO_OF_COMMENTS") AS 
  SELECT "NAME","NO_OF_COMMENTS" FROM NO_OF_COMMENTS noc 
WHERE noc.NO_OF_COMMENTS = (SELECT MAX(no_of_comments.NO_OF_COMMENTS) FROM no_of_comments);
--------------------------------------------------------
--  DDL for View SELECT12
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT12" ("NAME", "GAMECOUNT", "TOTALSCORE") AS 
  SELECT 
  u.NAME, 
  (SELECT COUNT(*) FROM SCORE s WHERE s.ID_USER = u.ID) AS GameCount,
  (SELECT SUM(sc.SCORE) FROM SCORE sc WHERE sc.id_user = u.id) AS TotalScore 
FROM USERNAMES u;
--------------------------------------------------------
--  DDL for View SELECT13
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT13" ("NAME") AS 
  SELECT NAME 
  FROM USERNAMES 
  WHERE ID = (SELECT SCORE.ID_USER FROM SCORE WHERE score.id = (SELECT MAX(id) FROM SCORE));
--------------------------------------------------------
--  DDL for View SELECT14
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT14" ("NAME", "NO_OF_COMMENTS") AS 
  SELECT m.name, (SELECT COUNT(c.comments) FROM COMMENTS c WHERE c.ID_GAME = m.ID) AS no_of_comments FROM maxratings m;
--------------------------------------------------------
--  DDL for View SELECT15
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "GAMECENTER"."SELECT15" ("NAME", "NO_OF_COMMENTS") AS 
  SELECT 
  u.NAME, 
  (SELECT COUNT(*) FROM COMMENTS c WHERE c.ID_USER = u.ID) AS NO_OF_COMMENTS 
FROM USERNAMES u;
REM INSERTING into GAMECENTER.COMMENTS
SET DEFINE OFF;
Insert into GAMECENTER.COMMENTS (ID,ID_GAME,ID_USER,COMMENTS) values ('21','1','6','very nice UI');
Insert into GAMECENTER.COMMENTS (ID,ID_GAME,ID_USER,COMMENTS) values ('22','2','7','crap');
Insert into GAMECENTER.COMMENTS (ID,ID_GAME,ID_USER,COMMENTS) values ('23','3','6','nice, but average');
Insert into GAMECENTER.COMMENTS (ID,ID_GAME,ID_USER,COMMENTS) values ('24','4','7','less than average game');
Insert into GAMECENTER.COMMENTS (ID,ID_GAME,ID_USER,COMMENTS) values ('25','4','8','best game ever');
Insert into GAMECENTER.COMMENTS (ID,ID_GAME,ID_USER,COMMENTS) values ('26','4','9','bullshit game');
REM INSERTING into GAMECENTER.GAME
SET DEFINE OFF;
Insert into GAMECENTER.GAME (ID,NAME,AUTHOR,DATE_ADDED,URLADDRESS) values ('1','Minesweeper','Lisiak',to_date('15.06.16','DD.MM.RR'),'minesweeper.lisiak.sk');
Insert into GAMECENTER.GAME (ID,NAME,AUTHOR,DATE_ADDED,URLADDRESS) values ('2','Kamene','Lisiak',to_date('20.06.16','DD.MM.RR'),'kamene.lisiak.sk');
Insert into GAMECENTER.GAME (ID,NAME,AUTHOR,DATE_ADDED,URLADDRESS) values ('3','FIFA','EAGames',to_date('12.03.16','DD.MM.RR'),'fifa.eagames.com');
Insert into GAMECENTER.GAME (ID,NAME,AUTHOR,DATE_ADDED,URLADDRESS) values ('4','Doom','Killer',to_date('15.02.95','DD.MM.RR'),'doom.killer.com');
Insert into GAMECENTER.GAME (ID,NAME,AUTHOR,DATE_ADDED,URLADDRESS) values ('5','Prince of Persia','BestGames',to_date('20.02.91','DD.MM.RR'),'prince.bestgames.com');
REM INSERTING into GAMECENTER.RATING
SET DEFINE OFF;
Insert into GAMECENTER.RATING (ID_GAME,ID_USER,RATING) values ('1','6','4');
Insert into GAMECENTER.RATING (ID_GAME,ID_USER,RATING) values ('2','7','1');
Insert into GAMECENTER.RATING (ID_GAME,ID_USER,RATING) values ('3','6','3');
Insert into GAMECENTER.RATING (ID_GAME,ID_USER,RATING) values ('4','7','2');
Insert into GAMECENTER.RATING (ID_GAME,ID_USER,RATING) values ('4','8','5');
Insert into GAMECENTER.RATING (ID_GAME,ID_USER,RATING) values ('4','9','1');
REM INSERTING into GAMECENTER.SCORE
SET DEFINE OFF;
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('14','1','6','2000');
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('15','2','7','12998');
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('16','2','6','22');
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('17','3','6','854');
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('18','4','7','214');
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('19','4','8','2');
Insert into GAMECENTER.SCORE (ID,ID_GAME,ID_USER,SCORE) values ('20','4','9','16855');
REM INSERTING into GAMECENTER.USERNAMES
SET DEFINE OFF;
Insert into GAMECENTER.USERNAMES (ID,NAME,PASSWORD,EMAIL,DATE_REGISTERED) values ('6','Joe','berg','joe@gmail.com',to_date('28.06.16','DD.MM.RR'));
Insert into GAMECENTER.USERNAMES (ID,NAME,PASSWORD,EMAIL,DATE_REGISTERED) values ('7','Sam','jackson','sam.jackson@gmail.com',to_date('28.06.16','DD.MM.RR'));
Insert into GAMECENTER.USERNAMES (ID,NAME,PASSWORD,EMAIL,DATE_REGISTERED) values ('8','TvojaManka','rytmaus','tvojamanka@icloud.com',to_date('28.06.16','DD.MM.RR'));
Insert into GAMECENTER.USERNAMES (ID,NAME,PASSWORD,EMAIL,DATE_REGISTERED) values ('9','razzer','julius',null,to_date('28.06.16','DD.MM.RR'));
Insert into GAMECENTER.USERNAMES (ID,NAME,PASSWORD,EMAIL,DATE_REGISTERED) values ('10','peter.s','kaviarenslavia','stasak@centrum.sk',to_date('28.06.16','DD.MM.RR'));
Insert into GAMECENTER.USERNAMES (ID,NAME,PASSWORD,EMAIL,DATE_REGISTERED) values ('11','anglickykapitan','brexit','outof@eu.eu',to_date('25.06.16','DD.MM.RR'));
--------------------------------------------------------
--  Constraints for Table RATING
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."RATING" ADD PRIMARY KEY ("ID_GAME", "ID_USER")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "GAMECENTER"."RATING" ADD CHECK (rating > 0 AND rating < 6) ENABLE;
  ALTER TABLE "GAMECENTER"."RATING" MODIFY ("RATING" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table USERNAMES
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."USERNAMES" ADD PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "GAMECENTER"."USERNAMES" MODIFY ("DATE_REGISTERED" NOT NULL ENABLE);
  ALTER TABLE "GAMECENTER"."USERNAMES" MODIFY ("PASSWORD" NOT NULL ENABLE);
  ALTER TABLE "GAMECENTER"."USERNAMES" MODIFY ("NAME" NOT NULL ENABLE);
  ALTER TABLE "GAMECENTER"."USERNAMES" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SCORE
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."SCORE" ADD PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "GAMECENTER"."SCORE" MODIFY ("SCORE" NOT NULL ENABLE);
  ALTER TABLE "GAMECENTER"."SCORE" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GAME
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."GAME" ADD PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "GAMECENTER"."GAME" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table COMMENTS
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."COMMENTS" ADD PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "GAMECENTER"."COMMENTS" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table COMMENTS
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."COMMENTS" ADD FOREIGN KEY ("ID_GAME")
	  REFERENCES "GAMECENTER"."GAME" ("ID") ENABLE;
  ALTER TABLE "GAMECENTER"."COMMENTS" ADD FOREIGN KEY ("ID_USER")
	  REFERENCES "GAMECENTER"."USERNAMES" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RATING
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."RATING" ADD FOREIGN KEY ("ID_GAME")
	  REFERENCES "GAMECENTER"."GAME" ("ID") ENABLE;
  ALTER TABLE "GAMECENTER"."RATING" ADD FOREIGN KEY ("ID_USER")
	  REFERENCES "GAMECENTER"."USERNAMES" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SCORE
--------------------------------------------------------

  ALTER TABLE "GAMECENTER"."SCORE" ADD FOREIGN KEY ("ID_GAME")
	  REFERENCES "GAMECENTER"."GAME" ("ID") ENABLE;
  ALTER TABLE "GAMECENTER"."SCORE" ADD FOREIGN KEY ("ID_USER")
	  REFERENCES "GAMECENTER"."USERNAMES" ("ID") ENABLE;
