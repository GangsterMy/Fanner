//
//  Service+Photo.m
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "Service+Photo.h"
#import "APIConstant.h"

@implementation Service (Photo)
- (void)getPhotosUserTimelineWithUserID:(NSString *)userID sucess:(void(^)(id result))sucess failure:(void (^)(NSError *error))failure; {
    NSDictionary *parameters = @{@"id":userID};
    [self requestWithPath:API_PHOTOS_TIMELINE parameters:parameters requestMethod:@"GET" success:sucess failure:failure];
}


@end
