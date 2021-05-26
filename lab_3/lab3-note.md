2021年5月20日 13点57分

![image-20210520135232247](https://i.loli.net/2021/05/20/Tga1DmiNFlf9Inw.png)

![image-20210526170814194](https://i.loli.net/2021/05/26/wI2pQytdMZYcTHx.png)



## 实验重点

不同类型指令在数据通路中的执行路径

## 相关设置原理

1、`primitives output register`

这一设置主要是在RAM的输出端口添加一个**寄存器**，对输出的数据进行打一拍缓存操作。如果勾选上这个，在高频时钟情况下，可以有效的保证输出信号满足**建立和保持时间**。而RAM本身默认读出数据延时为一拍，则RAM读出数据的总延时为2个时钟单位。

2、`Operating Mode`

主要包括了No Change , Write First和Read First，顾名思义，主要指的读出数据的先后顺序。在No Change模式下，写操作不改变输出端数据，在Write First模式下，如果对同一地址进行读写，则先写后读，在Read First模式下，如果对同一地址进行读写，则先读后写。


## 实验记录

### 工作记录

> 完成了什么工作

### 问题记录



001000_00000_00010_0000000000000101

![image-20210526200023159](https://i.loli.net/2021/05/26/Rk6VMtoG2ZUO7Iq.png)

## 实验结果

需要仿真图一张，控制台打印输出图一张，要求仿真图中包含 pc、instr、rs、rt、rd、result 信号， 仿真图应在控制台打印输出 Simulation succeeded 时截图。控制台打印输出图为此时截图。

![image-20210526205012447](https://i.loli.net/2021/05/26/USqt9CixlnFeKJT.png)