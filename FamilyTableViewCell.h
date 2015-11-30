//
//  FamilyTableViewCell.h
//  HDMedical
//
//  Created by DEV_00 on 15-8-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol rightBtnDelegate <NSObject>
- (void)rightBtnAction:(NSInteger)index;
@end

@interface FamilyTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView  * familyImgsView;
@property(nonatomic,strong)UILabel      * familyNickNameLabel;
@property(nonatomic,strong)UILabel      * familyNameAndPhoneLabel;

@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,assign)id rightBtnDelegate;
@end
