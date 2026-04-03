//
//  Vichile.h
//  LMProject
//
//  Created by zhanglimin on 2023/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Vichile : NSObject {
@public
    int _year;  // 4字节
    int _kilometres;    // 8字节
}

@property (nonatomic,copy) NSString *name;

- (void)run;

- (void)go __attribute__((objc_requires_super));

@end

NS_ASSUME_NONNULL_END
