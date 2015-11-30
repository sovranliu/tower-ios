//
//  HDEvaluateViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "DataItem.h"

@interface HDEvaluateViewController : CMViewController<UITextViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UILabel * doctorName;
@property(nonatomic,strong)UILabel * placehoder;
//@property(nonatomic,strong)NSString * doctorId;
@property(strong,nonatomic)dactorItem * docItem;
@property(strong,nonatomic)UITextView *textView;
@property(assign,nonatomic)NSString * goodOrBad;
@end
