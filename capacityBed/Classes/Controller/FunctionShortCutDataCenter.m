//
//  FunctionDataCenter.m
//  capacityBed
//
//  Created by cj on 2020/5/9.
//  Copyright © 2020 吾诺翰卓. All rights reserved.
//

#import "FunctionShortCutDataCenter.h"

@interface FunctionShortCutDataCenter ()
{
    //FunctionType430And730编码
    
      NSString * ZGLnoMemory_tap;                    //无记忆时短按
      NSString * ZGLnoMemory_longPress;              //无记忆时长按（进入记忆）
      NSString * ZGLmemory_tap;                      //有记忆时短按（执行记忆）
      NSString * ZGLmemory_longPress;                //有记忆时长按（退出记忆）
      
      NSString * ZGRnoMemory_tap;                    //无记忆时短按
      NSString * ZGRnoMemory_longPress;              //无记忆时长按（进入记忆）
      NSString * ZGRmemory_tap;                      //有记忆时短按（执行记忆）
      NSString * ZGRmemory_longPress;                //有记忆时长按（退出记忆）
      
      NSString * TVLnoMemory_tap;                    //无记忆时短按
      NSString * TVLnoMemory_longPress;              //无记忆时长按（进入记忆）
      NSString * TVLmemory_tap;                      //有记忆时短按（执行记忆）
      NSString * TVLmemory_longPress;                //有记忆时长按（退出记忆）
      
      NSString * TVRnoMemory_tap;                    //无记忆时短按
      NSString * TVRnoMemory_longPress;              //无记忆时长按（进入记忆）
      NSString * TVRmemory_tap;                      //有记忆时短按（执行记忆）
      NSString * TVRmemory_longPress;                //有记忆时长按（退出记忆）
      
      NSString * FLATLnoMemory_tap;                 //无记忆时短按
      NSString * FLATRnoMemory_tap;                  //无记忆时短按
      NSString * TVnoMemory_tap;                     //无记忆时短按
      NSString * ZGnoMemory_tap;                     //无记忆时短按
      NSString * FLATnoMemory_tap;                   //无记忆时短按
}
@end

@implementation FunctionShortCutDataCenter

-(instancetype)init
{
    if (self = [super init])
    {
        ZGLnoMemory_tap = @"FF FF FF FF 05 00 00 00 33 97 15"; //无记忆时短按
        ZGLnoMemory_longPress = @"FF FF FF FF 05 00 00 30 33 83 15";//无记忆时长按（进入记忆）
        ZGLmemory_tap = @"FF FF FF FF 05 00 00 31 33 82 85"; //有记忆时短按（执行记忆）
        ZGLmemory_longPress = @"FF FF FF FF 05 00 00 3F 33 86 E5"; //有记忆时长按（退出记忆）
        
        ZGRnoMemory_tap = @"FF FF FF FF 05 00 00 00 34 D6 D7";//无记忆时短按
        ZGRnoMemory_longPress = @"FF FF FF FF 05 00 00 40 34 E7 17"; //无记忆时长按（进入记忆）
        ZGRmemory_tap = @"FF FF FF FF 05 00 00 41 34 E6 87"; //有记忆时短按（执行记忆）
        ZGRmemory_longPress = @"FF FF FF FF 05 00 00 4F 34 E2 E7"; //有记忆时长按（退出记忆）
        
        TVLnoMemory_tap = @"FF FF FF FF 05 00 00 00 31 16 D4"; //无记忆时短按
        TVLnoMemory_longPress = @"FF FF FF FF 05 00 00 10 31 1B 14";//无记忆时长按（进入记忆）
        TVLmemory_tap = @"FF FF FF FF 05 00 00 11 31 1A 84"; //有记忆时短按（执行记忆）
        TVLmemory_longPress = @"FF FF FF FF 05 00 00 1F 31 1E E4";//有记忆时长按（退出记忆）
        
        TVRnoMemory_tap = @"FF FF FF FF 05 00 00 00 32 56 D5";//无记忆时短按
        TVRnoMemory_longPress = @"FF FF FF FF 05 00 00 20 32 4F 15";//无记忆时长按（进入记忆）
        TVRmemory_tap = @"FF FF FF FF 05 00 00 21 32 4E 85";//有记忆时短按（执行记忆）
        TVRmemory_longPress = @"FF FF FF FF 05 00 00 2F 32 4A E5"; //有记忆时长按（退出记忆）
        
        FLATLnoMemory_tap = @"FF FF FF FF 05 00 00 00 39 17 12";//无记忆时短按
        FLATRnoMemory_tap = @"FF FF FF FF 05 00 00 00 3A 57 13";//无记忆时短按
        TVnoMemory_tap = @"FF FF FF FF 05 00 00 00 3C D7 11";//无记忆时短按
        ZGnoMemory_tap = @"FF FF FF FF 05 00 05 00 3D 06 D0";//无记忆时短按
        FLATnoMemory_tap = @"FF FF FF FF 05 00 00 00 3B 96 D3";//无记忆时短按
    }
    return self;
}

//快捷类型
-(FunctionType)getFunctionTypeWithTitle:(NSString*)title
{
    FunctionType type = -1;
    /**
     
        FunctionTypeIQAndLQ      = 0,   //IQ || LQ   I06  L04=       //K1    W1

        FunctionTypeJQ              ,   //JQ && !JQ-D  =             //K2    W3  NQ
        FunctionTypeJQD             ,   //JQ-D                       //K2    W2
        FunctionTypeMQ              ,    //MQ        =               //K2    W4
        FunctionTypeU700,                                            //k2    W9   =====
        
        FunctionTypeKQH             ,   //KQ-H       =               //K3    W6
        FunctionTypeKQ              ,   // KQ && !KQ-H   =           //K3    W5
        
        FunctionType430And730       ,    //430 730  444      =       //K4     W7
        FunctionType420And442And720 ,    //420 442 720   =           //K5     W8
        FunctionTypeKQ2              ,   // KQ2   =                  //k6     W4
     */
    if ([title containsString:@"IQ"]||[title containsString:@"LQ"]) {
        
        type =  FunctionTypeIQAndLQ;
    }else if ([title containsString:@"JQ"] && ![title containsString:@"JQ-D"])
    {
        type =  FunctionTypeJQ;
    }else if ([title containsString:@"KQ2"])
    {
        type =  FunctionTypeKQ2;
    }else if ([title containsString:@"KQ"] && ![title containsString:@"KQ-H"])
    {
        type =  FunctionTypeKQ;
    }else if ([title containsString:@"JQ-D"])
    {
        type =  FunctionTypeJQD;
    }else if ([title containsString:@"U700"])
    {
        type =  FunctionTypeU700;
    }else if ([title containsString:@"KQ-H"])
    {
        type =  FunctionTypeKQH;
    }else if ([title containsString:@"MQ"])
    {
        type =  FunctionTypeMQ;
    }else if ([title containsString:@"430"]||[title containsString:@"730"])
    {
        type =  FunctionType430And730;
    }else if ([title containsString:@"420"]||[title containsString:@"720"]||[title containsString:@"443"])
    {
        type =  FunctionType420And442And720;
    }
    return type;
}

//获取快捷的图片以及编码 
-(NSMutableArray*)getKuaiJieFunctionTypeWithType:(FunctionType)functionType
{
    NSMutableArray * array = [NSMutableArray array];

    NSMutableArray * writeInstructArray = [@[@"FFFFFFFF05000000051703",@"FFFFFFFF0500005F0521F3",@"FFFFFFFF050000000F9704 ",@"FFFFFFFF0500000008D6C6",@"FFFFFFFF0500000028D71E",@"FFFFFFFF050000002916DE"] mutableCopy];
    NSMutableArray * imageArray=[@[@"图层1",@"零压力",@"止鼾",@"复原",@"听音乐",@"向上倾斜"] mutableCopy];
    NSMutableArray * titleArray=[@[@"TV",@"ZG",@"ANTI SNORE",@"FLAT",@"Music",@"Leg Relax"] mutableCopy];
    
    #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改   名字以及发码的修改
    if (functionType == FunctionTypeKQ || functionType == FunctionTypeKQH || functionType == FunctionTypeKQ2)
    {
        [titleArray replaceObjectAtIndex:2 withObject:@"LUMBER"];
        [writeInstructArray replaceObjectAtIndex:2 withObject:@"FFFFFFFF050000002E571C"];
    }
    
    if (functionType == FunctionType430And730) {
        
        writeInstructArray=[@[@"FFFFFFFF05000000051703",@"FFFFFFFF0500005F0521F3",@"FFFFFFFF050000000F9704 ",@"FFFFFFFF0500000008D6C6",@"FFFFFFFF0500000028D71E",@"FFFFFFFF050000002916DE",@"FFFFFFFF0500000008D6C6",@"FFFFFFFF0500000028D71E",@"FFFFFFFF050000002916DE"] mutableCopy];
        imageArray=[@[@"图层1",@"图层1",@"零压力",@"零压力",@"复原"] mutableCopy];
        titleArray=[@[@"TV",@"TV",@"ZG",@"ZG",@"FLAT"] mutableCopy];
    }
    
    if (functionType == FunctionType420And442And720) {
           
        writeInstructArray=[@[@"FFFFFFFF05000000051703",@"FFFFFFFF0500005F0521F3",@"FFFFFFFF050000000F9704 ",@"FFFFFFFF0500000008D6C6",@"FFFFFFFF0500000008D6C6"] mutableCopy];
        imageArray=[@[@"图层1",@"图层1",@"图层1",@"图层1",@"复原"] mutableCopy];
        titleArray=[@[@"Memmory",@"Memmory",@"TV",@"TV",@"FLAT"] mutableCopy];
    }
    
    [array addObject:writeInstructArray];
    [array addObject:imageArray];
    [array addObject:titleArray];
    return array;
}

//获取快捷时候头部试图的标题以及图片
-(NSMutableArray*)getKuaiJieHeaderFunctionTypeWithType:(FunctionType)functionType
{
    NSMutableArray * array = [NSMutableArray array];
    
    array = [@[@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"ZG",@"image":@"零压力"},@{@"name":@"ANTI SNORE",@"image":@"止鼾"},@{@"name":@"FLAT",@"image":@"复原"},@{@"name":@"Music",@"image":@"听音乐"},@{@"name":@"Leg Relax",@"image":@"向上倾斜"}] mutableCopy];
    
    #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改  修改圆圈内的显示
    #pragma mark-----2020.5.20新增
    if (functionType == FunctionTypeKQH || functionType == FunctionTypeKQ || functionType == FunctionTypeKQ2)
    {
        [array replaceObjectAtIndex:2 withObject:@{@"name":@"LUMBER",@"image":@"止鼾"}];
    }
    if (functionType == FunctionType430And730) {
        array=[@[@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"ZG",@"image":@"零压力"},@{@"name":@"ZG",@"image":@"零压力"},@{@"name":@"FLAT",@"image":@"复原"}] mutableCopy];
    }
    if (functionType == FunctionType420And442And720) {
        array=[@[@{@"name":@"Memmory",@"image":@"图层1"},@{@"name":@"Memmory",@"image":@"图层1"},@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"FLAT",@"image":@"复原"}] mutableCopy];
    }
    return array;
}

//获取430And730的发码
-(NSString *)setFunctionType430And730CodeWithType:(NSInteger)index withIsZG:(BOOL)isZG withIsTV:(BOOL)isTV withIsTap:(BOOL)isTap;
{
    NSString * code = @"";
    switch (index) {
        case 0:
        {
            if (isTap) {
                
                if (isTV) {
                    
                    code = TVLmemory_tap;
                }else{
                    code = TVLnoMemory_tap;
                }
                
            }else{
                
                if (isTV) {
                    code = TVLmemory_longPress;
                }else{
                    code = TVLnoMemory_longPress;
                }
            }
        }
            break;
        case 1:
            {
                code = TVnoMemory_tap;
            }
             break;
        case 2:
            {
                if (isTap) {
                    
                    if (isTV) {
                        
                        code = TVRmemory_tap;
                    }else{
                        code = TVRnoMemory_tap;
                    }
                    
                }else{
                    
                    if (isTV) {
                        code = TVRmemory_longPress;
                    }else{
                        code = TVRnoMemory_longPress;
                    }
                }
            }
             break;
        case 3:
            {
                if (isTap) {
                    
                    if (isZG) {
                        
                        code = ZGLmemory_tap;
                    }else{
                        code = ZGLnoMemory_tap;
                    }
                    
                }else{
                    
                    if (isZG) {
                        code = ZGLmemory_longPress;
                    }else{
                        code = ZGLnoMemory_longPress;
                    }
                }
            }
             break;
        case 4:
            {
                code = ZGnoMemory_tap;
            }
             break;
        case 5:
            {
                if (isTap) {
                    
                    if (isZG) {
                        
                        code = ZGRmemory_tap;
                    }else{
                        code = ZGRnoMemory_tap;
                    }
                    
                }else{
                    
                    if (isTV) {
                        code = ZGRmemory_longPress;
                    }else{
                        code = ZGRnoMemory_longPress;
                    }
                }
            }
             break;
        case 6:
            {
               code = FLATLnoMemory_tap;
            }
             break;
        case 7:
            {
               code = FLATnoMemory_tap;
            }
             break;
        case 8:
            {
               code = FLATRnoMemory_tap;
            }
            break;

        default:
            break;
    }
    return code;
}

//获取420And442And720的发码     isTap  是点击还是长按
-(NSString *)setFunctionType420And442And720WithType:(NSInteger)index withIsTV:(BOOL)isTV withIsTap:(BOOL)isTap
{
    NSString * code = @"";
    
    return code;
}

#pragma mark---快捷长按-view长按的处理
//快捷的长按处理（原有类型的）
-(NSString *)getFunctionTypeNormalCodeWithType:(NSInteger)index withIsTV:(BOOL)isTV withIsZG:(BOOL)isZG withIsAS:(BOOL)isAS
{
    NSString * code = @"";
    switch (index) {
       case 0:
           if (isTV) {
               code = @"FFFFFFFF0500005F052EF3";
           }
           else{
               code = @"FFFFFFFF05000050052B03";
           }
           isTV=!isTV;
       case 1:
           if (isZG) {
               code = @"FFFFFFFF0500009F097EF6";
           }
           else{
               code = @"FFFFFFFF05000090097B06";
           }
           break;
       case 2:
           
           if (isAS) {
               code = @"FFFFFFFF050000FF0FD6F4";
           }
           else{
               code = @"FFFFFFFF050000F00FD304";
           }
           break;
         
       default:
           break;
   }
    return code;
}

//快捷的点击事件===快捷的点击事件（原有类型的）
-(NSString *)getKuaiJieTapNormalCodeWithType:(NSInteger)_state1 withIsTV:(BOOL)isTV withIsZG:(BOOL)isZG withIsAS:(BOOL)isAS withType:(FunctionType)functionType withAry:(NSMutableArray*)writeInstructArray
{
    NSString * code = @"";
    switch (_state1) {
        case 0:
            if (isTV)
            {
                code = @"FFFFFFFF05000051052A93";
            }
            else{
                code = @"FFFFFFFF05000000051703";
            }
            break;
        case 1:
            if (isZG) {
                code = @"FFFFFFFF05000091097A96";
            }
            else{
                code = @"FFFFFFFF05000000091706";
            }
            break;
        case 2:
            #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改 顶腰发码的修改
            if (isAS) {
                
                if (functionType == FunctionTypeKQH || functionType == FunctionTypeKQ || functionType == FunctionTypeKQ2)
                {
                    code = @"FFFFFFFF050000002E571C";
                }else
                {
                    code = @"FFFFFFFF050000F10FD294";
                }
            }
            else{
                if (functionType == FunctionTypeKQH || functionType == FunctionTypeKQ || functionType == FunctionTypeKQ2)
                {
                    code = @"FFFFFFFF050000002E571C";
                }else
                {
                    code = @"FFFFFFFF050000000F9704";
                }
            }
            break;

        default:
            code = writeInstructArray[_state1];
            break;
    }
    return code;
}

@end
