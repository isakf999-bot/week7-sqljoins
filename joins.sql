SELECT bks.starttime
FROM cd.bookings bks
JOIN cd.members mems ON mems.memid = bks.memid
WHERE mems.firstname = 'David' AND mems.surname = 'Farrell';

SELECT bks.starttime AS start, facs.name
FROM cd.bookings bks
JOIN cd.facilities facs ON facs.facid = bks.facid
WHERE facs.name LIKE 'Tennis Court%'
AND bks.starttime >= '2012-09-21' AND bks.starttime < '2012-09-22'
ORDER BY bks.starttime;

SELECT DISTINCT recs.firstname, recs.surname
FROM cd.members mems
JOIN cd.members recs ON recs.memid = mems.recommendedby
ORDER BY recs.surname, recs.firstname;

SELECT mems.firstname AS memfname, mems.surname AS memsname, recs.firstname AS recfname, recs.surname AS recsname
FROM cd.members mems
LEFT OUTER JOIN cd.members recs ON recs.memid = mems.recommendedby
ORDER BY memsname, memfname;

SELECT DISTINCT mems.firstname || ' ' || mems.surname AS member, facs.name AS facility
FROM cd.members mems
JOIN cd.bookings bks ON mems.memid = bks.memid
JOIN cd.facilities facs ON facs.facid = bks.facid
WHERE facs.name LIKE 'Tennis Court%'
ORDER BY member, facility;

SELECT mems.firstname || ' ' || mems.surname AS member, facs.name AS facility,
  CASE WHEN mems.memid = 0 THEN bks.slots * facs.guestcost
  ELSE bks.slots * facs.membercost END AS cost
FROM cd.members mems
JOIN cd.bookings bks ON mems.memid = bks.memid
JOIN cd.facilities facs ON facs.facid = bks.facid
WHERE bks.starttime >= '2012-09-14' AND bks.starttime < '2012-09-15'
AND ((mems.memid = 0 AND bks.slots * facs.guestcost > 30)
  OR (mems.memid != 0 AND bks.slots * facs.membercost > 30))
ORDER BY cost DESC;

SELECT DISTINCT mems.firstname || ' ' || mems.surname AS member,
  (SELECT recs.firstname || ' ' || recs.surname
   FROM cd.members recs
   WHERE recs.memid = mems.recommendedby) AS recommender
FROM cd.members mems
ORDER BY member;

SELECT member, facility, cost FROM (
  SELECT mems.firstname || ' ' || mems.surname AS member, facs.name AS facility,
    CASE WHEN mems.memid = 0 THEN bks.slots * facs.guestcost
    ELSE bks.slots * facs.membercost END AS cost
  FROM cd.members mems
  JOIN cd.bookings bks ON mems.memid = bks.memid
  JOIN cd.facilities facs ON facs.facid = bks.facid
  WHERE bks.starttime >= '2012-09-14' AND bks.starttime < '2012-09-15'
) AS b
WHERE cost > 30
ORDER BY cost DESC;
