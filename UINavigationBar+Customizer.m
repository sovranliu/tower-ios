//
//  UINavigationBar+Customizer.m
//  Video
//
//  Created by Howard on 13-5-14.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "UINavigationBar+Customizer.h"
#import <objc/runtime.h>
#import "CommonDefine.h"


static const char *TintImageKey = "TintImage";
static const char *UIChangingKey = "UIChangingKey";
static const char *UISystemChangedKey = "UISystemChangedKey";

@implementation UINavigationBar(Customizer)
@dynamic tintImage;
@dynamic changingUserInteraction;
@dynamic userInteractionChangedBySystem;

- (UIImage *)tintImage
{
    return objc_getAssociatedObject(self, TintImageKey);
}

- (void)setTintImage:(UIImage *)newTintImage
{
    objc_setAssociatedObject(self, TintImageKey, newTintImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)changingUserInteraction
{
    return [objc_getAssociatedObject(self, UIChangingKey) boolValue];
}

- (void)setChangingUserInteraction:(BOOL)isChanging
{
    objc_setAssociatedObject(self, UIChangingKey, [NSNumber numberWithBool:isChanging], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)userInteractionChangedBySystem
{
    return [objc_getAssociatedObject(self, UISystemChangedKey) boolValue];
}

- (void)setUserInteractionChangedBySystem:(BOOL)isChanged
{
    objc_setAssociatedObject(self, UISystemChangedKey, [NSNumber numberWithBool:isChanged], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)drawRoundCornerAndShadow:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity roundingCorners:(UIRectCorner)roundingCorners cornerSize:(CGSize)cornerSize
{
    CGRect bounds           = self.bounds;
    bounds.size.height      += cornerSize.height;
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:roundingCorners cornerRadii:cornerSize];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = bounds;
    maskLayer.path          = maskPath.CGPath;
    
    [self.layer addSublayer:maskLayer];
    self.layer.mask             = maskLayer;
    self.layer.shadowOffset     = shadowOffset;
    self.layer.shadowOpacity    = shadowOpacity;
    self.layer.shadowPath       = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (UIImage *)patternImage:(UIImage *)img
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(img.size.width-10, img.size.height-10, img.size.width * 0.5, img.size.height * 0.5));
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -img.size.width,-img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (void)customNavigationBar:(UIImage *)bgImg cornerRadii:(CGSize)cornerSize roundingCorners:(UIRectCorner)roundingCorners shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity
{
    self.tintImage = bgImg;
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        {
            [self setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
            [self setTintColor:[UIColor colorWithPatternImage:bgImg]];
            [self drawRoundCornerAndShadow:shadowOffset shadowOpacity:shadowOpacity roundingCorners:roundingCorners cornerSize:cornerSize];
        }
        else
        {
            [self setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
//            [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:bgImg]];
        }
#else
        [self setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:bgImg]];
#endif
    }
    else
    {
        [bgImg drawInRect:self.bounds];
        [self setTintColor:[UIColor colorWithPatternImage:bgImg]];
        [self drawRoundCornerAndShadow:shadowOffset shadowOpacity:shadowOpacity roundingCorners:roundingCorners cornerSize:cornerSize];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (self.userInteractionChangedBySystem && self.userInteractionEnabled == NO)
    {
        return hitView;
    }
    
    CGPoint tmpPt   = CGPointMake(point.x, self.frame.origin.y+point.y);
    CGRect tmpRt    = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-5);
    BOOL isInRect = CGRectContainsPoint(tmpRt, tmpPt);

    if ([self pointInside:point withEvent:event] && isInRect)
    {
        self.changingUserInteraction = YES;
        self.userInteractionEnabled = YES;
        self.changingUserInteraction = NO;
    }
    else
    {
        self.changingUserInteraction = YES;
        self.userInteractionEnabled = NO;
        self.changingUserInteraction = NO;
    }

    return hitView;
}

// 避免iOS7SDK+iOS7DeviceLater,快速点击导航栏引起导航栏堆栈错乱问题
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    self.userInteractionChangedBySystem = !self.changingUserInteraction;
    [super setUserInteractionEnabled:userInteractionEnabled];
}

- (void)drawRect:(CGRect)rect
{
    if (IOS_VERSION < 5.0)
    {
        [self setTintColor:[UIColor colorWithPatternImage:self.tintImage]];
        [self.tintImage drawInRect:rect];
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGRect barFrame = self.frame;
//    barFrame.size.height = 44;
//    self.frame = barFrame;
//}

@end
