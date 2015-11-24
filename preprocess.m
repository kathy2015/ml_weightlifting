[Features, Data]=loadData();
    
    %transform categorical data into numbers
    [x,y]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'new_window'),Features)));

    newWindowData=Data(:,y);
    [row,column]=size(newWindowData);
    for i=1:row
    if strcmp(newWindowData{i,1},'no')
        Data{i,y}=0;
    elseif strcmp(newWindowData{i,1},'yes')
        Data{i,y}=1;    
    end
    end

%replace the sparse cells with the statistics data for each new window 
[x,belt_stat_range_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'kurtosis_roll_belt'),Features)));
[x,belt_stat_range_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'var_yaw_belt'),Features)));

[x,arm_stat1_range_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'var_accel_arm'),Features)));
[x,arm_stat1_range_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'var_yaw_arm'),Features)));

[x,arm_stat2_range_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'kurtosis_roll_arm'),Features)));
[x,arm_stat2_range_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'amplitude_yaw_arm'),Features)));

[x,dumbbell_stat_range_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'kurtosis_roll_dumbbell'),Features)));
[x,dumbbell_stat_range_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'amplitude_yaw_dumbbell'),Features)));

[x,forearm_stat1_range_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'kurtosis_roll_forearm'),Features)));
[x,forearm_stat1_range_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'amplitude_yaw_forearm'),Features)));

[x,forearm_stat2_range_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'var_accel_forearm'),Features)));
[x,forearm_stat2_range_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'var_yaw_forearm'),Features)));

%update on the sparsed cells with the stat data of each new window
for i=row:-1:1
        Data{i,5};
    if Data{i,5}==0
        % update sparse cells with the belt stat data 
        for k=belt_stat_range_start:belt_stat_range_end
            Data{i,k}=baseline{1,k};
            %test=Data{i,k};
        end
        
        % update sparse cells with the arm stata data
        for k=arm_stat1_range_start:arm_stat1_range_end
            Data{i,k}=baseline{1,k};
        end
        for k=arm_stat2_range_start:arm_stat2_range_end
            Data{i,k}=baseline{1,k};
        end
        
        % update sparse cells with the dumbbell stat data
        for k=dumbbell_stat_range_start:dumbbell_stat_range_end
            Data{i,k}=baseline{1,k};
        end
        
        %update sparse cells with the forearm stat data
        for k=forearm_stat1_range_start:forearm_stat1_range_end
            Data{i,k}=baseline{1,k};
        end
        for k=forearm_stat2_range_start:forearm_stat2_range_end
            Data{i,k}=baseline{1,k};
        end
        
    elseif Data{i,5}==1
        baseline=Data(i,:);
    end
end

%normalize data

[x,normdata_start]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'new_window'),Features)));
[x,normdata_end]=ind2sub(size(Features),find(cellfun(@(x)strcmp(x,'magnet_forearm_z'),Features)));

%transform datatype into double and cell into matrix
data_for_norm=Data(1:end,normdata_start:normdata_end);
data_matrix=str2double(data_for_norm);

%find the columns with nans and remove those columns

for f_i=1:size(data_matrix,1)
  nans = find(isnan(data_matrix(f_i,:)));
  not_nans = setdiff(1:size(data_matrix,2),nans);

  med_value = median(data_matrix(f_i,not_nans));

  data_matrix(f_i,nans) = med_value;
end

data_normalized=normalizeData(data_matrix);

%dimension reduction using PCA (imported drttoolbox)
[mappedX, mapping] = compute_mapping(data_normalized, 'PCA', 50);

%write input data in csv file
label=Data(1:end,159);
label_matrix=cell2mat(label);
%output_matrix=[num2cell(mappedX) cellstr(label_matrix)];
%save('C:\Users\kathy\Downloads\output_matrix');
dlmwrite('C:\Users\kathy\Downloads\weightproj_input.csv',mappedX, '-append'); 
dlmwrite('C:\Users\kathy\Downloads\weightproj_target.csv',label_matrix, '-append'); 

