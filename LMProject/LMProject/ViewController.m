//
//  ViewController.m
//  LMProject
//
//  Created by zhanglimin on 2022/6/16.
//

#import "ViewController.h"

#import "LMTestControl.h"
#import "Person.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import <malloc/malloc.h>
#import "YZMonitorRunloop.h"
#import "PBLagMonitor.h"
#import "ClassB.h"
#import <pthread/pthread.h>
#import "Car.h"
#import "BBA_BWM.h"
#import "TestVC.h"
#import "TestWebController.h"
#import <WebKit/WebKit.h>
#import "InteractivePetViewController.h"

@interface LMMediaPlaybackBridge : NSObject <WKScriptMessageHandler>
@end

@implementation LMMediaPlaybackBridge

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (![message.name isEqualToString:@"mediaPlayback"]) {
        return;
    }
    NSLog(@"[LMMediaBridge] body = %@", message.body);
}

@end

struct structA {
    double a;
    char b;
    int c;
    short d;
}sta;

struct structB {
    int a;
    int b;
    char c;
    short d;
}stb;

static UIView *staticView;

@interface ViewController ()
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic,strong) PBLagMonitor *monitor;
@property (atomic,assign) NSInteger index;
@property (nonatomic,strong) NSLock *lock;
@property (nonatomic,assign) pthread_mutex_t mlock;
@property (nonatomic,assign) BOOL isAddView;
@property (nonatomic,assign) NSInteger value;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) WKWebView *mediaTestWebView;
@property (nonatomic,strong) LMMediaPlaybackBridge *mediaPlaybackBridge;
@end

@implementation ViewController {
//    pthread_mutex_t mlock;
}

struct TestStruct {
    int a;
    int b;
};

#define LMNumber = 1022


- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加视频播放测试按钮
    [self setupVideoTestButton];

//    NSString *testStr = @"ABCDE";
//    NSArray *arr = [testStr componentsSeparatedByString:@"*"];
//    NSLog(@"%@",arr);

//    [self testFunctio];
//    NSString *st = @"s";
//    LMUtil *util = [LMUtil new];
//    if ([util isStringEmpty:st]) {
//        NSLog(@"YES, %@ is empty",st);
//    }else {
//        NSLog(@"NO, %@ is not empty",st);
//    }




    // Do any additional setup after loading the view.
//    self.lock = [NSLock new];
    
//    Car *c = [[Car alloc] init];
//    [c run];
//
//    BBA_BWM *bba = [BBA_BWM new];
//    [bba run];
    
//    id obj = [Vichile class];
//    id obj1 = object_getClass([Car class]);
//    id obj2 = objc_getMetaClass("Car");
//    BOOL isMeta = [Car isKindOfClass:obj1];
//    BOOL isMeta = [Car isKindOfClass:obj2];
    
//    if (isMeta) {
//        NSLog(@"Car isKindOfClass [Vichile class]");
//    }else {
//        NSLog(@"Car isNotKindOfClass [Vichile class]");
//    }
    
    
    
//    Car *c = [[Car alloc] init];
//    c->_year = 18;
//    c->_kilometres = 2;
//
//    NSLog(@"Car instanceSize: %zd",class_getInstanceSize([c class]));
//    NSLog(@"Car realSize: %zd",malloc_size((__bridge const void *)(c)));
//
//    BBA_BWM *bba = [[BBA_BWM alloc] init];
//    bba.nameplate = @"奥迪A6L";
//
//    NSLog(@"BBA_BWM instanceSize: %zd",class_getInstanceSize([bba class]));
//    NSLog(@"BBA_BWM realSize: %zd",malloc_size((__bridge const void *)(bba)));
    
    
//    pthread_mutex_init(&_mlock, NULL);
//    NSLog(@"%lu  %lu",sizeof(sta),sizeof(stb));
    
//    Person *p1 = [Person alloc];
//    NSLog(@"%lu  %lu",class_getInstanceSize(Person.class),malloc_size((__bridge const void)(p1)));
//    NSLog(@"%@ - %lu - %lu - %lu",p1,sizeof(p1),class_getInstanceSize([Person class]),malloc_size(CFBridgingRetain(p1)));
//
//    Person *p2 = [p1 init];
//    Person *p3 = [p2 init];
//    NSLog(@"p1: %@ - %p - %p",p1,p1,&p1);
//    NSLog(@"p1: %@ - %p - %p",p2,p2,&p2);
//    NSLog(@"p1: %@ - %p - %p",p3,p3,&p3);
    
//    YZMonitorRunloop *runloop = [YZMonitorRunloop sharedInstance];
//    runloop.limitMillisecond = 2000;
//    runloop.standstillCount = 1;
//    [runloop startMonitor];
    
//    _monitor = [PBLagMonitor new];
//    [_monitor beginMonitor];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"开始卡顿");
//        [NSThread sleepForTimeInterval:2];
//    });
    
//    staticView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    staticView.backgroundColor = UIColor.redColor;
//    [self.view addSubview:staticView];
    
//    [self lm_setupMediaBridgeTestWebView];
}

#pragma mark - 视频播放测试按钮

- (void)setupVideoTestButton {
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    testButton.frame = CGRectMake(20, 100, 200, 50);
    [testButton setTitle:@"测试视频切换效果" forState:UIControlStateNormal];
    testButton.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.8];
    [testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    testButton.layer.cornerRadius = 8;
    testButton.layer.masksToBounds = YES;

    [testButton addTarget:self action:@selector(openVideoPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];

    // 添加说明标签
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width - 40, 60)];
    tipLabel.text = @"点击按钮进入视频播放页面\n点击屏幕中上部区域可触发动画切换\n观察是否有闪烁/黑屏现象";
    tipLabel.numberOfLines = 3;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLabel];
}

- (void)openVideoPlayer {
    NSLog(@"🎬 打开视频播放器进行切换测试");

    InteractivePetViewController *petVC = [[InteractivePetViewController alloc] init];
    petVC.modalPresentationStyle = UIModalPresentationFullScreen;

    // 添加关闭按钮（方便返回）
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(20, 50, 60, 40);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    closeButton.layer.cornerRadius = 8;
    [closeButton addTarget:self action:@selector(dismissVideoPlayer) forControlEvents:UIControlEventTouchUpInside];
    [petVC.view addSubview:closeButton];

    [self presentViewController:petVC animated:YES completion:^{
        NSLog(@"✅ 视频播放页面已打开");
    }];
}

- (void)dismissVideoPlayer {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"✅ 已关闭视频播放页面");
    }];
}

- (void)lm_setupMediaBridgeTestWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.mediaPlaybackBridge = [LMMediaPlaybackBridge new];
    [config.userContentController addScriptMessageHandler:self.mediaPlaybackBridge name:@"mediaPlayback"];
    
    self.mediaTestWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.mediaTestWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mediaTestWebView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MediaBridgeTest" ofType:@"html"];
    if (path.length == 0) {
        NSLog(@"[LMMediaBridge] MediaBridgeTest.html 未加入 Copy Bundle Resources");
        return;
    }
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSURL *readAccessURL = [fileURL URLByDeletingLastPathComponent];
    [self.mediaTestWebView loadFileURL:fileURL allowingReadAccessToURL:readAccessURL];
}




int b = 2;
- (void)globalBlock {
    /*
     GlobalBlock:
     没有捕获变量或者只捕获了全局变量/静态变量的 block
     */
    static int a = 0;
    void(^globalBlock)(void) = ^{
        NSLog(@"%d",a);
        NSLog(@"self.value = %ld",(long)self.value);
        NSLog(@"%d",b);
    };
    a = 2;
    self.value = 2;
    globalBlock();
    NSLog(@"%@",globalBlock);
}

- (void)aBlock {
    int a = 2;
    NSLog(@"%@",^{
        NSLog(@"%d",a);
    });
}

- (void)aTest:(void(^)(id value))handler {
    NSLog(@"-0-   %@",[handler class]);
    handler(self);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    TestWebController *vc = [TestWebController new];
//    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:vc animated:true completion:nil];
    
//    [self testFunctio];
//    TestVC *vc = [TestVC new];
//    [self presentViewController:vc animated:YES completion:nil];
    
    
//    NSLog(@"%s", __FUNCTION__);
//    exit(0);
    
//    [self aTest:^(id a){
//        NSLog(@"-1- %@ \n -%@",self,a);
//    }];
    
    //    [self globalBlock];
//    [self aBlock];
//    self.isAddView = !self.isAddView;
//
//    if (self.isAddView) {
//        [staticView removeFromSuperview];
//        staticView = nil;
//    }else {
//        staticView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//        staticView.backgroundColor = UIColor.redColor;
//        [self.view addSubview:staticView];
//    }
    
    
//    [self test2];
//    [self test1];
    
//    LMTestControl *vie = [[LMTestControl alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.view addSubview:vie];
//    [vie test];
//    [ClassB test];
    
    
    
//    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
//    self.index = 0;
//    __weak typeof(self) wsf = self;
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        __strong typeof(wsf) stf = wsf;
//        for (int i = 0; i<1000; i++) {
////            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
////            [self.lock lock];
//            pthread_mutex_lock(&stf->_mlock);
////            @synchronized (self) {
//                self.index = self.index + 1;
//            pthread_mutex_unlock(&self->_mlock);
////            }
//            [self.lock unlock];
////            dispatch_semaphore_signal(sema);
////            NSLog(@"%d --1-- %ld",i,(long)self.index);
//        }
//    });
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for (int i = 0; i<1000; i++) {
////            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
////            self.index = self.index + 1;
////            @synchronized (self) {
//            pthread_mutex_lock(&self->_mlock);
////            [self.lock lock];
//                self.index = self.index + 1;
//            pthread_mutex_unlock(&self->_mlock);
////            }
////            [self.lock unlock];
////            dispatch_semaphore_signal(sema);
////            NSLog(@"%d --2-- %ld",i,(long)self.index);
//        }
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%ld --2",(long)self.index);
//    });
    
    
}

- (void)test2 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"0");
        dispatch_block_wait(^{
            NSLog(@"1");
            //        sleep(2);
        }, DISPATCH_TIME_FOREVER);
        NSLog(@"2");
    });
    
//    NSLog(@"0");
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"1");
//    });
//    NSLog(@"2");
}

- (void)test1 {
    NSLog(@"0");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
        dispatch_sync(dispatch_queue_create("dsf", DISPATCH_QUEUE_CONCURRENT), ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"4");
}

-(void)testFunctio {
//    [self concurrentQueueSyncTest];
//    [self serialQueueAsyncTest];
//    [self serialQueueSyncTest];
//    [self barrierTest];
//    [self semaphoreTest];
    [self sourceTimerTest];
}

- (void)sourceTimerTest {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"timer action");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_source_cancel(timer);
        });
    });
    // 启动
    dispatch_resume(timer);
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"timer canceled");
    });
}

- (void)semaphoreTest {
//        dispatch_queue_t queue = dispatch_queue_create("com.sema.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    if (!_array) {
        _array = [NSMutableArray array];
    }
    for (int i = 0; i < 10000; ++i) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            [self.array addObject:@(i)];
            printf("%d \n",i);
            dispatch_semaphore_signal(semaphore);
//            sleep(1);
        });
    }

}

- (void)barrierTest {
    dispatch_queue_t serialQueue = dispatch_queue_create("serial.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(serialQueue, ^{
        NSLog(@"111");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"222 -- begin");
        sleep(5);
        NSLog(@"222 -- end");
    });
    dispatch_barrier_async(serialQueue, ^{
        NSLog(@"--  barrier -- ");
        sleep(5);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"333");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"444");
    });
    
}

- (void)concurrentQueueSyncTest {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.test.concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"Before Sync %@",[NSThread currentThread]);
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"1111 %@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"2222  sleet 6s");
        sleep(5);
    });
    NSLog(@"After Sync %@",[NSThread currentThread]);
    
    NSLog(@"DeadLock Begin 000 ");
    dispatch_async(concurrentQueue, ^{
        NSLog(@"DeadLock Begin 111  %@",[NSThread currentThread]);
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"DeadLock  %@",[NSThread currentThread]);
        });
        NSLog(@"DeadLock End 111");
        dispatch_async(concurrentQueue, ^{
            NSLog(@"33333  %@", [NSThread currentThread]);
        });
        NSLog(@"4444444");
    });
    NSLog(@"DeadLock End");
}

- (void)serialQueueSyncTest {
    NSLog(@"Before Sync 线程 - %@",[NSThread currentThread]);
    dispatch_queue_t serialQueue = dispatch_queue_create("com.test.serial", NULL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"--- 1 ---- %@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"--- 2 等待3s ---");
        sleep(5);
    });
    NSLog(@"After Sync");
    
    NSLog(@"DeadLock Begin 000 ");
    dispatch_async(serialQueue, ^{
        NSLog(@"DeadLock Begin 111  %@",[NSThread currentThread]);
        dispatch_sync(serialQueue, ^{
            NSLog(@"DeadLock");
        });
        NSLog(@"DeadLock End 111");
        dispatch_async(serialQueue, ^{
            NSLog(@"33333  %@", [NSThread currentThread]);
        });
        NSLog(@"4444444");
    });
    NSLog(@"DeadLock End");
}

- (void)serialQueueAsyncTest {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.test.serial", NULL);
    NSLog(@"Before Async %@",[NSThread currentThread]);
    dispatch_async(serialQueue, ^{
        NSLog(@"1111  %@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"2222");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"3333");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"4444 等待2s");
        sleep(2);
    });
    NSLog(@"After Async");
}

@end
