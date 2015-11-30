//
//  HDMedicalBankViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-25.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDMedicalBankViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * bankTableView;
@property(nonatomic,strong)NSMutableArray * banckArray;
@property(nonatomic,strong)NSString * bankName;
@end
