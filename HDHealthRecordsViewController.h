//
//  HDHealthRecordsViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-8-17.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDHealthRecordsViewController : CMViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * healthRecordTableView;
@end
