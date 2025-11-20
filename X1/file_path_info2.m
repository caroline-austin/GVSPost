function [filenames]=file_path_info2(code_path,file_path)
%this function checks to see whether or not there are files in a folder and
%if there are it passes back the names of the files

%'preliminare'

%file_path=input('Where is the directory to take the data: ','s');

%--------------------------------------------------------------------------
% get file names
cd(file_path);
direc=dir; 
filenames={};
[filenames{1:length(direc),1}] = deal(direc.name);
filenames=filenames(3:length(filenames));
num_file=length(filenames);

if num_file==0
    cd(code_path);
    error('In the folder there arent files.');
end

cd(code_path);

% Creo le liste dei file
% k_F=0; k_R=0;
% for i=1:numero_file
%     nome=char(filenames(i));
%     if length(nome)>4
%         if strcmp(nome(length(nome)-2:length(nome)),'txt')==1
%             if strcmp(nome(5),'F')==1
%                 k_F=k_F+1;
%                 file_F(k_F)=i;
%             elseif strcmp(nome(5),'R')==1
%                 k_R=k_R+1;
%                 file_R(k_R)=i;
%             end
%         end
%     end
% end
% 
