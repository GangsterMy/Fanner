//
//  CoreDataStack+Common.m
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack+Common.h"

@implementation CoreDataStack (Common)
//e.g User key=uid value=~4dnfiqhgoe
-(NSManagedObject *)findUniqueEntityWithUniqueKey:(NSString *)key value:(id)value entityName:(NSString *)entityName {
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    fr.predicate = predicate;
    
    NSError *error;
    NSArray *users = [self.context executeFetchRequest:fr error:&error];
    
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

- (NSDate *)dateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"E MM dd HH:mm:ssZZZZZ yyyy";
    NSDate *createdDate = [dateFormatter dateFromString:dateStr];
    return createdDate;
}




@end
