//
//  ConversationListVC.h
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataTVC.h"
#import <UIKit/UIKit.h>
@class Conversation;

@interface ConversationListVC : CoreDataTVC



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end
