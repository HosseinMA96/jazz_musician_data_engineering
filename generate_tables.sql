SELECT csm1.id_musician, csm2.id_musician, session_year
FROM ernieplus.kirschbaum.curated_session_musician csm1
LEFT JOIN ernieplus.kirschbaum.curated_session_musician csm2 ON csm1.session_code = csm2.session_code left join ernieplus.kirschbaum.curated_sessions cs on
cs.session_code = csm1.session_code where csm1.id_musician  = 1;


CREATE TABLE hm31.curated_session_musician_years AS

SELECT csm1.id_musician, csm2.id_musician, session_year
FROM ernieplus.kirschbaum.curated_session_musician csm1
LEFT JOIN ernieplus.kirschbaum.curated_session_musician csm2 ON csm1.session_code = csm2.session_code left join ernieplus.kirschbaum.curated_sessions cs on
cs.session_code = csm1.session_code where csm1.id_musician <> csm2.id_musician;



select * from hm31.curated_session_musician_years as csmy where csmy.musician_1  = 1 and csmy.musician_2  = 200 ;


CREATE TABLE hm31.aligned_musicians AS
SELECT ID, ID AS musician_id
FROM (
  SELECT DISTINCT musician_1 AS ID
  FROM hm31.curated_session_musician_years csmy
) AS subquery_alias;


select * from hm31.aligned_musicians am limit 100;

select * from hm31.curated_session_musician_years csmy;
select count(*) from hm31.curated_session_musician_years csmy;


select MAX(id_musician) from kirschbaum.curated_musicians cm;

--For any user of interest, with the following queries, we can find the number of sessions they had with any collaborators
--And also we can get those to cross-check with the Neo4j results
select count(*) from hm31.curated_session_musician_years csmy where csmy.musician_1 = 50;
select * from hm31.curated_session_musician_years csmy where csmy.musician_1 = 50 and csmy.musician_2 = 23174;





