//
//  SettingVC.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/21.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "SettingVC.h"
#import "ConnectDeviceVC.h"
#import "MyQRCodeVC.h"
#import "ChooseLanguagVC.h"
#import "FunctionVC.h"
#import "PrivacyPolicyVC.h"

#import "jdy_scan_ble_ViewController.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    FunctionVC *touchuang_view;
}
@property (nonatomic, strong)UITableView * setTableView;
@property (nonatomic, strong)UILabel  * stateLabel;

@property (nonatomic, strong)NSArray * dataArray;

@end

@implementation SettingVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.TitleNav.text=Localized(@"Setting");
    self.dataArray=@[@[Localized(@"Connecting Device"),Localized(@"My QRCode")],@[Localized(@"Switch Language")],@[Localized(@"Version")],@[Localized(@"Privacy Policy")]];
    [self.setTableView reloadData];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.setTableView];
}

-(UITableView *)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, GVH(self.Nav)+24, kScreenwidth, kScreenwidth-GVH(self.Nav)-24) style:UITableViewStylePlain];
        _setTableView.delegate=self;
        _setTableView.dataSource=self;
        _setTableView.tableFooterView=[[UIView alloc] init];
        _setTableView.rowHeight=50;
        _setTableView.rowHeight=UITableViewAutomaticDimension;
        _setTableView.backgroundColor=[UIColor colorWithWhite:0.07 alpha:1];
        _setTableView.separatorColor=[UIColor colorWithWhite:0.07 alpha:1];
        _setTableView.scrollEnabled=NO;
    }
    return _setTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1];
        cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section==2) {
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(kScreenwidth - 45, 17.5, 30, 15)];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor whiteColor];
        label.text=@"1.0";
        [cell.contentView addSubview:label];
    }
    else if (indexPath.section==0){
        if (indexPath.row==0) {
            self.stateLabel.frame=CGRectMake(kScreenwidth - 155, 17.5, 120, 15);
            _stateLabel.text=Localized(@"Not Connected");
            [cell.contentView addSubview:self.stateLabel];
        }
        else{
            UIImageView * rightImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"二维码(2)")];
            rightImageView.frame=CGRectMake(kScreenwidth - 55, 15, 20, 20);
            [cell.contentView addSubview:rightImageView];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenwidth, 10)];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section)   return 10;
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
//        jdy_scan_ble_ViewController *vc = [[jdy_scan_ble_ViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (indexPath.section==0){
        if (indexPath.row==0) {
//            ConnectDeviceVC * vc=[[ConnectDeviceVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            
            jdy_scan_ble_ViewController *vc = [[jdy_scan_ble_ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"connect"] ==nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"connect"] isEqual:[NSNull null]])
            {
                jdy_scan_ble_ViewController *vc = [[jdy_scan_ble_ViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                touchuang_view = [[FunctionVC alloc] init];
                touchuang_view.titleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"connect"];
                touchuang_view.delegate = (id)self;
                [self.navigationController pushViewController:touchuang_view animated:YES];
            }
            
            
        }
        else{
            MyQRCodeVC * vc=[[MyQRCodeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section ==3)
    {
        PrivacyPolicyVC * vc=[[PrivacyPolicyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ChooseLanguagVC * vc=[[ChooseLanguagVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }

}

-(void)rx_data_event:(Byte *)bytes :(int)len
{
    //NSString *hexStr=[t Byte_to_String:bytes :len];//[t Byte_to_hexString:bytes :len];
    if( touchuang_view!=nil )
    {
        [ touchuang_view rx_ble_event:bytes :len ];
    }
    
}

-(void)rx_function_event:(Byte *)bytes :(int)len
{
    //NSString *hexStr=[t Byte_to_String:bytes :len];//[t Byte_to_hexString:bytes :len];
    if( touchuang_view!=nil )
    {
        [ touchuang_view rx_ble_function_event:bytes :len ];
    }
    
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel= [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.font=[UIFont systemFontOfSize:15];
        _stateLabel.textColor=[UIColor whiteColor];
        _stateLabel.textAlignment=NSTextAlignmentRight;
    }
    return _stateLabel;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
