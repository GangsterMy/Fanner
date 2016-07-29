//
//  CoreDataStack+Status.m
//  Fanner
//
//  Created by 赵麦 on 7/29/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack+Status.h"
#import "Status.h"
#import "CoreDataStack+User.h"

static NSString *const STATUS_ENTITY = @"Status";

@implementation CoreDataStack (Status)

-(Status *)checkExistdWithStatusID:(NSString *)sid {
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:STATUS_ENTITY];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sid like %@", sid];
    fr.predicate = predicate;
    
    NSError *error;
    NSArray *status = [self.context executeFetchRequest:fr error:&error];
    
    if (status.count > 0) {
        return status[0];
    }
    return nil;
}

-(Status *)insertOrUpdateWithStatusProfile:(NSDictionary *)statusProfile {
    
    Status *status = [self checkExistdWithStatusID:statusProfile[@"id"]];
    
    if (!status) {
        status = [NSEntityDescription insertNewObjectForEntityForName:STATUS_ENTITY inManagedObjectContext:self.context];
        
    }
    
    NSString *dateStr = statusProfile[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MM dd HH:mm:ssZZZZZ yyyy";
    status.created_at = [formatter dateFromString:dateStr];
    status.sid = statusProfile[@"id"];
    status.source = statusProfile[@"source"];
    status.text = statusProfile[@"text"];
    
    return status;
}

-(void)insertStatusWithArrayProfile:(NSArray *)arrayProfile  {
    [arrayProfile enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.context performBlockAndWait:^{
            //insert status
            Status *status = [self insertOrUpdateWithStatusProfile:obj];
            //insert user
            User *user = [self insertOrUpdateWithUserProfile:obj[@"user"] token:nil tokenSecret:nil];
            //set up relationship
            status.user = user;
            
        }];
        
        
        
    }];
}

@end
