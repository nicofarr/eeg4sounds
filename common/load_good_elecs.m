
electrodes = csvread('../common/eleckeep.txt');
elec_cell = cell(size(electrodes));
for i=1:size(electrodes)
    elec_cell{i} = ['E',num2str(electrodes(i))];
end

clear electrodes