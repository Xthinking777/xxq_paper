square;%最小二乘法拟合线性系统控制器
xx=xzc;

a_Estimated_MV=sum(n(1:d).^2);%估计的最小方差

a_Theoretical_MV=sum(n_real(1:d_real).^2);%真实最小方差

temp_y=1;
for kkk=1:4%方差
    for zz=1:5
    Kp_z=xx{kkk,zz}(1,1);
    Ki_z=xx{kkk,zz}(2,1);
    Kd_z=xx{kkk,zz}(3,1);
    if select==4
    Q1=filt([Kp_z+Ki_z+Kd_z -(Kp_z+2*Kd_z) Kd_z],1);
    y4=Fcor(Q1,filt(t_real(1:24)',1),filt(n_real(1:24)',1),y_a);%Generate output data
    y1=Fcor(Q1,filt(t(1:24)',1),filt(n(1:24)',1),y_a);%Generate output data
    if temp_y==1
        y_3=y1;
        temp_y=0;
    end
    vv(kkk,zz)=var(y1(1:1000));
    vv_real(kkk,zz)=var(y4(1:1000));
    end
    if select==5
    kfn(1)=n(1);
    kfn(2:25)=diff(n(1:25));
    kfd=[1 -1];
    H_=H;
    t_u=t(d+1:end)';
    t_up(1)=t_u(1);
    t_up(2:length(t_u))=diff(t_u);
    t_down=[1 -1];
    B_=B(d_real+1:end);
    D_=[1 D];
    sim('Pid_MVC_final1');%运行simulation
    if temp_y==1
        y_3=y1;
        temp_y=0;
    end
    vv(kkk,zz)=var(y1(1:1000));
    vv_real(kkk,zz)=var(y4(1:1000));
    end
    if select~=4&&select~=5
    NN=filt(n(1:min(50,length(n)))',1);
    kfn=NN.num{1,1};
    kfd=[1];
    H_=H;
    t_up=t(d+1:end)';
    t_down=[1];
    B_=B(d_real+1:end);
    D_=[1 D];
    sim('Pid_MVC_final1');%运行simulation
    if temp_y==1
        y_3=y1;
        temp_y=0;
    end
    vv(kkk,zz)=var(y1(1:100000));
    vv_real(kkk,zz)=var(y4(1:100000));
    end
    end
end

clear a_SettlingTime
for kkk=1:4%调节时间
    for zz=1:5
    NN=filt(n(1:min(25,length(n)))',1);
    kfn=NN.num{1,1};
    kfd=[1];
    H_=H;
    t_up=t(d+1:end);
    t_down=[1];
    B_=B(d_real+1:end);
    D_=[1 D];
    Kp_z=xx{kkk,zz}(1,1);
    Ki_z=xx{kkk,zz}(2,1);
    Kd_z=xx{kkk,zz}(3,1);
    sim('Pid_MVC_final1');%运行simulation
    for i=1:length(y2)
        if y2(i)>0.05 || y2(i)<-0.05
            lkl=i;
        end
    end
    vts(kkk,zz)=lkl;
    
    for i=1:length(y5)
        if y5(i)>0.05 || y5(i)<-0.05
            lklk=i;
        end
    end
    vts_real(kkk,zz)=lklk;
    end
end

for y=1:4%PID参数
    for z=1:5
        a_PID_Controller{y,z}=[roundn(xx{y,z}(1,1),-3) roundn(xx{y,z}(2,1),-3) roundn(xx{y,z}(3,1),-3)];
    end
end

for y=1:4%调节时间
    for z=1:5
        a_SettlingTime{y,z}=[roundn(vts(y,z),-2) roundn(vts_real(y,z),-2)];
    end
end

for y=1:4%Harris指标
    for z=1:5
        a_HarrisIndex{y,z}=[roundn(a_Estimated_MV/vv(y,z),-3) roundn(a_Theoretical_MV/vv_real(y,z),-3)];
    end
end

a_SettlingTime=a_SettlingTime.';
a_PID_Controller=a_PID_Controller.';
a_HarrisIndex=a_HarrisIndex.';

% figure(104)
% x_y=1:1:3000;
% y_output(1:1000)=y_1(1:1000);
% y_output(1001:2000)=y_2(1:1000);
% y_output(2001:3000)=y_3(1:1000);
% plot(x_y,y_output)
% hold on
% plot(x_y(1:1000),y_output(1:1000),'k');
% hold on
% plot(x_y(1001:2000),y_output(1001:2000),'r');
% hold on
% plot(x_y(2001:3000),y_output(2001:3000),'b');
% xlabel('Time','fontsize',15);
% ylabel('Output','fontsize',15); 
