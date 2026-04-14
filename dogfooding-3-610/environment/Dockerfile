# 1. 基础镜像：Windows系统 + JDK8
FROM mcr.microsoft.com/openjdk:8-windowsservercore-ltsc2022

# 2. 安装Maven构建工具（适配Windows容器）
RUN powershell -Command \
    Invoke-WebRequest -Uri "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip" -OutFile "C:\maven.zip"; \
    Expand-Archive -Path "C:\maven.zip" -DestinationPath "C:\"; \
    Remove-Item -Path "C:\maven.zip" -Force;

# 3. 配置Maven环境变量
ENV MAVEN_HOME=C:\apache-maven-3.9.6
ENV PATH=%MAVEN_HOME%\bin;%PATH%

# 4. 设置工作目录
WORKDIR C:\app

# 5. 复制repo目录下的所有项目文件到容器的C:\app
COPY repo/ ./

# 6. 编译项目（
RUN mvn clean compile

# 7. 打包项目
RUN mvn package -DskipTests

# 8. 暴露项目启动端口10888
EXPOSE 10888

# 9. 默认启动命令
CMD ["mvn", "spring-boot:run"]