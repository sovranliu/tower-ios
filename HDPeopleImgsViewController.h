//
//  HDPeopleImgsViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15/11/23.
//  Copyright © 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "PopupListComponent.h"

@interface HDPeopleImgsViewController : CMViewController<PopupListComponentDelegate>
@property int peopleType;
@property NSMutableArray * leftDataArra;
@property(nonatomic, strong)PopupListComponent* activePopup;
@end
