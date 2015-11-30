//
//  MyYuYueTableViewCell.h
//  HDMedical
//
//  Created by David on 15-9-18.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol rightBtnDelegate <NSObject>
- (void)rightBtnAction:(NSInteger)index;
- (void)rightCancelBtnAction:(NSInteger)index;
@end


@interface MyYuYueTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * tilteLable;
@property(nonatomic,strong)UILabel * timeLable;

@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UIButton * rightCancelBtn;
@property(nonatomic,strong)UILabel * tipLable;

@property(nonatomic,assign)id rightBtnDelegate;
@property(nonatomic,assign)id rightCancelBtnDelegate;


- (void)hiddenRightTwoBtnAWithMsg:(NSString *)msg;
- (void)showRightTwoBtn;
- (void)setTimeLableWidth:(float)width;
@end
