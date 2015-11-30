//
//  CMView.h
//  TestMyFramework
//
//  Created by Glen Lau on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Customizer.h"


@interface CMView : UIView

@end






@interface UIView (GetViewController)

//获取view的viewController
- (UIViewController *)viewController;

@end

