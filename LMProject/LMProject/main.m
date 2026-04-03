//
//  main.m
//  LMProject
//
//  Created by zhanglimin on 2022/6/16.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


typedef void(^Block)(void);
Block myblock() {
    int a = 10;
    Block blc = ^{
        NSLog(@"%d",a);
    };
    NSLog(@"%@",blc);
    return blc;
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        Block blc = myblock();
        blc();
        
        // global， 未捕获局部变量，Global 类型
        void (^block1)(void) = ^{
            NSLog(@"Hello");
        };
        
        // 将block赋值给了block2, 有拷贝操作+捕获局部变量，-- Malloc 类型
        int a = 10;
        void (^block2)(void) = ^{
            NSLog(@"Hello - %d",a);
        };
        
        // 捕获了局部变量，但没有copy操作，Stack 类型
        NSLog(@"%@", [^{
                    NSLog(@"%d",a);
                } class] );
        
        // stack
//        NSLog(@"%@  %@  %@", block1, block2, ^{
//            NSLog(@"%d",a);
//        });
        NSLog(@"%d",a);
        
        
        
        
        
        
    }
//    NSLog(@"%s", __FUNCTION__);
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
