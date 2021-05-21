## ALU

这里也有了bug

![image-20210510095106328](https://i.loli.net/2021/05/10/P9XCSwJiVnGpyUv.png)



pipeX_valid  第X级流水线上，1 有效数据， 0 没有数据 / 空

pipeX_data  第X级流水线上的数据

pipX_allowin  能否被上一级刷新

pipX_readygo 能否用于刷新下一级

pipX_to_pipX+1_valid  pipX能否进入pipX+1



## 8Bit 4级流水——带有暂停刷新功能

为什么需要暂停刷新功能？这是因为不同的指令需要不同的周期，在执行多周期指令的时候，**如果cpu不支持动态指令调度和多发射，那么必须停顿**。



一直卡再这里：

![image-20210510091436230](https://i.loli.net/2021/05/10/no8Pj37QDvCpRVY.png)

> 解决：
>
> `define T = 10` 因该写成`define T 10`

仿真结果图：

2021年5月11日

![image-20210511121340103](https://i.loli.net/2021/05/11/xLco7CFNsXPhDdJ.png)



## 报错

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]



[DRC NSTD-1] Unspecified I/O Standard: 32 out of 60 logical ports use I/O standard (IOSTANDARD) value 'DEFAULT', instead of a user assigned specific value. This may cause I/O contention or incompatibility with the board power or connectivity affecting performance, signal integrity or in extreme cases cause damage to the device or the components to which it is connected. To correct this violation, specify all I/O standards. This design will fail to generate a bitstream unless all logical ports have a user specified I/O standard value defined. To allow bitstream creation with unspecified I/O standard values (not recommended), use this command: set_property SEVERITY {Warning} [get_drc_checks NSTD-1].  NOTE: When using the Vivado Runs infrastructure (e.g. launch_runs Tcl command), add this command to a .tcl file and add that file as a pre-hook for write_bitstream step for the implementation run. Problem ports: res[31:0].



[DRC UCIO-1] Unconstrained Logical Port: 32 out of 60 logical ports have no user assigned specific location constraint (LOC). This may cause I/O contention or incompatibility with the board power or connectivity affecting performance, signal integrity or in extreme cases cause damage to the device or the components to which it is connected. To correct this violation, specify all pin locations. This design will fail to generate a bitstream unless all logical ports have a user specified site LOC constraint defined.  To allow bitstream creation with unspecified pin locations (not recommended), use this command: set_property SEVERITY {Warning} [get_drc_checks UCIO-1].  NOTE: When using the Vivado Runs infrastructure (e.g. launch_runs Tcl command), add this command to a .tcl file and add that file as a pre-hook for write_bitstream step for the implementation run.  Problem ports: res[31:0].