//
//  UINavigationBar+Customizer.h
//  Video
//
//  Created by Howard on 13-5-14.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UINavigationBar(Customizer)
@property (nonatomic, strong) UIImage *tintImage;
@property (nonatomic, assign) BOOL changingUserInteraction;
@property (nonatomic, assign) BOOL userInteractionChangedBySystem;

- (void)customNavigationBar:(UIImage *)bgImg cornerRadii:(CGSize)cornerSize roundingCorners:(UIRectCorner)roundingCorners shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;

@end
