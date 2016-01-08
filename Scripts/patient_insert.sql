-- WAIT!!!  Read item 0

-- 0 Need the program and program_provider database tables populated
--   with entries for the 'OSCAR' program.  These entries are written
--   the first time that OscarEMR starts up with a new database.
--   1. In oscar/database/mysql run something like this:
--      $ ./createdatabase_bc.sh root <password> oscar15_bc
--   2. Deploy Oscar war and start tomcat7:
--      (Inserts 'OSCAR' program into the program and program_provider database tables)
--      $ sudo service tomcat7 start
--      Verify that the tables have been populated:
--      mysql> select * from program where name='OSCAR';
--      mysql> select * from program_provider;
--   3. Now run this script.
     
-- 1
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
-- Patient Name: John Cleese
-- Description: Complex patient on many cardiac medications
(
 'MR','CLEESE','JOHN','','','BC','','250-000-0001','',
 '',NULL,'1940','09','25','448000001',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','M',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-25 15:50:33','2013-09-25 15:50:33',(select max(demographic_no) from demographic),
'999998','[25-Sep-2013 .: Tel-Progress Notes]',0,0,'','','',(select id from program where name='OSCAR'),'1','0','[25-Sep-2013 .: Tel-Progress Notes]',NULL,'0',0,0,'2da90304-4809-4777-a6d7-c8eb0fcc3698',0,NULL,NULL,NULL,NULL),
('2013-09-25 15:51:23','2013-09-25 15:50:00',(select max(demographic_no) from demographic),
'999998','[25-Sep-2013 .: Tel-Progress Notes]\nBP    130/85 sitting position \nHT    187 in cm \nHR    85 in bpm (nnn) Range:40-180 \nTEMP    37 degrees celcius \nWAIS    92 Waist Circum in cm \nWT    95 in kg',0,0,'','','',(select id from program where name='OSCAR'),'1','0','[25-Sep-2013 .: Tel-Progress Notes]\nBP    130/85 sitting position \nHT    187 in cm \nHR    85 in bpm (nnn) Range:40-180 \nTEMP    37 degrees celcius \nWAIS    92 Waist Circum in cm \nWT    95 in kg\n   ----------------History Record----------------   \n[25-Sep-2013 .: Tel-Progress Notes]\n',NULL,'0',0,0,'2da90304-4809-4777-a6d7-c8eb0fcc3698',0,NULL,NULL,NULL,NULL),
('2013-09-25 15:51:43','2013-09-25 15:50:00',(select max(demographic_no) from demographic),
'999998','[25-Sep-2013 .: Tel-Progress Notes]\nBP    130/85 sitting position \nHT    187 in cm \nHR    85 in bpm (nnn) Range:40-180 \nTEMP    37 degrees celcius \nWAIS    92 Waist Circum in cm \nWT    95 in kg',0,0,'','','',(select id from program where name='OSCAR'),'1','0','[25-Sep-2013 .: Tel-Progress Notes]\nBP    130/85 sitting position \nHT    187 in cm \nHR    85 in bpm (nnn) Range:40-180 \nTEMP    37 degrees celcius \nWAIS    92 Waist Circum in cm \nWT    95 in kg\n   ----------------History Record----------------   \n[25-Sep-2013 .: Tel-Progress Notes]\nBP    130/85 sitting position \nHT    187 in cm \nHR    85 in bpm (nnn) Range:40-180 \nTEMP    37 degrees celcius \nWAIS    92 Waist Circum in cm \nWT    95 in kg\n   ----------------History Record----------------   \n[25-Sep-2013 .: Tel-Progress Notes]\n\n',NULL,'0',0,0,'2da90304-4809-4777-a6d7-c8eb0fcc3698',0,NULL,NULL,NULL,NULL),
('2013-09-26 16:18:23','2013-09-26 16:18:23',(select max(demographic_no) from demographic),
'999998','Situational Crisis',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Situational Crisis',NULL,'0',0,0,'481d5e06-5854-4a04-8ae3-6be35f0b7176',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Start Date','','1990-01-01'),
((select max(note_id) from casemgmt_note),'Resolution Date','','1990-05-31'),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
66,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:18:23');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:19:01','2013-09-26 16:19:01',(select max(demographic_no) from demographic),
'999998','Vitamin D3',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Vitamin D3',NULL,'0',0,2,'604ee129-a4e0-4efc-b508-98c9911cde2f',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Start Date','YYYY','2012-01-01'),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:19:01');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:19:59','2013-09-26 16:19:59',(select max(demographic_no) from demographic),
'999998','Vitamin C',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Vitamin C',NULL,'0',0,1,'bc185582-c00b-4fd8-ad2a-3918e2274110',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Start Date','YYYY','2001-01-01'),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,
`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:20:10','2013-09-26 16:20:10',(select max(demographic_no) from demographic),
'999998','Ginseng Tincture',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Ginseng Tincture',NULL,'0',0,0,'20c8f109-a40b-4e4f-a222-9464d2d2cfff',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Start Date','YYYY','2000-01-01'),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:20:35','2013-09-26 16:20:35',(select max(demographic_no) from demographic),
'999998','Heart Attack',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Heart Attack',NULL,'0',0,0,'de752b1b-9eb5-451d-870b-6e2a59f8d055',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Age at Onset','45',NULL),
((select max(note_id) from casemgmt_note),'Relationship','Father',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
69,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:20:35');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Allergies
INSERT INTO `allergies` (`demographic_no`, `entry_date`, `DESCRIPTION`, `HICL_SEQNO`, `HIC_SEQNO`, `AGCSP`, `AGCCS`, `TYPECODE`, `reaction`, `drugref_id`, `archived`, `start_date`, `age_of_onset`, `severity_of_reaction`, `onset_of_reaction`, `regional_identifier`, `life_stage`, `position`, `lastUpdateDate`, `providerNo`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-26','PENICILLINS, COMBINATIONS WITH OTHER ANTIBACTERIAL',NULL,NULL,NULL,NULL,8,NULL,'43507',0,'1935-01-01',NULL,'4','4',NULL,NULL,0,'2013-03-05 13:30:47',NULL);
-- Clinically Measured Observations
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('BP',(select max(demographic_no) from demographic),
'999998','130/85','sitting position','','2013-09-25 00:00:00','2013-09-25 15:51:13',0),
('HT',(select max(demographic_no) from demographic),
'999998','187','in cm','','2013-09-25 00:00:00','2013-09-25 15:51:13',0),
('HR',(select max(demographic_no) from demographic),
'999998','85','in bpm (nnn) Range:40-180','','2013-09-25 00:00:00','2013-09-25 15:51:13',0),
('TEMP',(select max(demographic_no) from demographic),
'999998','37','degrees celcius','','2013-09-25 00:00:00','2013-09-25 15:51:13',0),
('WAIS',(select max(demographic_no) from demographic),
'999998','92','Waist Circum in cm','','2013-09-25 00:00:00','2013-09-25 15:51:13',0),
('WT',(select max(demographic_no) from demographic),
'999998','95','in kg','','2013-09-25 00:00:00','2013-09-25 15:51:13',0);
-- Labs
INSERT INTO `hl7TextInfo` (`lab_no`, `sex`, `health_no`, `result_status`, `final_result_count`, `obr_date`, `priority`, `requesting_client`, `discipline`, `last_name`, `first_name`, `report_status`, `accessionNum`, `filler_order_num`, `sending_facility`, `label`)
VALUES
((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=(SELECT DATABASE() FROM DUAL) AND TABLE_NAME='hl7TextInfo'),'M','9055555555','A',128,'2013-06-27 12:13:29',NULL,'BOB MDCARE','HAEM1/HAEM3/CHEM4/CHEM29/REFER1','EXCELLERIS','APATIENT','F','13-999955528',NULL,NULL,NULL);
INSERT INTO `patientLabRouting` (`demographic_no`, `lab_no`, `lab_type`,  `created`, `dateModified`)
VALUES
((select max(demographic_no) from demographic),
(select max(lab_no) from hl7TextInfo),
'HL7','0000-00-00 00:00:00',NULL);
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','8.0','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','6690-2'),
((select max(id) from measurements),'name','WBC'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','4.0'),
((select max(id) from measurements),'other_id','0-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','4.71','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','789-8'),
((select max(id) from measurements),'name','RBC'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','tera/L'),
((select max(id) from measurements),'minimum','4.20'),
((select max(id) from measurements),'other_id','0-1');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','158','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','718-7'),
((select max(id) from measurements),'name','Hemoglobin'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','g/L'),
((select max(id) from measurements),'minimum','133'),
((select max(id) from measurements),'other_id','0-2');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','0.46','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','4544-3'),
((select max(id) from measurements),'name','Hematocrit'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'minimum','0.38'),
((select max(id) from measurements),'other_id','0-3');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','99','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','A'),
((select max(id) from measurements),'identifier','787-2'),
((select max(id) from measurements),'name','MCV'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','fl'),
((select max(id) from measurements),'minimum','82'),
((select max(id) from measurements),'other_id','0-4');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','33.5','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','785-6'),
((select max(id) from measurements),'name','MCH'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','pg'),
((select max(id) from measurements),'minimum','27.5'),
((select max(id) from measurements),'other_id','0-5');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','341','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','786-4'),
((select max(id) from measurements),'name','MCHC'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','g/L'),
((select max(id) from measurements),'minimum','305'),
((select max(id) from measurements),'other_id','0-6');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','12.6','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','788-0'),
((select max(id) from measurements),'name','RDW'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','%'),
((select max(id) from measurements),'minimum','11.5'),
((select max(id) from measurements),'other_id','0-7');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','295','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','751-8'),
((select max(id) from measurements),'name','Neutrophils'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','2.0'),
((select max(id) from measurements),'other_id','0-9');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','6.0','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','751-8'),
((select max(id) from measurements),'name','Neutrophils'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','2.0'),
((select max(id) from measurements),'other_id','0-9');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','1.6','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','731-0'),
((select max(id) from measurements),'name','Lymphocytes'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','1.0'),
((select max(id) from measurements),'other_id','0-10');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','0.4','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','742-7'),
((select max(id) from measurements),'name','Monocytes'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','0.1'),
((select max(id) from measurements),'other_id','0-11');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','0.1','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','711-2'),
((select max(id) from measurements),'name','Eosinophils'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','0.0'),
((select max(id) from measurements),'other_id','0-12');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','0.0','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','704-7'),
((select max(id) from measurements),'name','Basophils'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','giga/L'),
((select max(id) from measurements),'minimum','0.0'),
((select max(id) from measurements),'other_id','0-13');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('INR',(select max(demographic_no) from demographic),
'0','1.0','INR Blood Work','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','6301-6'),
((select max(id) from measurements),'name','INR'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'minimum','0.8'),
((select max(id) from measurements),'other_id','1-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','5.2','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','14749-6'),
((select max(id) from measurements),'name','Glucose Random'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mmol/L'),
((select max(id) from measurements),'minimum','3.3'),
((select max(id) from measurements),'other_id','2-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('SCR',(select max(demographic_no) from demographic),
'0','68','in umol/L','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','A'),
((select max(id) from measurements),'identifier','14682-9'),
((select max(id) from measurements),'name','Creatinine'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','umol/L'),
((select max(id) from measurements),'minimum','70'),
((select max(id) from measurements),'other_id','3-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('EGFR',(select max(demographic_no) from demographic),
'0','113','in ml/min','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','33914-3'),
((select max(id) from measurements),'name','Estimated GFR'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mL/min'),
((select max(id) from measurements),'range','>=60');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','317','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','14933-6'),
((select max(id) from measurements),'name','Uric Acid'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','umol/L'),
((select max(id) from measurements),'minimum','234'),
((select max(id) from measurements),'other_id','4-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','45','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','1751-7'),
((select max(id) from measurements),'name','Albumin'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','g/L'),
((select max(id) from measurements),'minimum','35'),
((select max(id) from measurements),'other_id','5-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','16','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','14631-6'),
((select max(id) from measurements),'name','Total Bilirubin'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','umol/L'),
((select max(id) from measurements),'other_id','6-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','5','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','14629-0'),
((select max(id) from measurements),'name','Direct Bilirubin'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','umol/L'),
((select max(id) from measurements),'other_id','6-1');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','74','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','6768-6'),
((select max(id) from measurements),'name','Alkaline Phosphatase'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','U/L'),
((select max(id) from measurements),'minimum','48'),
((select max(id) from measurements),'other_id','7-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','10','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','2324-2'),
((select max(id) from measurements),'name','Gamma GT'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','U/L'),
((select max(id) from measurements),'minimum','10'),
((select max(id) from measurements),'other_id','8-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('ALT',(select max(demographic_no) from demographic),
'0','19','in U/L','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','1742-6'),
((select max(id) from measurements),'name','ALT'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','U/L'),
((select max(id) from measurements),'other_id','9-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','25','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','1920-8'),
((select max(id) from measurements),'name','AST'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','U/L'),
((select max(id) from measurements),'other_id','10-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','1.0','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','2524-7'),
((select max(id) from measurements),'name','Lactic Acid'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mmol/L'),
((select max(id) from measurements),'minimum','0.7'),
((select max(id) from measurements),'other_id','11-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','Slight','','','2013-05-31 10:20:12','2013-09-26 03:56:15',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','A'),
((select max(id) from measurements),'identifier','46425-5'),
((select max(id) from measurements),'name','Lipemia'),
((select max(id) from measurements),'labname','LIFELABS'),
((select max(id) from measurements),'accession','13-999955528'),
((select max(id) from measurements),'request_datetime','2013-05-27 13:40:00'),
((select max(id) from measurements),'datetime','2013-05-31 10:20:12'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'other_id','12-0');
-- Immunizations
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:01:22','2012-09-01 00:00:00','999998',NULL,'Td','0','0',NULL,'0',999998,'2013-09-27 14:01:22');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Left Delt'),
((select max(id) from preventions),'lot','1234'),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:01:44','2009-02-01 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:01:44');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location',''),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route',''),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:02:19','2012-10-31 00:00:00','999998',NULL,'Pneumovax','0','0',NULL,'0',999998,'2013-09-27 14:02:19');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'AVA-RAMIPRIL 5MG',6227,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'AVA-RAMIPRIL 5MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'RAMIPRIL','C09AA05',1,'02363283','MG','Take','PO','TABLET','2013-09-27 12:51:23','5.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'SPIRONOLACTONE 25MG TABLET',63449,NULL,1,1,'QAM','28','D','28',1,NULL,0,0,'SPIRONOLACTONE 25MG TABLET\nTake 1 PO QAM 28 days\nQty:28 Repeats:1',NULL,0,'SPIRONOLACTONE','C03DA01',1,'00613215','MG','Take','PO','TABLET','2013-09-27 12:51:23','25.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2014-01-17','2013-09-27',NULL,'FUROSEMIDE 20MG',6556,NULL,1,1,'QAM','56','D','56',1,NULL,0,0,'FUROSEMIDE 20MG\nTake 1 PO QAM 56 days\nQty:56 Repeats:1',NULL,0,'FUROSEMIDE','C03CA01',1,'02351420','MG','Take','PO','TABLET','2013-09-27 12:51:23','20.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,3,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATORVASTATIN 40MG',5513,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'ATORVASTATIN 40MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'ATORVASTATIN (ATORVASTATIN CALCIUM)','C10AA05',1,'02387913','MG','Take','PO','TABLET','2013-09-27 12:51:23','40.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,4,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-16','2013-09-27',NULL,'TYLENOL EXTRA STRENGTH TAB 500MG',3510,NULL,1,2,'QID','25','D','200',1,NULL,0,1,'TYLENOL EXTRA STRENGTH TAB 500MG\nTake 1-2 PO QID PRN\nQty:200 Repeats:1',NULL,0,'ACETAMINOPHEN','N02BE01',1,'00559407','MG','Take','PO','TABLET','2013-09-27 12:51:23','500.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,5,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ASA 81 MG',2895,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'ASA 81 MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'ACETYLSALICYLIC ACID','B01AC06',1,'02244993','MG','Take','PO','TABLET (ENTERIC-COATED)','2013-09-27 12:51:23','81.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,6,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'CARVEDILOL 12.5MG',6149,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'CARVEDILOL 12.5MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'CARVEDILOL','C07AG02',1,'02364948','MG','Take','PO','TABLET','2013-09-27 12:51:23','12.5 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,7,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'IBUPROFEN TAB 400MG',4367,NULL,1,1,'TID','28','D','84',1,NULL,0,1,'IBUPROFEN TAB 400MG\nTake 1 PO TID PRN\nQty:84 Repeats:1',NULL,0,'IBUPROFEN','M01AE01',1,'00636533','MG','Take','PO','TABLET','2013-09-27 12:51:23','400.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,8,NULL,0,'2013-09-27 12:51:23',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-06','2013-09-27',NULL,'ATIVAN 1MG',1512,NULL,1,1,'BID','20','D','40',1,NULL,0,1,'ATIVAN 1MG\nTake 1 SL BID PRN\nQty:40 Repeats:1',NULL,0,'LORAZEPAM','N05BA06',1,'02041421','MG','Take','SL','TABLET','2013-09-27 12:51:23','1.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,9,NULL,0,'2013-09-27 12:51:23',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','428','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','401','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','250','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','491','icd9',0,NULL);

-- 2
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Mark Ive
-- Description: Now has renal failure
(
 'MR','IVE','MARK','','','BC','','250-000-0002','',
 '',NULL,'1944','01','28','448000002',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','M',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 15:29:31','2013-09-26 15:29:31',(select max(demographic_no) from demographic),
'999998','[26-Sep-2013 .: Tel-Progress Notes] \n\nBP    140/90 sitting position',0,0,'','','',(select id from program where name='OSCAR'),'1','0','[26-Sep-2013 .: Tel-Progress Notes] \n\nBP    140/90 sitting position',NULL,'0',0,0,'7b259e6b-9123-405a-90a0-be4cedff9934',0,NULL,NULL,NULL,NULL),
('2013-09-26 16:21:41','2013-09-26 16:21:41',(select max(demographic_no) from demographic),
'999998','Heart Attack at 50',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Heart Attack at 50',NULL,'0',0,0,'01989864-5c5e-4b3b-aa43-bf510ffbbb52',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Start Date','','1905-06-16'),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
66,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:21:41');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:21:55','2013-09-26 16:21:55',(select max(demographic_no) from demographic),
'999998','Vitamin D3',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Vitamin D3',NULL,'0',0,0,'8b3aebfe-653d-4994-a245-6f501d96739e',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Start Date','YYYY','2005-01-01'),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:21:55');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:22:12','2013-09-26 16:22:12',(select max(demographic_no) from demographic),
'999998','Adopted - Unknown',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Adopted - Unknown',NULL,'0',0,0,'1a40d7d6-edb5-44f1-805a-fba05d520b31',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
69,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:22:12');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Allergies
INSERT INTO `allergies` (`demographic_no`, `entry_date`, `DESCRIPTION`, `HICL_SEQNO`, `HIC_SEQNO`, `AGCSP`, `AGCCS`, `TYPECODE`, `reaction`, `drugref_id`, `archived`, `start_date`, `age_of_onset`, `severity_of_reaction`, `onset_of_reaction`, `regional_identifier`, `life_stage`, `position`, `lastUpdateDate`, `providerNo`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-26','SULFADIAZINE',NULL,NULL,NULL,NULL,8,'Hives','43750',0,'1970-01-01',NULL,'2','2',NULL,NULL,0,'2013-03-05 14:27:08',NULL);
-- Clinically Measured Observations
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('BP',(select max(demographic_no) from demographic),
'999998','140/90','sitting position','','2013-09-26 00:00:00','2013-09-26 15:29:26',0);
-- Labs
INSERT INTO `hl7TextInfo` (`lab_no`, `sex`, `health_no`, `result_status`, `final_result_count`, `obr_date`, `priority`, `requesting_client`, `discipline`, `last_name`, `first_name`, `report_status`, `accessionNum`, `filler_order_num`, `sending_facility`, `label`)
VALUES
((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=(SELECT DATABASE() FROM DUAL) AND TABLE_NAME='hl7TextInfo'),'M','448000002','A',102,'2013-06-07 14:17:47',NULL,'BOB MDCARE','CHEM2','IVE','MARK','F','11-222075056',NULL,NULL,NULL);
INSERT INTO `patientLabRouting` (`demographic_no`, `lab_no`, `lab_type`,  `created`, `dateModified`)
VALUES
((select max(demographic_no) from demographic),
(select max(lab_no) from hl7TextInfo),
'HL7','0000-00-00 00:00:00',NULL);
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','161.2','','','2013-06-07 11:20:00','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements), 'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements), 'abnormal','A'),
((select max(id) from measurements), 'identifier','45066-8'),
((select max(id) from measurements), 'name','Creatinine'),
((select max(id) from measurements), 'labname','UVIC'),
((select max(id) from measurements), 'accession','11-222075056'),
((select max(id) from measurements), 'request_datetime','2013-06-07 10:44:00'),
((select max(id) from measurements), 'datetime','2013-06-07 11:20:00'),
((select max(id) from measurements), 'olis_status','F'),
((select max(id) from measurements), 'unit','umol/L'),
((select max(id) from measurements), 'other_id','0-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('EGFR',(select max(demographic_no) from demographic),
'0','113','in ml/min','','2013-06-07 11:20:00','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements), 'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements), 'abnormal','N'),
((select max(id) from measurements), 'identifier','33914-3'),
((select max(id) from measurements), 'name','Estimated GFR'),
((select max(id) from measurements), 'labname','UVIC'),
((select max(id) from measurements), 'accession','11-222075056'),
((select max(id) from measurements), 'request_datetime','2013-06-07 10:44:00'),
((select max(id) from measurements), 'datetime','2013-06-07 11:20:00'),
((select max(id) from measurements), 'olis_status','F'),
((select max(id) from measurements), 'unit','mL/min'),
((select max(id) from measurements), 'range','>=60');
-- Immunizations
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:03:52','2012-11-03 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:03:52');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','rt delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','im'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'AVA-RAMIPRIL 5MG',6227,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'AVA-RAMIPRIL 5MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'RAMIPRIL','C09AA05',2,'02363283','MG','Take','PO','TABLET','2013-09-27 12:57:32','5.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'SPIRONOLACTONE 25MG TABLET',63449,NULL,1,1,'QAM','28','D','28',1,NULL,0,0,'SPIRONOLACTONE 25MG TABLET\nTake 1 PO QAM 28 days\nQty:28 Repeats:1',NULL,0,'SPIRONOLACTONE','C03DA01',2,'00613215','MG','Take','PO','TABLET','2013-09-27 12:57:32','25.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2014-01-17','2013-09-27',NULL,'FUROSEMIDE 20MG',6556,NULL,1,1,'QAM','56','D','56',1,NULL,0,0,'FUROSEMIDE 20MG\nTake 1 PO QAM 56 days\nQty:56 Repeats:1',NULL,0,'FUROSEMIDE','C03CA01',2,'02351420','MG','Take','PO','TABLET','2013-09-27 12:57:32','20.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,3,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATORVASTATIN 40MG',5513,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'ATORVASTATIN 40MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'ATORVASTATIN (ATORVASTATIN CALCIUM)','C10AA05',2,'02387913','MG','Take','PO','TABLET','2013-09-27 12:57:32','40.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,4,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-16','2013-09-27',NULL,'TYLENOL EXTRA STRENGTH TAB 500MG',3510,NULL,1,2,'QID','25','D','200',1,NULL,0,1,'TYLENOL EXTRA STRENGTH TAB 500MG\nTake 1-2 PO QID PRN\nQty:200 Repeats:1',NULL,0,'ACETAMINOPHEN','N02BE01',2,'00559407','MG','Take','PO','TABLET','2013-09-27 12:57:32','500.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,5,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ASA 81 MG',2895,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'ASA 81 MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'ACETYLSALICYLIC ACID','B01AC06',2,'02244993','MG','Take','PO','TABLET (ENTERIC-COATED)','2013-09-27 12:57:32','81.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,6,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-06','2013-09-27',NULL,'ATIVAN 1MG',1512,NULL,1,1,'BID','20','D','40',1,NULL,0,1,'ATIVAN 1MG\nTake 1 SL BID PRN\nQty:40 Repeats:1',NULL,0,'LORAZEPAM','N05BA06',2,'02041421','MG','Take','SL','TABLET','2013-09-27 12:57:32','1.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,7,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'CARVEDILOL 12.5MG',6149,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'CARVEDILOL 12.5MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'CARVEDILOL','C07AG02',2,'02364948','MG','Take','PO','TABLET','2013-09-27 12:57:32','12.5 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,8,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'IBUPROFEN TAB 400MG',4367,NULL,1,1,'TID','28','D','84',1,NULL,0,1,'IBUPROFEN TAB 400MG\nTake 1 PO TID PRN\nQty:84 Repeats:1',NULL,0,'IBUPROFEN','M01AE01',2,'00636533','MG','Take','PO','TABLET','2013-09-27 12:57:32','400.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,9,NULL,0,'2013-09-27 12:57:32',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-10-25','2013-09-27',NULL,'PMS-DIGOXIN 0.25MG',9031,NULL,1,1,'OD','28','D','28',0,NULL,0,0,'PMS-DIGOXIN 0.25MG\nTake 1 PO OD 28 days\nQty:28 Repeats:0',NULL,0,'DIGOXIN','C01AA05',2,'02245428','MG','Take','PO','TABLET','2013-09-27 12:57:32','0.25 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,10,NULL,0,'2013-09-27 12:57:32',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','250','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','434','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','401','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','3000','icd9',0,NULL);

-- 3
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Joan Charles
-- Description:
(
 'MRS','CHARLES','JOAN','','','BC','','250-000-0003','',
 '',NULL,'1955','08','29','448000003',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','F',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:22:55','2013-09-26 16:22:55',(select max(demographic_no) from demographic),
'999998','Calcium and Magnesium',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Calcium and Magnesium',NULL,'0',0,2,'3df5c268-3266-47d2-bd8b-f244371abec9',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:22:55');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:23:02','2013-09-26 16:23:02',(select max(demographic_no) from demographic),
'999998','Vit D3',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Vit D3',NULL,'0',0,1,'b1a4f905-4b4d-4f8e-86e0-19e648ef6714',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:23:12','2013-09-26 16:23:12',(select max(demographic_no) from demographic),
'999998','Fish oil - omegas',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Fish oil - omegas',NULL,'0',0,0,'d3122d00-aaa9-496c-b3ed-22b31ccffbf1',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:23:38','2013-09-26 16:23:38',(select max(demographic_no) from demographic),
'999998','Rheumatoid Arthritis',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Rheumatoid Arthritis',NULL,'0',0,1,'a664fadf-20b0-47bb-993e-64bdbc180c77',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Age at Onset','25',NULL),
((select max(note_id) from casemgmt_note),'Relationship','Mother',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
69,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:23:38');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:23:54','2013-09-26 16:23:54',(select max(demographic_no) from demographic),
'999998','Rheumatoid Arthritis',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Rheumatoid Arthritis',NULL,'0',0,0,'a6ba3708-ffd9-4160-8f03-561f12555db6',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Age at Onset','22',NULL),
((select max(note_id) from casemgmt_note),'Relationship','Sister',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Labs
INSERT INTO `hl7TextInfo` (`lab_no`, `sex`, `health_no`, `result_status`, `final_result_count`, `obr_date`, `priority`, `requesting_client`, `discipline`, `last_name`, `first_name`, `report_status`, `accessionNum`, `filler_order_num`, `sending_facility`, `label`)
VALUES
((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=(SELECT DATABASE() FROM DUAL) AND TABLE_NAME='hl7TextInfo'),'F','448000003','A',104,'2013-06-20 13:24:44',NULL,'BOB MDCARE','HAEM1','CHARLES','JOAN','F','11-222075059',NULL,NULL,NULL);
-- 25 labno=27
INSERT INTO `patientLabRouting` (`demographic_no`, `lab_no`, `lab_type`,  `created`, `dateModified`)
VALUES
((select max(demographic_no) from demographic),
(select max(lab_no) from hl7TextInfo),
'HL7','0000-00-00 00:00:00',NULL);
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','4.9','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','14771-0'),
((select max(id) from measurements),'name','Glucose Fasting'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075059'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mmol/L'),
((select max(id) from measurements),'minimum','3.6'),
((select max(id) from measurements),'other_id','0-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','35','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','58453-2'),
((select max(id) from measurements),'name','Occult Blood Immunochemical'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075059'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','ng/mL'),
((select max(id) from measurements),'other_id','0-1');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('A1C',(select max(demographic_no) from demographic),
'0','6.4','Range:0.040-0.200','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','A'),
((select max(id) from measurements),'identifier','4548-4'),
((select max(id) from measurements),'name','Hemoglobin A1c'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075059'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','%'),
((select max(id) from measurements),'minimum','4.8'),
((select max(id) from measurements),'other_id','0-2');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','2.4','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','39469-2'),
((select max(id) from measurements),'name','LDL Cholesterol'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075059'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mmol/L'),
((select max(id) from measurements),'other_id','0-3');
-- Immunizatons
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:04:43','2003-02-01 00:00:00','999998',NULL,'Pneumovax','0','0',NULL,'0',999998,'2013-09-27 14:04:43');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location',''),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route',''),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:05:04','2012-10-31 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:05:04');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:05:21','2011-11-10 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:05:21');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:05:43','2010-10-29 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:05:43');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Left Deltoid'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'AVA-RAMIPRIL 5MG',6227,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'AVA-RAMIPRIL 5MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'RAMIPRIL','C09AA05',3,'02363283','MG','Take','PO','TABLET','2013-09-27 13:34:03','5.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:34:03',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'SPIRONOLACTONE 25MG TABLET',63449,NULL,1,1,'QAM','28','D','28',1,NULL,0,0,'SPIRONOLACTONE 25MG TABLET\nTake 1 PO QAM 28 days\nQty:28 Repeats:1',NULL,0,'SPIRONOLACTONE','C03DA01',3,'00613215','MG','Take','PO','TABLET','2013-09-27 13:34:03','25.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 13:34:03',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2014-01-17','2013-09-27',NULL,'FUROSEMIDE 20MG',6556,NULL,1,1,'QAM','56','D','56',1,NULL,0,0,'FUROSEMIDE 20MG\nTake 1 PO QAM 56 days\nQty:56 Repeats:1',NULL,0,'FUROSEMIDE','C03CA01',3,'02351420','MG','Take','PO','TABLET','2013-09-27 13:34:03','20.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,3,NULL,0,'2013-09-27 13:34:03',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATORVASTATIN 40MG',5513,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'ATORVASTATIN 40MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'ATORVASTATIN (ATORVASTATIN CALCIUM)','C10AA05',3,'02387913','MG','Take','PO','TABLET','2013-09-27 13:34:03','40.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,4,NULL,0,'2013-09-27 13:34:03',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-16','2013-09-27',NULL,'TYLENOL EXTRA STRENGTH TAB 500MG',3510,NULL,1,2,'QID','25','D','200',1,NULL,0,1,'TYLENOL EXTRA STRENGTH TAB 500MG\nTake 1-2 PO QID PRN\nQty:200 Repeats:1',NULL,0,'ACETAMINOPHEN','N02BE01',3,'00559407','MG','Take','PO','TABLET','2013-09-27 13:34:03','500.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,5,NULL,0,'2013-09-27 13:34:03',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ASA 81 MG',2895,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'ASA 81 MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'ACETYLSALICYLIC ACID','B01AC06',3,'02244993','MG','Take','PO','TABLET (ENTERIC-COATED)','2013-09-27 13:34:03','81.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,6,NULL,0,'2013-09-27 13:34:03',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'CARVEDILOL 12.5MG',6149,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'CARVEDILOL 12.5MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'CARVEDILOL','C07AG02',3,'02364948','MG','Take','PO','TABLET','2013-09-27 13:34:03','12.5 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,7,NULL,0,'2013-09-27 13:34:03',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','401','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','250','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','412','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','733','icd9',0,NULL);

-- 4
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Chuck Smith
-- Description: Healthy and active - has some OA but otherwise in great shape.
(
 'MR','SMITH','CHUCK','','','BC','','250-000-0004','',
 '',NULL,'1936','05','27','448000004',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','M',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,
`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:24:15','2013-09-26 16:24:15',(select max(demographic_no) from demographic),
'999998','Multivitamin',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Multivitamin',NULL,'0',0,1,'30881479-3941-41ba-91d6-ad541c763ae6',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:24:15');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:24:37','2013-09-26 16:24:37',(select max(demographic_no) from demographic),
'999998','Shark cartiledge',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Shark cartiledge',NULL,'0',0,0,'0453e23d-d1a0-428b-80b8-61402439a54f',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Immunizations
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:06:37','2012-10-25 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:06:37');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:07:06','2011-11-13 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:07:06');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:07:23','2005-10-29 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:07:23');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Left Deltoid'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','7153','icd9',0,NULL);

-- 5
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Dale Chan
-- Description: 40 yo healthy woman on thyroid replacement. 
--              Active. Has allergies to peanuts and other nuts
(
 'MRS','CHAN','DALE','','','BC','','250-000-0005','',
 '',NULL,'1973','01','29','448000005',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','F',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:25:08','2013-09-26 16:25:08',(select max(demographic_no) from demographic),
'999998','Vit D',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Vit D',NULL,'0',0,1,'0a49d7e2-82b6-4e93-8627-933acfc81cd3',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:25:08');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:25:17','2013-09-26 16:25:17',(select max(demographic_no) from demographic),
'999998','Ibuprofen as needed',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Ibuprofen as needed',NULL,'0',0,0,'09431dbb-7860-4438-a00d-7e728c02042f',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Alergies
INSERT INTO `allergies` (`demographic_no`, `entry_date`, `DESCRIPTION`, `HICL_SEQNO`, `HIC_SEQNO`, `AGCSP`, `AGCCS`, `TYPECODE`, `reaction`, `drugref_id`, `archived`, `start_date`, `age_of_onset`, `severity_of_reaction`, `onset_of_reaction`, `regional_identifier`, `life_stage`, `position`, `lastUpdateDate`, `providerNo`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-26','PEANUT OIL',NULL,NULL,NULL,NULL,11,'anaphylaxis','45043',0,NULL,'8','3','4',NULL,NULL,0,'2013-03-05 14:55:45',NULL);
-- Labs
INSERT INTO `hl7TextInfo` (`lab_no`, `sex`, `health_no`, `result_status`, `final_result_count`, `obr_date`, `priority`, `requesting_client`, `discipline`, `last_name`, `first_name`, `report_status`, `accessionNum`, `filler_order_num`, `sending_facility`, `label`)
VALUES
((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=(SELECT DATABASE() FROM DUAL) AND TABLE_NAME='hl7TextInfo'),'F','448000005',NULL,101,'2013-06-07 14:17:47',NULL,'BOB MDCARE','CHEM2','CHAN','DALE','F','11-222075057',NULL,NULL,NULL);
INSERT INTO `patientLabRouting` (`demographic_no`, `lab_no`, `lab_type`,  `created`, `dateModified`)
VALUES
((select max(demographic_no) from demographic),
(select max(lab_no) from hl7TextInfo),
'HL7','0000-00-00 00:00:00',NULL);
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','131.6','','','2013-06-07 11:20:00','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements), 'abnormal','N'),
((select max(id) from measurements), 'identifier','45066-8'),
((select max(id) from measurements), 'name','Creatinine'),
((select max(id) from measurements), 'labname','UVIC'),
((select max(id) from measurements), 'accession','11-222075057'),
((select max(id) from measurements), 'request_datetime','2013-06-07 10:44:00'),
((select max(id) from measurements), 'datetime','2013-06-07 11:20:00'),
((select max(id) from measurements), 'olis_status','F'),
((select max(id) from measurements), 'unit','umol/L'),
((select max(id) from measurements), 'other_id','0-0');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2014-01-17','2013-09-27',NULL,'SYNTHROID - TAB 100MCG',11481,NULL,1,1,'OD','112','D','112',0,NULL,0,0,'SYNTHROID - TAB 100MCG\nTake 1 PO OD 112 d\nQty:112 Repeats:0',NULL,0,'LEVOTHYROXINE SODIUM','H03AA01',4,'02172100','µG','Take','PO','TABLET','2013-09-27 13:41:22','100.0 µG',0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:41:22',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-09-27','2013-09-27',NULL,'EPIPEN 0.3MG/0.3ML AUTO-INJECTOR',3403,NULL,1,1,NULL,'0',NULL,'1',3,NULL,0,1,'EPIPEN 0.3MG/0.3ML AUTO-INJECTOR\nTake 1 IM once prn\nQty:1 Repeats:3',NULL,0,'EPINEPHRINE','C01CA24',4,'00509558','MG','Take','IM','SOLUTION','2013-09-27 13:41:22','1.0 MG',0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 13:41:22',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','244','icd9',0,NULL);

-- 6
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Harry Jones
-- Description: 93+ year old gentleman
(
 'MR','JONES','HARRY','','','BC','','250-000-0006',
 '','',NULL,'1919','07','30','448000006',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','M',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');

-- Immunizations
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:09:15','2012-10-25 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:09:15');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'FLUOXETINE 20MG',6937,NULL,1,1,'OD','28','D','28',1,NULL,0,0,'FLUOXETINE 20MG\nTake 1 PO OD 28 days\nQty:28 Repeats:1',NULL,0,'FLUOXETINE (FLUOXETINE HYDROCHLORIDE)','N06AB03',5,'02344157','MG','Take','PO','CAPSULE','2013-09-27 13:48:24','20.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'MS CONTIN SRT 100MG',4839,NULL,1,1,'Q12H','28','D','28',1,NULL,0,0,'MS CONTIN SRT 100MG\nTake 1 PO Q12H 28 days\nQty:28 Repeats:1',NULL,0,'MORPHINE SULFATE','N02AA01',5,'02014319','MG','Take','PO','TABLET (EXTENDED-RELEASE)','2013-09-27 13:48:24','100.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-10-29','2013-09-27',NULL,'MS IR TAB 5MG',4818,NULL,1,2,'Q4h','16','D','200',1,NULL,0,1,'MS IR TAB 5MG\nTake 1-2 PO Q4h prn\nQty:200 Repeats:1',NULL,0,'MORPHINE SULFATE','N02AA01',5,'02014203','MG','Take','PO','TABLET','2013-09-27 13:48:24','5.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,3,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATORVASTATIN 40MG',5513,NULL,1,1,'QHS','28','D','28',1,NULL,0,0,'ATORVASTATIN 40MG\nTake 1 PO QHS 28 days\nQty:28 Repeats:1',NULL,0,'ATORVASTATIN (ATORVASTATIN CALCIUM)','C10AA05',5,'02387913','MG','Take','PO','TABLET','2013-09-27 13:48:24','40.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,4,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-16','2013-09-27',NULL,'TYLENOL EXTRA STRENGTH TAB 500MG',3510,NULL,1,2,'Q6H','25','D','200',1,NULL,0,1,'TYLENOL EXTRA STRENGTH TAB 500MG\nTake 1-2 PO Q6H prn\nQty:200 Repeats:1',NULL,0,'ACETAMINOPHEN','N02BE01',5,'00559407','MG','Take','PO','TABLET','2013-09-27 13:48:24','500.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,5,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ASA 81 MG',2895,NULL,1,1,'QAM','28','D','28',1,NULL,0,0,'ASA 81 MG\nTake 1 PO QAM 28 days\nQty:28 Repeats:1',NULL,0,'ACETYLSALICYLIC ACID','B01AC06',5,'02244993','MG','Take','PO','TABLET (ENTERIC-COATED)','2013-09-27 13:48:24','81.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,6,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'VENTOLIN HFA 100?G',9667,NULL,1,2,'BID','4','W','112',1,NULL,0,1,'VENTOLIN HFA 100?G\nTake 1-2 INH BID qam prn 4 w\nQty:112 Repeats:1',NULL,0,'SALBUTAMOL (SALBUTAMOL SULFATE)','R03AC02',5,'02241497','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:48:24','100.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,7,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'QVAR 100?G',9783,NULL,2,2,'BID','4','W','112',1,NULL,0,0,'QVAR 100?G\nTake 2 INH BID 4 w\nQty:112 Repeats:1',NULL,0,'BECLOMETHASONE DIPROPIONATE','R03BA01',5,'02242030','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:48:24','100.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,8,NULL,0,'2013-09-27 13:48:24',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATROVENT HFA 20?G',9338,NULL,1,1,'TID','4','W','84',1,NULL,0,0,'ATROVENT HFA 20?G\nTake 1 INH TID 4 w\nQty:84 Repeats:1',NULL,0,'IPRATROPIUM BROMIDE','R03BB01',5,'02247686','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:48:24','20.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,9,NULL,0,'2013-09-27 13:48:24',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','492','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','8054','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','272','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','410','icd9',0,NULL);

-- 7
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Mary Jones
-- Description: Relatively healthy smoker with mild COPD
--              and previous depression.
(
 'MRS','JONES','MARY','','','BC','','250-000-0007',
 '','',NULL,'1923','10','16','448000007',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','F',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:25:59','2013-09-26 16:25:59',(select max(demographic_no) from demographic),
'999998','Post partum depression',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Post partum depression',NULL,'0',0,0,'f9cbd0d6-15b7-4a2d-90d3-1267e151cdae',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
66,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:25:59');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:26:10','2013-09-26 16:26:10',(select max(demographic_no) from demographic),
'999998','Multivit',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Multivit',NULL,'0',0,0,'7efdc6bc-20f8-4e63-b644-5495f7c6655e',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:26:10');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:26:28','2013-09-26 16:26:28',(select max(demographic_no) from demographic),
'999998','Depression',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Depression',NULL,'0',0,2,'1a6c9cc9-0071-422d-a7e5-d0b401045238',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Age at Onset','30',NULL),
((select max(note_id) from casemgmt_note),'Relationship','Mother',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
69,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:26:28');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:26:40','2013-09-26 16:26:40',(select max(demographic_no) from demographic),
'999998','Alcohol Abuse',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Alcohol Abuse',NULL,'0',0,1,'31f748e0-6e7e-4425-a80b-d6c8e2835a0d',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Relationship','Father',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,
`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:26:58','2013-09-26 16:26:58',(select max(demographic_no) from demographic),
'999998','Alcohol Abuse',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','Alcohol Abuse',NULL,'0',0,0,'6884becd-5299-43cd-9624-004cdaa0ca4b',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Age at Onset','21',NULL),
((select max(note_id) from casemgmt_note),'Relationship','Sister',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Immunizations
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:10:16','2012-10-25 00:00:00','999998',NULL,'Flu','0','0',NULL,'0',999998,'2013-09-27 14:10:16');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location','Right Delt'),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route','IM'),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'VENTOLIN HFA 100?G',9667,NULL,2,2,'BID','4','W','112',1,NULL,0,1,'VENTOLIN HFA 100?G\nTake 2 INH BID prn 4 w\nQty:112 Repeats:1',NULL,0,'SALBUTAMOL (SALBUTAMOL SULFATE)','R03AC02',6,'02241497','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:50:27','100.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:50:27',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATROVENT HFA 20?G',9338,NULL,2,2,'TID','4','W','168',1,NULL,0,0,'ATROVENT HFA 20?G\nTake 2 INH TID 4 w\nQty:168 Repeats:1',NULL,0,'IPRATROPIUM BROMIDE','R03BB01',6,'02247686','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:50:28','20.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 13:50:28',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','492','icd9',0,NULL);

-- 8
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Jill Thomas
-- Description: Elderly gardener, still volunteering to teach.
--              Some anxiety has been a long standing user of benzos.
--              Will not stop.
--              Now has renal failure
(
 'MS','THOMAS','JILL','','','BC','','250-000-0008',
 '','',NULL,'1924','04','28','448000008',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','F',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:27:21','2013-09-26 16:27:21',(select max(demographic_no) from demographic),
'999998','tiger balm on hands',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','tiger balm on hands',NULL,'0',0,0,'48866956-bf72-46e8-8278-789ec427d3ac',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
64,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:27:21');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:27:38','2013-09-26 16:27:38',(select max(demographic_no) from demographic),
'999998','anxiety',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','anxiety',NULL,'0',0,1,'36653951-a6ab-4ed3-a240-5c4c12164429',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Relationship','dad',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue` (`demographic_no`, `issue_id`, `acute`, `certain`, `major`, `resolved`, `program_id`, `type`, `update_date`)
VALUES
((select max(demographic_no) from demographic),
69,0,0,0,0,(select id from program where name='OSCAR'),'nurse','2013-09-26 16:27:38');
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 16:27:47','2013-09-26 16:27:47',(select max(demographic_no) from demographic),
'999998','anxiety',1,1,'999998','','',(select id from program where name='OSCAR'),'1','0','anxiety',NULL,'0',0,0,'e8171c10-f697-4d9d-aa42-f457a7829f30',0,NULL,NULL,NULL,NULL);
INSERT INTO `casemgmt_note_ext` (`note_id`, `key_val`, `value`, `date_value`)
VALUES
((select max(note_id) from casemgmt_note),'Relationship','sister',NULL),
((select max(note_id) from casemgmt_note),'Hide Cpp','0',NULL);
-- Alerts, Family History, Risk Factors
INSERT INTO `casemgmt_issue_notes` (`id`, `note_id`)
VALUES
((select max(id) from casemgmt_issue),(select max(note_id) from casemgmt_note));
-- Labs
INSERT INTO `hl7TextInfo` (`lab_no`, `sex`, `health_no`, `result_status`, `final_result_count`, `obr_date`, `priority`, `requesting_client`, `discipline`, `last_name`, `first_name`, `report_status`, `accessionNum`, `filler_order_num`, `sending_facility`, `label`)
VALUES
((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=(SELECT DATABASE() FROM DUAL) AND TABLE_NAME='hl7TextInfo'),'F','448000008','A',101,'2013-06-07 14:17:47',NULL,'BOB MDCARE','CHEM2','THOMAS','JILL','F','11-222075058',NULL,NULL,NULL);
INSERT INTO `patientLabRouting` (`demographic_no`, `lab_no`, `lab_type`,  `created`, `dateModified`)
VALUES
((select max(demographic_no) from demographic),
(select max(lab_no) from hl7TextInfo),
'HL7','0000-00-00 00:00:00',NULL);
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','158.4','','','2013-06-07 11:20:00','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','A'),
((select max(id) from measurements),'identifier','45066-8'),
((select max(id) from measurements),'name','Creatinine'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075058'),
((select max(id) from measurements),'request_datetime','2013-06-07 10:44:00'),
((select max(id) from measurements),'datetime','2013-06-07 11:20:00'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','umol/L'),
((select max(id) from measurements),'other_id','0-0');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2014-03-14','2013-09-27',NULL,'SYNTHROID - TAB 112MCG',11493,NULL,1,1,'OD','56','D','56',2,NULL,0,0,'SYNTHROID - TAB 112MCG\nTake 1 PO OD 56 d\nQty:56 Repeats:2',NULL,0,'LEVOTHYROXINE SODIUM','H03AA01',7,'02171228','µG','Take','PO','TABLET','2013-09-27 13:52:37','112.0 µG',0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:52:37',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2014-03-14','2013-09-27',NULL,'VALIUM 5 TAB',1544,NULL,2,2,'QHS','56','D','112',2,NULL,0,0,'VALIUM 5 TAB\nTake 2 PO QHS 56 d\nQty:112 Repeats:2',NULL,0,'DIAZEPAM','N05BA01',7,'00013285','MG','Take','PO','TABLET','2013-09-27 13:52:37','5.0 MG',0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 13:52:37',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-10-25','2013-09-27',NULL,'PMS-DIGOXIN 0.25MG',9031,NULL,1,1,'OD','28','D','28',0,NULL,0,0,'PMS-DIGOXIN 0.25MG\nTake 1 PO OD 28 days\nQty:28 Repeats:0',NULL,0,'DIGOXIN','C01AA05',7,'02245428','MG','Take','PO','TABLET','2013-09-27 13:52:37','0.25 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,3,NULL,0,'2013-09-27 13:52:37',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','244','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','3000','icd9',0,NULL);

-- 9
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Elizabeth Sinclair
-- Description: Smoker without COPD on the problem list (but on COPD meds)
(
 'MS','SINCLAIR','ELIZABETH','','','BC','','250-000-0009',
 '','',NULL,'1943','04','28','448000009',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','F',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'VENTOLIN HFA 100?G',9667,NULL,1,2,'BID','4','W','112',1,NULL,0,1,'VENTOLIN HFA 100?G\nTake 1-2 INH BID prn 4 w\nQty:112 Repeats:1',NULL,0,'SALBUTAMOL (SALBUTAMOL SULFATE)','R03AC02',8,'02241497','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:55:26','100.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:55:26',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'QVAR 100?G',9783,NULL,2,2,'BID','4','W','112',1,NULL,0,0,'QVAR 100?G\nTake 2 INH BID 4 w\nQty:112 Repeats:1',NULL,0,'BECLOMETHASONE DIPROPIONATE','R03BA01',8,'02242030','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:55:26','100.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,2,NULL,0,'2013-09-27 13:55:26',0),
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-11-22','2013-09-27',NULL,'ATROVENT HFA 20?G',9338,NULL,1,1,'TID','4','W','84',1,NULL,0,0,'ATROVENT HFA 20?G\nTake 1 INH TID 4 w\nQty:84 Repeats:1',NULL,0,'IPRATROPIUM BROMIDE','R03BB01',8,'02247686','µG','Take','INH','METERED-DOSE AEROSOL','2013-09-27 13:55:26','20.0 µG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,3,NULL,0,'2013-09-27 13:55:26',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','3051','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','303','icd9',0,NULL);

-- 10
INSERT INTO `demographic`
(
 title, last_name, first_name, address, city, province, postal, phone, phone2,
 email, myOscarUserName, year_of_birth, month_of_birth, date_of_birth, hin,
 ver, roster_status, roster_date, roster_termination_date,
 roster_termination_reason, patient_status, patient_status_date, date_joined,
 chart_no, official_lang, spoken_lang, provider_no, sex, end_date, eff_date,
 pcn_indicator, hc_type, hc_renew_date, family_doctor, alias, previousAddress,
 children, sourceOfIncome, citizenship, sin, country_of_origin, newsletter,
 anonymous, lastUpdateUser, lastUpdateDate
)
VALUES
--
-- Patient Name: Mary Sugar
-- Description: Diabetic w/ Renal Failure
(
 'MS','SUGAR','MARY','','','BC','','250-000-0010',
 '','',NULL,'1950','02','14','448000010',
 '','',NULL,NULL,
 '','AC','2013-09-25','2013-09-25',
 '','English','','999998','F',NULL,NULL,
 NULL,'BC',NULL,'<rdohip></rdohip><rd></rd>',NULL,NULL,
 NULL,NULL,NULL,'','-1','Unknown',
 NULL,'999998','2013-09-26 00:00:00'
);
-- Admission
INSERT INTO `admission` (`client_id`, `program_id`, `provider_no`, `admission_date`, `admission_from_transfer`, `admission_notes`, `temp_admission`, `discharge_date`, `discharge_from_transfer`, `discharge_notes`, `temp_admit_discharge`, `admission_status`, `team_id`, `temporary_admission_flag`, `radioDischargeReason`, `clientstatus_id`, `automatic_discharge`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
(select id from program where name='OSCAR'),'999998','2013-09-26 00:00:00',0,'',NULL,NULL,0,NULL,NULL,'current',NULL,0,NULL,NULL,0,'2013-09-26 00:00:00');
-- Encounters
INSERT INTO `casemgmt_note`
(
`update_date`, `observation_date`,`demographic_no`,
`provider_no`, `note`, `signed`, `include_issue_innote`,`signing_provider_no`, `encounter_type`, `billing_code`, `program_no`,`reporter_caisi_role`, `reporter_program_team`, `history`, `password`,`locked`, `archived`, `position`, `uuid`, `appointmentNo`,`hourOfEncounterTime`, `minuteOfEncounterTime`,`hourOfEncTransportationTime`, `minuteOfEncTransportationTime`
)
VALUES
('2013-09-26 15:31:20','2013-09-26 15:31:20',(select max(demographic_no) from demographic),
'999998','[26-Sep-2013 .: Tel-Progress Notes] \n\nBP    130/85 sitting position \nHT    160 in cm \nWT    85 in kg',0,0,'','','',(select id from program where name='OSCAR'),'1','0','[26-Sep-2013 .: Tel-Progress Notes] \n\nBP    130/85 sitting position \nHT    160 in cm \nWT    85 in kg',NULL,'0',0,0,'b09b2536-3f31-48aa-a696-03cb4457724e',0,NULL,NULL,NULL,NULL);
-- Clinically Measured Observations
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('BP',(select max(demographic_no) from demographic),
'999998','130/85','sitting position','','2013-09-26 00:00:00','2013-09-26 15:30:49',0),
('HT',(select max(demographic_no) from demographic),
'999998','160','in cm','','2013-09-26 00:00:00','2013-09-26 15:30:49',0),
('WT',(select max(demographic_no) from demographic),
'999998','85','in kg','','2013-09-26 00:00:00','2013-09-26 15:30:49',0);
-- Labs
INSERT INTO `hl7TextInfo` (`lab_no`, `sex`, `health_no`, `result_status`, `final_result_count`, `obr_date`, `priority`, `requesting_client`, `discipline`, `last_name`, `first_name`, `report_status`, `accessionNum`, `filler_order_num`, `sending_facility`, `label`)
VALUES
((SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=(SELECT DATABASE() FROM DUAL) AND TABLE_NAME='hl7TextInfo'),'F','448000010','A',105,'2013-06-20 13:24:44',NULL,'BOB MDCARE','HAEM1','SUGAR','MARY','F','11-222075060',NULL,NULL,NULL);
INSERT INTO `patientLabRouting` (`demographic_no`, `lab_no`, `lab_type`,  `created`, `dateModified`)
VALUES
((select max(demographic_no) from demographic),
(select max(lab_no) from hl7TextInfo),
'HL7','0000-00-00 00:00:00',NULL);
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','5.1','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','14771-0'),
((select max(id) from measurements),'name','Glucose Fasting'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075060'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mmol/L'),
((select max(id) from measurements),'minimum','3.6'),
((select max(id) from measurements),'other_id','0-0');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','38','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','58453-2'),
((select max(id) from measurements),'name','Occult Blood Immunochemical'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075060'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','ng/mL'),
((select max(id) from measurements),'other_id','0-1');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('A1C',(select max(demographic_no) from demographic),
'0','6.1','Range:0.040-0.200','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','A'),
((select max(id) from measurements),'identifier','4548-4'),
((select max(id) from measurements),'name','Hemoglobin A1c'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075060'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','%'),
((select max(id) from measurements),'minimum','4.8'),
((select max(id) from measurements),'other_id','0-2');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','2.9','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','39469-2'),
((select max(id) from measurements),'name','LDL Cholesterol'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075060'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','mmol/L'),
((select max(id) from measurements),'other_id','0-3');
INSERT INTO `measurements` (`type`, `demographicNo`, `providerNo`, `dataField`, `measuringInstruction`, `comments`, `dateObserved`, `dateEntered`, `appointmentNo`)
VALUES
('',(select max(demographic_no) from demographic),
'0','45','','','2013-06-20 13:24:44','2013-09-26 03:54:44',0);
INSERT INTO `measurementsExt` (`measurement_id`, `keyval`, `val`)
VALUES
((select max(id) from measurements),'lab_no',(select lab_no from hl7TextInfo where id=(select max(id) from hl7TextInfo))),
((select max(id) from measurements),'abnormal','N'),
((select max(id) from measurements),'identifier','1751-7'),
((select max(id) from measurements),'name','Albumin'),
((select max(id) from measurements),'labname','UVIC'),
((select max(id) from measurements),'accession','11-222075060'),
((select max(id) from measurements),'request_datetime','2013-06-20 12:50:00'),
((select max(id) from measurements),'datetime','2013-06-20 13:24:44'),
((select max(id) from measurements),'olis_status','F'),
((select max(id) from measurements),'unit','g/L'),
((select max(id) from measurements),'range','687');
-- Immunizations
INSERT INTO `preventions` (`demographic_no`, `creation_date`, `prevention_date`, `provider_no`, `provider_name`, `prevention_type`, `deleted`, `refused`, `next_date`, `never`, `creator`, `lastUpdateDate`)
VALUES
((select max(demographic_no) from demographic),
'2013-09-27 14:10:57','2012-10-15 00:00:00','999998',NULL,'Pneumovax','0','0',NULL,'0',999998,'2013-09-27 14:10:57');
INSERT INTO `preventionsExt` (`prevention_id`, `keyval`, `val`)
VALUES
((select max(id) from preventions),'location',''),
((select max(id) from preventions),'lot',''),
((select max(id) from preventions),'route',''),
((select max(id) from preventions),'dose',''),
((select max(id) from preventions),'comments',''),
((select max(id) from preventions),'neverReason',''),
((select max(id) from preventions),'manufacture',''),
((select max(id) from preventions),'name','');
-- Medications
INSERT INTO `drugs`
(`provider_no`, `demographic_no`, `rx_date`, `end_date`, `written_date`, `pickup_datetime`, `BN`, `GCN_SEQNO`, `customName`, `takemin`, `takemax`, `freqcode`, `duration`, `durunit`, `quantity`, `repeat`, `last_refill_date`, `nosubs`, `prn`, `special`, `special_instruction`, `archived`, `GN`, `ATC`, `script_no`, `regional_identifier`, `unit`, `method`, `route`, `drug_form`, `create_date`, `dosage`, `custom_instructions`, `unitName`, `custom_note`, `long_term`, `non_authoritative`, `past_med`, `patient_compliance`, `outside_provider_name`, `outside_provider_ohip`, `archived_reason`, `archived_date`, `hide_from_drug_profile`, `eTreatmentType`, `rxStatus`, `dispense_interval`, `refill_duration`, `refill_quantity`, `hide_cpp`, `position`, `comment`, `start_date_unknown`, `lastUpdateDate`, `dispenseInternal`)
VALUES
('999998',
(select max(demographic_no) from demographic),
'2013-09-27','2013-12-20','2013-09-27',NULL,'METFORMIN FC 500MG',5605,NULL,1,1,'BID','84','D','168',0,NULL,0,0,'METFORMIN FC 500MG\nTake 1 PO BID 84 days\nQty:168 Repeats:0',NULL,0,'METFORMIN HYDROCHLORIDE','A10BA02',9,'02385341','MG','Take','PO','TABLET','2013-09-27 13:56:25','500.0 MG',0,NULL,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1,NULL,0,'2013-09-27 13:56:25',0);
-- Problem List
INSERT INTO `dxresearch`
(demographic_no,
 start_date, update_date, status, dxresearch_code, coding_system, association, providerNo)
VALUES
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','250','icd9',0,NULL),
((select max(demographic_no) from demographic),
 '2013-09-26','2013-09-26 00:00:00','A','585','icd9',0,NULL);
