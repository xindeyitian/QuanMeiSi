//
//  FunctionDataCenter.h
//  capacityBed
//
//  Created by cj on 2020/5/9.
//  Copyright © 2020 吾诺翰卓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunctionShortCutDataCenter : NSObject

//根据名称划分类型  
-(FunctionType )getFunctionTypeWithTitle:(NSString*)title;

//获取快捷的图片以及编码
-(NSMutableArray*)getKuaiJieFunctionTypeWithType:(FunctionType)functionType;

//获取快捷时候头部试图的标题以及图片
-(NSMutableArray*)getKuaiJieHeaderFunctionTypeWithType:(FunctionType)functionType;

//获取430And730的发码     isTap  是点击还是长按
-(NSString *)setFunctionType430And730CodeWithType:(NSInteger)index withIsZG:(BOOL)isZG withIsTV:(BOOL)isTV withIsTap:(BOOL)isTap;

//获取420And442And720的发码     isTap  是点击还是长按
-(NSString *)setFunctionType420And442And720WithType:(NSInteger)index withIsTV:(BOOL)isTV withIsTap:(BOOL)isTap;

//快捷的长按处理（原有类型的）
-(NSString *)getFunctionTypeNormalCodeWithType:(NSInteger)index withIsTV:(BOOL)isTV withIsZG:(BOOL)isZG withIsAS:(BOOL)isAS;

//快捷的点击事件===快捷的点击事件（原有类型的）
-(NSString *)getKuaiJieTapNormalCodeWithType:(NSInteger)_state1 withIsTV:(BOOL)isTV withIsZG:(BOOL)isZG withIsAS:(BOOL)isAS withType:(FunctionType)functionType withAry:(NSMutableArray*)writeInstructArray;

@end

NS_ASSUME_NONNULL_END
