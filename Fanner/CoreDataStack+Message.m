//
//  CoreDataStack+Message.m
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack+Message.h"
#import "Message.h"
#import "CoreDataStack+Common.h"
#import "EntityNameConstant.h"
#import "CoreDataStack+User.h"

@implementation CoreDataStack (Message)

-(Message *)insertOrUpdateWithMessageProfile:(NSDictionary *)profile {
    
    //profile对应的借口那个部分
    //conversation-list返回的字典中键值dm所对应的值(字典)
    //1.checkExist
   Message *mg = (Message *) [self findUniqueEntityWithUniqueKey:@"mid" value:profile[@"id"] entityName:MESSAGE_ENTITY];
    if (!mg) {
       mg = [NSEntityDescription insertNewObjectForEntityForName:MESSAGE_ENTITY inManagedObjectContext:self.context];
    }
    
    NSString *mid = profile[@"id"];
    NSString *text = profile[@"text"];
    NSString *sender_id = profile[@"sender_id"];
    NSString *recipient_id = profile[@"recipient_id"];
    NSString *created_at = profile[@"created_at"];
    NSString *sender_screen_name = profile[@"sender_screen_name"];
    NSString *recipient_screen_name = profile[@"recipient_screen_name"];
    
    NSDictionary *senderProfile = profile[@"sender"];
    NSDictionary *recipientProfile = profile[@"recipient"];
    
    mg.mid = mid;
    mg.text = text;
    mg.sender_id = sender_id;
    mg.recipient_id = recipient_id;
    mg.created_at = [self dateFromString:created_at];
    mg.sender_screen_name = sender_screen_name;
    mg.recipient_screen_name = recipient_screen_name;
   
    //插入用户表
    User *sender = [self insertOrUpdateWithUserProfile:senderProfile token:nil tokenSecret:nil];
    User *recipient = [self insertOrUpdateWithUserProfile:recipientProfile token:nil tokenSecret:nil];
    mg.sender = sender;
    mg.recipient = recipient;
    
    return mg;

}

//add all messages to coredata
-(void)addMessageWithArray:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context performBlockAndWait:^{
             [self insertOrUpdateWithMessageProfile:obj];
        }];
    }];
}

-(NSArray *)fetchMessageWithUserID:(NSString *)userID {
   
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:MESSAGE_ENTITY];
  
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sender_id = %@ OR recipient_id = %@", userID, userID];
    fr.predicate = pre;
   
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES];
    fr.sortDescriptors = @[sortDescriptor];
    
    NSError *error;
    NSArray *arr = [self.context executeFetchRequest:fr error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
   
    return arr;
    
}



@end
