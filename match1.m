function [x2,y2,x3,y3]=match1(x0,y0,img1)
count=0;

for r = 0:16     %The search range of i_th is covered by i+1_th's range. 
    for x1 = x0-r:x0+r   %That's why x2=x3 and y2=y3 exist in the results
        for y1=y0-r:y0+r
            if img1(x1,y1)>=128
                count=count+1;
                if count==1
                    x2=x1;
                    y2=y1;
                end
                if count==2
                    x3=x1;
                    y3=y1;
                    return
                end
            end
        end
    end
end
        