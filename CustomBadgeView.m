//
//  CustomBadgeView.m
//  Video
//
//  Created by Howard on 13-5-9.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "CustomBadgeView.h"


@interface CustomBadgeView ()

- (void)initData;
- (id)initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining;
- (id)initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void)drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void)drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void)drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect;

@end

@implementation CustomBadgeView
@synthesize badgeText               = _badgeText;
@synthesize badgeTextColor          = _badgeTextColor;
@synthesize badgeInsetColor         = _badgeInsetColor;
@synthesize badgeFrameColor         = _badgeFrameColor;
@synthesize fontSize                = _fontSize;
@synthesize badgeFrame              = _badgeFrame;
@synthesize badgeShining            = _badgeShining;
@synthesize badgeCornerRoundness    = _badgeCornerRoundness;
@synthesize badgeScaleFactor        = _badgeScaleFactor;
@synthesize badgeViewSize           = _badgeViewSize;
@synthesize tipImage                = _tipImage;
@synthesize showTextTip             = _showTextTip;


- (id)initWithFrame:(CGRect)frame
{
    CGSize frameSize = CGSizeMake(25, 25);
    
    self = [super initWithFrame:CGRectMake(0, 0, frameSize.width, frameSize.height)];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

//- (void)dealloc
//{
//    self.badgeText          = nil;
//    self.badgeTextColor     = nil;
//    self.badgeInsetColor    = nil;
//    self.badgeFrameColor    = nil;
//    self.tipImage           = nil;
//    
//    [super dealloc];
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect imgRect = !_showTextTip ? CGRectMake(rect.size.width-_tipImage.size.width, (rect.size.height -_tipImage.size.height) / 2, _tipImage.size.width, _tipImage.size.height) : rect;
    
    if (!_showTextTip)[self.tipImage drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:.9];
    
    if (_showTextTip && _badgeText && [_badgeText length] > 0)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self drawRoundedRectWithContext:context withRect:rect];
        
        if(self.badgeShining && !self.tipImage)
        {
            [self drawShineWithContext:context withRect:rect];
        }
        
        if (self.badgeFrame && !self.tipImage)
        {
            [self drawFrameWithContext:context withRect:rect];
        }
        
        if ([_badgeText length] > 0)
        {
            [_badgeTextColor set];
            
            CGFloat sizeOfFont = 13.5 * _badgeScaleFactor;
            if ([self.badgeText length] < 2)
            {
                sizeOfFont += sizeOfFont * 0.20;
            }
            
            UIFont *textFont = [UIFont boldSystemFontOfSize:sizeOfFont];
            CGSize textSize = [self.badgeText sizeWithFont:textFont];
            [self.badgeText drawAtPoint:CGPointMake((rect.size.width-textSize.width) / 2, (rect.size.height-textSize.height) / 2) withFont:textFont];
        }
	}
}

#pragma mark - private's methods
- (void)initData
{
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.backgroundColor    = [UIColor clearColor];
    self.badgeTextColor     = [UIColor whiteColor];
    self.badgeFrameColor    = [UIColor whiteColor];
    self.badgeInsetColor    = [UIColor redColor];
    _fontSize               = 8;
    _badgeFrame             = YES;
    _badgeCornerRoundness   = 0.4;
    _badgeViewSize          = self.bounds.size;
    _showTextTip            = YES;
    self.tipImage           = nil;
}

- (id)initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining
{
    self = [self initWithFrame:CGRectZero];
    
    if (self)
    {
        _badgeScaleFactor   = scale;
		_badgeShining       = shining;
        self.badgeText      = badgeString;
        [self autoBadgeSizeWithString:badgeString];
    }
    
    return self;
}

- (id)initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining
{
    self = [self initWithFrame:CGRectZero];
    
    if (self)
    {
        self.badgeText          = badgeString;
		self.badgeTextColor     = stringColor;
		self.badgeFrame         = badgeFrameYesNo;
		self.badgeFrameColor    = frameColor;
		self.badgeInsetColor    = insetColor;
		self.badgeScaleFactor   = scale;
		self.badgeShining       = shining;
        [self autoBadgeSizeWithString:badgeString];
    }
    
    return self;
}

// Draws the Badge with Quartz
- (void)drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
	CGFloat radius  = CGRectGetMaxY(rect) * _badgeCornerRoundness;
	CGFloat puffer  = CGRectGetMaxY(rect) * 0.10;
	CGFloat maxX    = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY    = CGRectGetMaxY(rect) - puffer;
	CGFloat minX    = CGRectGetMinX(rect) + puffer;
	CGFloat minY    = CGRectGetMinY(rect) + puffer;
    
    CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [_badgeInsetColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
    CGContextFillPath(context);
    
	CGContextRestoreGState(context);
}

// Draws the Badge Shine with Quartz
- (void)drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
    
	CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	CGContextBeginPath(context);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClip(context);
	
	
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 0.4 };
	CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
    
	CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint, ePoint;
	sPoint.x = 0;
	sPoint.y = 0;
	ePoint.x = 0;
	ePoint.y = maxY;
	CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
	CGColorSpaceRelease(cspace);
	CGGradientRelease(gradient);
    
	CGContextRestoreGState(context);
}

// Draws the Badge Frame with Quartz
- (void)drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGFloat radius  = CGRectGetMaxY(rect) * _badgeCornerRoundness;
	CGFloat puffer  = CGRectGetMaxY(rect) * 0.10;
	CGFloat maxX    = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY    = CGRectGetMaxY(rect) - puffer;
	CGFloat minX    = CGRectGetMinX(rect) + puffer;
	CGFloat minY    = CGRectGetMinY(rect) + puffer;
	
    CGContextBeginPath(context);
	CGFloat lineSize = 2;
	if(_badgeScaleFactor > 1)
    {
		lineSize += _badgeScaleFactor * 0.25;
	}
    
	CGContextSetLineWidth(context, lineSize);
	CGContextSetStrokeColorWithColor(context, [_badgeFrameColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}

#pragma mark - public's methods
+ (CustomBadgeView*)customBadgeViewWithString:(NSString *)badgeString
{
    return [[self alloc] initWithString:badgeString withScale:1.0 withShining:YES];
}

+ (CustomBadgeView*)customBadgeViewWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining
{
    return [[self alloc] initWithString:badgeString withStringColor:stringColor withInsetColor:insetColor withBadgeFrame:badgeFrameYesNo withBadgeFrameColor:frameColor withScale:scale withShining:shining] ;
}

- (void)autoBadgeSizeWithString:(NSString *)badgeString
{
    CGSize retValue;
	CGFloat rectWidth, rectHeight;
	CGSize stringSize = [badgeString sizeWithFont:[UIFont boldSystemFontOfSize:_fontSize]];
    
	if ([badgeString length] >= 2)
    {
		CGFloat flexSpace   = [badgeString length];
		rectWidth           = 10 + (stringSize.width + flexSpace);
        rectHeight          = 5 + stringSize.height;
		retValue            = CGSizeMake(rectWidth*_badgeScaleFactor, rectHeight*_badgeScaleFactor);
	}
    else
    {
		retValue = CGSizeMake(_badgeViewSize.width*_badgeScaleFactor, _badgeViewSize.height*_badgeScaleFactor);
	}
    
	self.frame      = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
	self.badgeText  = badgeString;
    
	[self setNeedsDisplay];
}

#pragma mark setters
- (void)setBadgeViewSize:(CGSize)size
{
    _badgeViewSize = size;
    [self setBounds:CGRectMake(0, 0, size.width, size.height)];
}

#pragma mark - touches' event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [((UIControl*)self.superview) sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [((UIControl*)self.superview) sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
