//
//  HDYuYueDocViewController.h
//  HDMedical
//
//  Created by David on 15-9-16.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "MXPullDownMenu.h"

@interface HDYuYueDocViewController : CMViewController<MXPullDownMenuDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSString * doctorID;
@property(nonatomic,strong)MXPullDownMenu *yuyueDropMenu;
@property(nonatomic,strong)NSMutableArray *yuyueDocTimeArray;
@property(nonatomic,assign)int currentSelectedIndex;
@end
