//
//  XMSegmentView.h
//  多巴兔
//
//  Created by 郭建斌 on 15/9/21.
//  Copyright © 2015年 郭建斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XMSegmentView;
@protocol XMSegmentViewDelegate <NSObject>

/**
 *  点击item触发的代理方法
 */
- (void) segmentView:(XMSegmentView *)segmentView from:(NSInteger)fromIdx to:(NSInteger)toIdx;

@end




@interface XMSegmentView : UIView



@property (nonatomic, weak) id <XMSegmentViewDelegate> delegate;//代理
@property (nonatomic, strong) NSArray * items;//items
@property (nonatomic, assign) NSInteger selectedIndex;//选中的
@property (nonatomic, assign) NSInteger numberOfSegments;//segment数

@property (nonatomic, assign) CGFloat cornerRadius;//圆角弧度
@property (nonatomic, strong) UIFont *normalFont;//默认字体
@property (nonatomic, strong) UIFont *selectedFont;//选中字体

@property (nonatomic, strong) UIColor *strokeColor;//边框颜色
@property (nonatomic, strong) UIColor *normalFontColor;//字体平常颜色
@property (nonatomic, strong) UIColor *selectedFontColor;//字体选择颜色
@property (nonatomic, strong) UIColor *normalFillColor;//默认填充颜色
@property (nonatomic, strong) UIColor *selectedFillColor;//选中填充颜色



/**
 *  初始化
 */
+ (instancetype) segmentViewWithItems:(NSArray *)items frame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex;
+ (instancetype) segmentViewWithItems:(NSArray *)items frame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont strokeColor:(UIColor *)strokeColor normalFontColor:(UIColor *)normalFontColor selectedFontColor:(UIColor *)selectedFontColor  normalFillColor:(UIColor *)normalFillColor selectedFillColor:(UIColor *)selectedFillColor;

- (instancetype) initWithItems:(NSArray *)items frame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont strokeColor:(UIColor *)strokeColor normalFontColor:(UIColor *)normalFontColor selectedFontColor:(UIColor *)selectedFontColor  normalFillColor:(UIColor *)normalFillColor selectedFillColor:(UIColor *)selectedFillColor;



/**
 *  改变属性之后手动调用该方法刷新UI
 */
- (void)creatUIWithDefaultIndex:(NSInteger)index;



@end
