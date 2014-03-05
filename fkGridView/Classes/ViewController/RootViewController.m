//
//  RootViewController.m
//  fkGridView
//
//  Created by Ueoka Kazuya on 2014/03/02.
//  Copyright (c) 2014年 fromKK. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)dealloc
{
    [self.gridView removeFromSuperview];
    self.gridView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.gridView = [FKGridView new];
    self.gridView.frame = self.view.bounds;
    self.gridView.cols = 3;
    self.gridView.autoresizeWidth = YES;
    [self.view addSubview:self.gridView];
    
    for (int i = 0; i < 102; i++) {
        UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (320.0f - 5.0f * 4.0f) / 3.0f, rand() % 10 * 10.0f)];
        currentView.backgroundColor = [UIColor redColor];
        [self.gridView addGridItemView:currentView animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.gridView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
