//
//  PrivacyPolicyVC.m
//  capacityBed
//
//  Created by zhangkai on 2018/12/1.
//  Copyright © 2018 吾诺翰卓. All rights reserved.
//

#import "PrivacyPolicyVC.h"

@interface PrivacyPolicyVC ()

@end

@implementation PrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TitleNav.text=Localized(@"Privacy Policy");
    
    
    UIWebView * webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, KStatusBar+44, kScreenwidth, kScreenheight - KStatusBar-44)];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.uonep.com/shidao"]]];
    [self.view addSubview:webV];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
