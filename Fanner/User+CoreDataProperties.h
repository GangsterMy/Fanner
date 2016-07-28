//
//  User+CoreDataProperties.h
//  Fanner
//
//  Created by 赵麦 on 7/28/16.
//  Copyright © 2016 歹徒. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iconURL;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSString *tokenSecret;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *statuses;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStatusesObject:(NSManagedObject *)value;
- (void)removeStatusesObject:(NSManagedObject *)value;
- (void)addStatuses:(NSSet<NSManagedObject *> *)values;
- (void)removeStatuses:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
