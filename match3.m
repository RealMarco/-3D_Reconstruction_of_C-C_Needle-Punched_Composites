function [p2,p3]=match3(x0,y0,z1,S)
count=0;
p2=0;   % initialization, p2=0 stands for not found matched point p2
p3=0;   %

for r = 0:25     %
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
                    else     % count==2
                        return
                    end
                end
            end
        end
    end
end

return
        
