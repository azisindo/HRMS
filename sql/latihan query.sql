use hrms;
drop table ms_forms;
create table ms_forms (msf_id int,msf_parent_id int ,msf_name varchar(60),ms_descp varchar(100), primary key (msf_id));

desc ms_forms;

insert into ms_forms values(1,null,'setting','Setting'),
						   (2,1,'msfomrs','Master Forms'),
                           (3,1,'msuser','Master User'),
                           (4,1,'msakses','Master Akses'),
                           (5,null,'transaksi','transaksi'),
                           (6,5,'transaksi1','transaksi 1'),
                           (7,5,'transaksi2','transaksi 2'),
                           (8,5,'transaksi3','transaksi 3'),
                           (9,null,'Laporan','laporan'),
                           (10,9,'laporan1','Laporan 1'),
                           (11,9,'Laporan2','Laporan 2'),
                           (12,9,'Laporan3','Laporan 3');
delete from ms_forms;
commit;
                            
select * from ms_forms;                           

select * from ms_forms;


SELECT t1.msf_id, t1.ms_descp,t1.msf_parent_id FROM
ms_forms AS t1 LEFT JOIN ms_forms as t2
ON t1.msf_id = t2.msf_parent_id
WHERE t2.msf_parent_id IS not NULL
group by t1.msf_id;

drop table ms_person_forms;

create table ms_person_forms(mpf_mp_id varchar(12),mpf_msf_id int );

insert into ms_person_forms values('14110946',1),
								  ('14110946',2),
                                  ('14110946',3),
                                  ('14110946',4),
                                  ('14110946',5),
                                  ('14110946',6),
                                  ('14110946',7),
                                  ('14110946',8),
                                  ('14110946',9),
                                  ('14110946',10),
                                  ('14110946',11),
                                  ('14110946',12);

select * FROM ms_person_forms;

create table ms_person(mp_id varchar(12),mp_aktif varchar(1), mp_uu_id varchar(4));

insert into ms_person values('14110946','T','KZ01');
