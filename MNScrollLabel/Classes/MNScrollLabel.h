//
//  MNScrollLabel.h
//  MNScrollLabel
//
//  Created by jacknan on 2020/2/25.
//  Copyright © 2020 JackNan. All rights reserved.
// 跑马灯

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MNScrollLabel : UILabel
@property (nonatomic, assign, readonly) BOOL isStarting;    //是否滚动中
@property (nonatomic, assign) NSUInteger speed;    //滚动速率 default is 10


/// 开始滚动
- (void)start;

/// 停止 建议不使用主动停止
- (void)stop;
@end

@interface MNScrollLabelTimerManager : NSObject
+ (instancetype)shareInstance;
- (void)remove:(MNScrollLabel *)label;
- (void)add:(MNScrollLabel *)label;
@end

NS_ASSUME_NONNULL_END
