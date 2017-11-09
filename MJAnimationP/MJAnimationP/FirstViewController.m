//
//  FirstViewController.m
//  MJAnimationP
//
//  Created by Mac on 2017/11/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI{
    self.view.backgroundColor = [UIColor grayColor ];
    UIButton* backVC = [UIButton buttonWithType:UIButtonTypeCustom];
    backVC.frame = CGRectMake(129, 250, 100, 44);
    backVC.layer.borderWidth = 1;
    [backVC setTitle:@"nextVC" forState:UIControlStateNormal];
    [backVC setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
    [backVC addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backVC];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
