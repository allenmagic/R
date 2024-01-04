select
    iit.interview_id as 'cpe_interview_id',
    iit.task_id as 'task_id_external',
    isp.name as 'expert_vendor',
    ieim.subject as 'interview_subject',
    su.user_name as 'applicant',
    sd.dept_name as 'department',
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
    end) as 'project_name',
    (case
        when (ieim.interview_type = '1') then '项目费用'
        when (ieim.interview_type = '2') then '行研费用'
        when (ieim.interview_type = '3') then '高管费用'
        when (ieim.interview_type = '4') then '二级访谈'
        else '其它费用'
    end) as 'fee_type',
    (case
        when (ieim.interview_type = '4') then '二级投资'
        else '一级投资'
    end) as 'team',
    cast(iit.settle_time as date) as 'fee_date',
    iit.meeting_time as 'meeting_time',
    round(iit.fee,2) as 'fee',
    iit.fee_currency as 'fee_currency',
    iit.fee_min as 'duration',
    iit.expert as 'expert_intro',
    (case iit.meeting_summary_status 
        when 1 then '已完成'
        when 0 then '未完成'
        when 2 then '无纪要'
        else '其他'
    end) as 'summary_status', 
    iit.meeting_summary_url as 'summary_doc_url',
    (select group_concat(su1.user_name) from sys_user su1 left join sys_user_role sur on su1.user_id=sur.user_id where (find_in_set(su1.user_id,iei.participant)  or find_in_set(su1.user_id,forward_user)) and (su1.user_rank='D' OR su1.user_rank='MD' ) and sur.role_id='invest_team' ) as 'participant_director',
    (select group_concat(su1.user_name) from sys_user su1 left join sys_user_role sur on su1.user_id=sur.user_id where (find_in_set(su1.user_id,iei.participant)  or find_in_set(su1.user_id,forward_user)) and (su1.user_rank!='D' and su1.user_rank!='MD' )  and sur.role_id='invest_team') as 'participant_vp',
    (select group_concat(su1.user_name) from sys_user su1 left join sys_user_role sur on su1.user_id=sur.user_id where (find_in_set(su1.user_id,iei.participant)  or find_in_set(su1.user_id,forward_user))   and sur.role_id='invest_execut') as 'participant_executor'
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
where iit.fee is not null and iit.fee <> 0
order by iit.meeting_time