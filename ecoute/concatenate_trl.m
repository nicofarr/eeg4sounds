function [trl] = concatenate_trl(sampleinfo)


trl = [0 0 0];

startingpoint = sampleinfo(1,1);
endpoint = sampleinfo(1,2);

for i = 2:size(sampleinfo,1)
    curbounds = sampleinfo(i,:);
    
    if curbounds(1) == (endpoint+1)
        endpoint = curbounds(2);
        if i == size(sampleinfo,1)
            trl(end+1,:) = [startingpoint endpoint 0];                     
        end
        continue
    else
        trl(end+1,:) = [startingpoint endpoint 0];
        startingpoint = curbounds(1);
        endpoint = curbounds(2);
    end
    
    
    
    
    
end

trl(1,:)=[];