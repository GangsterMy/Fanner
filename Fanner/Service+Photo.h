//
//  Service+Photo.h
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "Service.h"

@interface Service (Photo)

- (void)getPhotosUserTimelineWithUserID:(NSString *)userID sucess:(void(^)(id result))sucess failure:(void (^)(NSError *error))failure;

@end
