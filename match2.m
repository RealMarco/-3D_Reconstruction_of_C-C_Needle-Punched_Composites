function [p2,p3]=match2(x0,y0,z1,S)
count=0;

for r = 0:50     %12
    for x1 = x0-r:x0+r
        for y1=y0-r:y0+r
            if all([x1>0&&x1<size(S,1) y1>0&&y1<=size(S,2)])
                if S(x1,y1,z1)~=0
                    p1=S(x1,y1,z1);
                    if count==0
                        p2=p1;
                        count=count+1;
                    elseif count==1
                        if p1~=p2    %±ÜÃâp1==p2
                            p3=p1;
                            count=count+1;
                            return
                        end
                    else
                        return
                    end
                end
            end
        end
    end
end
        