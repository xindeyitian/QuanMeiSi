//
//  MyQRCodeVC.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/22.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "MyQRCodeVC.h"

@interface MyQRCodeVC ()

@end

@implementation MyQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.TitleNav.text=@"我的二维码";
    [self.rigltbutton setImage:kxImageNameWith(@"分享") forState:UIControlStateNormal];
    [self setupSubviews];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)setupSubviews{
    //背景view
    UIView * bgView=[[UIView alloc] initWithFrame:CGRectMake((kScreenwidth - 312)/2, GMAXY(self.Nav)+75, 312, 312)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=5;
    [self.view addSubview:bgView];
    //二维码
    UIImageView * codeImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"qrcode")];
    codeImageView.frame=CGRectMake(68.5, 35, 175, 175);
    [bgView addSubview:codeImageView];
    
    UILabel * tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, GMAXY(codeImageView)+23, GVW(bgView)-20, 16)];
    tipLabel.textAlignment=NSTextAlignmentCenter;
    tipLabel.font=[UIFont systemFontOfSize:15];
    tipLabel.text=@"扫一扫上面的二维码，下载全美思";
    [bgView addSubview:tipLabel];

    UILabel * tipLabel1=[[UILabel alloc] initWithFrame:CGRectMake(10, GMAXY(tipLabel)+20, GVW(bgView)-20, 16)];
    tipLabel1.textAlignment=NSTextAlignmentCenter;
    tipLabel1.font=[UIFont systemFontOfSize:15];
    tipLabel1.text=@"专业按摩养生";
    tipLabel1.textColor=[UIColor colorWithRed:75/255.0 green:46/255.0 blue:174/255.0 alpha:1];
    [bgView addSubview:tipLabel1];

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
