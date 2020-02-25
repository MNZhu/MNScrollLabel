//
//  MNScrollLabel.m
//  MNScrollLabel
//
//  Created by jacknan on 2020/2/25.
//  Copyright © 2020 JackNan. All rights reserved.
//

#import "MNScrollLabel.h"

@interface MNScrollLabel ()
@property (nonatomic, strong) UIColor *mn_textColor;
@property (nonatomic, strong) NSAttributedString *mn_attributedText;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *scrollLabel;
@property (nonatomic, weak) UILabel *scrollLabel2;
@property (nonatomic, assign) BOOL isStarting;
@end

@implementation MNScrollLabel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.speed = 10;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)start {
    _isStarting = YES;
    _mn_textColor = self.textColor;
    _mn_attributedText = self.attributedText;
    self.textColor = UIColor.clearColor;
    [self reset];
}

- (void)stop {
    [_scrollView removeFromSuperview];
    [MNScrollLabelTimerManager.shareInstance remove:self];
    if (_isStarting) {
        _isStarting = NO;
        self.textColor = _mn_textColor;
        self.attributedText = _mn_attributedText;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_isStarting) {
        return;
    }
    [self reset];
}

- (void)reset {
    [MNScrollLabelTimerManager.shareInstance remove:self];
    if ([self.scrollLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.bounds.size.height)].width < self.bounds.size.width) {
        [self stop];
        return;
    }
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.frame = self.bounds;
    CGFloat width = [self.scrollLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.bounds.size.height)].width + 50;
    self.scrollLabel.frame = CGRectMake(0, 0, width, self.bounds.size.height);
    self.scrollLabel2.frame = CGRectMake(CGRectGetMaxX(self.scrollLabel.frame), 0, width, self.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollLabel.bounds.size.width*2, self.scrollLabel.bounds.size.height);
    
    [MNScrollLabelTimerManager.shareInstance add:self];
}

- (void)timerAction {
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += 0.1*self.speed;
    if (offset.x >= self.scrollLabel.bounds.size.width) {
        offset = CGPointZero;
    }
    self.scrollView.contentOffset = offset;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = UIScrollView.alloc.init;
        scrollView.backgroundColor = UIColor.clearColor;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}


- (UILabel *)scrollLabel {
    if (!_scrollLabel) {
        UILabel *la = UILabel.alloc.init;
        la.textColor = _mn_textColor;
        la.font = self.font;
        la.text = self.text;
        la.attributedText = _mn_attributedText;
        la.backgroundColor = UIColor.clearColor;
        [self.scrollView addSubview:la];
        _scrollLabel = la;
        
        la = UILabel.alloc.init;
        la.textColor = _mn_textColor;
        la.font = self.font;
        la.text = self.text;
        la.attributedText = _mn_attributedText;
        la.backgroundColor = UIColor.clearColor;
        [self.scrollView addSubview:la];
        _scrollLabel2 = la;
    }
    return _scrollLabel;
}

- (void)removeFromSuperview {
    [self stop];
    [super removeFromSuperview];
}

@end

@interface MNScrollLabelTimerManager ()

@property (nonatomic, strong) NSMutableArray *lableArr;
@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation MNScrollLabelTimerManager

+ (instancetype)shareInstance
{
    static dispatch_once_t p;
    static id instance = nil;
    dispatch_once(&p, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startTimer {
    [self stopTimer];
    if (self.lableArr.count == 0) {
        return;
    }
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
    [_timer addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    _timer.paused = NO;
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}
- (void)timerAction {
    for (MNScrollLabel *label in self.lableArr) {
        [label timerAction];
    }
}

- (void)remove:(MNScrollLabel *)label {
    [self.lableArr removeObject:label];
    if (self.lableArr.count == 0) {
        [self stopTimer];
    }
}

- (void)add:(MNScrollLabel *)label {
    [self.lableArr addObject:label];
    if (self.lableArr.count > 0) {
        [self startTimer];
    }
}

- (NSMutableArray *)lableArr {
    if (!_lableArr) {
        _lableArr = NSMutableArray.array;
    }
    return _lableArr;
}

@end
