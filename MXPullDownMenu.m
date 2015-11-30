//
//  MXPullDownMenu000.m
//  MXPullDownMenu
//
//  Created by 马骁 on 14-8-21.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MXPullDownMenu.h"
#import "CommonDefine.h"

@implementation MXPullDownMenu
{
    
    UIColor *_menuColor; // 菜单的颜色
    

    UIView *_backGroundView; // 背景view
    UITableView *_tableView; // 点击下拉的tableview
    
    NSMutableArray *_titles; // tableView 默认的标题
    NSMutableArray *_indicators; // tableview 右边默认的指示器
    
    
    NSInteger _currentSelectedMenudIndex; // 当前选中的行
    bool _show; // 显示还是消失
    
    NSInteger _numOfMenu; // 有几个菜单，就是有几个下拉列表 默认应该1
    
    NSArray *_array; // 下拉列表的数组，
    
    CGRect _tableRect;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    
    }
    return self;
}
//CGRectMake(15, 10, kScreenW- 30, 0);

//- (MXPullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)color
- (MXPullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)color withTableFrame:(CGRect)rect
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenW, 36);
        
        _tableRect = rect;
        _menuColor = UIColorFromRGB(0x7d7d7d);
        _array = array;

        _numOfMenu = _array.count;
        
        _titles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        _indicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        
        for (int i = 0; i < _numOfMenu; i++) {
            
            // 画左边的title
            CATextLayer *title = [CATextLayer new];
            title.string = _array[i][0];
            title.fontSize = 13.0;
            title.alignmentMode = kCAAlignmentLeft;
            title.foregroundColor = [UIColor blackColor].CGColor;
            title.contentsScale = 2.0;
            
            [title setFrame:CGRectMake(15, 10, kScreenW - 60, 36)];
            
            [self.layer addSublayer:title];
            [_titles addObject:title];
            
            
            // 画右边的箭头
            CAShapeLayer *indicator = [self creatIndicatorWithColor:[UIColor colorWithRed:60.0/255.0 green:163.0/255.0 blue:217.0/255.0 alpha:1.0] andPosition:CGPointMake(kScreenW - 40, self.frame.size.height / 2)];
            
            [self.layer addSublayer:indicator];
            [_indicators addObject:indicator];
            
            
            
        }
        // 创建tableview
        _tableView = [self creatTableViewAtPosition:CGPointMake(_tableRect.origin.x, self.frame.origin.y + self.frame.size.height)];
        _tableView.tintColor = color;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 设置menu, 并添加手势
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenu:)];
        [self addGestureRecognizer:tapGesture];
        
        // 创建背景
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
        [_backGroundView addGestureRecognizer:gesture];
         
        _currentSelectedMenudIndex = -1;
        _show = NO;
    }
    return self;
}

#pragma mark - tapEvent
// 处理菜单点击事件.
- (void)tapMenu:(UITapGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    
    // 得到tapIndex 0
    
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
            
        }];
        
    } else {
        // 显示下拉tableView
        _currentSelectedMenudIndex = tapIndex;
        [_tableView reloadData];
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
            _show = YES;
        }];
        
    }
}

- (void)tapBackGround:(UITapGestureRecognizer *)paramSender
{
    // 手指点击背景View
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];

}


#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [self confiMenuWithSelectRow:indexPath.row];
    [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row];
    
}


#pragma mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array[_currentSelectedMenudIndex] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.textLabel.text = _array[_currentSelectedMenudIndex][indexPath.row];
    
    // 打勾
    if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell.textLabel setTextColor:[tableView tintColor]];
    }
    
    return cell;
}





#pragma mark - animation
// 显示剪头
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
//    indicator.fillColor = forward ? _tableView.tintColor.CGColor : _menuColor.CGColor;
    indicator.fillColor = [UIColor colorWithRed:60.0/255.0 green:163.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    
    
    complete();
}

// 设置背景色的view
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    
    if (show) {// 显示半透明装背景View
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];

        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    
    } else { // 消失半透明状的背景view
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }
    complete();
    
}

// 出现下拉tableView
- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        
        // 设置tabview的frame
        tableView.frame = CGRectMake(_tableRect.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
        [self.superview addSubview:tableView];
        
//        CGFloat tableViewHeight = ([tableView numberOfRowsInSection:0] > 5) ? (5 * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
        // 设置tableview的高度
        CGFloat tableViewHeight = self.tableViewRowNum * tableView.rowHeight;
        
        // 下拉出现tablview
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(_tableRect.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width , tableViewHeight);
        }];

    } else {
        // 关闭tableView
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(_tableRect.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width , 0);
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
        }];
        
        
    }
    complete();
    
}

// 设置titleView的frame
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        title.foregroundColor = [UIColor grayColor].CGColor;
        title.contentsScale = 2.0;
    } else {
        title.foregroundColor = [UIColor blackColor].CGColor;
        title.contentsScale = 2.0;
    }

    [title setFrame:CGRectMake(15, _tableRect.origin.y, _tableRect.size.width, 36)];
    
    complete();
}

// 设置title 、backgroudView、UItableView arraow
- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}


#pragma mark - drawing

// 画三角
- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.1;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
  //  [layer setBackgroundColor:[UIColor blueColor].CGColor];
    
    return layer;
}


// 设置tableView 的坐标
- (UITableView *)creatTableViewAtPosition:(CGPoint)point
{
    UITableView *tableView = [UITableView new];
    
    tableView.frame = CGRectMake(point.x, point.y, self.frame.size.width, 0);
    tableView.rowHeight = 36;
    
    return tableView;
}


#pragma mark - otherMethods

//
//- (CGSize)calculateTitleSizeWithString:(NSString *)string
//{
//    CGFloat fontSize = 13.0;
//    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
//    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
//    return size;
//}

// 点击的时候选择
- (void)confiMenuWithSelectRow:(NSInteger)row
{
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [[_array objectAtIndex:_currentSelectedMenudIndex] objectAtIndex:row];
    
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
        
    }];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(kScreenW - 40, indicator.position.y);
}


@end

#pragma mark - CALayer Category

@implementation CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath
{
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}


@end
