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
#import "CellToolBarView.h"

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
    
    [cell.cellToolBar setupStarButtonWithBool:status.favorited.boolValue];
    cell.cellToolBar.delegate = self;
    
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

#pragma mark - CellToolBarDelegate
-(void)starWithCellTollBarView:(CellToolBarView *)toolBar sender:(id)sender forEvent:(UIEvent *)event {
    //取到收藏所在的indexPath, 即所在cell
    //取到所有touches
    NSSet *touches = [event allTouches];
    //取到某一个touch
    UITouch *touch = [touches anyObject];
    //取到这个touch的location
    CGPoint point = [touch locationInView:self.tableView];
    //最后获取这个位置所在的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    //用frc取到cell下的status对象
    Status *status = [self.frc objectAtIndexPath:indexPath];
    //请求收藏接口
    [[Service sharedInstance] starWithStatusID:status.sid success:^(NSArray *result) {
        NSLog(@"%@",result);
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateWithStatusProfile:result];
        [toolBar setupStarButtonWithBool:status.favorited.boolValue];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
};
-(void)unstarWithCellTollBarView:(CellToolBarView *)toolBar sender:(id)sender forEvent:(UIEvent *)event{
    
};

@end
