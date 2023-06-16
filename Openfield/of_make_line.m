function [of_xy] = make_line(of_xy,t_pre,t_post)
%-----Connect nose-neck-chest-hip ------%
data_point=(t_pre+t_post)/5;

for i=1:size(of_xy,2)
    for j = 1:data_point
        nose = of_xy(i).nose_xy(j,:);
        neck = of_xy(i).neck_xy(j,:);
        chest = of_xy(i).chest_xy(j,:);
        hip = of_xy(i).hip_xy(j,:);
        body=[nose;neck;chest;hip];
        of_xy(i).body(j).xy= body;
    end
end

end

