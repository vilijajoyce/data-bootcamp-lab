/*COVID-19 OMOP code for VA Data bootcamp lab presentation 20220929*/
/*Last updated 20220923 by Vilija Joyce*/

-- Clear temp tables (if they exist)
drop table if exists #concept


-- Pull COVID-19-related concepts from OMOP LabChemTest_Concept table
select	l.loinc_mapped 
		,l.concept_id
		,c.concept_name,
		sum(l.instancecount) as freq
from 
	cdwwork.omopv5dim.labchemtest_concept l
left outer join 
	cdwwork.omopv5.concept c
on		l.concept_id=c.concept_id
where	labchemtestname like '%covid-19%'
group by 
		l.loinc_mapped, l.concept_id, c.concept_name
order by 
		freq desc

-- n=29

-- Pull COVID-19 antibody lab tests from OMOP Measurement table
select 	person_id
		,measurement_date
		,value_as_number
		,unit_concept_id
		,value_source_value
		,unit_source_value
		,x_labchemtestsid
		,x_source_table
from 	cdwwork.omopv5.measurement
where 	measurement_concept_id in (706177)
		and	measurement_date>=convert(datetime,'2022-06-01') 
		and measurement_date<=convert(datetime,'2022-06-30')
order by
		person_id, measurement_date

-- n=1980