//
//  LoadingView.h
//  iPhoneNewVersion
//
//  Created by Howard on 13-7-10.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPROffsetY 60.f
#define kPRAnimationDuration .18f

typedef enum {
    kPRStateNormal      = 0,
    kPRStatePulling     = 1,
    kPRStateLoading     = 2,
    kPRStateHitTheEnd   = 3,
} PRState;

@interface LoadingView : UIView
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, getter = isAtTop) BOOL atTop;
@property (nonatomic) PRState state;
@property (nonatomic, strong) UIImage *arrowImage;
@property (nonatomic, strong) UIImage *arrowImageDown;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date format:(NSString*)formatString;
- (void)setState:(PRState)state animated:(BOOL)animated;
- (void)updateRefreshDate:(NSDate *)date;

@end
