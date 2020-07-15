#pod 不完全指令集合

###1、pod cache
Manipulate the CocoaPods cache（操作cocoapods的缓存）

* **pod cache list**  
列出pod缓存，包括下载过的pod第三方库的version，type，spec的json存储信息以及pod库下载的地址
![](https://wj-blog.oss-cn-beijing.aliyuncs.com/picgo/peipei/截屏2020-07-12 下午7.10.44.png)
* **pod cache clean**  清除以上所述pod的缓存

###2、pod deintegrate

```
Deintegrate your project from CocoaPods. Removing all
traces of CocoaPods from your Xcode project.
(从你的项目中把cocoapods分离出来，并且移除cocoapods的有关痕迹)

If no xcode project is specified, then a search for an
Xcode project will be made in the current directory.
(如果没有指定xcode项目，那么将在当前目录中搜索Xcode项目。)
```
言简意赅的说就是移除pod下载的内容，就是你pod install出来的东西都给你移除了啦，但是podfile还是会给你保留哒!

###3、pod env 
Display pod environment. 展示pod的环境信息包括一些列的环境数据，比如cocoapods的版本，ruby环境，当前主机信息，Xcode版本，git版本等等内容，若有疑问，敬请尝试！

###4、pod init
cd到你的项目地址，直接pod init，你就会直接得到一份podfile文件，上面写好了你的target还有它的格式，你只需要加入你需要的库名就欧克！（天哪，以前的我愚蠢的赋值了一份pod格式文件内容，每次需要用就去C+V一番，蠢爆了！！！）

###5、pod install
这个就超级无敌熟悉了，相信没人会不知道的。但是为了保持文档一致性，还是查查，没准又意外发现更蠢的自己呢。

```
Downloads all dependencies defined in Podfile and creates an Xcode Pods library project in "./Pods".
(1、创建./pod文件)

The Xcode project file should be specified in your `Podfile` like this: project 'path/to/XcodeProject.xcodeproj'
(2、创建引用pod资源的.xcodeproj文件)

If no project is specified, then a search for an Xcode project will be made. If more than one Xcode project is found, the command will raise an error.
(3、如果没有指定项目，那么将搜索Xcode项目。如果发现了多个Xcode项目，该命令将引发一个错误。)

This will configure the project to reference the Pods static library, add a build configuration file, and add a post build script to copy Pod resources.
(4、这将配置项目来引用Pods静态库，添加一个构建配置文件，并添加一个后构建脚本来复制Pod资源。)

This may return one of several error codes if it encounters problems. * `1` Generic error code * `31` Spec not found (i.e out-of-date source repos, mistyped Pod name etc...)
(5、可能会返回错误：“1”通用错误代码，“31”源错误)
```
emmmmmm 都在认知范围内，看看可选命令参数吧：

* **pod install --repo-update**
在install之前执行pod repo update---该命令请看下面内容
* **pod install --deployment** 不允许在install期间修改podfile或podfile.lock文件
* **pod install --clean-install** 会全部重新下载pod内容，效果同你项目第一次跑pod install，一般不建议用此命令


###6、pod ipc -----进程间通信
* **pod ipc list**  
* **pod ipc podfile PATH** 
* **podfile-json**
* **repl**
* **spec**
* **update-search-index**

###7、pod lib
* **pod lib create NAME**  以 NAME 命名，创建一个库的基础配置，你若是需要写自己的第三方库，这个命令可是基础嘞！得到的结果是一个超级基础的库的配置，修改spec的内容，可发布到你自己的仓库开源使用
* **pod lib lint** 检查该文件夹下的.podspec文件的规范
![](https://wj-blog.oss-cn-beijing.aliyuncs.com/picgo/peipei/20200712211003.png)

###8、pod list
列举所有pod仓库的第三方库，注意该命令可能会让电脑卡死，毕竟现在的开源库已经超级庞大了！查找并列出来可是一项超级大的工程。

###9、pod outdated
cd 到要检查的路径下，检查.lock文件中是否有可更新的项目，包括cocoapods版本，可以用来在优化项目的时候检查，建议多用新新的库哦，虽然你会趟坑，but新的库毕竟是改了bug过后的，大部分会更好用一些呢！

###10、pod plugins

###11、pod repo ----管理源文件
国内被墙，需要镜像下载呀，要换源啊！无奈！

* **pod repo add NAME URL [BRANCH]** 增加源文件的地址，其实是增加镜像地址，加快pod intall的速度
* **pod repo add-cdn NAME URL** 增加源文件的cdn地址，cdn的概述，emmmm，以后见真章
* **pod repo lint** 检查repo的文件的规范
* **pod repo list** 列出所有的源
* **pod repo push REPO [NAME.podspec]** 将新的规范push到源文件
* **pod repo remove NAME** 移除NAME的源
* **pod repo update** 更新源文件，根据下载过的内容检查更新增量下载

###12、pod search 
emmmm，接触pod最先接触的命令应该就是介个了，搜索你想要的库的名字，支持模糊，字母大小写忽略搜索

###13、pod setup
更新pod的版本啦

###14、pod spec
* **pod spec cat [QUERY]** 查询QUERY对应的.podspec文件
* **pod spec create [NAME|https://github.com/USER/REPO]** 创建一个.podspec文件，并以NAME名字命名，并且后面的url有效即会自动填充内容，否则需要自己去填充内容
* **pod spec edit [QUERY]** 编辑QUERY.podspec文件
* **pod spec lint** 检查当前路径下的.podspec文件的规范
* **pod spec which [QUERY]** 查询输入第三方库名字所对应的.podspec文件在当前电脑的路径

###15、pod trunk
* **pod trunk add-owner POD OWNER_EMAIL** 为pod添加管理员啦，多人协作开发某个项目
* **pod trunk delete NAME VERSION** 删除pod对应的version，一旦删除便无法提交---后续update后待测试
* **pod trunk deprecate NAME** 删除名字为pod的第三方库
* **pod trunk info NAME** 输出该pod的信息，包括version(发布时间)，owners列表
* **pod trunk me** 输出当前pod登录者的信息，会列出当前用户的写的pods
* **pod trunk push [path]** 将 path 的.podspec 文件推到远程仓库中，本地会自动检查规范，因此在此命令之前建议先 lint检查规范，若没有加地址会默认在当前目录下找.podspec 文件上传。若是第一次上传则会默认在仓库创建该项目；
* **pod trunk register  EMAIL [YOUR_NAME]** 在添加项目之前，pod 需要知道你的身份，否则你无法进行push，这就类似一个登陆，注册你的账号和邮箱，邮箱激活一下，之后 pod 发项目会记得这个身份，若要删除，则需要清除缓存，可见 pod cache 命令详解；
* **pod trunk remove-owner POD OWNER-EMAIL** 移除某 pod 的管理人

###16、pod try
**pod try NAME | URL** 会在当前目录下载该 pod 内容，需要提供 NAME 或者 URL

###17、pod update
* **pod update POD1 POD2 POD3** 更新 pod 的环境依赖，以及版本号，后面若没有 pod 名字，会忽略 pod.lock文件，全部更新。
* **pod update --no-repo-update** 忽略源文件去更新，会比较快一些


