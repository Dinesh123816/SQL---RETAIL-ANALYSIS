use healthcare;

alter table healthcare.medications
add constraint fk_diagnoses_diagnosis_id
foreign key (diagnosis_id)
references diagnoses (diagnosis_id)
on delete restrict
on update cascade;


select * from healthcare.appointments;
select * from healthcare.doctors;
select * from healthcare.diagnoses;
select * from healthcare.appointments;
select * from healthcare.medications;
select * from healthcare.patients;
select * from healthcare.diagnoses;
select * from healthcare.appointments;


SET SQL_SAFE_UPDATES = 0;

--  TASK 1 Write a query to fetch details of all completed appointments, including the patient’s name, doctor’s name, and specialization.

select healthcare.patients.patient_id,healthcare.doctors.doctor_id,healthcare.doctors.specialization from healthcare.appointments
inner join healthcare.patients on healthcare.appointments.patient_id=healthcare.patients.patient_id
inner join healthcare.doctors on healthcare.appointments.doctor_id=healthcare.doctors.doctor_id;

--  TASK 2  Retrieve all patients who have never had an appointment. Include their name,contact details, and address in the output.
select healthcare.patients.name,healthcare.patients.address,healthcare.patients.contact_number from healthcare.patients
left join healthcare.appointments on healthcare.appointments.patient_id=healthcare.patients.patient_id 
where healthcare.appointments.appointment_id is null;

-- TASK  3 Find the total number of diagnoses for each doctor, including doctors who haven’t diagnosed any patients. Display the doctor’s name, specialization, and total diagnoses.

select healthcare.doctors.name,healthcare.doctors.specialization,count(healthcare.doctors.doctor_id) as total_diagnoses from healthcare.doctors
right join healthcare.diagnoses on healthcare.doctors.doctor_id=healthcare.diagnoses.diagnosis_id 
group by healthcare.doctors.name,healthcare.doctors.specialization;

-- TASK 4 Write a query to identify mismatches between the appointments and diagnoses tables. Include all appointments and diagnoses with their corresponding patient and doctor details.

SELECT a.appointment_id,a.patient_id AS appt_patient_id, a.doctor_id AS appt_doctor_id,a.appointment_date,a.reason,a.status,
d.diagnosis_id,d.patient_id AS diag_patient_id,d.doctor_id AS diag_doctor_id,d.diagnosis_date,d.diagnosis,d.treatment
FROM healthcare.appointments a LEFT JOIN healthcare.diagnoses d ON a.patient_id = d.patient_id AND a.doctor_id = d.doctor_id;

-- Task For each doctor, rank their patients based on the number of appointments in  descending order.

select doctor_id,patient_id ,count(*)  as total_appoinments,rank() over( partition by doctor_id order by count(*)desc)as patient_rank
from healthcare.appointments 
group by doctor_id,patient_id;

-- Task Write a query to categorize patients by age group (e.g., 18-30, 31-50, 51+). Count the number of patients in each age group.
select case 
when age between 18 and 30 then '18-30'
when age between 31 and 50 then '31-50'
when age >50  then '51+'
else 'below 18' 
end as age_group,count(*) as total_patients 
from healthcare.patients group by age_group;

-- Task Retrieve a list of patients whose contact numbers end with "1234" and display their names in uppercase. 
 select upper(name) as patients_name from healthcare.patients where 
 contact_number like'%1234';
 
-- task Find patients who have only been prescribed "Insulin"  in any of their diagnoses.
 SELECT patient_id FROM diagnoses GROUP BY patient_id HAVING COUNT(DISTINCT diagnosis) = 1 AND MIN(diagnosis) = 'Insulin';
 
 
-- task Calculate the average duration (in days) for which medications are prescribed  for each diagnosis.
SELECT diagnosis_id, AVG(DATEDIFF(diagnosis_date,diagnosis_id)) AS avg_duration_days FROM healthcare.diagnoses GROUP BY diagnosis_id;

-- task query to identify the doctor who has attended the most unique patients.Include the doctor’s name, specialization, and the count of unique patients.  Expected Learning: Combining Joins, Grouping, and COUNT(DISTINCT)

SELECT  d.doctor_id, d.specialization, COUNT(DISTINCT a.patient_id) AS unique_patients FROM doctors d 
JOIN appointments a ON d.doctor_id = a.doctor_id 
GROUP BY  d.doctor_id, d.doctor_id, d.specialization
ORDER BY unique_patients DESC LIMIT 1;



