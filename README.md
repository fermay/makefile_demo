# 【目的】  
此项目旨在构建一个多平台的编译脚本    

# 【概览】 

> 1、旨在阐述怎么根据机器支持的最高指令集，设置相应的汇编函数（汇编函数需要自己写）  
> 2、旨在阐述怎么编写不同平台的Makefile.

# 【编译说明】  
>  1、linux  
>> #编译脚本路径：build  
>> [1]、32位  
>>> make -f Makefile_demo platform=x86_32  

>> [2]、64位  
>>> make -f Makefile_demo platform=x86_64  

>> [3]、arm32  
>>> make -f Makefile_Demo_unix platform=arm32 CROSS=xxxx     
>>> For example: make -f Makefile_Demo platform=arm32 CROSS=arm-linux-androideabi-   

> 2、android  
>>  ##编译脚本路径：build/android  
>>> build_andorid.py F:\software\android-ndk-r10e pure_c=0

> 3、windows  
>> #编译脚本路径：build  
>> [1]、32位  
>>> make -f Makefile_demo platform=x86_32 

>> [2]、64位  
>>> make -f Makefile_demo platform=x86_64

> 4、mac
>> [1]、32位  //待验证 
>>> make -f Makefile_demo target_plat=mac platform=x86_32 

>> [2]、64位  
>>> make -f Makefile_demo target_plat=mac platform=x86_64 

> 5、ios


