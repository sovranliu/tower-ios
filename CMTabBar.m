//
//  CMTabBar.m
//  Video
//
//  Created by Howard on 13-5-2.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "CMTabBar.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - TabBarItem class

@interface TabBarItem ()
{
    UIImageView         *iconImageView;
    UIImageView         *coatImageView;
}

@property (nonatomic, retain) UILabel *titleLabel;

- (void)initData;
- (void)initUI;
- (CGRect)rect:(CGRect)rc forEdge:(UIEdgeInsets)edge;
- (void)resizeSubViews;

@end

@implementation TabBarItem
@synthesize badgeValue          = _badgeValue;
@synthesize titleFont           = _titleFont;
@synthesize title               = _title;
@synthesize coatBgImage         = _coatBgImage;
@synthesize normalBgImage       = _normalBgImage;
@synthesize selectedBgImage     = _selectedBgImage;
@synthesize normalIconImage     = _normalIconImage;
@synthesize selectedIconImage   = _selectedIconImage;
@synthesize normalTitleColor    = _normalTitleColor;
@synthesize selectedTitleColor  = _selectedTitleColor;
@synthesize isCoated            = _isCoated;
@synthesize topOffset           = _topOffset;
@synthesize alignType           = _alignType;
@synthesize badgeView           = _badgeView;
@synthesize titleLabel          = _titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initData];
        [self initUI];
    }
    
    return self;
}

//- (void)dealloc
//{
//    self.titleLabel         = nil;
//    self.badgeView          = nil;
//    self.badgeValue         = nil;
//    self.titleFont          = nil;
//    self.title              = nil;
//    self.coatBgImage        = nil;
//    self.normalBgImage      = nil;
//    self.selectedBgImage    = nil;
//    self.normalIconImage    = nil;
//    self.selectedIconImage  = nil;
//    self.normalTitleColor   = nil;
//    self.selectedTitleColor = nil;
//    
//    [super dealloc];
//}

- (void)initData
{
    _isCoated               = NO;
    _topOffset              = 5;
    _alignType              = BadgeViewAlignRight;
    self.titleFont          = [UIFont systemFontOfSize:14];
    self.normalTitleColor   = [UIColor blackColor];
    self.selectedTitleColor = [UIColor whiteColor];
}

- (void)initUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setText:self.title];
    [_titleLabel setFont:self.titleFont];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:_normalTitleColor];
    //[_titleLabel setShadowColor:[UIColor colorWithWhite:.0f alpha:.4]];
    //[_titleLabel setShadowOffset:CGSizeMake(.5, .5)];
    [self addSubview:_titleLabel];
    [self setBackgroundColor:[UIColor colorWithPatternImage:self.normalBgImage]];
    
    if (self.normalIconImage)
    {
        iconImageView = [[UIImageView alloc] initWithImage:_normalIconImage];
        [self addSubview:iconImageView];
//        [iconImageView release];
    }
    
    coatImageView = [[UIImageView alloc] initWithImage:_coatBgImage];
    [self addSubview:coatImageView];
    [self sendSubviewToBack:coatImageView];
    [coatImageView setHidden:YES];
//    [coatImageView release];
    
    self.badgeView = [CustomBadgeView customBadgeViewWithString:@"" withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:1.0 withShining:YES];
    [_badgeView setBackgroundColor:[UIColor clearColor]];
    [_badgeView setFrame:CGRectMake(0, 0, _badgeView.frame.size.width, _badgeView.frame.size.height)];
    
    [self addSubview:_badgeView];
}

- (void)layoutSubviews
{
    [self resizeSubViews];
}

#pragma mark - private methods
- (CGRect)rect:(CGRect)rc forEdge:(UIEdgeInsets)edge
{
    return CGRectMake(rc.origin.x + edge.left,
                      rc.origin.y + edge.top,
                      rc.size.width - edge.left - edge.right,
                      rc.size.height - edge.top - edge.bottom);
}

- (void)resizeSubViews
{
    [iconImageView removeFromSuperview];
    
    if (self.normalIconImage)
    {
        iconImageView = [[UIImageView alloc] initWithImage:_normalIconImage];
        [self addSubview:iconImageView];
//        [iconImageView release];
        [iconImageView setHidden:NO];
    }
    else
        [iconImageView setHidden:YES];
    
    [coatImageView setImage:_coatBgImage];
    
    CGRect contentFrame     = [self rect:self.bounds forEdge:UIEdgeInsetsMake(_topOffset, 0, 0, 0)];
    CGRect titleFrame       = self.bounds;
    self.backgroundColor    = [UIColor colorWithPatternImage:self.normalBgImage];
//    self.backgroundColor  = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    if (self.normalIconImage)
    {
        iconImageView.frame = CGRectMake(contentFrame.origin.x + (contentFrame.size.width - _normalIconImage.size.width) / 2, contentFrame.origin.y, _normalIconImage.size.width, _normalIconImage.size.height);
        titleFrame.origin.y += _normalIconImage.size.height + _topOffset;
        titleFrame.size.height -= _normalIconImage.size.height + _topOffset;
    }
    else
    {
        titleFrame.origin.y     += _topOffset;
        titleFrame.size.height  -= 1.5 * _topOffset;
    }
    
    _titleLabel.frame       = titleFrame;
    _titleLabel.textColor   = _normalTitleColor;
    
    if (!self.normalIconImage)
    {
        [_titleLabel setCenter:CGPointMake(_titleLabel.center.x, (7 + titleFrame.size.height +_topOffset * 0.5) * 0.5)];
    }
    
    if (_isCoated)
    {
        coatImageView.frame =
        CGRectMake((self.bounds.size.width - self.coatBgImage.size.width) / 2,
                   (self.bounds.size.height - self.coatBgImage.size.height) / 2,
                   self.coatBgImage.size.width,
                   self.coatBgImage.size.height);
    }
    
    int width = self.bounds.size.width;
    int x = _alignType == BadgeViewAlignLeft ? width * 0.5 - _topOffset : ( _alignType == BadgeViewAlignCenter ? width * 0.5 : width * 0.5 + _topOffset);
    int y = _topOffset * 0.5 + _badgeView.bounds.size.height * 0.5;

    [_badgeView setCenter:CGPointMake(x, y)];
}

#pragma mark - public methods
- (void)setSelected:(BOOL)isSelected
{
    if (isSelected ) {
        coatImageView.hidden = NO;
        if (_selectedBgImage) {
            self.backgroundColor = [UIColor colorWithPatternImage:_selectedBgImage];
        }
        if (_selectedIconImage) {
            iconImageView.image = _selectedIconImage;
        }
        if (_selectedTitleColor) {
            _titleLabel.textColor = _selectedTitleColor;
        }
    } else {
        coatImageView.hidden = YES;
        if (_normalBgImage) {
            self.backgroundColor = [UIColor colorWithPatternImage:_normalBgImage];
        }
        if (_normalIconImage) {
            iconImageView.image = _normalIconImage;
        }
        if (_normalTitleColor) {
            _titleLabel.textColor = _normalTitleColor;
        }
    }
    
    if (!_isCoated)[coatImageView setHidden:YES];
}

#pragma mark setter
- (void)setBadgeValue:(NSString *)val
{
//    [_badgeValue release];
    _badgeValue = [val copy];
    
    if (_badgeView)[_badgeView autoBadgeSizeWithString:val];
}

- (void)setTitleFont:(UIFont *)font
{
//    [font retain];
//    [_titleFont release];
    _titleFont = font;
    
    [_titleLabel setFont:_titleFont];
}

- (void)setTitle:(NSString *)str
{
//    [str retain];
//    [_title release];
    _title = str;
    
    [_titleLabel setText:_title];
}

- (void)setIsCoated:(BOOL)isVal
{
    _isCoated = isVal;
    coatImageView.hidden = !isVal;
}

- (void)setTitleShadowColor:(UIColor *)color
{
    [_titleLabel setShadowColor:color];
}

- (void)setTitleShadowOffset:(CGSize)shadowOffset
{
    [_titleLabel setShadowOffset:shadowOffset];
}

@end


#pragma mark - CMTabBar class

@interface CMTabBar ()
{
    UIImageView *_bgImageView;
}
- (void)initData;
- (void)initUI;
- (void)reloadTabBarItems;

@end


@implementation CMTabBar
@synthesize currentHighlightedIndex = _currentHighlightedIndex;
@synthesize delegate                = _delegate;
@synthesize bgImage                 = _bgImage;
@synthesize coatBgImage             = _coatBgImage;
@synthesize tabBarItems             = _tabBarItems;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tabBarItems = [[NSMutableArray alloc] init];
        [self initData];
        [self initUI];
    }
    return self;
}

//- (void)delloc
//{
//    self.delegate               = nil;
//    self.bgImage                = nil;
//    self.coatBgImage            = nil;
//    [_tabBarItems release];     _tabBarItems    = nil;
//    [super dealloc];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setTabBarItems:(NSMutableArray *)tabBarArr
{
    for (UIView * _vv in _tabBarItems)
        [_vv removeFromSuperview];
    
//    [_tabBarItems release];
//    [tabBarArr retain];
    
    _tabBarItems = tabBarArr;
}

- (void)layoutSubviews
{
    for (UIView * _vv in _tabBarItems)
        [_vv removeFromSuperview];
    
    [_bgImageView setBounds:self.bounds];
    [_bgImageView setImage:_bgImage];
    [self reloadTabBarItems];
}

- (void)onSelected:(id)sender
{
    UIControl *ctrl     = (UIControl *)sender;
    int oldIndex        = _currentHighlightedIndex;
    BOOL isEnableSel    = [self.delegate tabBarShouldSelectedItem:self curItemTag:ctrl.tag];
    
    if (ctrl.tag != _currentHighlightedIndex)
    {
        if (isEnableSel)
        {
            [[_tabBarItems objectAtIndex:_currentHighlightedIndex] setSelected:NO];
            _currentHighlightedIndex = ctrl.tag;
            [((TabBarItem*)sender) setSelected:YES];
        }
    }
    
	if (isEnableSel && self.delegate && [self.delegate respondsToSelector:@selector(tabBarSelectedItemChanged:curItemTag:oldItemTag:)]) {
		[self.delegate tabBarSelectedItemChanged:self curItemTag:_currentHighlightedIndex oldItemTag:oldIndex];
	}
}

- (void)selectedAtIndex:(NSUInteger)index
{
    if (index < _tabBarItems.count)
    {
        TabBarItem * item = [_tabBarItems objectAtIndex:index];
        
        [self onSelected:item];
    }
}

#pragma mark - private methods
- (void)initData
{
    _currentHighlightedIndex = -1;
}

- (void)initUI
{
    [self setClipsToBounds:YES];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_bgImageView setImage:_bgImage];
    [self addSubview:_bgImageView];
//    [_bgImageView release];
    
    [self reloadTabBarItems];
}

- (void)reloadTabBarItems
{
    CGFloat itemWidth   = [_tabBarItems count] > 0 ? self.frame.size.width / [_tabBarItems count] : 0;
    
    for (int i = 0; i < [_tabBarItems count]; i++)
    {
        TabBarItem *item = [_tabBarItems objectAtIndex:i];
        [item setFrame:CGRectMake(itemWidth*i, 0, itemWidth, self.frame.size.height)];
        [item setIsCoated:YES];
        [item setCoatBgImage:_coatBgImage];
        item.tag = i;
        [item setSelected:_currentHighlightedIndex == i];
        [item addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

#pragma mark - public methods
- (void)removeHighlightMenuItem
{
    _currentHighlightedIndex = -1;
    for (TabBarItem *item in _tabBarItems) {
        [item setSelected:NO];
    }
}

- (void)addHighlightMenuItemAtIndex
{
    TabBarItem *item = _currentHighlightedIndex < [_tabBarItems count] ? [_tabBarItems objectAtIndex:_currentHighlightedIndex] : nil;
    if (item != nil)
        [item setSelected:YES];
}

- (void)removeHighlightMenuItemAtIndex
{
    TabBarItem *item = _currentHighlightedIndex < [_tabBarItems count] ? [_tabBarItems objectAtIndex:_currentHighlightedIndex] : nil;
    if (item != nil)
        [item setSelected:NO];
}

- (void)highlightMenuItemAtIndex:(int)index
{
    [self performSelector:@selector(doHighlightMenuItemAtIndex:) withObject:[NSNumber numberWithInt:index] afterDelay:.0];
}

- (void)doHighlightMenuItemAtIndex:(NSNumber *)indexNumber
{
    int index = [indexNumber intValue];
    
    if (index >= 0 && index == _currentHighlightedIndex) {
        [[_tabBarItems objectAtIndex:index] setSelected:YES];
        return;
    }
    
    if (_currentHighlightedIndex >= 0 && _currentHighlightedIndex < [_tabBarItems count])
        [[_tabBarItems objectAtIndex:_currentHighlightedIndex] setSelected:NO];
    _currentHighlightedIndex = index;
    
    if (index >= 0 && index < _tabBarItems.count) {
        [[_tabBarItems objectAtIndex:index] setSelected:YES];
    }
}

@end
