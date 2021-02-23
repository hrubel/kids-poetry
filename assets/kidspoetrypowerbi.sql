SELECT *
 FROM poem INNER JOIN poem_emotion ON poem.id = poem_emotion.poem_id
						 		   INNER JOIN emotion ON emotion.id = poem_emotion.emotion_id
						 		   INNER JOIN author ON author.id = poem.author_id
								   INNER JOIN grade ON author.id = author.grade_id
						  		   INNER JOIN gender on gender.id = author.gender_id
								 
