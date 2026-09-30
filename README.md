# 🏏 IPL SQL Data Analysis Project

## 📌 Project Overview

This project is a practical **IPL Data Analysis project using PostgreSQL and SQL**.

The analysis uses two IPL datasets:

- `ipl_matches` — match-level information
- `ipl_deliveries` — ball-by-ball delivery information

The project starts with basic SQL analysis and gradually moves to intermediate concepts such as:

- Aggregation
- `GROUP BY`
- `ORDER BY`
- `UNION ALL`
- `JOIN`
- `CASE WHEN`
- Subqueries
- `RANK()`
- `DENSE_RANK()`
- `LAG()`
- `PARTITION BY`
- Window functions
- `ROWS BETWEEN`
- Running totals
- Rolling/season windows

---

## 🎯 Project Objectives

The main objectives of this project are to:

1. Analyze IPL matches season by season.
2. Understand team participation and performance.
3. Analyze toss decisions and match outcomes.
4. Identify top-performing batsmen and bowlers.
5. Analyze venue-level match and scoring patterns.
6. Use `CASE WHEN` to categorize cricket data.
7. Use joins to combine match-level and ball-by-ball data.
8. Apply ranking and window functions to player and team analysis.
9. Calculate previous/current/next season windows.
10. Practice SQL patterns useful for Data Analyst interviews.

---

# 🗂️ Database Tables

## 1. `‪C:\Users\HP\Downloads\IPL_ANALYSIS_SQL.sql `

Match-level table containing information such as:

- `id`
- `season`
- `city`
- `date`
- `match_type`
- `player_of_match`
- `venue`
- `team1`
- `team2`
- `toss_winner`
- `toss_decision`
- `winner`
- `result`
- `result_margin`
- `target_runs`
- `target_overs`
- `super_over`
- `method`
- `umpire1`
- `umpire2`

## 2. `ipl_deliveries`

Ball-by-ball table containing:

- `match_id`
- `inning`
- `batting_team`
- `bowling_team`
- `over`
- `ball`
- `batter`
- `bowler`
- `non_striker`
- `batsman_runs`
- `extra_runs`
- `total_runs`
- `extras_type`
- `is_wicket`
- `player_dismissed`
- `dismissal_kind`
- `fielder`

---

# 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Database and SQL analysis |
| pgAdmin 4 | Query execution and database management |
| SQL | Data analysis |
| GitHub | Project version control and portfolio |

---

# 📊 SQL Analysis

## Q1. How many IPL matches were played in each season?

```sql
SELECT
    season,
    COUNT(*) AS total_matches
FROM ipl_matches
GROUP BY season
ORDER BY season;
```

---

## Q2. How many matches has each team played?

```sql
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
```

**Concepts:** `UNION ALL`, subquery, `GROUP BY`

---

## Q3. Which teams won matches in each IPL season?

```sql
SELECT DISTINCT
    season,
    winner
FROM ipl_matches
WHERE winner IS NOT NULL
ORDER BY season, winner;
```

---

## Q4. Which venues hosted the highest number of IPL matches?

```sql
SELECT
    venue,
    COUNT(*) AS total_matches
FROM ipl_matches
GROUP BY venue
ORDER BY total_matches DESC;
```

---

## Q5. How many matches were won by teams that chose to bat first vs field first?

```sql
SELECT
    toss_decision,
    COUNT(*) AS toss_winner_also_match_winner
FROM ipl_matches
WHERE toss_winner = winner
GROUP BY toss_decision
ORDER BY toss_decision;
```

---

## Q6. Which players have won Player of the Match most frequently?

```sql
SELECT
    player_of_match,
    COUNT(*) AS awards
FROM ipl_matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;
```

---

## Q7. How many tosses did each team win?

```sql
SELECT
    toss_winner,
    COUNT(*) AS toss_wins
FROM ipl_matches
GROUP BY toss_winner
ORDER BY toss_wins DESC;
```

---

## Q8. How many times did teams choose Bat or Field after winning the toss?

```sql
SELECT
    toss_decision,
    COUNT(*) AS toss_decisions
FROM ipl_matches
GROUP BY toss_decision
ORDER BY toss_decisions DESC;
```

---

## Q9. Who are the Top 10 batsmen by total runs?

```sql
SELECT
    batter,
    SUM(batsman_runs) AS total_runs
FROM ipl_deliveries
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 10;
```

---

## Q10. Which team had the highest number of wins in a single season?

```sql
SELECT
    season,
    winner,
    COUNT(*) AS total_wins
FROM ipl_matches
WHERE winner IS NOT NULL
GROUP BY season, winner
ORDER BY total_wins DESC
LIMIT 1;
```

---

## Q11. How many matches ended without a result?

```sql
SELECT
    COUNT(*) AS special_matches
FROM ipl_matches
WHERE winner IS NULL;
```

---

## Q12. Who are the Top 10 batsmen based on sixes?

```sql
SELECT
    batter,
    COUNT(*) AS total_sixes
FROM ipl_deliveries
WHERE batsman_runs = 6
GROUP BY batter
ORDER BY total_sixes DESC
LIMIT 10;
```

---

## Q13. Who are the Top 10 batsmen based on fours?

```sql
SELECT
    batter,
    COUNT(*) AS total_fours
FROM ipl_deliveries
WHERE batsman_runs = 4
GROUP BY batter
ORDER BY total_fours DESC
LIMIT 10;
```

---

## Q14. Which batsman scored the highest individual score in a match?

```sql
SELECT
    match_id,
    batter,
    SUM(batsman_runs) AS runs
FROM ipl_deliveries
GROUP BY match_id, batter
ORDER BY runs DESC
LIMIT 1;
```

---

## Q15. Find the winner of each IPL season.

```sql
SELECT DISTINCT ON (season)
    season,
    winner
FROM ipl_matches
WHERE winner IS NOT NULL
ORDER BY season, date DESC;
```

> This approach assumes the latest dated completed match in each season is the final.

---

# 🔗 JOIN Analysis

## Q16. Find the total runs scored in each season.

```sql
SELECT
    m.season,
    SUM(d.total_runs) AS total_runs
FROM ipl_matches AS m
JOIN ipl_deliveries AS d
    ON m.id = d.match_id
GROUP BY m.season
ORDER BY m.season;
```

---

## Q17. Find the total runs scored by each batsman along with the season.

```sql
SELECT
    m.season,
    d.batter,
    SUM(d.batsman_runs) AS total_runs
FROM ipl_matches AS m
JOIN ipl_deliveries AS d
    ON m.id = d.match_id
GROUP BY m.season, d.batter
ORDER BY m.season, total_runs DESC;
```

---

## Q18. Find the Top 10 batsmen based on total runs.

```sql
SELECT
    d.batter,
    SUM(d.batsman_runs) AS total_runs
FROM ipl_matches AS m
JOIN ipl_deliveries AS d
    ON m.id = d.match_id
GROUP BY d.batter
ORDER BY total_runs DESC
LIMIT 10;
```

---

## Q19. Find the number of matches played at each venue along with the total runs scored there.

```sql
SELECT
    m.venue,
    COUNT(DISTINCT m.id) AS total_matches,
    SUM(d.total_runs) AS total_runs
FROM ipl_matches AS m
JOIN ipl_deliveries AS d
    ON m.id = d.match_id
GROUP BY m.venue
ORDER BY total_runs DESC;
```

---

## Q20. Find the total number of wickets taken by each bowler.

```sql
SELECT
    d.bowler,
    COUNT(*) AS total_wickets
FROM ipl_matches AS m
JOIN ipl_deliveries AS d
    ON m.id = d.match_id
WHERE d.is_wicket = TRUE
GROUP BY d.bowler
ORDER BY total_wickets DESC;
```

> Note: For a more advanced bowling analysis, dismissals such as run-outs can be excluded because they are not credited to the bowler.

---

# 🧠 CASE WHEN Analysis

## Q21. Categorize matches based on winning margin.

```sql
SELECT
    result_margin,
    CASE
        WHEN result_margin IS NULL THEN 'No Margin'
        WHEN result_margin <= 20 THEN 'Close Match'
        WHEN result_margin <= 50 THEN 'Comfortable Win'
        ELSE 'Big Win'
    END AS match_category
FROM ipl_matches;
```

---

## Q22. Categorize every delivery based on batsman runs.

```sql
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
```

---

## Q23. Categorize deliveries based on whether a wicket occurred.

```sql
SELECT
    is_wicket,
    CASE
        WHEN is_wicket = TRUE THEN 'Wicket'
        ELSE 'No Wicket'
    END AS wicket_status
FROM ipl_deliveries;
```

---

## Q24. Categorize matches based on whether a Super Over happened.

```sql
SELECT
    super_over,
    CASE
        WHEN super_over = TRUE THEN 'Super Over'
        WHEN super_over = FALSE THEN 'Regular Match'
        ELSE 'Unknown'
    END AS match_category
FROM ipl_matches;
```

---

## Q25. Categorize matches based on match type.

```sql
SELECT
    match_type,
    CASE
        WHEN match_type = 'League' THEN 'League Match'
        ELSE 'Knockout Match'
    END AS match_category
FROM ipl_matches;
```

---

## Q26. Classify each match based on how the match was won.

```sql
SELECT
    season,
    winner,
    result,
    CASE
        WHEN result = 'runs' THEN 'Won by Runs'
        WHEN result = 'wickets' THEN 'Won by Wickets'
        ELSE 'Other'
    END AS winning_method
FROM ipl_matches;
```

---

## Q27. Classify each batsman's performance based on total runs.

```sql
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
```

---

# 📈 Ranking & Window Functions

## Q28. Find the Top 10 batsmen based on total runs using RANK().

```sql
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
```

---

## Q29. Rank teams based on their total runs using DENSE_RANK().

```sql
SELECT
    batting_team,
    SUM(total_runs) AS total_runs,
    DENSE_RANK() OVER (
        ORDER BY SUM(total_runs) DESC
    ) AS team_rank
FROM ipl_deliveries
GROUP BY batting_team
ORDER BY team_rank;
```

---

## Q30. Find the Top 3 batsmen in each IPL season.

```sql
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
```

---

## Q31. Find each batsman's total runs and their previous season's runs.

```sql
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
```

---

## Q32. Rank bowlers based on total wickets.

```sql
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
```

---

## Q33. Find the Top 3 bowlers in each season based on wickets.

```sql
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
```

---

# 🔥 Window Frame Analysis

## Q34. Calculate the total runs scored by a batsman over the current season and previous 2 seasons.

```sql
SELECT
    season,
    batter,
    season_runs,
    SUM(season_runs) OVER (
        PARTITION BY batter
        ORDER BY season
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_season_rolling_runs
FROM (
    SELECT
        m.season,
        d.batter,
        SUM(d.batsman_runs) AS season_runs
    FROM ipl_matches AS m
    JOIN ipl_deliveries AS d
        ON m.id = d.match_id
    GROUP BY m.season, d.batter
) AS season_data
ORDER BY batter, season;
```

**Frame:** `2 PRECEDING + CURRENT ROW`

---

## Q35. Calculate the cumulative runs scored by each batsman season by season.

```sql
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
    FROM ipl_matches AS m
    JOIN ipl_deliveries AS d
        ON m.id = d.match_id
    GROUP BY m.season, d.batter
) AS season_data
ORDER BY batter, season;
```

**Frame:** `UNBOUNDED PRECEDING → CURRENT ROW`

---

## Q36. Calculate the 3-season window consisting of the previous, current, and next season.

```sql
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
    GROUP BY m.season, d.batter
) AS season_data
ORDER BY batter, season;
```

**Frame:** `1 PRECEDING + CURRENT ROW + 1 FOLLOWING`

For example:

```text
Previous Season + Current Season + Next Season
```

At the first or last available season, SQL uses the rows that actually exist in the window.

---

## Q37. Calculate the combined runs of the current and previous season for each batsman.

```sql
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
    GROUP BY m.season, d.batter
) AS season_data
ORDER BY batter, season;
```

**Frame:** `1 PRECEDING + CURRENT ROW`

---

# 📚 SQL Concepts Covered

### Basic SQL

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `COUNT()`
- `SUM()`

### Combining Data

- `JOIN`
- `UNION ALL`
- Subqueries

### Conditional Logic

- `CASE`
- `WHEN`
- `ELSE`
- `IS NULL`
- Boolean conditions

### Window Functions

- `RANK()`
- `DENSE_RANK()`
- `LAG()`
- `PARTITION BY`
- `ORDER BY` inside window functions

### Window Frames

```text
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```

```text
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
```

```text
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
```

```text
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

---

# 🧩 Window Frame Cheat Sheet

| Frame | Meaning | Typical Use |
|---|---|---|
| `UNBOUNDED PRECEDING AND CURRENT ROW` | First row → current row | Running total |
| `2 PRECEDING AND CURRENT ROW` | Previous 2 + current | 3-row/season rolling total |
| `1 PRECEDING AND CURRENT ROW` | Previous + current | Current + previous season |
| `1 PRECEDING AND 1 FOLLOWING` | Previous + current + next | Centered 3-season window |
| `CURRENT ROW AND UNBOUNDED FOLLOWING` | Current → last row | Remaining/forward total |

---

# 💡 Key Learning Outcomes

By completing this project, I practiced:

- Writing SQL queries for real-world analytical questions.
- Working with relational IPL match and delivery data.
- Combining two tables using joins.
- Using aggregation to calculate player, team, venue, and season metrics.
- Using `CASE WHEN` for data categorization.
- Ranking players and teams using window functions.
- Comparing current and previous seasons using `LAG()`.
- Building cumulative and rolling calculations using window frames.
- Translating business questions into SQL queries.

---


# 👨‍💻 Author

**Prashant Yadav**

Aspiring Data Analyst | SQL | PostgreSQL | Data Analytics

---

# ⭐ Project Summary

This project demonstrates practical SQL skills through a real-world IPL sports analytics use case. It progresses from **basic aggregation and filtering to joins, conditional logic, ranking, `LAG()`, and window-frame analysis**.

The project is designed to demonstrate SQL problem-solving and analytical thinking for a **Data Analyst portfolio**.

