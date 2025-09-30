delete from Black_List_Data_Core_Flag_Group;

update Black_List_Data_Core
set flag_group_uuid  = null;

select * from Black_List_Data_Core;