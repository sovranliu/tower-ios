//
//  ChooseDocTableViewCell.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"


@interface ChooseDocTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * tipImgView;
@property(nonatomic,strong)UIImageView * leftImgView;
@property(nonatomic,strong)UILabel * tilteLable;
@property(nonatomic,strong)UILabel * detailLabel;

@property(nonatomic,strong)UIButton * ksBtn;
@property(nonatomic,strong)UILabel  * zcLable;
@property(nonatomic,strong)UIImageView * askView;
@property(nonatomic,strong)UIImageView * yuView;

- (void)setdetailLabelText:(NSString *)text;
- (void)setDocNameText:(NSString *)text;
- (void)setksText:(NSString *)text;
- (void)setzcText:(NSString *)text;
- (void)setaskViewImg:(NSString *)imgName;
- (void)setyuViewImg:(NSString *)imgName;
@end
