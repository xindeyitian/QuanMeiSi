//
//  FunctionMICROADJDataCenter.h
//  capacityBed
//
//  Created by cj on 2020/5/26.
//  Copyright © 2020 吾诺翰卓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface FunctionMicroAdjDataCenter : NSObject

#pragma mark=======KQ============
//获取微调KQ的头部图片
-(NSMutableArray*)getWeiTiaoKQHeaderDataAryWithType:(FunctionType)functionType;

//获取微调KQ的动图图片
-(NSMutableArray*)getWeiTiaoKQLongPressGIFDataAryWithType:(FunctionType)functionType;

//获取微调KQ的编码
-(NSString*)getWeiTiaoKQLongPressCodeDataAryWithType:(FunctionType)functionType WithLongPress:(UILongPressGestureRecognizer*)tap withIndex:(NSInteger)index;

#pragma mark=======其余============
//获取除KQ微调的头部图片
-(NSMutableArray*)getWeiTiaoHeaderDataAryWithType:(FunctionType)functionType;

//获取除KQ微调高亮的头部图片
-(NSMutableArray*)getWeiTiaoHighlightHeaderDataAryWithType:(FunctionType)functionType;

//获取除KQ微调点击时候的头部图片
-(NSMutableArray*)getWeiTiaoHighlightHeaderClickDataAryWithType:(FunctionType)functionType;

//获取除KQ微调点击时候的头部动图图片
-(NSMutableArray*)getWeiTiaoHighlightHeaderClickGIFDataAryWithType:(FunctionType)functionType withIndex:(NSInteger)index;

//获取除KQ微调点击时候的编码
-(NSMutableArray*)getWeiTiaoHighlightHeaderClickCodeDataAryWithType:(FunctionType)functionType;

//获取除KQ微调长按时候的信息
-(NSMutableArray*)getWeiTiaoHighlightHeaderLongPressDataAryWithType:(FunctionType)functionType;

//获取循环显示时候的信息
-(NSMutableArray*)getWeiTiaoXunhuanDataAryWithType:(FunctionType)functionType;

//获取循环显示时候头部的信息
-(NSMutableArray*)getWeiTiaoXunhuanHeaderDataAryWithType:(FunctionType)functionType;

//高亮下微调模块向上图标点击图片以及标题
-(NSMutableArray*)getWeiTiaoUpBtnClickDataWithType:(FunctionType)functionType WeiTiaoIsHighlight:(BOOL)WeiTiaoIsHighlight state2:(NSInteger)_state2;

//非高亮下微调模块向上头部试图的name和image
-(NSMutableArray*)getWeiTiaoUpBtnClickHeaderDataWithType:(FunctionType)functionType;

//微调模块的向上的按钮的发码数组
-(NSMutableArray*)getWeiTiaoUpBtnClickCodeDataWithType:(FunctionType)functionType;


//高亮下微调模块向下图标点击图片以及标题
-(NSArray*)getWeiTiaoDownBtnClickDataWithType:(FunctionType)functionType WeiTiaoIsHighlight:(BOOL)WeiTiaoIsHighlight state2:(NSInteger)_state2;

//非高亮下微调模块向下头部试图的name和image
-(NSArray*)getWeiTiaoDownBtnClickHeaderDataWithType:(FunctionType)functionType;

//微调模块的向下的按钮的发码数组
-(NSArray*)getWeiTiaoDownBtnClickCodeDataWithType:(FunctionType)functionType;


@end

NS_ASSUME_NONNULL_END
