//
//  HelloViewController.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/21.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "HelloViewController.h"
#import "SettingVC.h"


#import "JDY_BLE.h"
#import "sys/utsname.h"
#import "FunctionVC.h"


#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"CDD1"

#define CHARACTERISTIC_UUID @"CDD2"


@interface HelloViewController ()<JDY_BLE_Delegate>
{
    UIButton * enterButton;
     JDY_BLE*t;
    
     Byte selected_type;
    
     FunctionVC *touchuang_view;
    
     Byte viewData[9];
    
    NSString * titleStr;
     int ivt;
}
@property (nonatomic, strong) CBCentralManager *centerManager;


@end

@implementation HelloViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [t start_scan_ble];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    [enterButton setTitle:Localized(@"Enter") forState:UIControlStateNormal];

    if ([t get_connected_status])
    {
        
        [t disconnectPeripheral ];
        
    }
    
    NSLog(@"----%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UDID"]);
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Nav.hidden=YES;
    
    
    [SVProgressHUD setBackgroundColor:kxColor(32,32,32,1)];
    [SVProgressHUD  setOffsetFromCenter:UIOffsetMake(0, 130)];
    
     [SVProgressHUD show];
    
    
    
    
    
  
    

    
    
    t = [[JDY_BLE alloc] init];
    t.delegate = self;
    
    
     [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    
    
    
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenwidth  - 226)/2, 82, 226, 64)];
    imageView.image=kxImageNameWith(@"Logo");
    [self.view addSubview:imageView];
    
    
    //Base style for 圆角矩形 1
    UIView *style = [[UIView alloc] initWithFrame:CGRectMake(kScreenwidth/2.0-62.5, 260, 125, 53)];
    style.layer.cornerRadius = 5;
    style.layer.backgroundColor = [[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] CGColor];
    style.alpha = 1;
    
    //Gradient 0 fill for 圆角矩形 1
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 5;
    gradientLayer0.frame = style.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:27.0f/255.0f green:27.0f/255.0f blue:27.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 0)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [style.layer addSublayer:gradientLayer0];
    enterButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 125, 53)];
    [enterButton setTitle:Localized(@"Enter") forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [enterButton addTarget:self action:@selector(clickEnterButton) forControlEvents:UIControlEventTouchUpInside];
    [style addSubview:enterButton];
    
    
    [self.view addSubview:style];
}

-(void)clickEnterButton
{
    [SVProgressHUD dismiss];
    SettingVC * vc=[[SettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)scanTimer:(NSTimer *)timer
{
    [t start_scan_ble];

}
-(void)discoveryDidRefresh
{
    NSLog(@"---%@===%@",t.foundPeripherals,t.MAC_ADDRESS);
    
    [t.MAC_ADDRESS enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([t.MAC_ADDRESS[idx] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UDID"]])
        {
            selected_type = [t get_jdy_ble_type:(int)idx];
            
            titleStr = t.JDY_BLE_NAME[idx];
            
            
            if([t get_connected_status])
            {
                
                [t disconnected_JDY_BLE:idx ];
            }
            
            if (![t get_connected_status])//[[t activePeripheral] isConnected])
            {
                if( selected_type==touchuang||selected_type==pwm_dentiao )
                {
                    [t connect_JDY_BLE:idx];
                   
                }
                else
                {
                    //初始化提示框；
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"目前暂不支持此功能！" preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                    }]];
                    
                    //弹出提示框；
                    [self presentViewController:alert animated:true completion:nil];
                }
            }
        }
    
    }];
  

}

-(void) TY_send_data_hex:(NSString*)data : (Boolean) uart_function_select :(Boolean)hex_or_string
{
    if( uart_function_select)//透传 UUID FFE1
    {
        if( hex_or_string )
        {
            if([data length]>0);
            else return;
            //Str=[NSString stringWithFormat:@"%@",Str];
            NSData *da2=[t stringToByte:data];
            Byte *testbyte=(Byte*)[da2 bytes];
            
            int len=(int)[da2 length];
            [ t send_uart_data:testbyte pp:len ];
        }
        else
        {
            NSData *dat = [data dataUsingEncoding:NSUTF8StringEncoding];
            Byte *testbyte=(Byte*)[dat bytes];
            [ t send_uart_data:testbyte pp:(int)dat.length ];
        }
    }
    else//功能 UUID FFE2
    {
        NSLog( @"send_data: %@",data );
        
        if([data length]>0);
        else return;
        //Str=[NSString stringWithFormat:@"%@",Str];
        NSData *da2=[t stringToByte:data];
        Byte *testbyte=(Byte*)[da2 bytes];
        NSLog(@"hh=%@",data);
        int len=(int)[da2 length];
        
        [ t send_function_data:testbyte pp:len ];
    }
}

//模块连接后会调用此函数
-(void) JDY_BLE_Ready {
    
    [t enable_JDY_BLE_uart];
    [t enable_JDY_BLE_function];
    
    if(ivt==0)
    {
        [t stop_scan_ble];
        
        ivt=1;
        if( selected_type==touchuang )// 透传
        {
            [SVProgressHUD dismiss];
            touchuang_view = [[FunctionVC alloc] init];
            touchuang_view.titleStr = titleStr;
            touchuang_view.delegate = (id)self;
            [self.navigationController pushViewController:touchuang_view animated:YES];
        }
       
    }
    viewData[0]=0xcc;
    viewData[1]=0x33;
    viewData[2]=0xc3;
    viewData[3]=0x3c;
    viewData[4]=0x01;
    viewData[5]=0x01;
    viewData[6]=0x01;
    viewData[7]=0x01;
    viewData[8]=0x01;
}
// 透传通道 数据回调函数
-(void)rx_data_event:(Byte *)bytes :(int)len
{
    //NSString *hexStr=[t Byte_to_String:bytes :len];//[t Byte_to_hexString:bytes :len];
    if( touchuang_view!=nil )
    {
        [ touchuang_view rx_ble_event:bytes :len ];
    }
    
}
//功能配置 通道回调函数
-(void)rx_function_event:(Byte *)bytes :(int)len
{
    //NSString *hexStr=[t Byte_to_String:bytes :len];//[t Byte_to_hexString:bytes :len];
    if( touchuang_view!=nil )
    {
        [ touchuang_view rx_ble_function_event:bytes :len ];
    }
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
