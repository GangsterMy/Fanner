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
#import "SDImageCache.h"

@interface TimeLineTableViewCell()


@end

@implementation TimeLineTVC

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createRefreshControl];
    //.xib cell registe
    UINib *nib = [UINib nibWithNibName:@"TimeLineTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TLCell"];
    
    //auto content size
    self.tableView.estimatedRowHeight = 100;
    [self requestData];
     
    
}

-(void)requestData {
    [[Service sharedInstance]requestStatusWithSuccess:^(NSArray *result) {
        [[CoreDataStack sharedCoreDataStack] insertStatusWithArrayProfile:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configureFetch];
            [self performFetch];
        });
        
    } failure:^(NSError *error) {
        
    }];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewAutomaticDimension > 44) {
        return 44;
    }
    return UITableViewAutomaticDimension;
}

-(void)configureFetch {
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Status"];
    NSArray *descriptors = @[[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO]];
    fr.sortDescriptors = descriptors;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
}

-(void)showPhotoWithCell:(TimeLineTableViewCell *)cell photo:(Photo *)photo {
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photo.imageurl];
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (image) {
        imageInfo.image = image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:photo.largeurl];
    }
                            
    
    JTSImageViewController *imageViewController = [[JTSImageViewController alloc] initWithImageInfo:imageInfo  mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled |
    JTSImageViewControllerBackgroundOption_Blurred];
    
    imageViewController.interactionsDelegate = self;
   // imageViewController.interactionsDelegate = self;
    [imageViewController showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark -
- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提醒" message:@"保存图片" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:save];
    [controller addAction:cancel];
    
    [imageViewer presentViewController:controller animated:YES completion:nil];
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLCell"];
    
    Status *status = [self.frc objectAtIndexPath:indexPath];
    [cell configureWithStatus:status];
    
    cell.didSelectPhotoBlock = ^(TimeLineTableViewCell *cell) {
        [self showPhotoWithCell:cell photo:status.photo];
    };
    
    return cell;
}

//add refresh
-(void)createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshData {
    [self requestData];
    [self.refreshControl endRefreshing];
}

@end
