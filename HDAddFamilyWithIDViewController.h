//
//  HDAddFamilyWithIDViewController.h
//  HDMedical
//
//  Created by David on 15-8-22.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDAddFamilyWithIDViewController : CMViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UILabel     * addFamilyNumlabel;
@property(nonatomic,strong)UITextField * familyRelationField;
@property(nonatomic,strong)UITextField * familyNameField;
@property(nonatomic,strong)UITextField * familyIdentityField;
//@property(nonatomic,strong)UITextField * familyAgesField;
@property(nonatomic,strong)UIButton    * familySureBtn;
@end
