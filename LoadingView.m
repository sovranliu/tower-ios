//
//  LoadingView.m
//  iPhoneNewVersion
//
//  Created by Howard on 13-7-10.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

#define kPRMargin 5.f
#define kPRLabelHeight 20.f
#define kPRLabelWidth 100.f
#define kPRArrowWidth 20.f
#define kPRArrowHeight 40.f

#define kTextColor [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
//#define kPRBGColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]
#define kPRBGColor	[UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];


@interface LoadingView ()
{
    CALayer *_arrow;
    BOOL _loading;
}

- (void)layouts;
@end

@implementation LoadingView
@synthesize stateLabel  = _stateLabel;
@synthesize dateLabel   = _dateLabel;
@synthesize arrowView   = _arrowView;
@synthesize activityView= _activityView;

@synthesize atTop = _atTop;
@synthesize state = _state;
@synthesize loading = _loading;

@synthesize arrowImage  = _arrowImage;
@synthesize arrowImageDown = _arrowImageDown;

    //Default is at top
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top {
    self = [super initWithFrame:frame];
    if (self) {
        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont boldSystemFontOfSize:13.f];
//        _stateLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
//        _stateLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        _stateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.text = NSLocalizedString(@"下拉可以翻到上一页...", @"");
        [self addSubview:_stateLabel];

        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        _dateLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _dateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            //        _dateLabel.text = NSLocalizedString(@"最后更新", @"");
        [self addSubview:_dateLabel];

        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
        _arrow = [CALayer layer];
        _arrow.frame = CGRectMake(0, 0, 20, 20);
        _arrow.contentsGravity = kCAGravityResizeAspect;
//        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"blueArrow.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;

        [self.layer addSublayer:_arrow];

        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activityView];

        [self layouts];

    }
    return self;
}

//- (void)dealloc
//{
//    self.stateLabel     = nil;
//    self.dateLabel      = nil;
//    self.arrowView      = nil;
//    self.activityView   = nil;
//    
//    [super dealloc];
//}

- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrow.contents=(id)arrowImage.CGImage;
}

- (void)setArrowImageDown:(UIImage *)arrowImageDown
{
    _arrow.contents=(id)arrowImageDown.CGImage;
}

- (void)layouts
{
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame,arrowFrame;

    float x = 0,y,margin;
        //    x = 0;
    margin = (kPROffsetY - 2*kPRLabelHeight)/2;
    if (self.isAtTop) {
        y = size.height - margin - kPRLabelHeight;
        dateFrame = CGRectMake(0,y,size.width,kPRLabelHeight);

        y = y - kPRLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);


        x = kPRMargin;
        y = size.height - margin - kPRArrowHeight;
        arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
        _arrow.contents = (id)_arrowImageDown.CGImage;

    } else {    //at bottom
        y = margin;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight*1.5);

//        y = y + kPRLabelHeight;
//        dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
		dateFrame = CGRectZero;

        x = kPRMargin;
        y = margin;
        arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);

        _arrow.contents = (id)_arrowImage.CGImage;
        _stateLabel.text = NSLocalizedString(@"上拉加载...", @"");
        [_stateLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }

    _stateLabel.frame = stateFrame;
    _dateLabel.frame = dateFrame;
    _arrowView.frame = arrowFrame;
    _activityView.center = _arrowView.center;
    _arrow.frame = arrowFrame;
    _arrow.transform = CATransform3DIdentity;
}

- (void)setState:(PRState)state
{
    [self setState:state animated:YES];
}

- (void)setState:(PRState)state animated:(BOOL)animated
{
    float duration = animated ? kPRAnimationDuration : 0.f;
    if (_state != state) {
        _state = state;
        if (_state == kPRStateLoading) {    //Loading

            _arrow.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];

            _loading = YES;
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"正在刷新...", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"正在加载...", @"");
            }

        } else if (_state == kPRStatePulling && !_loading) {    //Scrolling

            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];

            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];

            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"松开立即刷新数据...", @"");
            } else {
               // _stateLabel.text = NSLocalizedString(@"释放加载更多...", @"");
                _stateLabel.text = NSLocalizedString(@"松开立即刷新数据...", @"");
            }

        } else if (_state == kPRStateNormal && !_loading){    //Reset

            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];

            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DIdentity;
            [CATransaction commit];

            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"下拉可以翻到上一页...", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"上拉可以翻到下一页...", @"");
            }
        } else if (_state == kPRStateHitTheEnd) {
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _activityView.hidden = YES;
                [_activityView stopAnimating];
                _stateLabel.text = NSLocalizedString(@"没有了哦...", @"");
            }
        }
    }
}

- (void)setLoading:(BOOL)loading
{
        //    if (_loading == YES && loading == NO) {
        //        [self updateRefreshDate:[NSDate date]];
        //    }
    _loading = loading;
}
- (void)updateRefreshDate:(NSDate *)date
{
    [self updateRefreshDate:date format:@"yyyy-MM-dd"];
}

- (void)updateRefreshDate:(NSDate *)date format:(NSString*)formatString
{
    if (date)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = formatString;
        NSString *dateString = [df stringFromDate:date];
        NSString *title = NSLocalizedString(@"今天", nil);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:date toDate:[NSDate date] options:0];
        int year = [components year];
        int month = [components month];
        int day = [components day];
        if (year == 0 && month == 0 && day < 3) {
            if (day == 0) {
                title = NSLocalizedString(@"今天",nil);
            } else if (day == 1) {
                title = NSLocalizedString(@"昨天",nil);
            } else if (day == 2) {
                title = NSLocalizedString(@"前天",nil);
            }
            df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
            dateString = [df stringFromDate:date];
        }
        
        [_dateLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"最后更新", @""), dateString]];
        
//        [df release];
    }
}

@end
