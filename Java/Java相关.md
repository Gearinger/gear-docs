### 创建Maven仓库

#### Docker 安装 Nexus

~~~sh
Docker search nexus
~~~

---

### 下载Java

https://www.oracle.com/java/technologies/javase-downloads.html

---

### Maven配置

- 下载及安装
- setting.xml配置

~~~xml
<mirrors>
    <mirror>
        <id>alimaven</id>
        <name>aliyun maven</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        <mirrorOf>central</mirrorOf>       
    </mirror>
</mirrors>

<profiles>
	<profile>    
		<id>jdk-1.8</id>    
		<activation>    
          <activeByDefault>true</activeByDefault>    
          <jdk>1.8</jdk>    
		</activation>    
		<properties>    
			<maven.compiler.source>1.8</maven.compiler.source>    
			<maven.compiler.target>1.8</maven.compiler.target>    
			<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>    
		</properties>    
	</profile>
  </profiles>
~~~

