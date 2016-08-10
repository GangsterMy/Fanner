//
//  CoreDataStack+Common.h
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack (Common)

-(NSManagedObject *)findUniqueEntityWithUniqueKey:(NSString *)key value:(id)value entityName:(NSString *)entityName;
- (NSDate *)dateFromString:(NSString *)dateStr;

@end
