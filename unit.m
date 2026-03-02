%% Author: George Hinds

function b_unit = unit(bmeasure)
    % bmeasure = [
    %     -3.064, -0.346, -5.452;
    %     -2.764, 0.173, -5.452;
    %     -3.364, 0.173, -5.452;
    %     -3.064, 0.693, -5.999;
    %     -3.664, -0.346, -5.999;
    %     -2.464, -0.346, -5.999
    %     ];
    rows = size(bmeasure, 1);
    columns = size(bmeasure, 2);
    b_unit = zeros(rows,columns);

    beacons = cell(rows, 1);

    for i = 1:rows
        beacons{i} = bmeasure(i,:);
        b_unit(i, :) = bmeasure(i,:) / norm(beacons{i});
    end
end