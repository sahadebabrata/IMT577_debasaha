/*
3) Write the SQL to determine the buildings that have held more than 100 classes 
from the Mathematics department since 1997 that have also
that have also held fewer than 80 classes from the Anthropology department since 
2016.
*/


-- the buildings that have held more than 100 classes from the Mathematics 
-- department since 1997
SELECT B.BuildingID, B.BuildingName, COUNT(C.ClassID) AS Math_ClassCount
FROM tblBUILDING B
JOIN tblCLASSROOM CMR ON B.BuildingID = CMR.BuildingID
JOIN tblCLASS C ON CMR.CLassroomID = C.ClassroomID
JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
WHERE D.DeptName = 'Mathematics'
AND C.[YEAR] >= 1997
GROUP BY B.BuildingID, B.BuildingName --- There aren't more than 100 classes 
though... 
HAVING COUNT(C.ClassID) > 100
--(buildings) also held fewer than 80 classes from the Anthropology department 
since 2016.
SELECT B.BuildingID, B.BuildingName, COUNT(C.ClassID) AS Anthr_ClassCount
FROM tblBUILDING B
JOIN tblCLASSROOM CMR ON B.BuildingID = CMR.BuildingID
JOIN tblCLASS C ON CMR.CLassroomID = C.ClassroomID
JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
WHERE D.DeptName = 'Anthropology' 
AND C.[YEAR] >= 2016
GROUP BY B.BuildingID, B.BuildingName
HAVING COUNT(C.ClassID) < 80 

--- COMBINE! ----
-- Confused because the first query does not have an answer because 100+ classes 
from Mathematics department by building does not exist. 
SELECT A.BuildingID, A.BuildingName
FROM 
(
SELECT B.BuildingID, B.BuildingName, COUNT(C.ClassID) AS Math_ClassCount
FROM tblBUILDING B
JOIN tblCLASSROOM CMR ON B.BuildingID = CMR.BuildingID
JOIN tblCLASS C ON CMR.CLassroomID = C.ClassroomID
JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
WHERE D.DeptName = 'Mathematics'
AND C.[YEAR] >= 1997
GROUP BY B.BuildingID, B.BuildingName
HAVING COUNT(C.ClassID) > 100
) AS A,
(
--(buildings) also held fewer than 80 classes from the Anthropology department 
since 2016.
SELECT B.BuildingID, B.BuildingName, COUNT(C.ClassID) AS Anthr_ClassCount
FROM tblBUILDING B
JOIN tblCLASSROOM CMR ON B.BuildingID = CMR.BuildingID
JOIN tblCLASS C ON CMR.CLassroomID = C.ClassroomID
JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
WHERE D.DeptName = 'Anthropology' 
AND C.[YEAR] >= 2016
GROUP BY B.BuildingID, B.BuildingName
HAVING COUNT(C.ClassID) < 80 
) AS B
WHERE A.BuildingID = B.BuildingID
GROUP BY A.BuildingID, A.BuildingName