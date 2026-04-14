#1.基础镜像
FROM mcr.microsoft.com/windows/servercore:ltsc2022

#2.安装 IIS
RUN dism /online /enable-feature /featurename:IIS-WebServer /all /quiet

#3.工作目录
WORKDIR C:\app

#4.复制项目文件
COPY repo/ ./

#5.默认启动命令
CMD ["cmd.exe"]