//
//  HDChatViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-2.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDChatViewController : CMViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic,strong)NSString * doctorId;
@property(nonatomic,assign)int pipe;
@property(nonatomic,assign)int messageId;
@property(nonatomic,assign)BOOL alreadyPipe;
@property(nonatomic,assign)BOOL isFormDocDetail;
@property(nonatomic,assign)float moveY;
@property(nonatomic,strong)NSString * doctorImgURL;

@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)NSMutableArray * chatArray;
@property(nonatomic,strong)NSMutableArray * charIndexArray;

@end
