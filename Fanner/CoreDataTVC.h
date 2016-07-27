//
//  CoreDataTVC.h
//  Fanner
//
//  Created by 赵麦 on 7/27/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTVC : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong)NSFetchedResultsController *frc;

-(void)performFetch;

@end
