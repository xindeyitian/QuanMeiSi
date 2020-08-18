//
//  FunctionVC.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"
#import "SVProgressHUD.h"

@protocol TY_Delegate
@optional

/*
 -(void) TY_send_data_hex:(NSString*)data : (Boolean) uart_function_select :(Boolean)hex_or_string
 
 uart_function_select=true表示透传
 uart_function_select=false表示功能
 hex_or_string=true表示十六进制发
 hex_or_string=false表示字符串发
 */
-(void) TY_send_data_hex:(NSString*)data : (Boolean) uart_function_select :(Boolean)hex_or_string;



-(void) first_ble_scan:(Boolean)p;


-(void)send_data:(Byte *)bytes :(int)len : (Boolean) p;



@end

@interface FunctionVC : BaseViewController{
@public
    BabyBluetooth *baby;
}
@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property(copy,nonatomic)NSString *titleStr;
@property (nonatomic,assign) id <TY_Delegate> delegate;

-(void)rx_ble_event:(Byte *)bytes :(int)len;//特征UUID FFE1透传接收
-(void)rx_ble_function_event:(Byte *)bytes :(int)len;//功能特征UUID FFE2接收数据函数

@end
