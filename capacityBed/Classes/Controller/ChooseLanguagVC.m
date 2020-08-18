//
//  ChooseLanguagVC.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/22.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "ChooseLanguagVC.h"

@interface ChooseLanguagVC ()

@property (nonatomic, strong)UIImageView * currentImageView;

@property (nonatomic, strong)NSString * languag;

@end

@implementation ChooseLanguagVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.TitleNav.text=Localized(@"Choose Language");
    [self.rigltbutton setTitle:Localized(@"Done") forState:UIControlStateNormal];
    [self setupSubviews];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setupSubviews{
    
    UIView * chineseView=[[UIView alloc] initWithFrame:CGRectMake(0, GMAXY(self.Nav)+1, kScreenwidth, 53)];
    chineseView.backgroundColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1];
    chineseView.userInteractionEnabled=YES;
    chineseView.tag=100;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLanguagView:)];
    [chineseView addGestureRecognizer:tap];
    [self.view addSubview:chineseView];
    
    UILabel * chineseLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 18, 100, 17)];
    chineseLabel.textColor=[UIColor whiteColor];
    chineseLabel.text=@"简体中文";
    chineseLabel.font=[UIFont systemFontOfSize:15];
    [chineseView addSubview:chineseLabel];
    
    UIView * englishView=[[UIView alloc] initWithFrame:CGRectMake(0, GMAXY(chineseView)+1, kScreenwidth, 53)];
    englishView.backgroundColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1];
    englishView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLanguagView:)];
    [englishView addGestureRecognizer:tap1];
    [self.view addSubview:englishView];
    
    UILabel * englishLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 18, 100, 17)];
    englishLabel.textColor=[UIColor whiteColor];
    englishLabel.text=@"Engliash";
    englishLabel.font=[UIFont systemFontOfSize:15];
    [englishView addSubview:englishLabel];
    self.languag=[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([self.languag isEqualToString:@"zh-Hans"]) {
        self.currentImageView.frame=CGRectMake(kScreenwidth - 35, GMAXY(chineseView)-34, 20, 15);
    }
    else{
        self.currentImageView.frame=CGRectMake(kScreenwidth - 35, GMAXY(englishView)-34, 20, 15);
    }

}

-(void)clickLanguagView:(UITapGestureRecognizer *)tap{
    
    UIView * view=tap.view;
    self.currentImageView.frame=CGRectMake(kScreenwidth - 35, GMAXY(view)-34, 20, 15);
    if (view.tag==100) {
        self.languag=@"zh-Hans";
    }
    else{
        self.languag=@"en";
    }

}

-(UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView  = [[UIImageView alloc] initWithImage:kxImageNameWith(@"对勾(1)")];
        _currentImageView.frame=CGRectMake(0, 0, 20, 15);
        [self.view addSubview:_currentImageView];
    }
    return _currentImageView;
}

-(void)rightEvents{
    [[NSUserDefaults standardUserDefaults] setObject:self.languag forKey:@"appLanguage"];
    
   // [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController  popToRootViewControllerAnimated:YES];
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
