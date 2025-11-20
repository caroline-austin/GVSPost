function [type_filenames] = get_filetype(filenames,filetype)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
num_files = length(filenames);
type_length = length(filetype);

type_filenames = strings(1,1);

num_type_files = 0;
for i = 1:num_files
    filename = char(filenames(i));
    filename_type = filename(end-(type_length-1):end);
    if filename_type == filetype
        num_type_files= num_type_files+1;
        type_filenames(num_type_files)= filename;
    end

end

end