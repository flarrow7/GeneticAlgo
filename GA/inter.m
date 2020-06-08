function [y] = two_point(string,position,position1)
y = string;
if string(position1) ~= string(position)
    if string(position) == '1'
        y(position) = '0';
        y(position1) = '1';
    else
        y(position) = '1';
        y(position1) = '0';
    end
end
  