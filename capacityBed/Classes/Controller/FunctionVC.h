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

typedef NS_ENUM(NSUInteger, FunctionType) {
    
    /**
     K1       1
     K2       4
     K3       2
     K4       1
     K5       1
     K6       1
     */
    FunctionTypeIQAndLQ      = 0,   //IQ || LQ   I06  L04=       //K1    W1

    FunctionTypeJQ              ,   //JQ && !JQ-D  =             //K2    W3  NQ
    FunctionTypeJQD             ,   //JQ-D                       //K2    W2
    FunctionTypeMQ              ,    //MQ        =               //K2    W4
    FunctionTypeU700,                                            //k2    W9   =====
    
    FunctionTypeKQH             ,   //KQ-H       =               //K3    W6
    FunctionTypeKQ              ,   // KQ && !KQ-H   =           //K3    W5
    
    FunctionType430And730       ,    //430 730  444      =       //K4    W7
    FunctionType420And442And720 ,    //420 442 720   =           //K5    W8
    FunctionTypeKQ2              ,   // KQ2   =                  //k6    W4
};

typedef NS_ENUM(NSUInteger, FunctionWeiTiaoType) {
    
    FunctionWeiTiaoTypeIQAndLQ      = 0,   //IQ || LQ   I06  L04=       //K1    W1
    FunctionWeiTiaoTypeJQD             ,   //JQ-D                       //K2    W2
    FunctionWeiTiaoTypeJQ              ,   //JQ && !JQ-D  =             //K2    W3  NQ
    FunctionWeiTiaoTypeMQ               ,   // KQ2   =                  //k6    W4
    FunctionWeiTiaoTypeKQ              ,   // KQ && !KQ-H   =           //K3    W5
    FunctionWeiTiaoTypeKQH             ,   //KQ-H       =               //K3    W6
    FunctionWeiTiaoType430And730       ,    //430 730  444      =       //K4    W7
    FunctionWeiTiaoType420And442And720 ,    //420 442 720   =           //K5    W8
    FunctionWeiTiaoTypeU700,                                            //k2    W9
};

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


-(void)sendDataWithString:(NSString *)writeInstruct1;//发送指令

@property (nonatomic, assign)FunctionType  functionType;

@property (nonatomic, assign)FunctionWeiTiaoType  functionWeiTiaoType;
/**
 2020.5.20
 
 快捷：
 
 关于新增K4  K5  K6的显示界面完成
 但是关于发码的还有疑问
 
 K6的话只有复原时候发码的的更改
 
 微调：
  
 U700
 FunctionType430And730
 FunctionType420And442And720
 
 */

@end
