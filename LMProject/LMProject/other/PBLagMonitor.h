//
//  PBLagMonitor.h
//  LMProject
//
//  Created by zhanglimin on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PBLagMonitor : NSObject
@property (nonatomic) BOOL isMonitoring;
- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视卡顿
@end

NS_ASSUME_NONNULL_END
