//
//  HDHealthManageViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-23.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDHealthManageViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * healthManageTableView;
@end
