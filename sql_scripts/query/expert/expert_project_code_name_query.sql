-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

-- ! 查询项目编号和项目名称，数据从2023-07-01开始筛选，在之前行研管理没统一。之后采用统一的行研管理，如果是行研访谈则统一使用Rxxxx代码

select DISTINCT 
(case
  when (ieim.interview_type = '1') then eip.tec_code
  when (ieim.interview_type = '2' and iindustry.sub_industry_code is not null) then iindustry.sub_industry_code
  when (ieim.interview_type = '2' and ieim.project_code is not null and ieim.project_code <> '') then ieim.project_code
  when (ieim.interview_type = '3') then suser.user_no
  when (ieim.interview_type = '4') then sdd2.dict_code
  else NULL
  end) as 'project_code',
(case
 when (ieim.interview_type = '1') then eip.tec_name
 when (ieim.interview_type = '2' and iindustry.sub_industry_code is not null) then iindustry.sub_industry_name
 when (ieim.interview_type = '2' and ieim.project_code is not null and ieim.project_code <> '') then eip.tec_name
 when (ieim.interview_type = '3') then suser.user_name
 when (ieim.interview_type = '4') then sdd2.dict_label
 else NULL
 end) as 'project_name'
from is_interview_task iit
left join is_expert_interview iei on iit.interview_id = iei.cpe_id
left join is_expert_interview_main ieim on iei.parent_id = ieim.id
left join is_service_provider isp on iei.service_provider = isp.id
left join sys_user su on ieim.apply_user = su.user_id
left join sys_user_dept sud on su.user_id = sud.user_id
left join sys_dept sd on sud.dept_id = sd.dept_id
left join es_proj_code eip on ieim.project_code = eip.tec_code
left join is_industry iindustry on 0 <> find_in_set(iindustry.sub_industry_code, iei.industry)
left join sys_user suser on suser.user_id = ieim.sponsor
left join sys_dict_data sdd2 on iei.sector = sdd2.dict_code and sdd2.dict_type = 'sector'
where iit.meeting_time >= '2023-07-01 00:00'
