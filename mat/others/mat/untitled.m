figure(5);
array = var_x;


array = array/max(array);

plot(array(1:1+1500),'Color',[0 0 0]);
hold on;plot(array(1655:1655+1500),'Color',[1 0 0]);
%plot(array(1:1655),'Color',[0 1 0]);
%hold on;plot(array(1655:3401),'k');
hold on;plot(array(3401:3401+1500),'Color',[0 0 1]);
hold on;plot(array(5308:5308+1500),'Color',[1 1 0]);
hold on;plot(array(7238:7238+1500),'Color',[ 0 1 1]);
hold on;plot(array(9098:9098+1500),'Color',[1 0 1]);
hold on;plot(array(10500:10500+1500),'Color',[1 1 1]);
hold on;plot(array(12430:12430+1500),'Color',[.5 .5 .5]);

