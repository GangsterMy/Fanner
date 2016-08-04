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
//单例
+(instancetype)sharedInstance {
    static Service *service;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        service = [[Service alloc] init];
        
    });
    return service;
}

//Xauth授权
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
//获取用户信息
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
//授权时使用
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

//重构Baserequest方法 把两个token参数简化了
-(void)requestWithPath:(NSString *)path
            parameters:(NSDictionary *)parameters
         requestMethod:(NSString *)requestMethod
               success:(void (^)(NSArray *result))success
               failure:(void (^)(NSError *error))failure {
    
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:path
                                            parameters:parameters
                                                  host:FANFOU_API_HOST
                                           consumerKey:CONSUMER_KEY
                                        consumerSecret:CONSUMER_SECRET
                                           accessToken:user.token
                                           tokenSecret:user.tokenSecret
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
//API_HOME_TIMELINE
-(void)requestStatusWithSuccess:(void (^)(NSArray *result))success
                        failure:(void (^)(NSError *error))failure {
    
    [self requestWithPath:API_HOME_TIMELINE
               parameters:@{@"mode":@"lite",@"count":@60,@"format":@"html"}
            requestMethod:@"GET"
                  success:success failure:failure];
}

#pragma mark - POST DATA
//post include text and photo
-(void)sendStatus:(NSString *)status
        imageData:(NSData *)imageData
  replyToStatusID:(NSString *)replyToStatusID
   repostStatusID:(NSString *)repostStatusID
          success:(void (^)(NSArray *result))success
          failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"status"] = status;
    parameters[@"format"] = @"html";
    
    if (replyToStatusID) {
        parameters[@"in_reply_to_status_id"] = replyToStatusID;
        
    }
    if (repostStatusID) {
        parameters[@"repost_status_id"] = repostStatusID;
    }
    
    if (imageData) {
        //post image
        [self postPhotoWithPath:API_UPLOAD_PHOTO parameters:parameters success:success failure:failure data:imageData];
        
    } else {
        //post status
        //        User *user = [CoreDataStack sharedCoreDataStack].currentUser;
        //        [self requestWithPath:API_UPDATE_TEXT parameters:parameters
        //                  accessToken:user.token
        //                  tokenSecret:user.tokenSecret
        //                requestMethod:@"POST"
        //                      success:success
        //                      failure:failure];
        [self requestWithPath:API_UPDATE_TEXT
                   parameters:parameters
                requestMethod:@"POST"
                      success:success
                      failure:failure];
        
    }
    
}

#pragma mark - PhotoUpload
//用图片上传的表单格式的构造
- (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters data:(NSData *)data fileName:(NSString *)fileName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}


//post photo
-(void)postPhotoWithPath:(NSString *)path
              parameters:(NSDictionary *)parameters
//            accessToken:(NSString *)accessToken
//            tokenSecret:(NSString *)tokenSecret
//          requestMethod:(NSString *)requestMethod
                 success:(void (^)(NSArray *result))success
                 failure:(void (^)(NSError *error))failure

                    data:(NSData *)imageData {
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    
    //parameter is nil 因为后面重新传了这个菜蔬包含的头
    NSMutableURLRequest *request = [[TDOAuth URLRequestForPath:path
                                                    parameters:nil
                                                          host:FANFOU_API_HOST
                                                   consumerKey:CONSUMER_KEY
                                                consumerSecret:CONSUMER_SECRET
                                                   accessToken:user.token
                                                   tokenSecret:user.tokenSecret
                                                        scheme:@"http"
                                                 requestMethod:@"POST"
                                                  dataEncoding:TDOAuthContentTypeUrlEncodedForm
                                                  headerValues:nil
                                               signatureMethod:TDOAuthSignatureMethodHmacSha1] mutableCopy];
    NSString *boundary = [self generateBoundaryString];
    //与发布文本不同的http头和body
    request.HTTPBody = [self createBodyWithBoundary:boundary parameters:parameters data:imageData fileName:@"photo"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
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

//收藏
-(void)starWithStatusID:(NSString *)statusID success:(void(^)(NSArray *result)) success failure:(void(^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@:%@.json", API_FAVORITES_CREATE,statusID];
    [self requestWithPath:path parameters:nil requestMethod:@"POST" success:success failure:failure];
}
-(void)unstarWithStatusID:(NSString *)statusID success:(void(^)(NSArray *)) success failure:(void(^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@:%@.json", API_FAVORITES_DESTROY,statusID];
    [self requestWithPath:path parameters:nil requestMethod:@"POST" success:success failure:failure];
}


@end
