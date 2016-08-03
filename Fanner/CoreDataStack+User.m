//
//  CoreDataStack+User.m
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack+User.h"
#import "User.h"

NSString *const USER_ENTITY = @"User";

@implementation CoreDataStack (User)
@dynamic currentUser;

-(User *)currentUser {
//    NSString *str = [NSString stringWithFormat:@"%@",@YES];
    User *user =[self findUniqueEntityWithUniqueID:@"isActive" value:@YES];
    return user;
}

//search status through active user
-(User *)findUniqueEntityWithUniqueID:(NSString *)key value:(id)value {
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    fr.predicate = predicate;
    
    NSError *error;
    NSArray *users = [self.context executeFetchRequest:fr error:&error];
    
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

-(User *)findUserWithID:(NSString *)uid {
    User *user = [self findUniqueEntityWithUniqueID:@"uid" value:uid];
    return user;
}

-(User *)checkExistdWithUserID:(NSString *)uid {
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid like %@", uid];
    fr.predicate = predicate;
    
    NSError *error;
    NSArray *users = [self.context executeFetchRequest:fr error:&error];
    
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

-(User *)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret {
    User *user = [self checkExistdWithUserID:userProfile[@"id"]];
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY inManagedObjectContext:self.context];
        
    }
    
    user.name = userProfile[@"name"];
    user.uid =  userProfile[@"id"];
    user.iconURL = userProfile[@"profile_image_url"];
    if (token) {
    user.token = token;
    }
    if (tokenSecret) {
    user.tokenSecret = tokenSecret;
    }
    
    return user;
}

@end
