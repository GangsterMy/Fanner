//
//  Service+Conversation.m
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "Service+Conversation.h"
#import "APIConstant.h"

@implementation Service (Conversation)
-(void)conversationListWithSuccess:(void(^)(NSArray *result)) success failure:(void(^)(NSError *error))failure {
    [self requestWithPath:API_CONVERSATION_LIST parameters:nil requestMethod:@"GET" success:success failure:failure];
}

-(void)conversationWithUserID:(NSString *)userID succes:(void(^)(NSArray *result)) success failure:(void(^)(NSError *error))failure {
    //userID为nil
    NSDictionary *parameters = @{@"id":userID};
    [self requestWithPath:API_DIRECT_MESSAGES_CONVERSATION parameters:parameters requestMethod:@"GET" success:success failure:failure];
}

-(void)postMessageWithUserID:(NSString *)userID text:(NSString *)text succes:(void(^)(NSArray *result)) success failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{@"user":userID,
                                 @"text":text};
    [self requestWithPath:API_DIRECT_MESSAGES_NEW parameters:parameters requestMethod:@"POST" success:success failure:failure];

}

@end
