//
//  User+CoreDataProperties.h
//  Fanner
//
//  Created by 赵麦 on 8/9/16.
//  Copyright © 2016 歹徒. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"
#import "Status.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iconURL;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSString *tokenSecret;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSNumber *followers_count;
@property (nullable, nonatomic, retain) NSNumber *friends_count;
@property (nullable, nonatomic, retain) NSNumber *favourites_count;
@property (nullable, nonatomic, retain) NSNumber *statuses_count;
@property (nullable, nonatomic, retain) NSSet<Status *> *statuses;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStatusesObject:(Status *)value;
- (void)removeStatusesObject:(Status *)value;
- (void)addStatuses:(NSSet<Status *> *)values;
- (void)removeStatuses:(NSSet<Status *> *)values;

@end

NS_ASSUME_NONNULL_END
