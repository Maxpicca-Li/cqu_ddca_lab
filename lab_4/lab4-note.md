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

