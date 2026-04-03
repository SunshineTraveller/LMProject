//
//  LMTestControl.h
//  LMProject
//
//  Created by zhanglimin on 2023/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMTestControl : UIControl

@property (nonatomic,strong) dispatch_queue_t testQueue;

- (void)test;


@end

NS_ASSUME_NONNULL_END
