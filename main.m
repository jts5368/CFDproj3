clear 
clc

% -------------------------------------------------------------------------
% Interface tracking test
% -------------------------------------------------------------------------



Nx =33;
Ny = 33;
x = linspace(0,1,Nx);
y = linspace(0,1,Ny);
h = y(3) - y(2);
[X,Y] = meshgrid(x,y);

%% circle stuff
cir_dis = 0:pi/50:2*pi; %decrease step size for more exact circle
xcir = 0.15 * cos(cir_dis) + 0.5;
ycir = 0.15 * sin(cir_dis) + 0.75;
plot(xcir,ycir)
hold on
for i = 1:Nx
    plot(ones(1,length(x))*x(i),y,'k','Linewidth',0.25)
    plot(x,ones(1,length(y))*y(i),'k','Linewidth',0.25)
end

x_pos = 0.5;
y_pos = 0.75;
r = 0.15;

j=1;
for i = 1:length(x)
    if x(i) > 0.5-0.15 && x(i) < 0.5+0.15
        cir_xloc_x(j) = x(i);
        xnode(j) = i;
        j=j+1;
    end
end

cir_xloc_y1 = -(-((cir_xloc_x-x_pos).^2 - r^2)).^(1/2) + y_pos;
cir_xloc_y2 = (-((cir_xloc_x-x_pos).^2 - r^2)).^(1/2) + y_pos;
cir_xloc_y = [cir_xloc_y1,cir_xloc_y2];
cir_xloc_x = [cir_xloc_x,cir_xloc_x];
xnode = [xnode,xnode];

for i=1:length(xnode)
    for j=1:length(x)-1
    if y(j) < cir_xloc_y(i) && y(j+1) > cir_xloc_y(i)
    ynodefromx(i) = j;
    end
    end
end


j=1;
for i = 1:length(y)
    if y(i) > y_pos-r && y(i) < y_pos+r
        cir_yloc_y(j) = y(i);
        ynode(j) = i;
        j=j+1;
    end
end

cir_yloc_x2 = (-((cir_yloc_y-y_pos).^2 - r^2)).^(1/2) + x_pos;
cir_yloc_x1 = -(-((cir_yloc_y-y_pos).^2 - r^2)).^(1/2) + x_pos;
cir_yloc_x = [cir_yloc_x1,cir_yloc_x2];
cir_yloc_y = [cir_yloc_y,cir_yloc_y];
ynode = [ynode,ynode];

plot(cir_xloc_x,cir_xloc_y,'o')
plot(cir_yloc_x,cir_yloc_y,'o')

%first area, semi trapizoid
istrap = true;
i_nt = 1;
for i_xx=1:length(cir_xloc_x) -1
     
    for i_yx=1:length(cir_yloc_x)-1
    
        if cir_yloc_x(i_yx) > cir_xloc_x(i_xx) && ...
                cir_yloc_x(i_yx) < cir_xloc_x(i_xx+1)
            
             istrap = false;
        end
        
    end
    
    if istrap == true
    linear_distance = ((cir_xloc_x(i_xx+1)- cir_xloc_x(i_xx))^2 +...
        (cir_xloc_y(i_xx+1)- cir_xloc_y(i_xx))^2)^(1/2);
    angle = 2 * asin(linear_distance/2 / r);
    area_sector = angle/(2*pi) * pi*r^2;
    area_triangle = linear_distance/2 * r*cos(angle);
    area_sliver = area_sector-area_triangle;
    area_trap = (abs( y(ynodefromx(i_xx)+1) - cir_xloc_y(i_xx)) +abs( y(ynodefromx(i_xx)+1)...
                - cir_xloc_y(i_xx+1)))/2 * h;
    area = area_trap + area_sliver;
    C(xnode(i_xx),ynode(i_xx)) = area/h^2;
    else
       istrap = true; 
        
    end
     
end




T = 2;
t = T/2; %this is for book example, deliverable 2 has t = T/pi
PHI = 1/pi .* cos(pi*t/T).*sin(pi.*X).^2 .* sin(pi.*Y).^2;

u = -2.*cos(pi.*t./T).*sin(pi.*X).^2 .* sin(pi.*Y).*cos(pi.*Y);
v = 2.*cos(pi.*t./T).*sin(pi.*Y).^2 .* sin(pi.*X).*cos(pi.*X);

figure
quiver(X,Y,u,v)
% C = (u.^2 + v.^2).^(1/2);




