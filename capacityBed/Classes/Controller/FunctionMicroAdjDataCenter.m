//
//  FunctionMICROADJDataCenter.m
//  capacityBed
//
//  Created by cj on 2020/5/26.
//  Copyright © 2020 吾诺翰卓. All rights reserved.
//

#import "FunctionMicroAdjDataCenter.h"

@interface FunctionMicroAdjDataCenter ()
{
    //gif图片
    NSString * tuiBuGif;
    NSString * beiTuiUp;
    NSString * headGif;
    NSString * headTiaoZheng;
    NSString * tunBuUp;
    NSString * tunbuDown;
    NSString * backTiaoZheng;
    NSString * legTiaoZheng;
    NSString * backDownTiaoZheng;
    NSString * backLegDown;
    NSString * LeanGif;
}
@end

@implementation FunctionMicroAdjDataCenter

-(instancetype)init
{
    if (self = [super init])
    {
        //腿部调整111.gif
        /**
         Leg Circulation
         LEG
         */
        tuiBuGif = @"腿部调整111.gif";
        /**
         Back Leg Circulation
         Hip Circulation
         BACK AND LEG
         */
        beiTuiUp = @"背腿升起111.gif";
        /**
         HEAD
         */
        headGif = @"头部调整111F.gif";
        /**
         HEAD
         Head Circulation
         Waist Circulation
         */
        headTiaoZheng = @"头部调整1112.gif";
        /**
         WAIST
         Waist Circulation
         Hip Circulation
         Hip
         */
        tunBuUp = @"臀部上升111.gif";
        /**
         WAIST
         HIP
         */
        tunbuDown = @"臀部下降111.gif";
        /**
         BACK
         Whole Body Circulation
         */
        backTiaoZheng = @"背部调整111f.gif";
        /**
        LEG
        */
        legTiaoZheng = @"腿部调整111F.gif";
        /**
        BACK
        */
        backDownTiaoZheng = @"背部调整111.gif";
        /**
        BACK AND LEG
        */
        backLegDown = @"背腿下降111.gif";
        
        LeanGif = @"";
    }
    return self;
}

//获取微调的图片以及编码
-(NSMutableArray*)getWeiTiaoKQHeaderDataAryWithType:(FunctionType)functionType
{
    NSMutableArray * array= [NSMutableArray array];
    
    array=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"Leg Circulation",@"image":@"图层1"},@{@"name":@"Hip Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}] mutableCopy];
    
    return array;
}

//获取微调KQ的动图图片以及编码
-(NSMutableArray*)getWeiTiaoKQLongPressGIFDataAryWithType:(FunctionType)functionType
{
    NSMutableArray * array= [NSMutableArray array];
    
    array = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"BACK",@"image":backDownTiaoZheng},@{@"name":@"HEAD",@"image":headTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
    
    return array;
}

//获取微调KQ的编码
-(NSString*)getWeiTiaoKQLongPressCodeDataAryWithType:(FunctionType)functionType WithLongPress:(UILongPressGestureRecognizer*)tap withIndex:(NSInteger)index;
{
    NSString * code = @"";
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        
        if (index == 0)
        {
            code = @"FFFFFFFF05000000039701";
        }else
        {
            code = @"FFFFFFFF0500000004D6C3";
        }
    }

    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (index == 1)
        {
            code = @"FF FF FF FF 05 00 00 00 00 D700";
        }else
        {
            code = @"FF FF FF FF 05 00 00 00 00 D7 00";
        }
    }
    return code;
}

//获取除KQ微调的头部图片
-(NSMutableArray*)getWeiTiaoHeaderDataAryWithType:(FunctionType)functionType
{
    NSMutableArray * headerTipArray= [NSMutableArray array];
    
    headerTipArray = [@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}] mutableCopy];
    
     #pragma mark----6.12关于新加MQ的微调界面
        if (functionType == FunctionTypeJQD)
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"WAIST",@"image":@"图层1拷贝13"}];
        }
        else if (functionType == FunctionTypeMQ || functionType == FunctionTypeKQH)
        {
            #pragma mark----6.19新加MQ
            if (functionType == FunctionTypeKQH)
            {
              headerTipArray=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"Overall Lifting",@"image":@"复原"}] mutableCopy];
            }else
            {
               headerTipArray=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}] mutableCopy];
            }
        } else if (functionType == FunctionTypeIQAndLQ)
        {
             [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"HIP",@"image":@"图层1拷贝13"}];
          
    #pragma mark=-------7.13修改JQ
        }else  if (functionType == FunctionTypeJQ)
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"BACK AND LEG",@"image":@"图层1"}];
            [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"WAIST",@"image":@"图层1拷贝13"}];
        }
        #pragma mark-------6.3号新增
        else  if (functionType == FunctionType430And730)
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"BACK",@"image":@"背部调整f2"}];
            [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
            [headerTipArray replaceObjectAtIndex:3 withObject:@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        }else  if (functionType == FunctionType420And442And720)
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"BACK",@"image":@"背部调整f2"}];
            [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
            [headerTipArray removeLastObject];
        }else  if (functionType == FunctionTypeU700)
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"Lean",@"image":@"向下倾斜111"}];
            [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"HEAD",@"image":@"头部调整F-1"}];
            [headerTipArray replaceObjectAtIndex:3 withObject:@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        }
        else
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"BACK AND LEG",@"image":@"图层1"}];
        }
    
    return headerTipArray;
}

//获取除KQ微调高亮的头部图片
-(NSMutableArray*)getWeiTiaoHighlightHeaderDataAryWithType:(FunctionType)functionType
{
    NSMutableArray * headerTipArray= [NSMutableArray array];
    
    headerTipArray = [@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}] mutableCopy];
    
    return headerTipArray;
}

//获取除KQ微调点击时候的头部图片
-(NSMutableArray*)getWeiTiaoHighlightHeaderClickDataAryWithType:(FunctionType)functionType
{
   NSMutableArray * headerTipArray= [NSMutableArray array];
    
    headerTipArray = [@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}] mutableCopy];
    
    if (functionType == FunctionTypeJQD)//腰部调整
    {
        [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"Waist Circulation",@"image":@"图层1"}];
    }
    #pragma  mark----7.13
    if (functionType == FunctionTypeJQ)//jq
    {
        [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"Back Leg Circulation",@"image":@"图层1"}];
        [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"Waist Circulation",@"image":@"图层1拷贝13"}];
    }
    
    return headerTipArray;
}

//获取除KQ微调点击时候的头部动图图片
-(NSMutableArray*)getWeiTiaoHighlightHeaderClickGIFDataAryWithType:(FunctionType)functionType withIndex:(NSInteger)index;
{
    NSMutableArray * headerTipArray= [NSMutableArray array];
    
    headerTipArray= [@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}] mutableCopy];
    
    #pragma  mark----7.13
    if (functionType == FunctionTypeJQ)//jq
    {
        [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"Waist Circulation",@"image":tunBuUp}];
    }
    #pragma mark----7.13调整

    if (index ==1)
    {
        if (functionType == FunctionTypeJQD)//腰部调整
        {
            [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"Waist Circulation",@"image":tunBuUp}];

        }else if (functionType == FunctionTypeIQAndLQ)//臀部调整
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"Hip Circulation",@"image":tunBuUp}];
        }
        #pragma mark----7.13调整
        else if (functionType == FunctionTypeJQ) {
            
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"Back Leg Circulation",@"image":beiTuiUp}];
            [headerTipArray replaceObjectAtIndex:2 withObject:@{@"name":@"Waist Circulation",@"image":headTiaoZheng}];
        }
        else//背腿调整
        {
            [headerTipArray replaceObjectAtIndex:1 withObject:@{@"name":@"Hip Circulation",@"image":beiTuiUp}];
        }
    }
    
    return headerTipArray;
}

//获取除KQ微调点击时候的编码
-(NSMutableArray*)getWeiTiaoHighlightHeaderClickCodeDataAryWithType:(FunctionType)functionType
{
    NSMutableArray * codeArray= [NSMutableArray array];
    
    codeArray = [@[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068A"] mutableCopy];
    
    #pragma mark=====5.24新加的
    #pragma mark=====7.14修改的

    if (functionType == FunctionTypeJQ)//jq
    {
        codeArray=
        [@[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E8C74F",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E5068A"] mutableCopy];
        
    }
    return codeArray;;
}

//获取除KQ微调长按时候的信息
-(NSMutableArray*)getWeiTiaoHighlightHeaderLongPressDataAryWithType:(FunctionType)functionType
{
    NSMutableArray * array = [NSMutableArray array];
       
    NSMutableArray * headerTipArray = [NSMutableArray array];
    NSMutableArray * imageArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    
    imageArray=[@[@"背部调整f2",@"图层1",@"头部调整F-1",@"图层1拷贝11"] mutableCopy];
    titleArray=[@[@"BACK",@"HIP",@"HEAD",@"LEG"] mutableCopy];
    headerTipArray=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}] mutableCopy];

    if (functionType == FunctionTypeJQD)
    {
        headerTipArray=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"WAIST",@"image":@"图层1拷贝13"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}] mutableCopy];
        imageArray= [@[@"背部调整f2",@"图层1拷贝13",@"头部调整F-1",@"图层1拷贝11"] mutableCopy];
        titleArray=[@[@"BACK",@"WAIST",@"HEAD",@"LEG"] mutableCopy];
        
    }else if (functionType == FunctionTypeIQAndLQ)
    {
        headerTipArray=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1拷贝13"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}] mutableCopy];
        imageArray=[@[@"背部调整f2",@"图层1拷贝13",@"头部调整F-1",@"图层1拷贝11"] mutableCopy];
        titleArray=[@[@"BACK",@"HIP",@"HEAD",@"LEG"] mutableCopy];
    }else
    {
        headerTipArray=[@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}] mutableCopy];
        imageArray=[@[@"背部调整f2",@"图层1",@"头部调整F-1",@"图层1拷贝11"] mutableCopy];
        titleArray=[@[@"BACK",@"BACK AND LEG",@"HEAD",@"LEG"] mutableCopy];
    }
    
    [array addObject:headerTipArray];
    [array addObject:imageArray];
    [array addObject:titleArray];
    return array;
}

//获取循环显示时候的信息
-(NSMutableArray*)getWeiTiaoXunhuanDataAryWithType:(FunctionType)functionType
{
    NSMutableArray *   title= [@[@"Whole Body Circulation",@"Hip Circulation",@"Head Circulation",@"Leg Circulation"] mutableCopy];
    
     if (functionType == FunctionTypeJQD)
     {
         title=[@[@"Whole Body Circulation",@"Waist Circulation",@"Head Circulation",@"Leg Circulation"] mutableCopy];
     }
    
    if (functionType == FunctionTypeJQ)
    {
        title=[@[@"Whole Body Circulation",@"Back Leg Circulation",@"Waist Circulation",@"Leg Circulation"] mutableCopy];
    }
    return title;
}

//获取循环显示时候头部的信息
-(NSMutableArray*)getWeiTiaoXunhuanHeaderDataAryWithType:(FunctionType)functionType
{
     NSMutableArray * headerTipArray=[@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}] mutableCopy];
    return headerTipArray;
}

//高亮下微调模块向上图标点击图片以及标题
-(NSMutableArray*)getWeiTiaoUpBtnClickDataWithType:(FunctionType)functionType WeiTiaoIsHighlight:(BOOL)WeiTiaoIsHighlight state2:(NSInteger)_state2;
{
    //向上按钮并且state2不等于1的数组
    NSMutableArray * resultAry = [NSMutableArray array];
    if (WeiTiaoIsHighlight ==1)//高亮下的微调
    {
        resultAry = [@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}] mutableCopy];
        if (_state2 ==1)
        {
            if (functionType == FunctionTypeJQD)//腰部调整
            {
                resultAry =[@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":tunBuUp},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}] mutableCopy];
            }else if (functionType == FunctionTypeIQAndLQ)//臀部调整
            {
                resultAry = [@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":tunBuUp},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}] mutableCopy];
            }else//背腿调整
            {
                resultAry = [@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":beiTuiUp},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}] mutableCopy];
            }
        }
    }
    
    if (_state2 !=1)
    {
        resultAry = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"HIP",@"image":@""},@{@"name":@"HEAD",@"image":headTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        #pragma mark=-------7.13修改JQ
        if (functionType == FunctionTypeJQ)
        {
            resultAry = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"WAIST",@"image":tunBuUp},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
        if (functionType == FunctionType430And730) {
            
            resultAry = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
        if (functionType == FunctionType420And442And720) {
            
            resultAry = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
        if (functionType == FunctionTypeU700) {
            
            resultAry = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"Lean",@"image":LeanGif},@{@"name":@"HEAD",@"image":headTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
    }
    return resultAry;
}

//非高亮下微调模块向上头部试图的name和image
-(NSMutableArray*)getWeiTiaoUpBtnClickHeaderDataWithType:(FunctionType)functionType
{
    NSArray * array = [NSArray array];
    if (functionType == FunctionTypeJQD)//腰部调整
    {
        array = @[@{@"name":@"WAIST",@"image":tunBuUp}];
    }else if (functionType == FunctionTypeIQAndLQ)//臀部调整
    {
        array = @[@{@"name":@"HIP",@"image":tunBuUp}];
    }else if (functionType == FunctionTypeMQ||functionType == FunctionTypeKQH)
    {
        if (functionType == FunctionTypeMQ)
        {
             array =  @[@{@"name":@"LEG",@"image":tuiBuGif}];
        }else
        {
             array =  @[@{@"name":@"Overall Lifting",@"image":@"复原"}];
        }
    }else if (functionType == FunctionType430And730 || functionType == FunctionType420And442And720)
    {
         array =  @[@{@"name":@"BACK",@"image":backTiaoZheng}];
    }else if (functionType == FunctionTypeU700)
    {
         array =  @[@{@"name":@"Lean",@"image":@"倾斜站位"}];
    }
    else//背腿调整
    {
        array = @[@{@"name":@"BACK AND LEG",@"image":beiTuiUp}];
    }
    return [array mutableCopy];
}

//微调模块的向上的按钮的发码数组
-(NSMutableArray*)getWeiTiaoUpBtnClickCodeDataWithType:(FunctionType)functionType
{
    NSArray * writeInstructArray=@[@"FFFFFFFF05000000039701",@"FFFFFFFF050000000D16C5",@"FFFFFFFF050000000116C0",@"FFFFFFFF05000000065702"];
    if (functionType == FunctionTypeJQ)
    {
        writeInstructArray=@[@"FFFFFFFF05000000039701",@"FFFFFFFF050000002B971F",@"FFFFFFFF050000000D16C5",@"FFFFFFFF05000000065702"];
    }
    
     #pragma mark----6.19新加MQ
    if (functionType == FunctionTypeMQ||functionType == FunctionTypeKQH)
    {
        writeInstructArray=@[@"FF FF FF FF 05 00 00 00 03 97 01",@"FF FF FF FF 05 00 00 00 06 57 02"];
    }
    return [writeInstructArray mutableCopy];
}

//高亮下微调模块向下图标点击图片以及标题
-(NSArray*)getWeiTiaoDownBtnClickDataWithType:(FunctionType)functionType WeiTiaoIsHighlight:(BOOL)WeiTiaoIsHighlight state2:(NSInteger)_state2
{
    NSArray * newArray = [NSArray array];
    if (WeiTiaoIsHighlight ==1)
    {
        newArray=@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}];
        if (_state2 ==1)
        {
            if (functionType == FunctionTypeJQD)//腰部调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":tunBuUp},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}];
            }else if (functionType == FunctionTypeIQAndLQ)//臀部调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":tunBuUp},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}];
            }else//背腿调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":backTiaoZheng},@{@"name":@"Hip Circulation",@"image":beiTuiUp},@{@"name":@"Head Circulation",@"image":headTiaoZheng},@{@"name":@"Leg Circulation",@"image":tuiBuGif}];
            }
        }
        return newArray;
    }
    
    if (_state2 !=1)
    {
        newArray=@[@{@"name":@"BACK",@"image":backDownTiaoZheng},@{@"name":@"HIP",@"image":@""},@{@"name":@"HEAD",@"image":headGif},@{@"name":@"LEG",@"image":legTiaoZheng}];
        #pragma mark=-------7.13修改JQ
        if (functionType == FunctionTypeJQ)
        {
            newArray=@[@{@"name":@"BACK",@"image":backDownTiaoZheng},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"WAIST",@"image":tunbuDown},@{@"name":@"LEG",@"image":legTiaoZheng}];
        }
        if (functionType == FunctionType430And730) {
            
            newArray = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
        if (functionType == FunctionType420And442And720) {
            
            newArray = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
        if (functionType == FunctionTypeU700) {
            
            newArray = [@[@{@"name":@"BACK",@"image":backTiaoZheng},@{@"name":@"Lean",@"image":LeanGif},@{@"name":@"HEAD",@"image":headTiaoZheng},@{@"name":@"LEG",@"image":tuiBuGif}] mutableCopy];
        }
    }
    return newArray;
}

//非高亮下微调模块向下头部试图的name和image
-(NSArray*)getWeiTiaoDownBtnClickHeaderDataWithType:(FunctionType)functionType
{
    NSArray * array = [NSArray array];
    if (functionType == FunctionTypeJQD)//腰部调整
    {
        array = @[@{@"name":@"WAIST",@"image":tunbuDown}];
    }else if (functionType == FunctionTypeIQAndLQ)//臀部调整
    {
        array = @[@{@"name":@"HIP",@"image":tunbuDown}];
    }else if (functionType == FunctionTypeMQ||functionType == FunctionTypeKQH)
    {
         #pragma mark----6.19新加MQ
        if (functionType == FunctionTypeMQ)
        {
            array =  @[@{@"name":@"LEG",@"image":tuiBuGif}];
        }else
        {
            array =  @[@{@"name":@"Overall Lifting",@"image":@"复原"}];
        }
    }else if (functionType == FunctionType430And730 || functionType == FunctionType420And442And720)
    {
         array =  @[@{@"name":@"BACK",@"image":backTiaoZheng}];
    }else if (functionType == FunctionTypeU700)
    {
         array =  @[@{@"name":@"Lean",@"image":@"倾斜站位"}];
    }else//背腿调整
    {
        array = @[@{@"name":@"BACK AND LEG",@"image":backLegDown}];
    }
    return array;
}

//微调模块的向下的按钮的发码数组
-(NSArray*)getWeiTiaoDownBtnClickCodeDataWithType:(FunctionType)functionType
{
    NSArray  * writeInstructArray=@[@"FFFFFFFF0500000004D6C3",@"FFFFFFFF050000000E56C4",@"FFFFFFFF050000000256C1",@"FFFFFFFF050000000796C2"];
    #pragma mark----7.13   JQ键值更新
        
    if (functionType == FunctionTypeJQ)
    {
        writeInstructArray=@[@"FFFFFFFF0500000004D6C3",@"FFFFFFFF050000002CD6DD",@"FFFFFFFF050000000E56C4",@"FFFFFFFF050000000796C2"];
    }
    
     #pragma mark----6.19新加MQ
    if (functionType == FunctionTypeMQ||functionType == FunctionTypeKQH)
    {
        writeInstructArray=
        @[@"FF FF FF FF 05 00 00 00 04 D6 C3",@"FF FF FF FF 05 00 00 00 07 96 C2"];
    }
    return writeInstructArray;
}

@end
