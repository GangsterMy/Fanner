//
//  LoginViewController.m
//  Fanner
//
//  Created by 赵麦 on 7/25/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)login:(UIBarButtonItem *)sender {
    
    // login success
    
    [self performSegueWithIdentifier:@"ShowAccountsSegue" sender:nil];
    
    // login fail
    
    
    
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    
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
