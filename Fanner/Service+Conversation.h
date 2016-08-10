//
//  Service+Conversation.h
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "Service.h"

@interface Service (Conversation)
//List [Conversation]
-(void)conversationListWithSuccess:(void(^)(NSArray *result)) success failure:(void(^)(NSError *error))failure;
//User [Message]
-(void)conversationWithUserID:(NSString *)userID succes:(void(^)(NSArray *result)) success failure:(void(^)(NSError *error))failure;
@end
