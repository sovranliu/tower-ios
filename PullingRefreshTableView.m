//
//  PullingRefreshTableView.m
//  PullingTableView
//
//  Created by luo danal on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullingRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "LoadingView.h"


@interface PullingRefreshTableView ()
- (void)scrollToNextPage;
@end

@implementation PullingRefreshTableView
@synthesize pullingDelegate = _pullingDelegate;
@synthesize dateFormatString;
@synthesize autoScrollToNextPage;
@synthesize reachedTheEnd = _reachedTheEnd;
@synthesize enableHeaderPull = _enableHeaderPull;
@synthesize enableFooterPull = _enableFooterPull;
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize refreshDate = _refreshDate;
@synthesize loadDate    = _loadDate;

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
//    [_headerView release];  _headerView = nil;
//    [_footerView release];  _footerView = nil;
//    [_msgLabel release];    _msgLabel   = nil;
//    self.loadDate           = nil;
//    self.refreshDate        = nil;
//    self.dateFormatString   = nil;
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        // Initialization code
        self.dateFormatString = @"yyyy-MM-dd HH:mm";
        CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
        _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
        _headerView.atTop = YES;
        [self addSubview:_headerView];
        
        rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
        _footerView.atTop = NO;
        [self addSubview:_footerView];
		
		self.enableHeaderPull = YES;
		self.enableFooterPull = YES;
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate
{
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self)
    {
        self.pullingDelegate = aPullingDelegate;
    }
    return self;
}

- (void)setReachedTheEnd:(BOOL)reachedTheEnd
{
    _reachedTheEnd      = reachedTheEnd;
    _footerView.state   = _reachedTheEnd ? kPRStateHitTheEnd : kPRStateNormal;
}

- (void)setEnableHeaderPull:(BOOL)enable
{
    _enableHeaderPull   = enable;
    _headerView.hidden  = !_enableHeaderPull;
}

- (void)setEnableFooterPull:(BOOL)enable
{
	_enableFooterPull   = enable;
	_footerView.hidden  = !_enableFooterPull;
}

#pragma mark - Scroll methods
- (void)scrollToNextPage
{
    float h = self.frame.size.height;
    float y = self.contentOffset.y + h;
    y = y > self.contentSize.height ? self.contentSize.height : y;
      
    [UIView animateWithDuration:.7f 
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
                        self.contentOffset = CGPointMake(0, y);  
                     }
                     completion:^(BOOL bl){
                     }];
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading)
        return;

    CGPoint offset      = scrollView.contentOffset;
    CGSize size         = scrollView.frame.size;
    CGSize contentSize  = scrollView.contentSize;
    float yMargin       = offset.y + size.height - contentSize.height;

    if (offset.y < -kPROffsetY)     //header totally appeard
    {
         _headerView.state = kPRStatePulling;
    }
    else if (offset.y > -kPROffsetY && offset.y < 0)    //header part appeared
    { 
        _headerView.state = kPRStateNormal;
        [_headerView updateRefreshDate:self.refreshDate format:dateFormatString];    
    }
    else if ( yMargin > kPROffsetY)     //footer totally appeared
    {  
        if (_footerView.state != kPRStateHitTheEnd)
            _footerView.state = kPRStatePulling;
    }
    else if ( yMargin < kPROffsetY && yMargin > 0)  //footer part appeared
    {
        if (_footerView.state != kPRStateHitTheEnd)
            _footerView.state = kPRStateNormal;
        
        [_footerView updateRefreshDate:self.loadDate format:dateFormatString];
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) return;
    
    if (_headerView.state == kPRStatePulling)
    {
		if (self.enableHeaderPull == NO) return;
        
        _isFooterInAction = NO;
        _headerView.state = kPRStateLoading;
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(kPROffsetY, 0, 0, 0);
        }];
        
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)])
        {
            [_pullingDelegate pullingTableViewDidStartRefreshing:self];
        }
    }
    else if (_footerView.state == kPRStatePulling)
    {
        if (self.reachedTheEnd || self.enableFooterPull == NO)
        {
            return;
        }
        
        _isFooterInAction = YES;
        _footerView.state = kPRStateLoading;
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, kPROffsetY, 0);
        }];
        
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)])
        {
            [_pullingDelegate pullingTableViewDidStartLoading:self];
        }
    }
}

- (void)tableViewDidFinishedLoading
{    
    //[_headerView updateRefreshDate:[NSDate date] format:dateFormatString];
    [self tableViewDidFinishedLoadingWithMessage:nil];
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg
{
    if (_footerView.loading)
    {
        _footerView.loading = NO;
        PRState state = self.reachedTheEnd ? kPRStateHitTheEnd : kPRStateNormal;
        [_footerView setState:state animated:NO];
        NSDate *date = [NSDate date];
        
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewLoadingFinishedDate)])
        {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }

        self.loadDate = date;
        [_footerView updateRefreshDate:date format:dateFormatString];
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
        
//        NSLog(@"self.contentInset: %@, self.contentOffset: %@", NSStringFromUIEdgeInsets(self.contentInset), NSStringFromCGPoint(self.contentOffset));
    }
    else    // _headerView.loading
    {
        _headerView.loading = NO;
        [_headerView setState:kPRStateNormal animated:NO];
        NSDate *date = [NSDate date];
        
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewRefreshingFinishedDate)])
        {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }
        self.refreshDate = date;

        [_headerView updateRefreshDate:date format:dateFormatString];
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }

            if (self.contentOffset.y < 0)
                [self setContentOffset:CGPointMake(0,0) animated:YES];
        }];
    }
}

- (void)flashMessage:(NSString *)msg
{
    //Show message
    __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
    
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = rect;
        _msgLabel.font = [UIFont systemFontOfSize:14.f];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [UIColor colorWithWhite:.5 alpha:.7];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLabel];
    }
    _msgLabel.text = msg;
    
    rect.origin.y += 20;
    [UIView animateWithDuration:.4f animations:^{
        _msgLabel.frame = rect;
    } completion:^(BOOL finished){
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            [_msgLabel removeFromSuperview];
            _msgLabel = nil;            
        }];
    }];
}

- (void)setArrowImage:(UIImage *)arrowImage arrowDownImage:(UIImage *)arrowDownImage
{
    if(self.enableHeaderPull)
        [_headerView setArrowImageDown:arrowDownImage];
    if(self.enableFooterPull)
        [_footerView setArrowImage:arrowImage];
}

- (void)launchRefreshing
{
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:kPRAnimationDuration*2 animations:^{
        self.contentOffset = CGPointMake(0, -kPROffsetY-10.);
    } completion:^(BOOL bl){
//        _headerView.state = kPRStatePulling;
//        [UIView animateWithDuration:kPRAnimationDuration*2 animations:^{
//            self.contentOffset = CGPointMake(0, -kPROffsetY-1.);
//        } completion:^(BOOL finished) {
//            [self tableViewDidEndDragging:self];
//        }];
        [self tableViewDidEndDragging:self];
    }];
}

#pragma mark - 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect frame = _footerView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
    _footerView.frame = frame;
    if (self.autoScrollToNextPage && _isFooterInAction)
    {
        [self scrollToNextPage];
        _isFooterInAction = NO;
    }
    else if (_isFooterInAction)
    {
        _isFooterInAction = NO;
        CGPoint offset = self.contentOffset;
        offset.y += 44.f;
        self.contentOffset = offset;
    }
}

@end
