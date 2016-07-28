//
//  CoreDataStack+User.h
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack.h"
#import "User.h"

@interface CoreDataStack (User)

-(void)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret;
@property (nonatomic,strong) User *currentUser;

@end
