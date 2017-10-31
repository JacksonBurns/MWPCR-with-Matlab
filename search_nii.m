% search all .nii file under the main_path and it's subfolder.
% input:allpath={};main_path is the goal file path.
% output:all the complete path of the .nii files.
function [allpath]=search_nii(allpath,main_path)
allfile=dir(main_path);
    for index=3:length(allfile)
        path=strcat(main_path,'\',allfile(index).name);
        if isdir(path)
            allpath=search_nii(allpath,path);
        elseif ~isempty(regexp(allfile(index).name,'\.nii', 'once'))      
            allpath(length(allpath)+1,1)={path};
        end
    end    
end