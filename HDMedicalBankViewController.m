//
//  HDMedicalBankViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-25.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMedicalBankViewController.h"

@interface HDMedicalBankViewController ()

@end

@implementation HDMedicalBankViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"银行列表";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.banckArray = [NSMutableArray arrayWithObjects:@"中国银行",@"招商银行",@"农业银行",@"建设银行",@"工商银行", nil];
}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
    
    [self initMineinofTableView];
}

- (void)initMineinofTableView
{
    self.bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
    [self.bankTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.bankTableView.delegate = self;
    self.bankTableView.dataSource = self;
    self.bankTableView.showsHorizontalScrollIndicator = NO;
    self.bankTableView.showsVerticalScrollIndicator= NO;
    self.bankTableView.bounces = YES;
    //    self.mineMoneyPackTableView.allowsSelection = NO;
    self.bankTableView.alwaysBounceVertical = NO;
    self.bankTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.bankTableView];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.banckArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    NSString *bankName = [self.banckArray objectAtIndex:indexPath.row];
    
    tableCell.textLabel.text = bankName;
    
    if ([self.bankName isEqualToString:bankName]) {
        [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObject:[self.banckArray objectAtIndex:indexPath.row] forKey:@"bankName"];

//    [DataEngine sharedDataEngine].currentBank = indexPath.row;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalselectedBank object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
