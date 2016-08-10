//
//  TimeLineTableViewCell.h
//  Fanner
//
//  Created by 赵麦 on 7/28/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeLineTableViewCell;
@class DTAttributedLabel;
@class CellToolBarView;
typedef void (^DidSelectPhotoBlock) (TimeLineTableViewCell *cell);

@class Status;
@interface TimeLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) DidSelectPhotoBlock didSelectPhotoBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (nonatomic, weak) CellToolBarView *cellToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeigtConstrain;
-(void)configureWithStatus:(Status *)status;
@end
