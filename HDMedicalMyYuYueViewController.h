//
//  HDMedicalMyYuYueViewController.h
//  HDMedical
//
//  Created by David on 15-9-18.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "MyYuYueTableViewCell.h"

@interface HDMedicalMyYuYueViewController : CMViewController<UITableViewDataSource,UITableViewDelegate,rightBtnDelegate>
@property(nonatomic,strong)UITableView * mineYuYueTableView;
@property(nonatomic,strong)NSMutableArray * mineYuyueArray;
@end
