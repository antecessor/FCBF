function OutFeatures=FCBF(Features,Target,threshold)
%% Apply Threshold
for i=1:size(Features,2)
    I(i) = abs(MutualInformation(Features(:,i), Target));
end
[sortedI,indSort]=sort(I);
index_selected=find(sortedI>threshold);
NewFeatures=Features(:,indSort(index_selected));
%% Removing similarities
Matrix_Mu=zeros(size(NewFeatures,2));
for i=1:size(NewFeatures,2)-1
    for j=i+1:size(NewFeatures,2)
       Matrix_Mu(i,j)= abs(MutualInformation(Features(:,i), Features(:,j)));
       Matrix_Mu(j,i)= Matrix_Mu(i,j);
    end
end
SelectedFeature=[];
for i=1:size(Matrix_Mu,2)
   Col= Matrix_Mu(:,i);
   index=find(Col>2);
   MI=[];
   for j=1:numel(index)
        MI=[MI MutualInformation(Features(:,index(j)), Target)] ;
   end
   [~,selected]=sort(MI);
   SelectedFeature=[SelectedFeature; index(selected(1:round(.6*numel(selected))))];
   
end
SelectedFeature=unique(SelectedFeature);
OutFeatures=Features(:,SelectedFeature);
end