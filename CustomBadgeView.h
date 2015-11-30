//
//  CustomBadgeView.h
//  Video
//
//  Created by Howard on 13-5-9.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomBadgeView : UIView
@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIColor *badgeInsetColor;
@property (nonatomic, strong) UIColor *badgeFrameColor;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic) BOOL badgeFrame;
@property (nonatomic) BOOL badgeShining;
@property (nonatomic) CGFloat badgeCornerRoundness;
@property (nonatomic) CGFloat badgeScaleFactor;
@property (nonatomic, setter = setBadgeViewSize:) CGSize badgeViewSize;
@property (nonatomic) BOOL showTextTip;
@property (nonatomic, strong) UIImage *tipImage;

+ (CustomBadgeView*)customBadgeViewWithString:(NSString *)badgeString;
+ (CustomBadgeView*)customBadgeViewWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void)autoBadgeSizeWithString:(NSString *)badgeString;

@end
