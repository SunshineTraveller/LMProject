//
//  LMTestControl.m
//  LMProject
//
//  Created by zhanglimin on 2023/3/2.
//

#import "LMTestControl.h"

@implementation LMTestControl

//- (instancetype)init {
//
//    NSString *name = [self entryPointName];
//    NSLog(@"%@",name);
//    return [super init];
//}

- (NSString *)entryPointName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    NSString *name = [self entryPointName];
    NSLog(@"%@",name);
    if (self) {
        self.testQueue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL);
        self.backgroundColor = UIColor.cyanColor;
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)test {
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("testConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(concurrentQueue, ^{
//        NSLog(@"a");
//    });
//    dispatch_async(concurrentQueue, ^{
//        for (int i = 0; i < 1000; i++) {
//            NSLog(@" ");
//        }
//        NSLog(@"b");
//    });
//    dispatch_async(concurrentQueue, ^{
//        NSLog(@"c");
//    });
//    dispatch_async(concurrentQueue, ^{
//        NSLog(@"d");
//    });
//    dispatch_async(concurrentQueue, ^{
//        NSLog(@"e");
//    });
//    [self executeAysnc:^{
//        NSLog(@"1");
//    }];
//    [self executeAysnc:^{
//        for (int i = 0; i < 1000; i++) {
//            NSLog(@" ");
//        }
//        NSLog(@"2");
//    }];
//    [self executeAysnc:^{
//        NSLog(@"3");
//    }];
    [self abcdeft:^{
        [self etertererwe];
    }];
}

- (void)etertererwe {
    NSLog(@"===========");
}

- (void)executeAysnc:(void(^)(void))block {
    dispatch_async(self.testQueue, ^{
        block();
    });
}

- (void)abcdeft:(void(^)(void))askldjas {
    NSLog(@"哈师大快捷键凯撒金开水阀手打");
}

-(void)dealloc {
    NSLog(@"LMTestControl dealloc");
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
