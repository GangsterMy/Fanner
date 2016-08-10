//
//  CoreDataStack+User.m
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack+User.h"
#import "User.h"
#import "CoreDataStack+Common.h"
#import "EntityNameConstant.h"

@implementation CoreDataStack (User)
@dynamic currentUser;

-(User *)currentUser {
//    NSString *str = [NSString stringWithFormat:@"%@",@YES];
//    User *user =[self findUniqueEntityWithUniqueID:@"isActive" value:@YES];
    User *user = (User *)[self findUniqueEntityWithUniqueKey:@"isActive" value:@YES entityName:USER_ENTITY];
    return user;
}

//search status through active user

-(User *)findUserWithID:(NSString *)uid {
    User *user = (User *)[self findUniqueEntityWithUniqueKey:@"uid" value:uid entityName:USER_ENTITY];
    return user;
}

//-(User *)checkExistdWithUserID:(NSString *)uid {
//    
//    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid like %@", uid];
//    fr.predicate = predicate;
//    
//    NSError *error;
//    NSArray *users = [self.context executeFetchRequest:fr error:&error];
//    
//    if (users.count > 0) {
//        return users[0];
//    }
//    return nil;
//}

-(User *)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret {
    //checkExistdWithUserID -> common.h
    User *user = (User *)[self findUniqueEntityWithUniqueKey:@"uid" value:userProfile[@"id"] entityName:USER_ENTITY];
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY inManagedObjectContext:self.context];
        
    }
    
    user.name = userProfile[@"name"];
    user.uid =  userProfile[@"id"];
    user.iconURL = userProfile[@"profile_image_url"];
    
    user.followers_count = userProfile[@"followers_count"];
    user.friends_count = userProfile[@"friends_count"];
    user.statuses_count = userProfile[@"statuses_count"];
    user.favourites_count = userProfile[@"favourites_count"];
    
    if (token) {
    user.token = token;
    }
    if (tokenSecret) {
    user.tokenSecret = tokenSecret;
    }
  
    [self saveContext];
    
    return user;
}

@end
