#import "@preview/charged-ieee:0.1.0": ieee

#show: ieee.with(
  title: [基于磁场导向控制和FPGA的智能力反馈旋钮],
  abstract: [
    The process of scientific writing is often tangled up with the intricacies of typesetting, leading to frustration and wasted time for researchers. In this paper, we introduce Typst, a new typesetting system designed specifically for scientific writing. Typst untangles the typesetting process, allowing researchers to compose papers faster. In a series of experiments we demonstrate that Typst offers several advantages, including faster document creation, simplified syntax, and increased ease-of-use.
  ],
  authors: (
    (
      name: "仇琨元",
      department: [电子与电气工程系],
      organization: [南方科技大学],
      email: "1191...."
    ),
    (
      name: "张立远",
      department: [电子与电气工程系],
      organization: [南方科技大学],
      email: "12012724"
    ),
  ),
  index-terms: ("Scientific writing", "Typesetting", "Document creation", "Syntax"),

)

= 项目背景
旋钮，作为一种历史悠久的输入装置具有十分广泛的应用，从工厂的大型设备，录音室里的录音设备，到汽车的中控系统，家用微波炉的调节装置，旋钮无处不在。旋钮作为一种控制模组，相比于按钮、拉杆，其优势在于其可以控制连续的物理量，并让用户清楚地感知到当前所控制的物理量的值以及其和边界值的距离，具有较好的人机功效。随着旋钮在生产生活中应用的进一步深入，人们发现一般的旋钮已经无法满足一些需求，比如，不同应用场景下，旋钮产生的顿挫感是不同的，例如在飞机驾驶室的控制面板上，为了防止误操作，扭动旋钮时感受到的顿挫感往往会被设计得非常明显，而在汽车音响的音量控制旋钮上，为了使驾驶员能够灵敏、快速地调节音量，旋钮地顿挫感，或者说力反馈，则会被设计得尽可能小。传统的机械旋钮要设计不同的力反馈，必须基于不同的机械结构，而在人们追求一切事物都可以电控化的今天，机械旋钮显然已经有些过时了，更好的办法则是利用电机输出扭矩，光电传感器或磁传感器来实时感知电机转子位置，微控制器或FPGA来综合所有调控，输出指令和控制电机的PWM波形。本项目所要实现的即是这样一种基于FPGA作为主控、直流无刷电机作为扭矩输出的智能电控力反馈旋钮，而电机的控制方面，本项目采用的是磁场导向控制或矢量控制（Field Oriented Control，简称FOC），FOC作为一种电机控制方法，优势在于具有较高的精度，因为其早期开发的目的是为了高性能的电机应用，可以在整个频率范围内运转、电机零速时可以输出额定转矩、且可以快速的加减速，因此十分适合用于本项目。


= 项目方法
矢量控制（vector control）也称为磁场导向控制（field-oriented control，简称FOC），是一种利用变频器（VFD）控制三相交流电机的技术，利用调整变频器的输出频率、输出电压的大小及角度，来控制电机的输出。其特性是可以个别控制电机的磁场及转矩，类似他激式直流电机的特性。由于处理时会将三相输出电流及电压以矢量来表示，因此称为矢量控制。矢量控制可以适用在交流感应电机及直流无刷电机，早期开发的目的为了高性能的电机应用，可以在整个频率范围内运转、电机零速时可以输出额定转矩、且可以快速的加减速。不过相较于直流电机，矢量控制可配合交流电机使用，电机体积小，成本及能耗都较低，因此开始受到产业界的关注。矢量控制除了用在高性能的电机应用场合外，也已用在一些家电的应用中。
利用矢量控制，可以用类似控制他激直流电机的方式控制交流感应电机及同步电机。在他激直流电机中，磁场电流及电枢电流可独立控制，在矢量控制，控制磁场及电枢的电流互相垂直，理论上不会互相影响，因此当控制转矩时，不会影响产生磁场的磁链，因此可以有快速的转矩响应。

矢量控制会依照程式中计算的电流矢量，产生三相PWM的电压提供给电机，目的是要控制电机的三相电流。其中会将电流及电压等物理量在二个系统之间转换，一个是随速度及时间改变的三相系统，另一个则是二轴非线变的旋转坐标系统。

定子电流的矢量可以用（d,q）轴的坐标系统来定义，其中场磁链的电流分量对正d轴（direct），而转矩的电流分量对正q轴（quadrature）。电机的（d,q）轴坐标可以对应（a,b,c）三相的弦波系统。而（d,q）轴的电流矢量一般可以个别用PI控制器进行控制，也就是没有微分（D）单元的PID控制器。
和（d,q）轴的坐标系统有关的坐标转换如下：

- 由三相的瞬时电流值转换为(a,b,c)三相的弦波电流矢量。

- 利用克拉克变换，由(a,b,c)三相转换到($alpha,beta$)二相坐标系，在实现矢量控制时一般假设电机没有接地，且三相电流平衡，因此可以只感测三相电流中的二相。($alpha$,$beta$)坐标系的两轴相互垂直，α轴对齐于(a,b,c)三相坐标系中的a轴，将($alpha,beta$)二相坐标系转换为(a,b,c)三相坐标系则由克拉克逆变换或空间矢量脉冲宽度调制(Space Vector Pulse Width Modulation,简称SVPWM)来实现。


== 克拉克变换
对于一个三相对称的系统，其三相电压的表达式为：

$U_a = V cos(omega t)$

$U_b = V cos(omega t + 2/3pi)$

$U_c = V cos(omega t - 2/3pi)$

在$alpha,beta$平面上进行矢量合成与正交化，可得到电压矢量在$alpha,beta$两轴上的分量$U_alpha,U_beta$：

$|U_alpha| = k_1k_2sin theta(|U_a| - 1/2|U_b| - 1/2|U_c|)$

$|U_beta| = k_1k_2sin theta (sqrt(3)/2|U_b|-sqrt(3)/2|U_c|)$

将上述变换转换成矩阵的形式：

$mat(U_alpha;U_beta;U_0) = k_1k_2sin theta mat(1, -1/2, -1/2;0,sqrt(3)/2,-sqrt(3)/2;1/(k_1k_2sin theta),1/(k_1k_2sin theta),1/(k_1k_2sin theta))mat(U_a;U_b;U_c)$

则此变换对应的矩阵为:

$T_c = k_1k_2sin theta  mat(1, -1/2, -1/2;0,sqrt(3)/2,-sqrt(3)/2;1/(k_1k_2sin theta),1/(k_1k_2sin theta),1/(k_1k_2sin theta))$

== SVPWM
SVPWM的基本思想是将三相电压矢量表示为一个旋转的空间矢量，通过适当选择和控制逆变器开关的状态，使得逆变器输出电压矢量在一个采样周期内尽可能逼近所需的参考电压矢量。

首先，根据需要生成的三相交流电压，计算出相应的参考电压矢量$attach(V,br:r)$。然后，将整个空间划分为六个扇区（每个扇区60度），确定参考矢量$attach(V,br:r)$所在的扇区。将参考电压矢量$attach(V,br:r)$分解为该扇区内的两个基本电压矢量和零矢量的线性组合。计算基本电压矢量和零矢量作用的时间，使得平均电压矢量等于参考电压矢量。根据计算出的时间生成相应的PWM信号，控制逆变器的开关状态。

设$attach(V,br:r)$是参考电压矢量，$V_1,V_2$是基本电压矢量，$V_0$是零矢量，$T_1,T_2$是它们的作用时间，$T_s$是采样周期，则可以表示为：

$V_r T_s = V_1T_1 + V_2T_2 + V_0(T_s-T_1-T_2)$




== 派克变换
派克变换（Park Transformation），也称为dq0变换，是一种将三相静止参考系（ABC）转换为旋转参考系（dq0）的方法。这种变换广泛应用于交流电机控制（如永磁同步电机和感应电机）中，以简化分析和控制。

派克变换将三相电流（或电压）$I_A,I_B,I_C$转换为d,q坐标系下的d轴，q轴和0轴分量$I_q,I_d,I_0$,其变换矩阵如下：

$mat(I_q;I_d;I_0)=2/3mat(cos theta, cos(theta - 2/3 pi),cos (theta+2/3 pi);-sin theta, -sin(theta - 2/3 pi),-sin (theta + 2/3 pi);1/2, 1/2, 1/2)mat(I_A;I_B;I_C)$
其中，$theta$是旋转参考系相对于静止参考系的角度。

= 项目框图
Figure1为本项目的项目框图，包括了如下组件：
#table(
  columns: 2,
  table.header(
    [器件名称],
    [器件功能]
  ),
  [FPGA开发板： Next 4 DDR],
  [中控，输出负责进行克拉克-派克变换以及SVPWM，模式转换],
  [磁编码器：AS5600], [检测电机转子的角位移，使用IIC通信协议与主控通信],
  [模数转换器：ADC7928],[将电机三相电流的模拟值转化为数字值并发送给主控，进行后续的FOC计算],
  [无刷直流电机],[作为旋钮的主体，用户旋转电机转子，磁编码器检测转动角度，发送给主控处理，输出一个力反馈扭矩]
 
)

#figure(
  image("diagram.png", width: 80%),
  caption: [
    项目各组件和框图
  ],
)


#figure(
  image("nexy.jpg", width: 80%),
  caption: [
    FPGA 开发板: Nexy 4 DDR
  ],
)
#figure(
  image("as5600.png", width: 50%),
  caption: [
    霍尔磁编码器：AS5600 
  ],
)

#figure(
  image("7928.jpg", width: 50%),
  caption: [
    模数转换器：ADC7928 
  ],
)
#figure(
  image("motor.png", width: 50%),
  caption: [
    直流无刷电机 
  ],
)



= 代码实现
== 代码介绍
本项目使用Verilog语言实现，开发环境为Quartus，至于为什么没有使用VHDL，我们发现VHDL关于FOC方面的资料过少，而我们对FOC也只是入门阶段，尚不具备独立开发一个FOC算法的VHDL脚本的能力，而Verilog的FOC资料较为齐全，我们在FOC算法的实现上借用了前人的成果。

代码分为以下几个部分：
#figure(
  image("code.png", width: 50%),
  caption: [
    代码文件结构 
  ],
)

#table(
  columns: 2,
  table.header(
    [文件名称],
    [实现的功能]
  ),
 [fpga_top.v],[FPGA工程的顶层模块，控制电机的切向力矩一会顺时针一会逆时针，同时可以通过 UART 监测电流环控制的跟随曲线],
 [i2c_register_read.v],[I2C 读控制器],
 [adc_ad7928.v],[通过 SPI 接口从 ADC7928 (ADC芯片) 中读出 ADC 值。],
 [uart_monitor.v],[UART发送器，格式为：115200,8,n,1，可以把 i_val0, i_val1, i_val2, i_val3 变成10进制格式，放在一行里，通过 UART 发送出去],
 [foc_top.v],[FOC 算法（仅包含电流环） + SVPWM],
 [cartesian2polar.v],[把直角坐标系 (x,y) 转换为极坐标系 ],
 [clark_tr.v],[实现克拉克变换],
 [park_tr.v],[实现帕克变换],
 [pi_controller.v],[PI控制器],
 [svpwm.v],[7 段式 SVPWM 生成器（调制器），输入定子极坐标系下的电压矢量，输出PWM使能信号和三相PWM信号],
 [sincos.v],[查表计算 sin和cos]
)
== 系统仿真
我们分别针对Clarke-Park变换和SVPWM算法这两个FOC中的核心模块进行了仿真，并编写了testbench文件。
#table(
  columns: 2,
  table.header(
    [文件名称],
    [实现的功能]
  ),
  [tb_clark_park.v],[对Clarke-Park变换进行仿真，输入三相PWM正弦波，输出两相dq坐标系正弦波],
  [tb_svpwm.v],[对SVPWM算法进行仿真，输入dq坐标系相电流，输出三路PWM脉冲波以驱动三相电机]
)
仿真结果表明，两个核心模块均能正确运行，下面是仿真结果展示图：
#figure(
  image("tb_clark_park_tr.png", width: 100%),
  caption: [
    Clarke-Park变换仿真结果图 
  ],
)
#figure(
  image("tb_svpwm_2.png", width: 100%),
  caption: [
   SVPWM算法仿真结果图 
  ],
)

Figure7是对一个相位差为$2/3pi$的三相正弦电流先进行CLarke变换，得到转子坐标系上的两相正弦电流，再通过Park变换得到定子坐标系上的两相电流的过程进行仿真，Clarke变换的预期结果应该是两相正弦电流，其中一相的相位为$0$，另一相为$1/2pi$，从图中可以看出，仿真结果符合预期，而Park变换的预期结果应是两个定值，因为Park变换把转子坐标又转换成了定子坐标，从图中可以看出，控制电机输出扭矩的交轴电流$I_q$始终保持在一个高位，而控制磁链的直轴电流$I_d$除了有一点抖动以外基本上保持在0的位置，说明结果符合预期，电机能够实现平稳转动。



Figure8是对SVPWM过程的仿真，
= 功能展示

= 总结

