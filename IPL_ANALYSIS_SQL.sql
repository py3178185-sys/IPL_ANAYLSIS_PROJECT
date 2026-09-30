



 		

   CREATE TABLE ipl_deliveries (
    match_id INTEGER,
    inning INTEGER,
    batting_team TEXT,
    bowling_team TEXT,
    over INTEGER,
    ball INTEGER,
    batter TEXT,
    bowler TEXT,
    non_striker TEXT,
    batsman_runs INTEGER,
    extra_runs INTEGER,
    total_runs INTEGER,
    extras_type TEXT,
    is_wicket BOOLEAN,
    player_dismissed TEXT,
    dismissal_kind TEXT,
    fielder TEXT
);

   SELECT * FROM ipl_deliveries

 CREATE TABLE ipl_matches (
    id INTEGER,
    season INTEGER,
    city TEXT,                                                  
    date DATE,
    match_type TEXT,
    player_of_match TEXT,
    venue TEXT,
    team1 TEXT,
    team2 TEXT,
    toss_winner TEXT,
    toss_decision TEXT,
    winner TEXT,
    result TEXT,
    result_margin INTEGER,
    target_runs INTEGER,
    target_overs NUMERIC,
    super_over BOOLEAN,
    method TEXT,
    umpire1 TEXT,
    umpire2 TEXT



    SET datestyle = 'MDY';
	 SELECT * FROM ipl_matches
                                                       




      SELECT * FROM  ipl_matches
     
	  SELECT count(*) FROM ipl_deliveries


    --Q1.How many IPL matches were played in each season?

	  SELECT COUNT(id) as total_matches ,season FROM ipl_matches
      GROUP BY season
       order by season


    SELECT 
    season,
    COUNT(*) AS total_matches
	FROM ipl_matches
	GROUP BY season
	ORDER BY season;


---Q2. How many matches has each team played?

	select * from ipl_matches
     
 
   SELECT 
    team,
    COUNT(*) AS matches_played
	FROM (
	    SELECT team1 AS team
	    FROM ipl_matches
	
	    UNION ALL
	
	    SELECT team2 AS team
	    FROM ipl_matches
	) t
	GROUP BY team
	ORDER BY matches_played DESC;


	 Q3. Who was the winning team in each IPL season?

        SELECT DISTINCT
	    season,
	    winner
		FROM ipl_matches
		WHERE winner IS NOT  NULL
		ORDER BY season;

    SELECT * FROM ipl_matches

   ---Q4. Which venues hosted the highest number of IPL matches?

  	 SELECT 
   	 venue,
	 COUNT(*) AS total_matches
	 FROM ipl_matches
	 GROUP BY venue
	 ORDER BY total_matches DESC;

---Q5. How many matches were won by teams that chose to bat first vs field first?

    SELECT
    toss_decision,
    COUNT(*) AS toss_winner_also_match_winner
	FROM ipl_matches
	WHERE toss_winner = winner
	GROUP BY toss_decision
	ORDER BY toss_decision;


 --Q6. Which players have won Player of the Match most frequently?
	 SELECT
	 player_of_match,
    COUNT(*) AS awards
	FROM ipl_matches
	WHERE player_of_match IS NOT NULL
	GROUP BY player_of_match
	ORDER BY awards DESC
	LIMIT 10;

  --  Q6. How many tosses did each team win?
	SELECT
	    toss_winner,
	    COUNT(*) AS toss_wins
	FROM ipl_matches
	GROUP BY toss_winner
	ORDER BY toss_wins DESC;
	
	--Q7. How many times did teams choose Bat or Field after winning the toss?

       SELECT toss_decision,COUNT(*) AS toss_winning FROM ipl_matches
	   GROUP BY toss_decision
	   ORDER BY toss_winning 

  --  Q8. Who are the Top 10 batsmen by total runs?
	SELECT
    batter,
    SUM(batsman_runs) AS total_runs
	FROM ipl_deliveries
	GROUP BY batter
	ORDER BY total_runs DESC
	LIMIT 10;


  -- Q9. Which team had the highest number of wins in a single season?

   SELECT
    season,
    winner,
    COUNT(*) AS total_wins
	FROM ipl_matches
	WHERE winner IS NOT NULL
	GROUP BY season, winner
	ORDER BY total_wins DESC
	LIMIT 1;

--Q10. How many matches ended without a result or were tied?

    SELECT
    COUNT(*) AS special_matches
	FROM ipl_matches
	WHERE winner IS NULL;

	
  --11. Who are the top 10 batsmen based on sixes?

   SELECT
    batter,
    COUNT(*) AS total_sixes
	FROM ipl_deliveries
	WHERE batsman_runs = 6
	GROUP BY batter
	ORDER BY total_sixes DESC
	LIMIT 10;


  --  12. Who are the top 10 batsmen based on fours?

    
    SELECT
    batter,
    COUNT(*) AS total_sixes
	FROM ipl_deliveries
	WHERE batsman_runs = 4
	GROUP BY batter
	ORDER BY total_sixes DESC
	LIMIT 10;

--	13. Which batsman scored the highest individual score in a match?

    SELECT
    match_id,
    batter,
    SUM(batsman_runs) AS runs
	FROM ipl_deliveries
	GROUP BY match_id, batter
	ORDER BY runs DESC
	LIMIT 1;


   --Q14. Find out each season winner team
    SELECT DISTINCT ON (season)
       season,
       winner
	FROM ipl_matches
	ORDER BY season, date DESC;


 --Q.15 Find the total runs scored in each season.
       SELECT m.season,
	     SUM(d.total_runs) AS total_runs 
	   FROM ipl_matches m
	   JOIN ipl_deliveries d
	   ON m.id = d.match_id
	   GROUP BY m.season
	   ORDER BY m.season

---Q16. Find the total runs scored by each batsman along with the season.

	   SELECT 
	    m.season,
	    d.batter,
	    SUM(d.batsman_runs) AS total_runs
	    FROM ipl_matches AS m
	    JOIN ipl_deliveries AS d
	     ON m.id = d.match_id
	   GROUP BY m.season, d.batter
	   ORDER BY m.season, total_runs DESC;

--Q17. Find the top 10 batsmen based on total runs.

  SELECT 
    d.batter,
    SUM(d.batsman_runs) AS total_runs
	FROM ipl_matches AS m
	JOIN ipl_deliveries AS d
	    ON m.id = d.match_id
	GROUP BY d.batter
	ORDER BY total_runs DESC
	LIMIT 10;

---Q18. Find the number of matches played at each venue along with the total runs scored there.
	   SELECT 
    m.venue,
    COUNT(DISTINCT m.id) AS total_matches,
    SUM(d.total_runs) AS total_runs
	FROM ipl_matches AS m
	JOIN ipl_deliveries AS d
	    ON m.id = d.match_id
	GROUP BY m.venue
	ORDER BY total_runs DESC;

--Q19.. Find the total number of wickets taken by each bowler.
	SELECT 
	    d.bowler,
	    COUNT(*) AS total_wickets
	FROM ipl_matches AS m
	JOIN ipl_deliveries AS d
	    ON m.id = d.match_id
	WHERE d.is_wicket = 'True'
	GROUP BY d.bowler
	ORDER BY total_wickets DESC;


--Q20. Categorize matches based on winning margin.

    SELECT
    result_margin,
    CASE
        WHEN result_margin IS NULL THEN 'No Margin'
        WHEN result_margin <= 20 THEN 'Close Match'
        WHEN result_margin <= 50 THEN 'Comfortable Win'
        ELSE 'Big Win'
    END AS match_category
    FROM ipl_matches;


--  Q21. Categorize every delivery based on batsman runs.
    SELECT
    batsman_runs,
    CASE
        WHEN batsman_runs = 0 THEN 'Dot Ball'
        WHEN batsman_runs = 1 THEN 'Single'
        WHEN batsman_runs = 2 THEN 'Double'
        WHEN batsman_runs = 4 THEN 'Four'
        WHEN batsman_runs = 6 THEN 'Six'
        ELSE 'Other'
    END AS delivery_category
    FROM ipl_deliveries;

 -- Q22. Categorize deliveries based on whether a wicket occurred.
	 SELECT
	    is_wicket,
	    CASE
	        WHEN is_wicket = TRUE THEN 'Wicket'
	        ELSE 'No Wicket'
	    END AS wicket_status
	FROM ipl_deliveries;

 --  Q23. Categorize matches based on whether a Super Over happened

	 SELECT
    super_over,
    CASE
        WHEN super_over = 'Y' THEN 'Super Over'
        WHEN super_over = 'N' THEN 'Regular Match'
        ELSE 'Other'
    END AS match_category
    FROM ipl_matches;


	--Q24. Categorize matches based on match type.
	SELECT
    match_type,
    CASE
        WHEN match_type = 'League' THEN 'League Match'
        ELSE 'Knockout Match'
    END AS match_category
    FROM ipl_matches;

   --Q25.classify each match based on how the match was won.

	SELECT
    m.season,
    m.winner,
    m.result,
    CASE
        WHEN m.result = 'runs' THEN 'Won by Runs'
        WHEN m.result = 'wickets' THEN 'Won by Wickets'
        ELSE 'Other'
    END AS winning_method
	FROM ipl_matches AS m
	JOIN ipl_deliveries AS d
	    ON m.id = d.match_id
	GROUP BY
	    m.season,
	    m.winner,
	    m.result;

  -- Q26.classify each batsman's performance based on total runs.

   SELECT
    d.batter,
    SUM(d.batsman_runs) AS total_runs,

    CASE
        WHEN SUM(d.batsman_runs) < 500 THEN 'Low Scorer'
        WHEN SUM(d.batsman_runs) <= 1000 THEN 'Medium Scorer'
        ELSE 'High Scorer'
    END AS performance_category

	FROM ipl_deliveries AS d
	JOIN ipl_matches AS m
	    ON d.match_id = m.id
	
	GROUP BY d.batter
	ORDER BY total_runs DESC;


   --Q27.Find the top 10 batsmen based on total runs 
	SELECT *
	FROM (
	    SELECT
	        batter,
	        SUM(batsman_runs) AS total_runs,
	        RANK() OVER (
	            ORDER BY SUM(batsman_runs) DESC
	        ) AS run_rank
	    FROM ipl_deliveries
	    GROUP BY batter
	) AS ranked_players
	WHERE run_rank <= 10
	ORDER BY run_rank;

--Q28.	Rank teams based on their total runs.

	SELECT
	    batting_team,
	    SUM(total_runs) AS total_runs,
	    DENSE_RANK() OVER (
	        ORDER BY SUM(total_runs) DESC
	    ) AS team_rank
	FROM ipl_deliveries
	GROUP BY batting_team
	ORDER BY team_rank;


 --Q29. Find the top 3 batsmen in each IPL season.

	
	   SELECT *
	FROM (
	    SELECT
	        m.season,
	        d.batter,
	        SUM(d.batsman_runs) AS total_runs,
	
	        RANK() OVER (
	            PARTITION BY m.season
	            ORDER BY SUM(d.batsman_runs) DESC
	        ) AS run_rank
	
	    FROM ipl_matches AS m
	    JOIN ipl_deliveries AS d
	        ON m.id = d.match_id
	
	    GROUP BY m.season, d.batter
	) AS ranked_players
	
	WHERE run_rank <= 3
	ORDER BY season, run_rank;
	
---Q30.Find each batsman's total runs and their previous season's runs.

	SELECT
    season,
    batter,
    total_runs,

    LAG(total_runs) OVER (
        PARTITION BY batter
        ORDER BY season
    ) AS previous_season_runs

	FROM (
	    SELECT
	        m.season,
	        d.batter,
	        SUM(d.batsman_runs) AS total_runs
	    FROM ipl_matches AS m
	    JOIN ipl_deliveries AS d
	        ON m.id = d.match_id
	    GROUP BY m.season, d.batter
	) AS player_season;

	--Q31.Rank bowlers based on total wickets.
	SELECT
    bowler,
    COUNT(*) AS total_wickets,

    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS wicket_rank

	FROM ipl_deliveries
	WHERE is_wicket = TRUE
	GROUP BY bowler
	ORDER BY wicket_rank;


  --Q32.Find the top 3 bowlers in each season based on wickets.

			SELECT *
		  FROM (
		    SELECT
		        m.season,
		        d.bowler,
		        COUNT(*) AS total_wickets,
		
		        RANK() OVER (
		            PARTITION BY m.season
		            ORDER BY COUNT(*) DESC
		        ) AS wicket_rank
		
		    FROM ipl_matches AS m
		    JOIN ipl_deliveries AS d
		        ON m.id = d.match_id
		
		    WHERE d.is_wicket = TRUE
		
		    GROUP BY m.season, d.bowler
		) AS ranked_bowlers
		
			WHERE wicket_rank <= 3
			ORDER BY season, wicket_rank;
		
		 --Q33.Calculate the total runs scored by a batsman over the current season and previous 2 seasons.
		   
		   SUM(season_runs) OVER (
		    PARTITION BY batter
		    ORDER BY season
		    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		)
	
 --Q34.Calculate the cumulative runs scored by each batsman season by season.
	
	SELECT
    season,
    batter,
    season_runs,
    SUM(season_runs) OVER (
        PARTITION BY batter
        ORDER BY season
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_runs
 FROM (
    SELECT
        m.season,
        d.batter,
        SUM(d.batsman_runs) AS season_runs
    FROM ipl_matches m
    JOIN ipl_deliveries d
        ON m.id = d.match_id
    GROUP BY m.season, d.batter
 ) t
  ORDER BY batter, season;

  --Q35.Calculate the 3-season window consisting of the previous, current, and next season.

	SELECT
	    season,
	    batter,
	    season_runs,
	
	    SUM(season_runs) OVER (
	        PARTITION BY batter
	        ORDER BY season
	        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	    ) AS three_season_runs
	
	FROM (
	    SELECT
	        m.season,
	        d.batter,
	        SUM(d.batsman_runs) AS season_runs
	    FROM ipl_matches AS m
	    JOIN ipl_deliveries AS d
	        ON m.id = d.match_id
	    GROUP BY
	        m.season,
	        d.batter
	) AS season_data
	
	ORDER BY
	    batter,
	    season;
  --Q36.Calculate the combined runs of the current and previous season for each batsman.
	  SELECT
	    season,
	    batter,
	    season_runs,
	    
	    SUM(season_runs) OVER (
	        PARTITION BY batter
	        ORDER BY season
	        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
	    ) AS current_previous_season_runs
	
	FROM (
	    SELECT
	        m.season,
	        d.batter,
	        SUM(d.batsman_runs) AS season_runs
	    FROM ipl_matches AS m
	    JOIN ipl_deliveries AS d
	        ON m.id = d.match_id
	    GROUP BY
	        m.season,
	        d.batter
	) AS season_data
	
	ORDER BY
	    batter,
	    season;