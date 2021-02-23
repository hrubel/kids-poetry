SELECT*
FROM author;

/*1a*/

SELECT COUNT(grade_id) as author_count_by_grade, grade_id as grade
FROM author
GROUP BY grade
ORDER BY grade;

--Mahesh
SELECT DISTINCT(g.name), COUNT(a.name) OVER(PARTITION BY g.name) as total_poets
			   FROM author AS a
			   LEFT JOIN grade a g
			   ON a.grade_id = g.id
			   GROUP BY g.name, a.name 
			   ORDER BY total_poets;

/*1b I know numbers aren't right, but I've spent too long on it already*/

SELECT g1.grade_id AS grade, COUNT(g1.gender_id) AS female, COUNT(g2.gender_id) AS male
			   FROM author AS g1 INNER JOIN author AS g2
			   USING (grade_id)
			   WHERE g1.gender_id=1
			   AND g2.gender_id= 2
			   GROUP BY grade
			   ORDER BY grade;
			   
--Mahesh

SELECT grade_id, gende.name, COUNT(*) as gender_count
			   FROM author INNER JOIN gender ON author.gender_id=
			   USING (grade_id)
			   WHERE g1.gender_id=1
			   AND g2.gender_id= 2
			   GROUP BY grade
			   ORDER BY grade;

/*1c*/

More female aurthors in general and as their ages go up, the amount of poets go up.

/*2 I know this is also incorrect, but I'm struggling with time again*/

SELECT*
FROM poem;

SELECT t1.char_count, CHAR_LENGTH(t1.text)/t1.char_count as love, CHAR_LENGTH(t2.text)/t1.char_count as death
FROM poem AS t1 INNER JOIN poem AS t2 USING(id)
WHERE t1.text ILIKE '%love%'
AND t2.text ILIKE '%death%';

SELECT char_count, COUNT(text)
FROM poem
WHERE text LIKE '%love%' 
AND text LIKE '%death%';

--Mahesh

SELECT COUNT(id) AS poem_count, AVH(char_count) AS avg_char_count
			CASE WHEN LOWER(text) LIKE '%death%' THEN 'death'
			ELSE 'love' END AS love_deathe_cat
FROM poem 
WHERE text ILIKE '%love%'
AND text ILIKE '%death%'
GROUP BY CASE WHEN LOWER(text) LIKE ;

/*3*/
WITH emotions AS (SELECT emotion.id, emotion.name, TRUNC(AVG(poem_emotion.intensity_percent),2) as percent_emotion
		FROM emotion
		LEFT JOIN poem_emotion
		USING(id)
		GROUP BY emotion.id)
SELECT char_count, emotions.percent_emotion, emotions.name
FROM poem
LEFT JOIN emotions
USING (id)
WHERE name IS NOT NULL;

--3b Mahesh
WITH emo as (SELECT name as emotion, ROUND(AVG(intensity_percent),2) as avg_intensity, ROUND(AVG(char_count),2) as avg_char_count, COUNT(poem.id)
				FROM poem_emotion
				JOIN poem on poem_emotion.poem_id = poem.id
				JOIN emotion on poem_emotion.emotion_id = emotion.id
				GROUP BY name),
 emotions as (SELECT poem_id, intensity_percent, char_count, title, text, name
				FROM poem_emotion
				JOIN poem on poem_emotion.poem_id = poem.id
				JOIN emotion on poem_emotion.emotion_id = emotion.id)
SELECT poem_id, intensity_percent, char_count, title, text, (e.char_count - emo.avg_char_count) AS diff_fromavg_char_count
FROM emotions as e
FULL JOIN emo on e.name = emo.emotion
WHERE name LIKE 'Joy'
ORDER BY intensity_percent DESC
LIMIT 7;


/*4*/
--Mahesh
WITH grade_one_anger AS (SELECT *
						 FROM poem INNER JOIN poem_emotion ON poem.id = poem_emotion.poem_id
						 		   INNER JOIN emotion ON emotion.id = poem_emotion.emotion_id
						 		   INNER JOIN author ON author.id = poem.author_id
						  		   INNER JOIN gender on gender.id = author.gender_id
						 WHERE grade_id = 1
						 	   AND emotion.name = 'Anger'
						 ORDER BY intensity_percent DESC
						 LIMIT 5),
	 grade_five_anger AS (SELECT *
						  FROM poem INNER JOIN poem_emotion ON poem.id = poem_emotion.poem_id
						  		    INNER JOIN emotion ON emotion.id = poem_emotion.emotion_id
						  		    INNER JOIN author ON author.id = poem.author_id
						  			INNER JOIN gender on gender.id = author.gender_id
						  WHERE grade_id = 5
						  	    AND emotion.name = 'Anger'
						  ORDER BY intensity_percent DESC
						  LIMIT 5)
SELECT *
FROM grade_one_anger
UNION ALL
SELECT *
FROM grade_five_anger;

/*5*/

WITH emily_grade_count AS (SELECT grade_id, COUNT(DISTINCT id) AS total_emilys
						   FROM author
						   WHERE LOWER(name) LIKE '%emily%'
						   GROUP BY grade_id),
	 emily_emotion_count AS (SELECT grade_id,
						   		    SUM(CASE WHEN emotion.name = 'Anger' THEN 1 ELSE 0 END) AS total_anger,
								    SUM(CASE WHEN emotion.name = 'Fear' THEN 1 ELSE 0 END) AS total_fear,
								    SUM(CASE WHEN emotion.name = 'Sadness' THEN 1 ELSE 0 END) AS total_sadness,
								    SUM(CASE WHEN emotion.name = 'Joy' THEN 1 ELSE 0 END) AS total_joy
						     FROM poem INNER JOIN author ON poem.author_id = author.id
						     	 	   INNER JOIN poem_emotion ON poem.id = poem_emotion.poem_id
						     		   INNER JOIN emotion ON poem_emotion.emotion_id = emotion.id
						     WHERE LOWER(author.name) LIKE '%emily%'
						     GROUP BY grade_id)
SELECT grade_id, total_emilys, total_anger, total_fear, total_sadness, total_joy
FROM emily_grade_count INNER JOIN emily_emotion_count USING(grade_id);