//
//  HDMineInfoViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-17.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "MXPullDownMenu.h"

@interface HDMineInfoViewController : CMViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,MXPullDownMenuDelegate>
@property(nonatomic,strong)UITableView * mineInfoTableView;
@property(nonatomic,strong)NSMutableArray * mineInfoArray;
@property(nonatomic,strong)NSIndexPath * selectedIndexPath;
@property(nonatomic,strong)NSString * bankName;
@end
