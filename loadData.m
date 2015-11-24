function [Features, Data]=loadData()
FNAME='WearableComputing_weight_lifting_exercises_biceps_curl_variations.csv';
NCOLUMNS=159;

%read data from file
fp=fopen(FNAME);
C=textscan(fp,'%s','Delimiter',',');
fclose(fp);

%reformat data into matrix
Features=C{1}(1:NCOLUMNS)';
Data=C{1}(NCOLUMNS+1:end);
D=reshape(Data,NCOLUMNS,[]);
Xcell=D(1:end,:);
Data=Xcell';

 




