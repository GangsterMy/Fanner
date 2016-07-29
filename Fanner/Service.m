//
//  Service.m
//  Fanner
//
//  Created by 赵麦 on 7/27/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "Service.h"
#import "APIConstant.h"
#import "CoreDataStack.h"
#import "CoreDataStack+User.h"

@interface Service ()
@property (nonnull,strong) NSURLSession *session;

@end

@implementation Service

+(instancetype)sharedInstance {
    static Service *service;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        service = [[Service alloc] init];
        
    });
    return service;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 60;
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

//Xauth
//最终目的是获取到access token and access secret
-(void)authoriseWithUserName:(NSString *)userName
                    password:(NSString *)passWord
                     success:(void (^)(NSString *token, NSString *tokenSecret)) success {
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:API_ACCESS_TOKEN
                                         GETParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        userName, @"x_auth_username",
                                                        passWord, @"x_auth_password",
                                                        @"client_auth", @"x_auth_mode",
                                                        nil]
                                                  host:FANFOU_BASE_HOST
                                           consumerKey:CONSUMER_KEY
                                        consumerSecret:CONSUMER_SECRET
                                           accessToken:nil
                                           tokenSecret:nil];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        NSArray *sp1 = [str componentsSeparatedByString:@"="];
        NSString *tokenSecret = sp1[2];
        NSString *ele1 = sp1[1];
        NSArray *sp2 = [ele1 componentsSeparatedByString:@"&"];
        NSString *token = sp2[0];
        
        //https://github.com/FanfouAPI/FanFouAPIDoc/wiki/Oauthoauth_token=8ldIZyxQeVrFZXFOZH5tAwj6vzJYuLQpl0WUEYtWc&oauth_token_secret=x6qpRnlEmW9JbQn4PQVVeVG8ZLPEx6A0TOebgwcuA
        //oauth_token=8ldIZyxQeVrFZXFOZH5tAwj6vzJYuLQpl0WUEYtWc&oauth_token_secret=x6qpRnlEmW9JbQn4PQVVeVG8ZLPEx6A0TOebgwcuA
        
        success(token,tokenSecret);
    }];
    
    [task resume];
    
}

-(void)requestVerifyCredential:(NSDictionary *)parameters
                   accessToken:(NSString *)accessToken
                   tokenSecret:(NSString *)tokenSecret
                 requestMethod:(NSString *)requestMethod
                       success:(void (^)(NSDictionary *result))success {
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:API_VERIFY_CREDENTIALS
                                            parameters:parameters
                                                  host:FANFOU_API_HOST
                                           consumerKey:CONSUMER_KEY
                                        consumerSecret:CONSUMER_SECRET
                                           accessToken:accessToken
                                           tokenSecret:tokenSecret
                                                scheme:@"http"
                                         requestMethod:requestMethod
                                          dataEncoding:TDOAuthContentTypeUrlEncodedForm
                                          headerValues:nil
                                       signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateWithUserProfile:result token:accessToken tokenSecret:tokenSecret];
        
        success(result);
    }];
    
    [task resume];
    
}

#pragma mark - Base Request
-(void)requestWithPath:(NSString *)path
            parameters:(NSDictionary *)parameters
           accessToken:(NSString *)accessToken
           tokenSecret:(NSString *)tokenSecret
         requestMethod:(NSString *)requestMethod
               success:(void (^)(NSArray *result))success
               failure:(void (^)(NSError *error))failure {
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:path
                                            parameters:parameters
                                                  host:FANFOU_API_HOST
                                           consumerKey:CONSUMER_KEY
                                        consumerSecret:CONSUMER_SECRET
                                           accessToken:accessToken
                                           tokenSecret:tokenSecret
                                                scheme:@"http"
                                         requestMethod:requestMethod
                                          dataEncoding:TDOAuthContentTypeUrlEncodedForm
                                          headerValues:nil
                                       signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        } else {
            
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"result = %@", result);
            success(result);
        }
    }];
    
    [task resume];
    
}

#pragma mark - Status
-(void)requestStatusWithSuccess:(void (^)(NSArray *result))success
                        failure:(void (^)(NSError *error))failure {
    
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    
    [self requestWithPath:API_HOME_TIMELINE parameters:nil accessToken:user.token tokenSecret:user.tokenSecret requestMethod:@"GET" success:success failure:failure];
    
    
}



@end
