//
//  TimeLineTableViewCell.h
//  Fanner
//
//  Created by 赵麦 on 7/28/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeLineTableViewCell;
typedef void (^DidSelectPhotoBlock) (TimeLineTableViewCell *cell);

@class Status;
@interface TimeLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) DidSelectPhotoBlock didSelectPhotoBlock;
-(void)configureWithStatus:(Status *)status;
@end
