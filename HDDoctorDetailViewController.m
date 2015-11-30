//
//  HDDoctorDetailViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDDoctorDetailViewController.h"
#import "HDEvaluateViewController.h"
#import "LoadingView.h"
#import "UIView+Positioning.h"
#import "PinJiaTableViewCell.h"
#import "HDChatViewController.h"
#import "UIImageView+WebCache.h"
#import "CMTabBarController.h"
#import "HDLoginViewController.h"
#import "JSONFormatFunc.h"
#import "HDYuYueDocViewController.h"

@interface HDDoctorDetailViewController ()

@end

@implementation HDDoctorDetailViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"在线问诊";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.docPJArray = [[NSMutableArray alloc] init];
    self.headDic    = [[NSMutableDictionary alloc] init];
}

- (void)requestDoctorDetailInfo
{
    // 1 请求用户评价
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl1 appendString:KHDMedicalCommentlist];
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    NSLog(@"doctor =%@",self.docItem.userGlobalId);
    [totalParamDic setObject:self.docItem.userGlobalId forKey:@"id"];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"page"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:1];
}

- (void)loadUIData
{
    [self initDoctorDetailTableView];
    [self initHeadView];
    [self initFootView];
    // 请求数据
    [self requestDoctorDetailInfo];
}

- (void) initDoctorDetailTableView
{
    self.doctorDetailTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 54) style:UITableViewStylePlain];
    [self.doctorDetailTableView setArrowImage:[UIImage imageNamed:@"refresh_up"] arrowDownImage:[UIImage imageNamed:@"refresh_down"]];
    self.doctorDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.doctorDetailTableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0f];
    self.doctorDetailTableView.delegate = self;
    self.doctorDetailTableView.dataSource = self;
    [self.doctorDetailTableView setPullingDelegate:self];
    [self.doctorDetailTableView setEnableFooterPull:YES];
    [self.doctorDetailTableView setEnableHeaderPull:NO];
    self.doctorDetailTableView.footerView.stateLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
    [self.doctorDetailTableView setBackgroundColor:[UIColor whiteColor]];
    self.doctorDetailTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.doctorDetailTableView];
}

- (void)initHeadView
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView * showIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
    [headView addSubview:showIconImgView];
    [showIconImgView setImageWithURL:[NSURL URLWithString:self.docItem.photo] placeholderImage:[UIImage imageNamed:@"user_photo_default"]];
    
    // 名字
    UILabel * docName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    [docName setTag: 10];
    [docName setText:self.docItem.name];
    [docName setTextAlignment:NSTextAlignmentLeft];
    [docName setX:showIconImgView.x + showIconImgView.width + 15];
    [docName setY:showIconImgView.y + 2];
    [docName setFont:[UIFont systemFontOfSize:20.0]];
    
    //隶属于
    UILabel * owner = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    [owner setTag: 11];
    [owner setText:self.docItem.department];
    [owner setTextColor:[UIColor lightGrayColor]];
    [owner setTextAlignment:NSTextAlignmentLeft];
    [owner setX:docName.x + docName.width];
    [owner setY:docName.y];
    [owner setFont:[UIFont systemFontOfSize:16.0]];
    
    // 主任医生
    UILabel * mainDoc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 120, 40)];
    [mainDoc setTag: 11];
    mainDoc.lineBreakMode = NSLineBreakByWordWrapping;
    mainDoc.numberOfLines = 2;
    [mainDoc setText:self.docItem.title];
    [mainDoc setTextColor:[UIColor lightGrayColor]];
    [mainDoc setTextAlignment:NSTextAlignmentLeft];
    [mainDoc setX:docName.x ];
    [mainDoc setY:docName.bottom];
    [mainDoc setFont:[UIFont systemFontOfSize:16.0]];
    
    //擅长
    UILabel * goodAt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, 0)];
    [goodAt setTag: 11];
    [goodAt setText:[NSString stringWithFormat:@"%@",self.docItem.docDescription]];
    [goodAt setTextColor:[UIColor lightGrayColor]];
    [goodAt setTextAlignment:NSTextAlignmentLeft];
    [goodAt setX:showIconImgView.x ];
    [goodAt setY:showIconImgView.bottom + 10];
    [goodAt setFont:[UIFont systemFontOfSize:14.0]];
    [goodAt setNumberOfLines:0];
    
    // 算googAt 的高度
    CGRect  goodAtRect = [goodAt.text boundingRectWithSize:CGSizeMake(kScreenW - 30,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    [goodAt setFrame:CGRectMake(goodAt.frame.origin.x, goodAt.frame.origin.y , goodAtRect.size.width, goodAtRect.size.height)];
    
    // 简介
    UILabel * introduce = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, 0)];
    [introduce setTag: 11];
    [introduce setText:self.docItem.resume];
    [introduce setTextColor:[UIColor lightGrayColor]];
    [introduce setTextAlignment:NSTextAlignmentLeft];
    [introduce setX:goodAt.x ];
    [introduce setY:goodAt.bottom + 10];
    [introduce setFont:[UIFont systemFontOfSize:14.0]];
    [introduce setNumberOfLines:0];
    
    // 算简介的高度
    CGRect  introduceRect = [introduce.text boundingRectWithSize:CGSizeMake(kScreenW - 30,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    [introduce setFrame:CGRectMake(introduce.frame.origin.x, introduce.frame.origin.y , introduceRect.size.width, introduceRect.size.height)];
    
    // gap
    UIView * gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 6)];
    [gapView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [gapView setX:0];
    [gapView setY:introduce.bottom + 6];
    
    // 用户评价
    UILabel * yhpj = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [yhpj setTag: 13];
    [yhpj setText:@"用户评价(0)"];
    [yhpj setTextColor:[UIColor lightGrayColor]];
    [yhpj setTextAlignment:NSTextAlignmentLeft];
    [yhpj setX:introduce.x ];
    [yhpj setY:gapView.bottom +7];
    [yhpj setFont:[UIFont systemFontOfSize:14.0]];
    
    // 赞
    UIButton * zangBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [zangBtn addTarget:self action:@selector(zangBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [zangBtn setImage:[UIImage imageNamed:@"askdoctor_good"] forState:UIControlStateNormal];
    [zangBtn setImage:[UIImage imageNamed:@"askdoctor_suggest_good"] forState:UIControlStateHighlighted];
    [zangBtn setX:kScreenW- 120];
    [zangBtn setY:gapView.bottom + 5];
    
    
    //赞的数量
    UILabel * zangnum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [zangnum setTag: 11];
    [zangnum setText:self.docItem.goodNum];
    [zangnum setTextColor:[UIColor lightGrayColor]];
    [zangnum setTextAlignment:NSTextAlignmentLeft];
    [zangnum setX:zangBtn.right + 2 ];
    [zangnum setY:gapView.bottom + +5];
    [zangnum setFont:[UIFont systemFontOfSize:14.0]];
    
    [headView addSubview:zangBtn];
    [headView addSubview:zangnum];
    
    // gap3
    UIView * gap3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 15)];
    [gap3 setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [gap3 setX:zangnum.right];
    [gap3 setY:zangnum.y + 8];
    [headView addSubview:gap3];
    
    // bad
    UIButton * badBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [badBtn addTarget:self action:@selector(badBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [badBtn setImage:[UIImage imageNamed:@"askdoctor_bad"] forState:UIControlStateNormal];
    [badBtn setImage:[UIImage imageNamed:@"askdoctor_suggest_bad"] forState:UIControlStateHighlighted];
    [badBtn setX:gap3.right + 3];
    [badBtn setY:gapView.bottom + 5];
    [headView addSubview:badBtn];
    
    
    //bad的数量
    UILabel * badnum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [badnum setTag: 11];
    [badnum setText:self.docItem.badNum];
    [badnum setTextColor:[UIColor lightGrayColor]];
    [badnum setTextAlignment:NSTextAlignmentLeft];
    [badnum setX:badBtn.right + 2 ];
    [badnum setY:gapView.bottom + 5];
    [badnum setFont:[UIFont systemFontOfSize:14.0]];
    [headView addSubview:badnum];
    
    // gap2
    UIView * gapView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    [gapView2 setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [gapView2 setX:0];
    [gapView2 setY:yhpj.bottom + 6];
    
    
    
    //headViewHeight 高度
    float headViewHeight = 15 + 80 + 15 + goodAtRect.size.height + introduceRect.size.height  +12 + 30 + 1 + 12 + 5;
    [headView setFrame:CGRectMake(0, 0, kScreenW, headViewHeight)];
    
    [headView addSubview:showIconImgView];
    [headView addSubview:docName];
    [headView addSubview:mainDoc];
    [headView addSubview:owner];
    [headView addSubview:goodAt];
    [headView addSubview:introduce];
    [headView addSubview:gapView];
    [headView addSubview:yhpj];
    [headView addSubview:gapView2];
    


    
//    // 问诊按钮
//    UIButton * askDocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [askDocBtn setTitle:@"问  诊" forState:UIControlStateNormal];
//    [askDocBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
//    askDocBtn.tag = 2;
//    [askDocBtn addTarget:self action:@selector(askBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [askDocBtn setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:102/255.0 blue:197/255.0 alpha:1.0]];
//    [askDocBtn setFrame:CGRectMake(20, headViewHeight - 55, kScreenW/2.0 - 25, 40)];
//    [askDocBtn.layer setCornerRadius:5.0];
//    [headView addSubview:askDocBtn];
//    
//    // 评价按钮
//    UIButton * pingjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pingjiaBtn setTitle:@"评  价" forState:UIControlStateNormal];
//    [pingjiaBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
//    pingjiaBtn.tag = 3;
//    [pingjiaBtn addTarget:self action:@selector(pingjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [pingjiaBtn setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:152/255.0 blue:58/255.0 alpha:1.0]];
//    [pingjiaBtn setFrame:CGRectMake(kScreenW/2.0 + 5, headViewHeight - 55, kScreenW/2.0 - 25, 40)];
//    [pingjiaBtn.layer setCornerRadius:5.0];
//    [headView addSubview:pingjiaBtn];
    
    
    
    self.doctorDetailTableView.tableHeaderView = headView;
}

- (void)initFootView
{
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 54)];
    [footView setBackgroundColor:[UIColor colorWithRed:61.0/255.0 green:143.0/255.0 blue:236.0/255.0 alpha:1.0]];
    [footView setX:0];
    [footView setY:kScreenH - 64 - 54];
    
    // 第一条竖线
    UIView * gap1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 54)];
    [gap1 setBackgroundColor:[UIColor lightGrayColor]];
    [gap1 setX:kScreenW/3.0];
    [gap1 setY:0];
    
    // 第二条竖线
    UIView * gap2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 54)];
    [gap2 setBackgroundColor:[UIColor lightGrayColor]];
    [gap2 setX:2 * kScreenW/3.0];
    [gap2 setY:0];
    
    //咨询图片
    UIImageView * askDocImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [askDocImg setImage:[UIImage imageNamed:@"askdoctor_ask"]];
    [askDocImg setY:54/2.0 -10];
    [askDocImg setX:kScreenW/3.0/2.0 - 33];
    [footView addSubview:askDocImg];
    
    // 咨询文本
    UILabel * askDocLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [askDocLabel setText:@"咨询"];
    [askDocLabel setX:kScreenW/3.0/2.0 - 10];
    [askDocLabel setY:54/2.0 -10];
    [askDocLabel setTextAlignment:NSTextAlignmentLeft];
    [askDocLabel setFont:[UIFont systemFontOfSize:18.0]];
    [askDocLabel setBackgroundColor:[UIColor clearColor]];
    [askDocLabel setTextColor:[UIColor whiteColor]];
    [footView addSubview:askDocLabel];
    
    //预约图片
    UIImageView * yuyueImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [yuyueImg setImage:[UIImage imageNamed:@"askdoctor_yuyue"]];
    [yuyueImg setY:54/2.0 -10];
    [yuyueImg setX:kScreenW/2.0 - 33];
    [footView addSubview:yuyueImg];
    
    // 预约文本
    UILabel * yuyueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [yuyueLabel setText:@"预约"];
    [yuyueLabel setX:kScreenW/2.0 - 10];
    [yuyueLabel setY:54/2.0 -10];
    [yuyueLabel setTextAlignment:NSTextAlignmentLeft];
    [yuyueLabel setFont:[UIFont systemFontOfSize:18.0]];
    [yuyueLabel setBackgroundColor:[UIColor clearColor]];
    [yuyueLabel setTextColor:[UIColor whiteColor]];
    [footView addSubview:yuyueLabel];
    
    //评价图片
    UIImageView * pinjiaImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [pinjiaImg setImage:[UIImage imageNamed:@"askdoctor_pinjia"]];
    [pinjiaImg setY:54/2.0 -10];
    [pinjiaImg setX:5 * kScreenW/6.0 - 33];
    [footView addSubview:pinjiaImg];
    
    // 评价文本
    UILabel * pingjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [pingjiaLabel setText:@"评价"];
    [pingjiaLabel setX:5 *kScreenW/6.0 - 10];
    [pingjiaLabel setY:54/2.0 -10];
    [pingjiaLabel setTextAlignment:NSTextAlignmentLeft];
    [pingjiaLabel setFont:[UIFont systemFontOfSize:18.0]];
    [pingjiaLabel setBackgroundColor:[UIColor clearColor]];
    [pingjiaLabel setTextColor:[UIColor whiteColor]];
    [footView addSubview:pingjiaLabel];
    
    // 咨询button
    UIButton * askdocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [askdocBtn addTarget:self action:@selector(askdocBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [askdocBtn setFrame:CGRectMake(0, 0, kScreenW/3.0, 54)];
    [askdocBtn setX:0];
    [askdocBtn setY:0];
    [footView addSubview:askdocBtn];
    
    // 预约button
    UIButton * yueyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yueyeBtn addTarget:self action:@selector(yueyeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [yueyeBtn setFrame:CGRectMake(0, 0, kScreenW/3.0, 54)];
    [yueyeBtn setX:kScreenW/3.0];
    [yueyeBtn setY:0];
    [footView addSubview:yueyeBtn];
    
    // 评价button
    UIButton * pingjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pingjiaBtn addTarget:self action:@selector(pingjiaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pingjiaBtn setFrame:CGRectMake(0, 0, kScreenW/3.0, 54)];
    [pingjiaBtn setX:2 * kScreenW/3.0];
    [pingjiaBtn setY:0];
    [footView addSubview:pingjiaBtn];
    
    
    [footView addSubview:gap1];
    [footView addSubview:gap2];
    
    [self.view addSubview:footView];
    
}
- (void)pingjiaBtnAction:(id)sender
{
    NSLog(@"pingjiaBtnAction");
    
    if ([DataEngine sharedDataEngine].isLogin)
    {
        HDEvaluateViewController * evalutateVC = [[HDEvaluateViewController alloc] init];
        evalutateVC.docItem = self.docItem;
        //    evalutateVC.doctorId = self.docItem.userGlobalId;
        //    evalutateVC.doctorId = @"b197e518-fdd9-4c8e-b386-ecc4925ca6f3";
        [self.navigationController pushViewController:evalutateVC animated:YES];
    }else
    {
        HDLoginViewController * loginVC = [[HDLoginViewController alloc] init];
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
    }
}

- (void)yueyeBtnAction:(id)sender
{
    if ([DataEngine sharedDataEngine].isLogin)
    {
        HDYuYueDocViewController * yuyueVC = [[HDYuYueDocViewController alloc] init];
        yuyueVC.doctorID =self.docItem.userGlobalId;
        //    yuyueVC.doctorID = @"b197e518-fdd9-4c8e-b386-ecc4925ca6f3";
        [self.navigationController pushViewController:yuyueVC animated:YES];
    }else
    {
        HDLoginViewController * loginVC = [[HDLoginViewController alloc] init];
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
    }
}

- (void)askdocBtnAction:(id)sender
{
    NSLog(@"askdocBtnAction");
    
    if ([DataEngine sharedDataEngine].isLogin)
    {
        
        HDChatViewController * chatVC = [[HDChatViewController alloc] init];
        chatVC.doctorId = self.docItem.userGlobalId;
        chatVC.doctorImgURL =  self.docItem.photo;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else
    {
        HDLoginViewController * loginVC = [[HDLoginViewController alloc] init];
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
    }
}

- (void)zangBtnAction:(id)sender
{
    NSLog(@"zangBtnAction");
}

- (void)badBtnAction:(id)sender
{
     NSLog(@"badBtnAction");
}

- (void)askBtnAction:(id)sender
{
    NSLog(@"askBtnAction");
}

#pragma mark -  PullingRefreshTableViewScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.doctorDetailTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.doctorDetailTableView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
// 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //    if ([self.wisdomListData count]>0)
    //    {
    //        [self.wisdomListData removeAllObjects];
    //    }
    //    pageNumber = 0;
    //    [self request2972Type155:1+pageNumber*10 EndIndex:10+pageNumber*10];
    NSLog(@"pullingTableViewDidStartRefreshing");
}

// 上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    NSLog(@"pullingTableViewDidStartLoading");
    
    NSString   * currentPage =  [self.headDic  objectForKey:@"currentPage"];
    int page = [currentPage intValue];
    
    BOOL end = [[self.headDic objectForKey:@"end"] boolValue];
    if (!end)
    {
        NSLog(@"pull data");
        // 1 请求用户评价
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl1 appendString:KHDMedicalCommentlist];
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        NSLog(@"doctor =%@",self.docItem.userGlobalId);
        [totalParamDic setObject:self.docItem.userGlobalId forKey:@"id"];
        [totalParamDic setObject:[NSString stringWithFormat:@"%d",++page] forKey:@"page"];
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:1];
        
        self.doctorDetailTableView.reachedTheEnd  = NO;
        [self.doctorDetailTableView tableViewDidFinishedLoading];
    }else
    {
        
        self.doctorDetailTableView.reachedTheEnd  = YES;
        [self.doctorDetailTableView tableViewDidFinishedLoading];

    }
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

- (NSDate *)pullingTableViewLoadingFinishedDate
{
    return [NSDate date];
}

#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.docPJArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.docPJArray count] > 0)
    {
        pjdoctorItem * item = [self.docPJArray objectAtIndex:indexPath.row];
        NSString * textHeight = item.content;
        CGRect  titleRect = [textHeight boundingRectWithSize:CGSizeMake(kScreenW - 20,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        return titleRect.size.height + 40;
    }
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    PinJiaTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[PinJiaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    if ([self.docPJArray count] > 0)
    {
        pjdoctorItem * item = [self.docPJArray objectAtIndex:indexPath.row];
        
        tableCell.nickName.text = item.username;
        tableCell.date.text = item.date;
        tableCell.pinjiaDetail.text = item.content;
        CGRect  titleRect = [tableCell.pinjiaDetail.text boundingRectWithSize:CGSizeMake(kScreenW - 20,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        [tableCell.pinjiaDetail setFrame:CGRectMake(tableCell.pinjiaDetail.frame.origin.x, tableCell.pinjiaDetail.frame.origin.y, titleRect.size.width, titleRect.size.height)];
        
        [tableCell.singleLine setFrame:CGRectMake(0, titleRect.size.height + 39, kScreenW, 1)];

    }
    
    
    //[tableCell setSize:CGSizeMake(kScreenW, titleRect.size.height + 30)];
    
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSDictionary * doctorPinJiadic = [JSONFormatFunc dictionaryValueForKey:@"data" ofDict:responseData];
        
        NSString * nextStart = [JSONFormatFunc strValueForKey:@"nextStart" ofDict:doctorPinJiadic];
        NSString * currentPage = [JSONFormatFunc strValueForKey:@"page" ofDict:doctorPinJiadic];
        NSString * totalPages = [JSONFormatFunc strValueForKey:@"pageCount" ofDict:doctorPinJiadic];
        NSString * everyPageSize = [JSONFormatFunc strValueForKey:@"pageSize" ofDict:doctorPinJiadic];
        NSString * totalCounts = [JSONFormatFunc strValueForKey:@"recordCount" ofDict:doctorPinJiadic];
        
        [self.headDic  setValue:nextStart forKey:@"nextStart"];
        [self.headDic  setValue:currentPage forKey:@"currentPage"];
        [self.headDic  setValue:totalPages forKey:@"totalPages"];
        [self.headDic  setValue:everyPageSize forKey:@"everyPageSize"];
        [self.headDic  setValue:totalCounts forKey:@"totalCounts"];
        if ([currentPage isEqualToString:totalPages])
        {
            [self.headDic  setValue:[NSNumber numberWithBool:YES]  forKey:@"end"];
        }else
        {
            [self.headDic  setValue:[NSNumber numberWithBool:NO]  forKey:@"end"];
        }
        
        NSMutableArray * dianpinArray = [NSMutableArray arrayWithArray:[JSONFormatFunc arrayValueForKey:@"records" ofDict:doctorPinJiadic]]  ;
        if (code == 1 && [dianpinArray count] >0)
        {
            
            for (int i= 0 ; i< [dianpinArray count] ; i ++)
            {
                NSDictionary * dic = [dianpinArray objectAtIndex:i];
                pjdoctorItem * item = [[pjdoctorItem alloc] init];
                item.attitude   = [JSONFormatFunc strValueForKey:@"attitude" ofDict:dic];
                item.content    = [JSONFormatFunc strValueForKey:@"content" ofDict:dic];
                
//                NSDate *confromTimesp = [NSDate dateWithTimeInterval:[[JSONFormatFunc strValueForKey:@"date" ofDict:dic] intValue]/1000 sinceDate:[NSDate date]];
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
//
//                
//                item.date       = destDateString;
                
                long long int  time = [[JSONFormatFunc strValueForKey:@"date" ofDict:dic] longLongValue];
                long long int actural = time/1000;
                
                NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:(long long int)actural];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
                
                item.date = destDateString;

                
                item.username   = [JSONFormatFunc strValueForKey:@"username" ofDict:dic];
                
                [self.docPJArray addObject:item];
            }
            
            [self.doctorDetailTableView reloadData];
            
            UILabel * pinjaiLabe = (UILabel *)[self.view viewWithTag:13];
            [pinjaiLabe setText:[NSString stringWithFormat:@"用户评价(%@)",totalCounts]];
            
            

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
