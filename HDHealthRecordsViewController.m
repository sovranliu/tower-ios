//
//  HDHealthRecordsViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-8-17.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDHealthRecordsViewController.h"

@interface HDHealthRecordsViewController ()
- (void)initHealthRecordTableView;
@end

@implementation HDHealthRecordsViewController
@synthesize healthRecordTableView;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"小熊家庭医生";
        self.showNav    = YES;
        self.resident   = YES;
        
    }
    return self;
}

- (void)initHealthRecordTableView
{
    self.healthRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 49 - 64) style:UITableViewStylePlain];
    [self.healthRecordTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.healthRecordTableView.delegate = self;
    self.healthRecordTableView.dataSource = self;
    self.healthRecordTableView.showsHorizontalScrollIndicator = NO;
    self.healthRecordTableView.showsVerticalScrollIndicator= NO;
    self.healthRecordTableView.bounces = NO;
    self.healthRecordTableView.alwaysBounceVertical = YES;
    self.healthRecordTableView.alwaysBounceHorizontal = YES;
    [self.view addSubview:self.healthRecordTableView];
    
}


- (void)initExtendedData
{
    
}

- (void)loadUIData
{
    [self initHealthRecordTableView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    switch (indexPath.row) {
        case 0:
            //[tableCell.imageView setImage:[UIImage imageNamed:@"app_setting"]];
            //            [tableCell.imageView setImage:[UIImage imageNamed:@"health_family"]];
            [tableCell.textLabel setText:@"体检报告"];
            break;
        case 1:
            //[tableCell.imageView setImage:[UIImage imageNamed:@"app_setting"]];
            //            [tableCell.imageView setImage:[UIImage imageNamed:@"health_family"]];
            [tableCell.textLabel setText:@"检查结果"];
            break;
        case 2:
            //[tableCell.imageView setImage:[UIImage imageNamed:@"app_setting"]];
            [tableCell.textLabel setText:@"医生处方"];
            break;
        case 3:
            //[tableCell.imageView setImage:[UIImage imageNamed:@"app_setting"]];
            [tableCell.textLabel setText:@"健康状况"];
            break;
        case 4:
            //[tableCell.imageView setImage:[UIImage imageNamed:@"app_setting"]];
            [tableCell.textLabel setText:@"电子报告"];
            break;
        default:
            break;
    }
    
    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:@"http://www.baidu.com"];
    //    [self setHiddenTabBarView:YES];
    //    [self.navigationController pushViewController:webViewVC animated:YES];
}


@end
