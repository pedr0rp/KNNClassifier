clear;
clc;
import_data %creates data variable

%Manhattan = 1
%Euclidian = 2 
%Minkowsk  = 3
DISTANCE = 3;

qtd_classes = [0 0 0];

for (i=1:size(data,1)) 
    
    index = 0;
    for j=1:3
        if(data(i,j)==1)
            index = j;
            break;
        end;
    end 
  
    qtd_classes(1,index) = qtd_classes(1,index)+1;   
end

qt_train = round(qtd_classes*(1/3));
qt_test = qtd_classes-qt_train;
qt_exit = [0 0 0];

train = [];
test = [];
flag = 0;

while(qt_exit(1,1)<qt_train(1,1) || qt_exit(1,2)<qt_train(1,2) || qt_exit(1,3)<qt_train(1,3))
    
    r = randi([1 size(data,1)],1,1);  
    
    for j=1:3
        if(data(r,j)==1)
            index = j;
            break;
        end;
    end 
    
    if (qt_exit(1,index)<qt_train(1,index))
        qt_exit(1,index) = qt_exit(1,index)+1;            
        flag = 1;       
    end;    
    
    if(flag == 1) 
        train = [train; data(r,:)];
        if(r == 1) 
            data = data(2:end,:);
        elseif(r == size(data,1))
            data = data(1:size(data,1)-1,:);
        else
            data = data([1:r-1,r+1:end],:);
        end
        
        flag = 0;
    end    
end

test = data;
K = 10;
matches = 0;

for(k=1:size(test,1))
    x = test(k,:);
    d = [];

    %Manhattan
    if(DISTANCE==1)
        for (i=1:size(train,1))  
            temp = [0 0 0 0];    
            for (j=4:size(test,2))
                temp(1,j-3) = abs(test(k,j)- train(i,j)) ;     
            end
            d = [d; sum(temp)];    
        end
    end
    
    if(DISTANCE==2)
        for (i=1:size(train,1))  
            temp = [0 0 0 0];    
            for (j=4:size(test,2))
                temp(1,j-3) = power(test(k,j)- train(i,j),2) ;     
            end
            d = d.^(1/2);
            d = [d; sum(temp)];    
        end
    end
    
    if(DISTANCE==3)
        w = 3;
        for (i=1:size(train,1))  
            temp = [0 0 0 0];    
            for (j=4:size(test,2))
                temp(1,j-3) = power(test(k,j)- train(i,j),w) ;     
            end
            d = d.^(1/2);
            d = [d; sum(temp)];    
        end
    end

    result = [train d];
    result = sortrows(result,8);
    result = result(1:K,:);


    sums = [0 0 0];
    qtd_classes = [0 0 0];

    for (i=1:size(result,1)) 
        index = 0;
        for j=1:3
            if(result(i,j)==1)
                index = j;
                break;
            end;
        end   

        qtd_classes(1,index) = qtd_classes(1,index)+1;
        sums(1,index) = sum(1,index) + result(i,8);

    end

    [index,index] = min(sums./qtd_classes);
    if (test(k,index)==1)
        matches = matches+1;
    end;
    
end;

matches/size(test,1)





