function [idx,members,mean1]=clustering(cts,U)
%�ú�������ROI��ع�ϵ�ķ���
%idx�Ƕ�Ӧ�ļ�Ⱥ�У������ļ���ROI��ع�ϵ
%members�Ƕ�Ӧ�ļ�Ⱥ�У�������ROI�Ե���ع�ϵ��ʱ������
%mean1��members����Ⱥ�ֱ�ȡƽ��ֵ���õ�һ��ƽ��ʱ������
%cts��ԭʼ�������ʱ������
%U��ָ���ļ�Ⱥ��
[xx,y,z]=size(cts);
idx=cell(y,1);
members=cell(U,z);
mean1=zeros(xx,U,z);
cts1=zeros(xx*z,y);%����ʱ��Ϊ�˱��ָ�����������һ�£�group
for j=1:z
    cts1((xx*j-xx+1):(xx*j),:)=cts(:,:,j);
end
for i=1:y
    idx{i,1}=i;  %��ʼ��idx
end
%���о���
%1.���ȼ����ʼ����,�γɾ������
d=zeros(y,y);
for i=1:y
    for j=i+1:y
        d(i,j)=pdist2(cts1(:,i)',cts1(:,j)')^2;
        d(j,i)=d(i,j);
    end
    d(i,i)=inf;
    disp(i);
end
save('d','d');
%2.�������࣬���¾������(������С����������кϲ�����Ϊ������С����ϲ�����ʹwithin-cluster variance��������)
for k=y:-1:U+1
    [a,aa]=find(d==min((d(:))));
    if length(a)>1
        a=a(1);
        aa=aa(1);
    end
    if a>aa
        b=a;
        a=aa;
        aa=b;
    end
    column=zeros(k,1);
    for i=1:k
        column(i)=size(idx{i,1},2);
    end
    for i=setdiff(1:k,[a,aa])
        d(a,i)=(column(a)+column(i))/(column(a)+column(i)+column(aa))*d(a,i)+(column(aa)+column(i))/(column(a)+column(i)+column(aa))*d(aa,i)-column(i)/(column(a)+column(i)+column(aa))*d(a,aa);
        d(i,a)=d(a,i);
    end
    d(aa,:)=[];
    d(:,aa)=[];
    %�������������
    idx{a,1}=[idx{a,1},idx{aa,1}];
    idx{aa,1}=[];
    idx=idx(cellfun(@(x) ~isequal(x,''),idx));
    disp(k);
end
save('idx','idx','d');
for j=1:z
    for i=1:U
        members{i,j}=cts(:,[idx{i,1}],j);
        mean1(:,i,j)=mean(members{i,j},2);
    end
end
