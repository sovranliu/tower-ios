//
//  HDMyFamilyViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-8-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "PopupListComponent.h"

@interface HDMyFamilyViewController : CMViewController<UITableViewDataSource,UITableViewDelegate,PopupListComponentDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView * myfamilyTableView;
@property (nonatomic, strong) PopupListComponent* activePopup;
@property (nonatomic,strong)NSMutableArray * relationArray;


@end
