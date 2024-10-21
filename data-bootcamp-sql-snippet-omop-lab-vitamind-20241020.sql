/*Vitamin D OMOP code for VA Data Bootcamp - Lab presentation 20241023*/
/*Last updated 20241020 by Vilija Joyce - vilija.joyce@va.gov*/

-- Clear temp tables (if they exist)
drop table if exists #vitd_concepts

-- Pull Vitamin D-related concepts from OMOP LabChemTest_Concept and Concept tables
select 
l.loinc_mapped 
,l.LabChemTestName
,l.concept_id
,c.concept_name,
sum(l.instancecount) as freq
into #vitd_concepts
from cdwwork.omopv5dim.labchemtest_concept l
left outer join cdwwork.omopv5.concept c
on l.concept_id=c.concept_id
where labchemtestname like '%vitamin%d%'
group by l.loinc_mapped, l.LabChemTestName, l.concept_id, c.concept_name
order by freq desc
-- n=893

select * from #vitd_concepts order by freq DESC

-- Clear temp tables (if they exist)
drop table if exists #vitd_concepts2

-- Keep concept of interest
select distinct concept_id, concept_name 
into #vitd_concepts2 
from #vitd_concepts 
where concept_id='3020149'

-- Clear temp tables (if they exist)
drop table if exists #vitd_labs;

-- Pull Vitamin D-related labs from OMOP Measurement table
select 
l.person_id
,l.measurement_datetime
,l.value_as_number
,l.value_source_value
,l.unit_source_value
,l.measurement_concept_id
,l.measurement_source_value
,l.x_source_table
,l.x_source_id_primary
into #vitd_labs
from cdwwork.omopv5.measurement l
inner join #vitd_concepts2 as r1 
on l.measurement_source_concept_id = r1.concept_id
inner join cdwwork.omopv5.person as r2
on l.person_id = r2.person_id
where l.measurement_date>='2024-09-01' and l.measurement_date<='2024-09-24'
-- n=131039

-- Review
select top 1000 * from #vitd_labs


