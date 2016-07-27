//
//  AccountsTableViewController.m
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "CoreDataStack+User.h"

@implementation AccountsTableViewController

-(void)configureFetch {
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
}


@end
