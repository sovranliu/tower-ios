//
//  HDMainViewController.h
//  HDMedical
//
//  Created by David on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "ImagePlayerView.h"
#import "SDWebImageDownloaderDelegate.h"
#import "PullingRefreshTableView.h"
#import "MXPullDownMenu.h"
#import "JKAlertDialog.h"
#import "HDSelectCityAndRegionViewController.h"


@interface HDMainViewController : CMViewController<ImagePlayerViewDelegate,PullingRefreshTableViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate
>
@property(strong, nonatomic)ImagePlayerView *imagePlayerView;
@property(strong,nonatomic) NSMutableArray * imageAndAdvURLArray;
@property(strong,nonatomic) NSMutableArray * newsArray;

@property(strong, nonatomic) PullingRefreshTableView *hdMainTableView;
@property(strong, nonatomic) NSMutableArray * mediclalNewArray;
@property(strong, nonatomic) NSArray *dropDownArryList;

@property(assign,nonatomic) int  pages;
@property(assign,nonatomic) BOOL pageend;

@property(strong, nonatomic)UIButton *directBtn ;//小区选择
@property(strong,nonatomic)NSMutableArray *regionArray;

@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)UIButton * rightBtn;


//@property(nonatomic,strong)UITableView * regionTableView;
//@property(nonatomic,strong)JKAlertDialog *alert;


@property(nonatomic,strong)UIView * hiddenKeyBoardView;

//@property(nonatomic,strong)HDSelectCityAndRegionViewController * scrcVC;


@end
