//
//  HDChatViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-2.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDChatViewController.h"
#import "MessageModel.h"
#import "CellFrameModel.h"
#import "MessageCell.h"
#import "JSONFormatFunc.h"
#import "UIImageView+WebCache.h"


#define kToolBarH 44
#define kTextFieldH 30
@interface HDChatViewController ()
{
    NSMutableArray *_cellFrameDatas;
    UITableView *_chatView;
    UIImageView *_toolBar;
}
@end

@implementation HDChatViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"咨询";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initExtendedData
{
    self.messageId = 0;
    self.alreadyPipe = NO;
    self.isFormDocDetail = YES;
    self.chatArray = [[NSMutableArray alloc] init];
//    self.charIndexArray = [[NSMutableArray alloc] init];
    _cellFrameDatas =[[NSMutableArray alloc] init];
    
}



- (void)loadUIData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 创建通道
    if (self.isFormDocDetail) 
    [self createPipe];
    
    //0.加载数据
    //[self loadData];
    
    //1.tableView
    [self addChatView];
    
    //2.工具栏
    [self addToolBar];
    
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pullMessage:) userInfo:nil repeats:YES];
    //每2秒运行一次function方法。
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.timer fire];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
//    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
}
/**
 *  记载数据
 */
//- (void)loadData
//{
//    _cellFrameDatas =[NSMutableArray array];
//    NSURL *dataUrl = [[NSBundle mainBundle] URLForResource:@"messages.plist" withExtension:nil];
//    NSArray *dataArray = [NSArray arrayWithContentsOfURL:dataUrl];
//    for (NSDictionary *dict in dataArray) {
//        MessageModel *message = [MessageModel messageModelWithDict:dict];
//        CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
//        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
//        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
//        cellFrame.message = message;
//        [_cellFrameDatas addObject:cellFrame];
//    }
//}

/**
 *  添加TableView
 */
- (void)addChatView
{
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    UITableView *chatView = [[UITableView alloc] init];
    chatView.frame = CGRectMake(0, 0, self.view.frame.size.width, kScreenH - kToolBarH - 64);
    chatView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
    chatView.delegate = self;
    chatView.dataSource = self;
    chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatView.allowsSelection = NO;
    chatView.tag = 10;
    [chatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    _chatView = chatView;
    
    [self.view addSubview:chatView];
}

/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, kScreenH - 64 - kToolBarH, self.view.frame.size.width, kToolBarH);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeySend;
    textField.enablesReturnKeyAutomatically = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(5, (kToolBarH - kTextFieldH) * 0.5, self.view.frame.size.width -10, kTextFieldH);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    [bgView addSubview:textField];
}


- (void)postTalkToServer:(NSString * )text
{
    // 1 post到服务器
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl1 appendString:@"/"];
    [baseUrl1 appendString:KHDMedicalPush];
    
    [baseUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"self.pipe = %d,self.token = %@,self.content = %@",self.pipe,[DataEngine sharedDataEngine].deviceToken,text);
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pipe] forKey:@"pipe"];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    [totalParamDic setObject:text forKey:@"content"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:[baseUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] userInfo:totalParamDic withReqTag:2];
}

- (void)pullMessage:(id)sender
{
    NSLog(@"pullmessage");
    if (self.alreadyPipe)
    {
        [self  pullChatDataWith5Mins];
    }
}

- (void)createPipe
{
    // 1 请求创建回话
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl1 appendString:@"/"];
    [baseUrl1 appendString:KHDMedicalTalk];
    
    NSLog(@"self.doctorID = %@,self.token = %@",self.doctorId,[DataEngine sharedDataEngine].deviceToken);
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:@"test" forKey:@"topic"];
    [totalParamDic setObject:self.doctorId forKey:@"id"];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:1];
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellFrameDatas.count;
}

- (MessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    
 //   [self.charIndexArray addObject:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1.获得时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    //2.创建一个MessageModel类
    MessageModel *message = [[MessageModel alloc] init];
    message.text = textField.text;
    message.time = locationString;
    message.type = 0;
    
    //3.创建一个CellFrameModel类
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    //CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = YES;//![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    //4.添加进去，并且刷新数据
    //[_cellFrameDatas addObject:cellFrame];
    //[_chatView reloadData];
    
    // 上传数据post 到服务端
    [self postTalkToServer:textField.text];
    
    textField.text = @"";
    
    
    [self endEdit];
    
    return YES;
}

- (void)endEdit
{
    [self.view endEditing:YES];
}
/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChange:(NSNotification *)note
{
    
//    // 调整
//    float visiableHeight = 0;
//    for (int i = 0; i < [self.charIndexArray count]; i ++)
//    {
//        MessageCell * cell = (MessageCell *)[_chatView cellForRowAtIndexPath:[self.charIndexArray objectAtIndex:i]];
//        visiableHeight += cell.bounds.size.height;
//    }
//    
//    
//    NSLog(@"visiablehetth = %f,fdfdsfds = %f,self.movwY = %f",visiableHeight,kScreenH - 64 - 49 + self.moveY,self.moveY);
//    //
//    
//    if (visiableHeight > kScreenH - 64 - 49 + self.moveY)
//    {
//        NSLog(@"dfdfsdfds");
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, self.moveY);
//        }];
//    }else
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            _toolBar.transform = CGAffineTransformMakeTranslation(0, self.moveY);
//        }];
//        
//    }
//    

//    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//    NSLog(@"duration =%f",duration);
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.moveY = keyFrame.origin.y - kScreenH;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, self.moveY);
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)pullChatDataWith5Mins
{
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl1 appendString:@"/"];
    [baseUrl1 appendString:KHDMedicalPull];
    
   // NSLog(@"self.pipe = %d,self.token = %@,self.messageId = %d",self.pipe,[DataEngine sharedDataEngine].deviceToken,self.messageId);
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pipe] forKey:@"pipe"];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.messageId] forKey:@"messageId"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:3];
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    // 创建会话返回通道pipeId
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"11111 responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
//        NSString  * message =  [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        if (code == 1 )
        {
            int pipe = [[JSONFormatFunc numberValueForKey:@"data" ofDict:responseData] intValue];
            NSLog(@"会话pipe ＝ %d,messageId = %d",pipe,self.messageId);
            self.pipe = pipe;
            self.alreadyPipe = YES;
            
//            // 立即拉取数据
            NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
            [baseUrl1 appendString:@"/"];
            [baseUrl1 appendString:KHDMedicalPull];
            
//            NSLog(@"self.pipe = %d,self.token = %@,self.messageId = %d",self.pipe,[DataEngine sharedDataEngine].deviceToken,self.messageId);
            // 参数封装
            NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
            [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pipe] forKey:@"pipe"];
            [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
            [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.messageId] forKey:@"messageId"];
            // 发送数据
            [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:3];
            
        }
    }// post 对话到server
    else if (vc == self && [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString  * message =  [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        //NSLog(@"post 对话到server ---message =%@,code = %d",message,code);
        if (code == 1 )
        {
            if (self.alreadyPipe)
            {
                // post 数据到服务器后立即拉下数据
                //self.messageId = [[responseData objectForKey:@"data"] intValue];
                
                [self pullChatDataWith5Mins];
            }
        }else if(code <0)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
    //  post 数据到服务器后立即拉下服务端全部数据返回
    else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 3)
    {
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString  * message =  [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        NSLog(@"post 数据到服务器后立即拉下服务端全部数据返回----message =%@,code = %d",message,code);
        if (code == 1 )
        {
            [self.chatArray addObjectsFromArray:(NSMutableArray *)[JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData]];
            [_cellFrameDatas removeAllObjects];
//            NSLog(@"sel.chararray = %ld",[self.chatArray count]);
            for (NSDictionary *dict in  self.chatArray) {
                
                NSString * lastMessageId = [JSONFormatFunc strValueForKey:@"messageId" ofDict:dict];
                self.messageId = [lastMessageId intValue];
                
                NSString * speaker = [JSONFormatFunc strValueForKey:@"speaker" ofDict:dict];
                NSString * userID = [DataEngine sharedDataEngine].userId;
                
                int speakerType = ([speaker isEqualToString:userID] ? 0: 1);

                MessageModel *message = [MessageModel messageModelWithDict:dict withTypeId:speakerType];
                CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
                message.showTime = NO;
                cellFrame.message = message;
                [_cellFrameDatas addObject:cellFrame];
            }
            [_chatView reloadData];
            
            //5.自动滚到最后一行
            if (_cellFrameDatas.count>= 1)
            {
                NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
                [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            }
            
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
