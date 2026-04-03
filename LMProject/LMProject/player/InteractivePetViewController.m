//
//  InteractivePetViewController.m
//  LMProject
//
//  Created on 2026-04-03.
//  透明视频播放的互动宠物控制器
//

#import "InteractivePetViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h> // 必须引入，用于处理视频时间 (kCMTimeZero)

@interface InteractivePetViewController ()

// 双播放器方案：实现无缝切换
@property (nonatomic, strong) AVPlayer *playerA;        // 播放器 A
@property (nonatomic, strong) AVPlayer *playerB;        // 播放器 B
@property (nonatomic, strong) AVPlayerLayer *layerA;    // 图层 A
@property (nonatomic, strong) AVPlayerLayer *layerB;    // 图层 B

// 视频资源 URL
@property (nonatomic, strong) NSURL *idleURL;
@property (nonatomic, strong) NSURL *testURL;

// 当前状态
@property (nonatomic, assign) BOOL isPlayingIdle;       // 当前应该播放哪个视频
@property (nonatomic, assign) BOOL isUsingPlayerA;      // 当前正在使用哪个播放器
@property (nonatomic, assign) NSInteger loopCount;

// 容器视图
@property (nonatomic, strong) UIView *playerContainerView;

@end

@implementation InteractivePetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];

    self.loopCount = 0;

    [self setupVideoURLs];
    [self setupPlayer];

    // 开始自动循环播放
    [self startAutoLoop];
}

// 加载视频资源 URL
- (void)setupVideoURLs {
    self.idleURL = [[NSBundle mainBundle] URLForResource:@"lobster_idle" withExtension:@"mov"];
    if (!self.idleURL) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lobster_idle" ofType:@"mov"];
        if (path) {
            self.idleURL = [NSURL fileURLWithPath:path];
        }
    }

    self.testURL = [[NSBundle mainBundle] URLForResource:@"lobster_test" withExtension:@"mov"];
    if (!self.testURL) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lobster_test" ofType:@"mov"];
        if (path) {
            self.testURL = [NSURL fileURLWithPath:path];
        }
    }

    if (!self.idleURL || !self.testURL) {
        NSLog(@"❌ 视频资源加载失败！idle=%@, test=%@", self.idleURL, self.testURL);
    } else {
        NSLog(@"✅ 视频资源就绪\nidle: %@\ntest: %@", self.idleURL, self.testURL);
    }
}

// 配置双播放器和显示图层
- (void)setupPlayer {
    // 创建两个独立的播放器
    self.playerA = [[AVPlayer alloc] init];
    self.playerB = [[AVPlayer alloc] init];

    // 计算视频显示区域
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    CGFloat videoSize = screenWidth * 0.5;
    CGFloat videoX = (screenWidth - videoSize) / 2.0;
    CGFloat videoY = (screenHeight - videoSize) / 2.0;

    CGRect videoFrame = CGRectMake(videoX, videoY, videoSize, videoSize);

    // 创建容器视图（用于放置两个图层）
    self.playerContainerView = [[UIView alloc] initWithFrame:videoFrame];
    self.playerContainerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.playerContainerView.layer.borderColor = [UIColor redColor].CGColor;
    self.playerContainerView.layer.borderWidth = 2.0;
    [self.view addSubview:self.playerContainerView];

    // 创建两个图层，都放在同一个位置（重叠）
    self.layerA = [AVPlayerLayer playerLayerWithPlayer:self.playerA];
    self.layerA.frame = self.playerContainerView.bounds;
    self.layerA.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerContainerView.layer addSublayer:self.layerA];

    self.layerB = [AVPlayerLayer playerLayerWithPlayer:self.playerB];
    self.layerB.frame = self.playerContainerView.bounds;
    self.layerB.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerContainerView.layer addSublayer:self.layerB];

    // 初始状态：layerA 可见，layerB 隐藏
    self.layerA.opacity = 1.0;
    self.layerB.opacity = 0.0;
    self.isUsingPlayerA = YES;

    // 添加提示标签
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, screenWidth - 40, 80)];
    tipLabel.text = @"🔄 双播放器无缝切换\n观察视频切换时是否还有闪烁";
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:tipLabel];

    NSLog(@"📺 双播放器已就绪，容器 frame: %@", NSStringFromCGRect(videoFrame));
}

#pragma mark - 自动循环播放

// 开始自动循环：idle -> test -> idle -> test ...
- (void)startAutoLoop {
    if (!self.idleURL || !self.testURL) {
        NSLog(@"❌ 视频资源未加载，无法开始循环");
        return;
    }

    NSLog(@"🎬 开始双播放器无缝循环");
    self.isPlayingIdle = YES;

    // 在 playerA 上播放第一个视频
    [self playVideoOnPlayer:self.playerA
                      layer:self.layerA
                   videoURL:self.idleURL
                  videoName:@"lobster_idle"];
}

// 在指定播放器上播放视频
- (void)playVideoOnPlayer:(AVPlayer *)player
                    layer:(AVPlayerLayer *)layer
                 videoURL:(NSURL *)videoURL
                videoName:(NSString *)videoName {

    self.loopCount++;
    NSLog(@"▶️  [循环 %ld] 加载: %@ 到 %@",
          (long)self.loopCount,
          videoName,
          layer == self.layerA ? @"PlayerA" : @"PlayerB");

    // 创建新的 PlayerItem
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoURL];

    // 监听播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];

    // 替换播放内容并播放
    [player replaceCurrentItemWithPlayerItem:item];
    [player play];

    NSLog(@"🎬 开始播放: %@", videoName);
}

// 视频播放完成回调
- (void)videoDidFinishPlaying:(NSNotification *)notification {
    AVPlayerItem *finishedItem = notification.object;

    // 移除这个 item 的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:finishedItem];

    NSString *currentVideo = self.isPlayingIdle ? @"idle" : @"test";
    NSLog(@"✅ %@ 播放完成", currentVideo);

    // 切换到下一个视频
    self.isPlayingIdle = !self.isPlayingIdle;
    NSURL *nextVideoURL = self.isPlayingIdle ? self.idleURL : self.testURL;
    NSString *nextVideoName = self.isPlayingIdle ? @"lobster_idle" : @"lobster_test";

    // 确定下一个要使用的播放器和图层（与当前相反）
    AVPlayer *nextPlayer = self.isUsingPlayerA ? self.playerB : self.playerA;
    AVPlayerLayer *nextLayer = self.isUsingPlayerA ? self.layerB : self.layerA;
    AVPlayerLayer *currentLayer = self.isUsingPlayerA ? self.layerA : self.layerB;

    // 在后台播放器上预加载下一个视频
    [self playVideoOnPlayer:nextPlayer
                      layer:nextLayer
                   videoURL:nextVideoURL
                  videoName:nextVideoName];

    // 等待下一个视频就绪后再切换
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self switchToLayer:nextLayer fromLayer:currentLayer];
    });
}

// 淡入淡出切换图层
- (void)switchToLayer:(AVPlayerLayer *)toLayer fromLayer:(AVPlayerLayer *)fromLayer {
    NSLog(@"🔄 开始切换图层动画");

    // 禁用隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    // 将目标图层提到最前面
    [toLayer removeFromSuperlayer];
    [self.playerContainerView.layer addSublayer:toLayer];
    toLayer.opacity = 0.0;

    [CATransaction commit];

    // 执行淡入淡出动画
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];  // 0.3秒淡入淡出
    [CATransaction setCompletionBlock:^{
        // 动画完成后隐藏旧图层
        fromLayer.opacity = 0.0;
        NSLog(@"✅ 图层切换完成");
    }];

    toLayer.opacity = 1.0;

    [CATransaction commit];

    // 切换当前使用的播放器标记
    self.isUsingPlayerA = !self.isUsingPlayerA;
}

// 获取文件大小（MB）
- (CGFloat)getFileSizeInMB:(NSURL *)url {
    if (!url) return 0;
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:&error];
    if (error) return 0;
    unsigned long long fileSize = [attrs fileSize];
    return fileSize / 1024.0 / 1024.0;
}

#pragma mark - 生命周期

- (void)dealloc {
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // 停止播放
    [self.playerA pause];
    [self.playerB pause];

    NSLog(@"🔚 双播放器已销毁，共循环 %ld 次", (long)self.loopCount);
}

@end
