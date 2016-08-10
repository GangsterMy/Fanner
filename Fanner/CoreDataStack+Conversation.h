//
//  CoreDataStack+Conversation.h
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack.h"
@class Conversation;

@interface CoreDataStack (Conversation)
-(Conversation *)insertOrUpdateConversationProfile:(NSDictionary *)profile;
-(void)addConversationsWithArrayProfile:(NSArray *)profile;

@end
