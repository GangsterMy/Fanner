//
//  CoreDataStack.h
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

+(instancetype)sharedCoreDataStack;



-(void)saveContext;

@end
