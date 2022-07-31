SELECT ext, tabs, spaces, countext, LOG((spaces+1)/(tabs+1)) lratio
FROM (
  SELECT REGEXP_EXTRACT(sample_path, r'\.([^\.]*)$') ext, 
         SUM(best='tab') tabs, SUM(best='space') spaces, 
         COUNT(*) countext
  FROM (
    SELECT sample_path, sample_repo_name, IF(SUM(line=' ')>SUM(line='\t'), 'space', 'tab') WITHIN RECORD best,
           COUNT(line) WITHIN RECORD c
    FROM (
      SELECT LEFT(SPLIT(content, '\n'), 1) line, sample_path, sample_repo_name 
      FROM [fh-bigquery:github_extracts.contents_top_repos_top_langs]
      HAVING REGEXP_MATCH(line, r'[ \t]')
    )
    HAVING c>10 # at least 10 lines that start with space or tab
  )
  GROUP BY ext
)
ORDER BY countext DESC
LIMIT 100