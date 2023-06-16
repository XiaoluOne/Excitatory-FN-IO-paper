function [x,y] = of_xy(body,loop_index)
%Organize coordinates of every body parts for each trial
% Input: body = body position (nose, ear, neck, chest, hip)
loop_index = int64(loop_index);
x = table2array(body(loop_index,1));
y = table2array(body(loop_index,2));
end

