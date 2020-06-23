clc,clear all,close all
% Frequent itemset mining
% Rasit EVDUZEN
% 12-Mar-2020

%% Dataset - 1
MinSupp = 0.60;          % Minimum Support&Treshold 
TransactionDatabase = {...
    {'a','c','d'}
    {'b','c','e'}
    {'a','b','c','e'}
    {'b','e'}
    {'a','b','c','e'}
    };

%% Data Pre Processing
STR = [];
for i = 1:size(TransactionDatabase,1)
    STR = [STR,cat(i,TransactionDatabase{i:i})];
end
ORIGINALITEMS = unique(sort(STR));
ORIGINALITEMSp = ORIGINALITEMS;      % Unique item 

% Cell-Transaction Data Base Convert to Numerical Data Base
NDB = zeros(size(TransactionDatabase,1),size(ORIGINALITEMS,2));   % Numerical Database
for i = 1:length(TransactionDatabase)
    for j=1:size(TransactionDatabase{i},2)
        temp = TransactionDatabase{i}{j};
        index = find(strcmp(temp, ORIGINALITEMS));
        NDB(i,index) = 1;
    end
end

%% Apriori Algorithm

[NumOfTransactions,NumOfItems] = size(NDB);

SUPPORTS = [];
for i=1:NumOfItems
    SUPPORTS(i,1) = sum(NDB(:,i))/NumOfTransactions;
end

I = find(SUPPORTS >= MinSupp);
F1 = [1:length(I)]';
SUPPORTS = SUPPORTS(I);
NDB = NDB(:,I);
ORIGINALITEMS = ORIGINALITEMS(I);

Fk = F1; tempFk = {};
loop = 1; k = 1;
while loop
    k = k + 1;
    Ck = [];
    Fkm1 = Fk;
    for i=1:size(Fkm1,1)
        C1 = Fkm1(i,:);
        for j=1:size(F1)
            C2 = F1(j);
            tmp = [C1,C2];
            tmp = unique(tmp);
            if length(tmp) ==k
                if isempty(Ck)
                    Ck = [Ck; tmp];
                else
                    tmploop = 1; r = 0; Y = 1;
                    while tmploop
                        r = r + 1;
                        if prod(Ck(r,:)==tmp)
                            tmploop = 0; Y = 0;
                        end
                        if r == size(Ck,1)
                            tmploop = 0;
                        end
                    end
                    if Y == 1
                        Ck = [Ck; tmp];
                    end
                end
            end
        end
    end
    Fk = []; SUPPORTS = [];
    for i=1:size(Ck,1)
        tmp = Ck(i,:);
        tmp = NDB(:,tmp);
        supp = length(find(prod(tmp')==1))/NumOfTransactions;
        if supp >= MinSupp
            Fk = [Fk; Ck(i,:)];
            SUPPORTS = [SUPPORTS, supp];
        end
    end
    tempFk = {tempFk; ORIGINALITEMS(Fk)};
    if isempty(Fk)
        loop = 0;
    end
end



%% PLOT DATA
% NOT : This code neded parametric plot for each frequent item

set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(1,5,1)
annotation('textbox', [0.151, 0.01, 0.1, 0.1], 'String', "Minimum Support :" + MinSupp)
cellplot(TransactionDatabase),title('Transaction Database')

subplot(1,5,2)
cellplot(ORIGINALITEMSp'),title('Items')

subplot(1,5,3)
cellplot(ORIGINALITEMS'),title('Frequent 1-Items')


subplot(1,5,4)
cellplot(tempFk{1,1}{1,1}{2,1}),title('Frequent 2-Items')

subplot(1,5,5)
cellplot(tempFk{1,1}{2,1}),title('Frequent 3-Items')