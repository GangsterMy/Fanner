//
//  UserViewController.h
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARSegmentPager/ARSegmentPageController.h>
#import "CoreDataTVC.h"

@interface UserViewController : ARSegmentPageController

@property (nonatomic,strong) NSString *userID;

@end
