##create table hrms
use hrms;

drop table ms_forms;
create table ms_forms (msf_id int,msf_parent_id int ,msf_name varchar(60),ms_descp varchar(100), primary key (msf_id));

drop table ms_person_forms;
create table ms_person_forms(mpf_mp_id varchar(12),mpf_msf_id int );

drop table ms_person;
create table ms_person(mp_id varchar(12),mp_aktif varchar(1), mp_uu_id varchar(4));




