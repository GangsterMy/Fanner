//
//  CoreDataStack+Conversation.m
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack+Conversation.h"
#import "Conversation.h"
#import "CoreDataStack+Common.h"
#import "EntityNameConstant.h"
#import "CoreDataStack+Message.h"

@implementation CoreDataStack (Conversation)
//插入单条
-(Conversation *)insertOrUpdateConversationProfile:(NSDictionary *)profile {
    //coversation_list返回的数据
    NSString *otherid = profile[@"otherid"];
    NSString *msg_num = profile[@"msg_num"];
    NSString *new_conv = profile[@"new_conv"];
    NSDictionary *messProfile = profile[@"dm"];
    
    Conversation *conversation = (Conversation *)[self findUniqueEntityWithUniqueKey:@"otherid" value:otherid entityName:CONVERSATION_ENTITY];
    if (!conversation) {
        //insert
       conversation = [NSEntityDescription insertNewObjectForEntityForName:CONVERSATION_ENTITY inManagedObjectContext:self.context];
    }
    //update
    conversation.otherid = otherid;
    //nsstring -> nsnumber
    conversation.msg_num = @(msg_num.integerValue);
    //nsstring -> nsnumber(bool)
    conversation.new_conv = @(new_conv.boolValue);
    
    //insert message
    Message *mg = [self insertOrUpdateWithMessageProfile:messProfile];
    //build relationships
    conversation.message = mg;
    
    return conversation;
}

-(void)addConversationsWithArrayProfile:(NSArray *)profile {
    //syn
    [self.context performBlockAndWait:^{
        
        [profile enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertOrUpdateConversationProfile:dic];
        }];
    }];
}




@end
