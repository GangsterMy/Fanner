//
//  ComposeViewController.m
//  Fanner
//
//  Created by 赵麦 on 8/3/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "ComposeViewController.h"
#import "Service.h"

#ifdef DEBUG
#define NSLog(FORMAT,...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
#else
#define NSLog(…)
#endif

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ComposeViewController
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)takePhoto:(id)sender {
    //create picker controller
    UIImagePickerController *picker =  [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Picker Delegate
//success load
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //get the original image
    _pickerImageView.image = info[UIImagePickerControllerOriginalImage];
    //dismiss picker view controller back to send page
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postContent:(id)sender {
    NSData *data = UIImageJPEGRepresentation(_pickerImageView.image, 0.5);
    [[Service sharedInstance] sendStatus:@"test4" imageData:data replyToStatusID:nil repostStatusID:nil success:^(NSArray *result) {
        NSLog(@"%@", result);
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
