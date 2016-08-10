//
//  CoreDataStack+Message.h
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack.h"
@class Message;
@interface CoreDataStack (Message)
-(Message *)insertOrUpdateWithMessageProfile:(NSDictionary *)profile;
-(void)addMessageWithArray:(NSArray *)array;
-(NSArray *)fetchMessageWithUserID:(NSString *)userID;
@end
