//
//  HDSelfAskDocViewController.m
//  HDMedical
//
//  Created by David on 15-9-6.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDSelfAskDocViewController.h"
#import "HDSelfCheckViewController.h"
#import "JSONFormatFunc.h"
#import "HDPeopleImgsViewController.h"
#import "UIKit+AFNetworking.h"


@interface HDSelfAskDocViewController ()

@end

@implementation HDSelfAskDocViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"自我诊断";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalBodyImg object:nil];
}

- (void)initExtendedData
{
    self.isfirstClickFlag = NO;
    self.leftTableViewDataArray = [[NSMutableArray alloc] init];
    self.rightTableViewDataArray = [[NSMutableArray alloc] init];
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl appendString:KHDMedicalLoadBody];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:nil withReqTag:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectedBodyAction:)
                                                 name:KHDMedicalBodyImg object:nil];
    
}

- (void)selectedBodyAction:(NSNotification *)sender
{
    NSString * name = [[sender object] objectForKey:@"name"];
    
    // 更新cell 颜色
    self.isfirstClickFlag = YES;
    [self.leftTableView reloadData];
    
    
    long index = 0;
    
    for (int i = 0;i < [self.leftTableViewDataArray count]; i ++)
    {
        if ([[self.leftTableViewDataArray objectAtIndex:i] isEqualToString:name])
        {
            index = i;
        }
    }
    
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                               
    
    UITableViewCell * tableCell = [self.leftTableView cellForRowAtIndexPath:indexPath];
    [tableCell setBackgroundColor:[UIColor whiteColor]];
    
    
    
    // 2 请求参数
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl1 appendString:KHDMedicalLoadSymptom];
    // 参数
    NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [paramDic setObject:[self.leftTableViewDataArray objectAtIndex:indexPath.row] forKey:@"body"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:paramDic withReqTag:2];

    
    
    
    NSLog(@"selectedBodyAction");
}

- (void)loadUIData
{
    [self initLeftTableView];
    [self initRightTableView];
    [self initSelfCheckPeopleBodyImgsNavigationItem];
}

- (void)initSelfCheckPeopleBodyImgsNavigationItem
{
    UIButton *addFamilyNumBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [addFamilyNumBtn setBackgroundImage:[UIImage imageNamed:@"mine_addfamily"] forState:UIControlStateNormal];
    [addFamilyNumBtn setTitle:@"肢体视图" forState:UIControlStateNormal];
    [addFamilyNumBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    addFamilyNumBtn.tag = 101;
    [addFamilyNumBtn setFrame:CGRectMake(0, 0, 80, 35)];
    [addFamilyNumBtn addTarget:self action:@selector(selfCheckPeopleBodyImgsAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addFamilyNumBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}


- (void)selfCheckPeopleBodyImgsAction:(id)sender
{
    HDPeopleImgsViewController * hdpimsVC = [[HDPeopleImgsViewController alloc] init];
    hdpimsVC.leftDataArra = self.leftTableViewDataArray;
    [self.navigationController pushViewController:hdpimsVC animated:YES];
}

- (void)initLeftTableView
{
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, kScreenH - 64) style:UITableViewStylePlain];
    [self.leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.leftTableView setSeparatorInset:UIEdgeInsetsZero];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.showsHorizontalScrollIndicator = NO;
    self.leftTableView.showsVerticalScrollIndicator= NO;
    self.leftTableView.bounces = YES;
    self.leftTableView.alwaysBounceVertical = NO;
    self.leftTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.leftTableView];
    
    
    // 分割线左移 ios7
    if ([ self.leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.leftTableView   setSeparatorInset:UIEdgeInsetsZero];
    }
    // 分割线左移 ios8
    if ([self.leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.leftTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}

- (void)initRightTableView
{
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(120, 0, kScreenW - 120, kScreenH - 64) style:UITableViewStylePlain];
    [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.showsHorizontalScrollIndicator = NO;
    self.rightTableView.showsVerticalScrollIndicator= NO;
    self.rightTableView.bounces = YES;
    self.rightTableView.alwaysBounceVertical = NO;
    self.rightTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.rightTableView];
}


#pragma mark -列表处理
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(tableView == self.leftTableView)
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [cell setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [cell setLayoutMargins:UIEdgeInsetsZero];
            
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int num = (tableView == self.leftTableView) ? (int)[self.leftTableViewDataArray count] : (int)[self.rightTableViewDataArray count] ;
    return num;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = (tableView == self.leftTableView) ? 80 : 45 ;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        NSString *cellIdentifierStr = @"LeftBasicInforIdentifier";
        
        UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
        if (tableCell == nil)
        {
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
        }
        
        if ([self.leftTableViewDataArray count] > 0)
        {
            tableCell.textLabel.text = [self.leftTableViewDataArray objectAtIndex:indexPath.row];
            [tableCell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [tableCell setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
            
            if (indexPath.row == 0 && !self.isfirstClickFlag)
            {
                [tableCell setBackgroundColor:[UIColor whiteColor]];
            }
        }
        
        return tableCell;
        
    }else
    {
        NSString *cellIdentifierStr = @"RightBasicInforIdentifier";
        
        UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
        if (tableCell == nil)
        {
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
        }
        
        if ([self.rightTableViewDataArray count] > 0)
        {
            tableCell.textLabel.text = [self.rightTableViewDataArray objectAtIndex:indexPath.row];
        }
        
        
        return tableCell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        // 更新cell 颜色
        self.isfirstClickFlag = YES;
        [tableView reloadData];
        UITableViewCell * tableCell = [self.leftTableView cellForRowAtIndexPath:indexPath];
        [tableCell setBackgroundColor:[UIColor whiteColor]];
        
        

        // 2 请求参数
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl1 appendString:KHDMedicalLoadSymptom];
        // 参数
        NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [paramDic setObject:[self.leftTableViewDataArray objectAtIndex:indexPath.row] forKey:@"body"];
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:paramDic withReqTag:2];
        

    }else if (tableView == self.rightTableView)
    {
        HDSelfCheckViewController * selfVC = [[HDSelfCheckViewController alloc] init];
        selfVC.selfSymptom = [self.rightTableViewDataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController: selfVC animated:YES];
    }
    
    
    
    NSLog(@"didSelectRow");
//    TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:@"http://www.baidu.com"];
//    [self setHiddenTabBarView:YES];
//    [self.navigationController pushViewController:webViewVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
       // NSString * msg = [responseData objectForKey:@"msg"];
        NSArray * dataArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [dataArray count] >0)
        {
            [self.leftTableViewDataArray removeAllObjects];
            [self.leftTableViewDataArray addObjectsFromArray:dataArray];
            [self.leftTableView reloadData];
            
            // 2 请求参数
            NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
            [baseUrl1 appendString:KHDMedicalLoadSymptom];
            // 参数
            NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:1];
            [paramDic setObject:[dataArray objectAtIndex:0] forKey:@"body"];
            // 发送数据
            [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:paramDic withReqTag:2];
            
        }
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        int code = [[responseData objectForKey:@"code"] intValue];
        //NSString * msg = [responseData objectForKey:@"msg"];
        NSArray * dataArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
//        NSLog(@"code = %d,msg =%@",code,msg);
        if (code == 1 && [dataArray count] >0)
        {
            [self.rightTableViewDataArray removeAllObjects];
            [self.rightTableViewDataArray addObjectsFromArray:dataArray];
            [self.rightTableView reloadData];
        }
    }
    
}

- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag
{
    
}

- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag
{
    NSLog(@"error %@",error.description);
}

@end
