//
//  BaseViewController.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/21.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:rightBtn];
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.Nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenwidth, KNavHeight)];
    _Nav.backgroundColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1];
    [self.view addSubview:_Nav];
    
    
    
    self.TitleNav = [[UILabel alloc] initWithFrame:CGRectMake((kScreenwidth-200)/2, KStatusBar+9, 200, 26)];
    [self.TitleNav setFont:[UIFont systemFontOfSize:18]];
    self.TitleNav.font = [UIFont systemFontOfSize:18];
    self.TitleNav.textColor = [UIColor whiteColor];
    self.TitleNav.backgroundColor = [UIColor clearColor];
    self.TitleNav.textAlignment = NSTextAlignmentCenter;
    [_Nav addSubview:self.TitleNav];
    
    
    
    _leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftbutton.frame = CGRectMake(0, KStatusBar, 60, 44);
    [_leftbutton setTitle:@"" forState:UIControlStateNormal];
    [_leftbutton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    _leftbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftbutton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:2];
    
    [_leftbutton addTarget:self action:@selector(leftEvents) forControlEvents:UIControlEventTouchUpInside];
    [_Nav addSubview:_leftbutton];
    
    
    
    
    _rigltbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rigltbutton.frame = CGRectMake(kScreenwidth-50, KStatusBar, 50, 44);
    [_rigltbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rigltbutton addTarget:self action:@selector(rightEvents) forControlEvents:UIControlEventTouchUpInside];
    [_Nav addSubview:_rigltbutton];
    _rigltbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    
    
    
    _leftbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_leftbutton setTitleColor:[UIColor blackColor] forState:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, GVH(_Nav)-1, kScreenwidth, 0.5)];
    line.backgroundColor = [UIColor blackColor];
    [_Nav addSubview:line];
    line.hidden =1;
    _line = line;
    self.view.backgroundColor=[UIColor colorWithWhite:0.07 alpha:1];

}

-(void)leftEvents
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightEvents{
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:1 animated:0];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:1 animated:0];
    
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
