2021年5月20日15点40分

![image-20210520154013517](https://i.loli.net/2021/05/20/EINL1cURgvuTz5P.png)

![image-20210520155336204](https://i.loli.net/2021/05/20/VMxLUrS39Z8ROd5.png)

rsE不读到0（遇到sb要写0的时候，无需前推）

// TODO 选择信号：谁和谁对应来着，忘记了



![image-20210520160344233](https://i.loli.net/2021/05/20/fkuApJG2QZ946Tr.png)



// XXX

数据阻塞

control为什么也要接入，那还不如直接在datapath里面做所有数据信号和控制信号的流水线分割





==控制冒险==

在decode阶段放置一个判断是否相等

![image-20210520180949933](https://i.loli.net/2021/05/20/wTxfMR3Nmha9s8S.png)

![image-20210520181508647](https://i.loli.net/2021/05/20/1rzdHEWIipAvVuq.png)

## 问题记录

1、仿真时，从controller 到 datapath 再到 mips 继而top，所有控制信号传递都是X

结果才发现，controller中clk和rst都没有传进去，搞撒子流水线分割哦！



2、branch指令，处理报红（equalD指令为X）

writeback时，在下降沿写入

![image-20210606183331668](https://i.loli.net/2021/06/06/pduSTgwlDLEbMIG.png)

第三条指令`addi $7,$3,-9`错误

![](https://upload-images.jianshu.io/upload_images/24714066-81cf9e8866ca69c6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

心态崩了，原来是这里错了

![image-20210606192413298](https://i.loli.net/2021/06/06/sa3UcJLKwTZEi1m.png)

clk下降沿结果：

![img](https://upload-images.jianshu.io/upload_images/24714066-3dbaa5a2fc60cee0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



遇到的问题

![img](../../../浏览器下载/QQ下载/1978451498/Image/C2C)ZU(RXA[$SL`0~1KZ98Z(B7.png)

## debug成果

![](https://upload-images.jianshu.io/upload_images/24714066-fa1ac35bda4075b7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 实验结果

1、需要仿真图一张，控制台打印输出图一张，要求仿真图中包含 pc、instr、rs、rt、rd、result 信号， 仿真图应在控制台打印输出 Simulation succeeded 时截图。控制台打印输出图为此时截图

