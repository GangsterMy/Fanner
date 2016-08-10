//
//  Service.h
//  Fanner
//
//  Created by 赵麦 on 7/27/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDOAuth.h>

@interface Service : NSObject

+(instancetype)sharedInstance;
-(void)authoriseWithUserName:(NSString *)userName
                    password:(NSString *)passWord
                     success:(void (^)(NSString *token, NSString *tokenSecret)) success;

-(void)requestVerifyCredential:(NSDictionary *)parameters
                   accessToken:(NSString *)accessToken
                   tokenSecret:(NSString *)tokenSecret
                 requestMethod:(NSString *)requestMethod
                       success:(void (^)(NSDictionary *result))success;

-(void)requestStatusWithSuccess:(void (^)(NSArray *result))success
                        failure:(void (^)(NSError *error))failure;

-(void)sendStatus:(NSString *)status
        imageData:(NSData *)imageData
  replyToStatusID:(NSString *)replyToStatusID
   repostStatusID:(NSString *)repostStatusID
          success:(void (^)(NSArray *result))success
          failure:(void (^)(NSError *error))failure;

-(void)requestWithPath:(NSString *)path
            parameters:(NSDictionary *)parameters
         requestMethod:(NSString *)requestMethod
               success:(void (^)(NSArray *result))success
               failure:(void (^)(NSError *error))failure;

-(void)starWithStatusID:(NSString *)statusID success:(void(^)(id result)) success failure:(void(^)(NSError *error))failure;
-(void)unstarWithStatusID:(NSString *)statusID success:(void(^)(id result)) success failure:(void(^)(NSError *error))failure;

@end
