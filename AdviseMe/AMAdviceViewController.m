//
//  AMAdviceViewController.m
//  AdviseMe
//
//  Created by Robert Audi on 07/05/14.
//  Copyright (c) 2014 Robert Audi. All rights reserved.
//

#import "AMAdviceViewController.h"
#import <AFHTTPRequestOperationManager.h>

@interface AMAdviceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *adviceButton;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;

@end

@implementation AMAdviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)adviceButtonTapped:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://api.adviceslip.com/advice" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.adviceLabel.text = responseObject[@"slip"][@"advice"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)adviceTapped:(id)sender {
}

@end
