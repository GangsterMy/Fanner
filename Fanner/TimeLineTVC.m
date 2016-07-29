//
//  TimeLineTVC.m
//  Fanner
//
//  Created by 赵麦 on 7/29/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "TimeLineTVC.h"
#import "CoreDataStack+User.h"
#import "CoreDataStack+Status.h"
#import "TimeLineTableViewCell.h"
#import "Service.h"

@implementation TimeLineTVC

-(void)viewDidLoad {
    [super viewDidLoad];
    //.xib cell registe
    UINib *nib = [UINib nibWithNibName:@"TimeLineTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TLCell"];
    
    //auto content size
    self.tableView.estimatedRowHeight = 100;
    
    [[Service sharedInstance]requestStatusWithSuccess:^(NSArray *result) {
        [[CoreDataStack sharedCoreDataStack] insertStatusWithArrayProfile:result];
        [self configureFetch];
        [self performFetch];
    } failure:^(NSError *error) {
        
    }];
     
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(void)configureFetch {
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Status"];
    NSArray *descriptors = @[[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES]];
    fr.sortDescriptors = descriptors;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLCell"];
    
    Status *status = [self.frc objectAtIndexPath:indexPath];
    [cell configureWithStatus:status];
    
    return cell;
}



@end
