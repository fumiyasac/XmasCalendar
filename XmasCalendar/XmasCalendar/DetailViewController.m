//
//  DetailViewController.m
//  XmasCalendar
//
//  Created by 酒井文也 on 2014/12/13.
//  Copyright (c) 2014年 just1factory. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *nightView;

@property (strong, nonatomic) IBOutlet UILabel *nightViewDate;

- (IBAction)backButton:(UIButton *)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //日付を表示
    self.nightViewDate.text = [NSString stringWithFormat:@"2014年12月%@日", self.detailId];
    
    //画像を表示
    NSString *nightImageName = [NSString stringWithFormat:@"sample%@.jpg", self.detailId];
    self.nightView.image = [UIImage imageNamed:nightImageName];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)backButton:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
