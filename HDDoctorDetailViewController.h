//
//  HDDoctorDetailViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "PullingRefreshTableView.h"
#import "DataItem.h"

@interface HDDoctorDetailViewController : CMViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic) PullingRefreshTableView * doctorDetailTableView;
@property(strong,nonatomic)NSMutableArray * docPJArray;
@property(strong,nonatomic)dactorItem * docItem;
@property(strong,nonatomic)NSMutableDictionary * headDic;
@property(assign,nonatomic)int totalPages;
@property(assign,nonatomic)int pageSize;
@property(assign,nonatomic)int recordCount;

- (void)requestDoctorDetailInfo;
@end
