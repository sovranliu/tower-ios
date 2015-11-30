//
//  HDPeopleImgsViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15/11/23.
//  Copyright © 2015年 HD. All rights reserved.
//

#import "HDPeopleImgsViewController.h"
#import "MLButton.h"
#import "UIView+ColorPointAndMask.h"
#import "UIView+Positioning.h"
#import "HDSelfAskDocViewController.h"

#define kTopTipHeight (kScreenH- 64 - 400)/2.0

@interface HDPeopleImgsViewController ()

@end

@implementation HDPeopleImgsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"视图";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{

}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
      //  [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    
    [self initSelfCheckPeopleBodyImgsNavigationItem];
    [self initBodyImgs:0];
}

#pragma mark - UIReflash work1

- (void)initSelfCheckPeopleBodyImgsNavigationItem
{
    UIButton *addFamilyNumBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addFamilyNumBtn setTitle:@"选择视图" forState:UIControlStateNormal];
    [addFamilyNumBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    addFamilyNumBtn.tag = 101;
    [addFamilyNumBtn setFrame:CGRectMake(0, 0, 80, 35)];
    [addFamilyNumBtn addTarget:self action:@selector(selfCheckPeopleBodyImgsAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addFamilyNumBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

- (void)selfCheckPeopleBodyImgsAction:(id)sender
{
    
    if (self.activePopup)
    {
        self.activePopup = nil;
    }else
    {
        PopupListComponent *popupList = [[PopupListComponent alloc] init];
        NSArray* listItems = [NSArray arrayWithObjects:
                              [[PopupListComponentItem alloc] initWithCaption:@"男性-正面" image:nil itemId:1 showCaption:YES],
                              [[PopupListComponentItem alloc] initWithCaption:@"男性-背面" image:nil itemId:2 showCaption:YES],
                              [[PopupListComponentItem alloc] initWithCaption:@"女性-正面" image:nil itemId:3 showCaption:YES],
                              [[PopupListComponentItem alloc] initWithCaption:@"女性-背面" image:nil itemId:4 showCaption:YES],
                              nil];
        
        popupList.textColor = [UIColor whiteColor];
        popupList.allowedArrowDirections = UIPopoverArrowDirectionUp;
        popupList.font =[UIFont systemFontOfSize:14.0];
        
        // Optional: store any object you want to have access to in the delegeate callback(s):
        // popupList.userInfo = @"Value to hold on to";
        
        UIView * btnView = (UIView *)sender;
        UIView * btnViewCopyFrame = [[UIView alloc] initWithFrame:CGRectMake(btnView.frame.origin.x, btnView.frame.origin.y -40, btnView.frame.size.width, btnView.frame.size.height)];
        
        [popupList showAnchoredTo:btnViewCopyFrame inView:self.view withItems:listItems withDelegate:self];
        
        self.activePopup = popupList;
    }
}

#pragma mark - popupList delegate
- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId
{
    NSLog(@"User chose item with id = %d", itemId);
    if (itemId == 1)
    {
        self.peopleType = 0;
    }else if (itemId == 2)
    {
        self.peopleType = 1;
    }else if (itemId == 3)
    {
        self.peopleType = 2;
    }else if (itemId == 4)
    {
        self.peopleType = 3;
    }
    
    for(UIView *subview in [self.view subviews])
        [subview removeFromSuperview];
    
     [self initBodyImgs:self.peopleType];
    self.activePopup = nil;
}

- (void) popupListcompoentDidCancel:(PopupListComponent *)sender
{
    NSLog(@"Popup cancelled");
    self.activePopup = nil;
}

- (void)initBodyImgs:(int)type
{
    switch (type)
    {
        case 0:
        {
            // 头
            MLButton *button1 = [MLButton buttonWithType:UIButtonTypeCustom];
            button1.isIgnoreTouchInTransparentPoint = YES;
            button1.backgroundColor = [UIColor clearColor];
            [button1 setImage:[UIImage imageNamed:@"male_front_head"] forState:UIControlStateNormal];
            //button1.imageView.contentMode = UIViewContentModeScaleToFill;
            [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button1];
            button1.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 颈
            MLButton *button2 = [MLButton buttonWithType:UIButtonTypeCustom];
            button2.isIgnoreTouchInTransparentPoint = YES;
            button2.backgroundColor = [UIColor clearColor];
            [button2 setImage:[UIImage imageNamed:@"male_front_neck"] forState:UIControlStateNormal];
            button2.imageView.contentMode = UIViewContentModeScaleToFill;
            [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button2];
            button2.frame =CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 胸
            MLButton *button3 = [MLButton buttonWithType:UIButtonTypeCustom];
            button3.isIgnoreTouchInTransparentPoint = YES;
            button3.backgroundColor = [UIColor clearColor];
            [button3 setImage:[UIImage imageNamed:@"male_front_chest"] forState:UIControlStateNormal];
            button3.imageView.contentMode = UIViewContentModeScaleToFill;
            [button3 addTarget:self action:@selector(button3Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button3];
            button3.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腹部
            MLButton *button4 = [MLButton buttonWithType:UIButtonTypeCustom];
            button4.isIgnoreTouchInTransparentPoint = YES;
            button4.backgroundColor = [UIColor clearColor];
            [button4 setImage:[UIImage imageNamed:@"male_front_belly"] forState:UIControlStateNormal];
            button4.imageView.contentMode = UIViewContentModeScaleToFill;
            [button4 addTarget:self action:@selector(button4Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button4];
            button4.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 手臂
            MLButton *button5 = [MLButton buttonWithType:UIButtonTypeCustom];
            button5.isIgnoreTouchInTransparentPoint = YES;
            button5.backgroundColor = [UIColor clearColor];
            [button5 setImage:[UIImage imageNamed:@"male_front_arm"] forState:UIControlStateNormal];
            button5.imageView.contentMode = UIViewContentModeScaleToFill;
            [button5 addTarget:self action:@selector(button5Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button5];
            button5.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 臀部
            MLButton *button6 = [MLButton buttonWithType:UIButtonTypeCustom];
            button6.isIgnoreTouchInTransparentPoint = YES;
            button6.backgroundColor = [UIColor clearColor];
            [button6 setImage:[UIImage imageNamed:@"male_front_basin"] forState:UIControlStateNormal];
            button6.imageView.contentMode = UIViewContentModeScaleToFill;
            [button6 addTarget:self action:@selector(button6Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button6];
            button6.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腿部
            MLButton *button7 = [MLButton buttonWithType:UIButtonTypeCustom];
            button7.isIgnoreTouchInTransparentPoint = YES;
            button7.backgroundColor = [UIColor clearColor];
            [button7 setImage:[UIImage imageNamed:@"male_front_leg"] forState:UIControlStateNormal];
            button7.imageView.contentMode = UIViewContentModeScaleToFill;
            [button7 addTarget:self action:@selector(button7Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button7];
            button7.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
        }
            break;
        case 1:
        {
            // 头
            MLButton *button1 = [MLButton buttonWithType:UIButtonTypeCustom];
            button1.isIgnoreTouchInTransparentPoint = YES;
            button1.backgroundColor = [UIColor clearColor];
            [button1 setImage:[UIImage imageNamed:@"male_back_head"] forState:UIControlStateNormal];
            //button1.imageView.contentMode = UIViewContentModeScaleToFill;
            [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button1];
            button1.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 骨
            MLButton *button2 = [MLButton buttonWithType:UIButtonTypeCustom];
            button2.isIgnoreTouchInTransparentPoint = YES;
            button2.backgroundColor = [UIColor clearColor];
            [button2 setImage:[UIImage imageNamed:@"male_back_neck"] forState:UIControlStateNormal];
            button2.imageView.contentMode = UIViewContentModeScaleToFill;
            [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button2];
            button2.frame =CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 臀部
            MLButton *button3 = [MLButton buttonWithType:UIButtonTypeCustom];
            button3.isIgnoreTouchInTransparentPoint = YES;
            button3.backgroundColor = [UIColor clearColor];
            [button3 setImage:[UIImage imageNamed:@"male_back_back"] forState:UIControlStateNormal];
            button3.imageView.contentMode = UIViewContentModeScaleToFill;
            [button3 addTarget:self action:@selector(button8Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button3];
            button3.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腹部
            MLButton *button4 = [MLButton buttonWithType:UIButtonTypeCustom];
            button4.isIgnoreTouchInTransparentPoint = YES;
            button4.backgroundColor = [UIColor clearColor];
            [button4 setImage:[UIImage imageNamed:@"male_back_butt"] forState:UIControlStateNormal];
            button4.imageView.contentMode = UIViewContentModeScaleToFill;
            [button4 addTarget:self action:@selector(button9Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button4];
            button4.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 手臂
            MLButton *button5 = [MLButton buttonWithType:UIButtonTypeCustom];
            button5.isIgnoreTouchInTransparentPoint = YES;
            button5.backgroundColor = [UIColor clearColor];
            [button5 setImage:[UIImage imageNamed:@"male_back_arm"] forState:UIControlStateNormal];
            button5.imageView.contentMode = UIViewContentModeScaleToFill;
            [button5 addTarget:self action:@selector(button5Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button5];
            button5.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腿部
            MLButton *button6 = [MLButton buttonWithType:UIButtonTypeCustom];
            button6.isIgnoreTouchInTransparentPoint = YES;
            button6.backgroundColor = [UIColor clearColor];
            [button6 setImage:[UIImage imageNamed:@"male_back_leg"] forState:UIControlStateNormal];
            button6.imageView.contentMode = UIViewContentModeScaleToFill;
            [button6 addTarget:self action:@selector(button7Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button6];
            button6.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);

        }
            break;
        case 2:
        {
            // 头
            MLButton *button1 = [MLButton buttonWithType:UIButtonTypeCustom];
            button1.isIgnoreTouchInTransparentPoint = YES;
            button1.backgroundColor = [UIColor clearColor];
            [button1 setImage:[UIImage imageNamed:@"female_front_head"] forState:UIControlStateNormal];
            //button1.imageView.contentMode = UIViewContentModeScaleToFill;
            [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button1];
            button1.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 颈
            MLButton *button2 = [MLButton buttonWithType:UIButtonTypeCustom];
            button2.isIgnoreTouchInTransparentPoint = YES;
            button2.backgroundColor = [UIColor clearColor];
            [button2 setImage:[UIImage imageNamed:@"female_front_neck"] forState:UIControlStateNormal];
            button2.imageView.contentMode = UIViewContentModeScaleToFill;
            [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button2];
            button2.frame =CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 胸
            MLButton *button3 = [MLButton buttonWithType:UIButtonTypeCustom];
            button3.isIgnoreTouchInTransparentPoint = YES;
            button3.backgroundColor = [UIColor clearColor];
            [button3 setImage:[UIImage imageNamed:@"female_front_chest"] forState:UIControlStateNormal];
            button3.imageView.contentMode = UIViewContentModeScaleToFill;
            [button3 addTarget:self action:@selector(button3Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button3];
            button3.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腹部
            MLButton *button4 = [MLButton buttonWithType:UIButtonTypeCustom];
            button4.isIgnoreTouchInTransparentPoint = YES;
            button4.backgroundColor = [UIColor clearColor];
            [button4 setImage:[UIImage imageNamed:@"female_front_belly"] forState:UIControlStateNormal];
            button4.imageView.contentMode = UIViewContentModeScaleToFill;
            [button4 addTarget:self action:@selector(button4Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button4];
            button4.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 手臂
            MLButton *button5 = [MLButton buttonWithType:UIButtonTypeCustom];
            button5.isIgnoreTouchInTransparentPoint = YES;
            button5.backgroundColor = [UIColor clearColor];
            [button5 setImage:[UIImage imageNamed:@"female_front_arm"] forState:UIControlStateNormal];
            button5.imageView.contentMode = UIViewContentModeScaleToFill;
            [button5 addTarget:self action:@selector(button5Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button5];
            button5.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 臀部
            MLButton *button6 = [MLButton buttonWithType:UIButtonTypeCustom];
            button6.isIgnoreTouchInTransparentPoint = YES;
            button6.backgroundColor = [UIColor clearColor];
            [button6 setImage:[UIImage imageNamed:@"female_front_basin"] forState:UIControlStateNormal];
            button6.imageView.contentMode = UIViewContentModeScaleToFill;
            [button6 addTarget:self action:@selector(button10Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button6];
            button6.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腿部
            MLButton *button7 = [MLButton buttonWithType:UIButtonTypeCustom];
            button7.isIgnoreTouchInTransparentPoint = YES;
            button7.backgroundColor = [UIColor clearColor];
            [button7 setImage:[UIImage imageNamed:@"female_front_leg"] forState:UIControlStateNormal];
            button7.imageView.contentMode = UIViewContentModeScaleToFill;
            [button7 addTarget:self action:@selector(button7Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button7];
            button7.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);

        }
            break;
        case 3:
        {
            // 头
            MLButton *button1 = [MLButton buttonWithType:UIButtonTypeCustom];
            button1.isIgnoreTouchInTransparentPoint = YES;
            button1.backgroundColor = [UIColor clearColor];
            [button1 setImage:[UIImage imageNamed:@"female_back_head"] forState:UIControlStateNormal];
            //button1.imageView.contentMode = UIViewContentModeScaleToFill;
            [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button1];
            button1.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 颈
            MLButton *button2 = [MLButton buttonWithType:UIButtonTypeCustom];
            button2.isIgnoreTouchInTransparentPoint = YES;
            button2.backgroundColor = [UIColor clearColor];
            [button2 setImage:[UIImage imageNamed:@"female_back_neck"] forState:UIControlStateNormal];
            button2.imageView.contentMode = UIViewContentModeScaleToFill;
            [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button2];
            button2.frame =CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 背
            MLButton *button3 = [MLButton buttonWithType:UIButtonTypeCustom];
            button3.isIgnoreTouchInTransparentPoint = YES;
            button3.backgroundColor = [UIColor clearColor];
            [button3 setImage:[UIImage imageNamed:@"female_back_back"] forState:UIControlStateNormal];
            button3.imageView.contentMode = UIViewContentModeScaleToFill;
            [button3 addTarget:self action:@selector(button8Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button3];
            button3.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腹部
            MLButton *button4 = [MLButton buttonWithType:UIButtonTypeCustom];
            button4.isIgnoreTouchInTransparentPoint = YES;
            button4.backgroundColor = [UIColor clearColor];
            [button4 setImage:[UIImage imageNamed:@"female_back_butt"] forState:UIControlStateNormal];
            button4.imageView.contentMode = UIViewContentModeScaleToFill;
            [button4 addTarget:self action:@selector(button9Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button4];
            button4.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 手臂
            MLButton *button5 = [MLButton buttonWithType:UIButtonTypeCustom];
            button5.isIgnoreTouchInTransparentPoint = YES;
            button5.backgroundColor = [UIColor clearColor];
            [button5 setImage:[UIImage imageNamed:@"female_back_arm"] forState:UIControlStateNormal];
            button5.imageView.contentMode = UIViewContentModeScaleToFill;
            [button5 addTarget:self action:@selector(button5Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button5];
            button5.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
            
            // 腿部
            MLButton *button6 = [MLButton buttonWithType:UIButtonTypeCustom];
            button6.isIgnoreTouchInTransparentPoint = YES;
            button6.backgroundColor = [UIColor clearColor];
            [button6 setImage:[UIImage imageNamed:@"female_back_leg"] forState:UIControlStateNormal];
            button6.imageView.contentMode = UIViewContentModeScaleToFill;
            [button6 addTarget:self action:@selector(button7Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button6];
            button6.frame = CGRectMake(self.view.centerX- 100, kTopTipHeight, 200, 400);
        }
            break;
            
        default:
            break;
    }
}


- (void)pressTextStr:(NSString *)str
{
    for (NSString * text in  self.leftDataArra) {
        if ([text isEqualToString:str])
        {
            
            NSLog(@"vc = %@",self.parentViewController);
            
            //[(HDSelfAskDocViewController *)self.parentViewController selectTableCellAction:0];
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:text, @"name",nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalBodyImg object:userInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

- (void)button1Pressed
{
    [self pressTextStr:@"头部"];
}
- (void)button2Pressed
{
    [self pressTextStr:@"颈部"];
}
- (void)button3Pressed
{
    [self pressTextStr:@"胸部"];
}
- (void)button4Pressed
{
    [self pressTextStr:@"腹部"];
}
- (void)button5Pressed
{
    [self pressTextStr:@"上肢"];
   
}
- (void)button6Pressed
{
    [self pressTextStr:@"男性生殖"];
}

- (void)button7Pressed
{
    [self pressTextStr:@"下肢"];
}

- (void)button8Pressed
{
    [self pressTextStr:@"骨"];
}

- (void)button9Pressed
{
    [self pressTextStr:@"臀部"];
}

-(void)button10Pressed
{
    [self pressTextStr:@"女性生殖"];
}

@end
