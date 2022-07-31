SELECT a.id id, size, content, binary, copies, sample_repo_name , sample_path
FROM (
  SELECT id, FIRST(path) sample_path, FIRST(repo_name) sample_repo_name 
  FROM [bigquery-public-data:github_repos.sample_files] 
  WHERE REGEXP_EXTRACT(path, r'\.([^\.]*)$') IN ('java','h','js','c','php','html','cs','json','py','cpp','xml','rb','cc','go')
  GROUP BY id
) a
JOIN [bigquery-public-data:github_repos.contents] b
ON a.id=b.id