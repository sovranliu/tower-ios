//
//  HDReceiveFamilyViewController.h
//  HDMedical
//
//  Created by David on 15-9-26.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "MyYuYueTableViewCell.h"
#import "DataItem.h"

@interface HDReceiveFamilyViewController : CMViewController<UITableViewDataSource,UITableViewDelegate,rightBtnDelegate>
@property(nonatomic,strong)UITableView * reveiveFamilyTableView;
@property(nonatomic,strong)myMessageCenterItem * messageItem;
@property(nonatomic,strong)NSString * selectedStr;
@end
