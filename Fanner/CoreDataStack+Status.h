//
//  CoreDataStack+Status.h
//  Fanner
//
//  Created by 赵麦 on 7/29/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack.h"
@class Status;

@interface CoreDataStack (Status)

- (void)insertOrUpdateStatusWithObjects:(NSArray *)objects;

-(void)insertStatusWithArrayProfile:(NSArray *)arrayProfile;
-(Status *)insertOrUpdateWithStatusProfile:(NSDictionary *)statusProfile;
- (NSFetchRequest *)photoFetchRequest;


@end
