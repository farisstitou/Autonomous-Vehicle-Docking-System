%% Author: George Hinds

function bmeasure = get_points()

    filename = 'CAD Test.csv';
    beaconData = readtable(filename);
    bmeasure = beaconData{:, 2:4};

end