#App 的生命流程
**三大部分**：<br>
1、APP启动流程<br>
2、APP初始化流程<br>
3、APP运行时生命周期<br>


####一、App 的启动流程
* 1：加载info.plist文件----确认支持APP运行的基本运行条件，如启动图片，支持版本信息，是否全屏或者横屏还是竖屏，等<br>
* 2：创建沙盒（iOS8后，每次启动都会生成新的沙盒路径---数据如何移动的呢）<br>
* 3：根据info.plist检查权限，如推送，获取位置，网络获取等等-（在加载到启动页一般会显示权限弹框请求是否允许）<br>
* 4：加载Mach-O文件, 读取dyld路径并运行dyld动态连接器（内核加载主程序，dyld只会负责动态库的加载）<br>
    * 4.1 dyld寻找合适的CPU运行环境，加载程序运行所需要的依赖库和自己写的.h.m文件编译成的.o可执行文件，并对库进行链接
    * 4.2 加载所有的方法（runtime此时被初始化）
    * 4.3 加载C函数，加载category扩展（runtime对所有类结构进行初始化）
    * 4.4 加载C++静态函数，加载OC的load方法
    * 4.5 最后dyld返回函数地址，main函数被调用
  
  
  
**启动优化的点：**<br>

* 减少系统依赖库，减少第三方库（库越少加载的速度越快，就越早返回程序入口main函数的地址）<br>
* 对于自己加入的库能静态就选择静态，少用动态库，动态库的加载方式比静态库慢，若必须要动态库，把多个非系统的动态库合并成一个动态库，使用 frameWork 根据情况选择 optional 和 required，若该 framework 支持所有 iOS 系统版本，设置为 required，否则设置为 optional，optional 会有一些额外的检查会导致加载变慢<br>
* 减少项目文件的 category，静态变量等的使用数量<br>
* 使用 appcode 检查项目中没有使用的类和方法-----其实方法和类的占用很小很小<br>
* 图片资源尽量压缩到最小，启动加载时候回加载图片资源进行 IO 操作，因此图片小一点加载的速度也会提升一点<br>
* 内存上的优化，类和方法名不要过于长，每个方法名和类名都在_cstring段存了相应字符串值，所以名字的长短对可执行文件大小有影响，也影响加载速度耗费内存；OC 的动态特性，是加载后通过他们名字反射找到再进行调用，OC 的对象模型会把名字的字符串都保存下来----其实这个也是很小的，这些占用的内存其实很小很小几乎可以忽略不计

**冷启动&&热启动**
冷启动和热启动并非是指是否 kill 掉程序的重启，而是若程序刚刚被程序运行过一次，那么程序的代码会被 dyld 缓存起来，即使沙雕进程再次重启也会相对而言快一点，如果长时间没有启动或者当前的 dyld 缓存已经被其他应用占据，那么这次启动所花费的时间就会比较长一点，这才是冷启动和热启动的区别，在于 dyld 是否被占用或者释放。

**启动时间的测试方法**
在Xcode 中的 Edit -> Run -> Auguments 将环境变量DYLD_PRINT_STAISTICS 设为启动 APP 时控制台会输出的启动耗时内容

####APP 的初始化流程
* 1.main 函数
* 2.执行 UIApplicationMain
   * 2.1 创建 UIApplication 对象
   * 2.2 创建 UIApplication 的 delegate 对象
   * 2.3 创建 MainRunloop
   * 2.4 delegate 对象开始处理（监听）系统事件（没有 storyboard）
* 3.根据 info.plist 获得最主要storyboard 的文件名，加载最主要的 storyboard（当有 storyboard）
* 4.程序启动完毕的时候，就会调用代理的 application：didFinishLaunchIngWithOptions：方法<br>  
    在 application:didFinishLaunchingWithOptions:中创建 UIWindow<br>
    创建 UIWindow 和 rootViewCOntroller<br>
* 5.最终显示你的第一个窗口

**初始化的优化点**
1.尽量使用纯代码，xib 或者 storyboard 搭建的 UI 框架到编译的时候也还是要解析成代码编译成.O 文件执行<br>
2.尽量缩减 application:didFinishLaunchingWithOption:代码中执行的时间。能多线程就多线程，能后台执行就后台执行，部分可以选择懒加载或者后台加载，不要阻塞主线程造成启动时间的加长。

####生命周期
vievwController 的生命周期

```
#pragma mark --- sb相关的life circle
//执行顺序1
// 当使用storyBoard时走的第一个方法。这个方法而不走initWithNibName方法。
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
     NSLog(@"1----%s", __func__);
    if (self = [super initWithCoder:aDecoder])
     {
          //这里仅仅是创建self，还没有创建self.view所以不要在这里设置self.view相关操作
     }
    return self;
}
#pragma mark --- life circle
//执行顺序1
// 当控制器不是SB时，都走这个方法。(xib或纯代码都会走这个方法)
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSLog(@"1-----%s", __func__);
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        //这里仅仅是创建self，还没有创建self.view所以不要在这里设置self.view相关操作
    }
    return self;
}

//执行顺序2
// xib加载完成时调用，纯代码不会调用。系统自行调用
- (void)awakeFromNib {
    [super awakeFromNib];
     //当awakeFromNib方法被调用时，所有视图的outlet和action已经连接，但还没有被确定。
     NSLog(@"2-----%s", __func__);
}

//执行顺序3
// 加载控制器的self.view视图。(默认从nib)
- (void)loadView {
    //该方法一般开发者不主动调用，应该由系统自行调用。
    //系统会在self.view为nil的时候调用。当控制器生命周期到达需要调用self.view的时候会自行调用。
    //或者当我们设置self.view=nil后，下次需要用到self.view时，系统发现self.view为nil，则会调用该方法。
    //该方法一般会首先根据nibName去找对应的nib文件然后加载。
    //如果nibName为空或找不到对应的nib文件，则会创建一个空视图(这种情况一般是纯代码)
    NSLog(@"3------%s", __func__);
    //该方法比较特殊，如果重写不能调用父类的方法[super loadView];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

//执行顺序4
//视图控制器中的视图加载完成，viewController自带的view加载完成后会第一个调用的方法
- (void)viewDidLoad {
    //当self.view被创建后，会立即调用该方法。一般用于完成各种初始化操作
    NSLog(@"4------%s", __func__);
    [super viewDidLoad];
}

//执行顺序5
//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"5-----%s", __func__);
    [super viewWillAppear:animated];
}

//执行顺序6
// view 即将布局其 Subviews
- (void)viewWillLayoutSubviews {
    //view即将布局它的Subviews子视图。 当view的的属性发生了改变。
    //需要要调整view的Subviews子视图的位置，在调整之前要做的工作都可以放在该方法中实现
    NSLog(@"6-----%s", __func__);
    [super viewWillLayoutSubviews];
}

//执行顺序7
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews {
    //view已经布局其Subviews，这里可以放置调整完成之后需要做的工作
    NSLog(@"7-----%s", __func__);
    [super viewDidLayoutSubviews];
}

//执行顺序8
//视图已经出现
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"8------%s", __func__);
    [super viewDidAppear:animated];
}

//执行顺序9
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"9-----%s", __func__);
    [super viewWillDisappear:animated];
}

//执行顺序10
//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"10-------%s", __func__);
    [super viewDidDisappear:animated];
}

//执行顺序11
// 视图被销毁
- (void)dealloc {
    //系统会在此时释放掉init与viewDidLoad中创建的对象
    NSLog(@"11-----%s", __func__);
}

//执行顺序12
//出现内存警告  //模拟内存警告:点击模拟器->hardware-> Simulate Memory Warning
- (void)didReceiveMemoryWarning {
    //在内存足够的情况下，app的视图通常会一直保存在内存中，但是如果内存不够，一些没有正在显示的viewController就会收到内存不足的警告。
    //然后就会释放自己拥有的视图，以达到释放内存的目的。但是系统只会释放内存，并不会释放对象的所有权，所以通常我们需要在这里将不需要显示在内存中保留的对象释放它的所有权，将其指针置nil。
    NSLog(@"12-----%s", __func__);
    [super didReceiveMemoryWarning];
}


```
    
    
**load的调用时机与规则**<br>
当类被程序引用的时候就会调用类的+load方法，当程序启动时，会加载相关Mach-O文件，这个时候就会查找项目中那些文件被引用，这个时候就会调用+load。<br>
1.当父类和子类都实现+load方法时,父类+load方法的执行顺序要优先于子类执行<br>
2.当子类未实现+load方法时,不会调用父类+load方法<br>
3.类中的+load方法执行顺序要优先于类别(Category)中的+load方法，虽然在APP启动流程中，Category的加载顺序在OC的+load方法之前，但是Category中的+load方法的执行顺序却在OC类的+load方法之后。<br>
4.当有多个类别(Category)都实现了+load方法时,这几个+load方法都会执行,其执行顺序与类别文件在Build Phases里的Compile Sources中出现顺序一样。<br>
5.由4可以得知，当有多个不同的类或者不同类的Category的时候,每个类+load 执行顺序与其在Compile Sources出现的顺序一致。<br>

**+initialize的调用实际与规则**<br>
不同于+load，类中的+initialize是在引用类被首次使用时被调用。也就是说也许你工程里import了一个类，但是你并没有调用这个类的任何方法，那么这个类的+initialize方法就不会被调用。而+initialize方法也只会调用一次，那就是首次调用这个类的任意方法时。<br>
1.父类的+initialize方法会比子类的先执行<br>
2.当子类未实现+initialize方法时,会调用父类+initialize方法,子类实现+initialize方法时,会覆盖父类+initialize方法.<br>
3.当有多个Category都实现了initialize方法,会覆盖类中的方法,只执行一个(会执行Compile Sources 列表中最后一个Category 的initialize方法，因为覆盖的原因，所以最后一个覆盖了前面的)

