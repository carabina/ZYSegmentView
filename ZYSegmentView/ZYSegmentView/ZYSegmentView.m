//
//  ZYSegmentView.m
//  ZYSegmentView
//
//  Created by ripper on 16/4/24.
//  Copyright © 2016年 ripper. All rights reserved.
//

#import "ZYSegmentView.h"
#define KCornerRadius 15    //圆角弧度
#define KStrokeWidth 1     //边框宽度
#define kNormalFont [UIFont systemFontOfSize:15]//默认字体
#define kSelectedFont [UIFont systemFontOfSize:15]//选中字体
#define kStrokeColor [UIColor colorWithRed:0.05f green:0.71f blue:1.00f alpha:1.00f]//边框颜色
#define kNormalFontColor [UIColor colorWithRed:0.05f green:0.71f blue:1.00f alpha:1.00f]//字体平常颜色
#define kSelectedFontColor [UIColor whiteColor]//字体选中颜色
#define kSelectedFillColor [UIColor colorWithRed:0.05f green:0.71f blue:1.00f alpha:1.00f]//选中填充颜色
#define KNormalFillColor [UIColor clearColor]//默认填充颜色



#pragma mark - backgroundView
@interface ZYBackgroundView : UIView

@end

@implementation ZYBackgroundView

+(Class)layerClass
{
    return [CAShapeLayer class];
}

@end




#pragma mark - segmentView
@interface ZYSegmentView ()

@property (nonatomic, weak) UISegmentedControl * nativeSegmentedControl;//原生segment
@property (nonatomic, weak) ZYBackgroundView * selectedBackgroundView;//选中的背景视图
@property (nonatomic, assign) NSInteger lastIndex;//上一次选中
@property (nonatomic, assign) CGFloat strokeWidth;//边框宽度(暂未实现)

@end


@implementation ZYSegmentView

#pragma mark - init
- (instancetype) initWithItems:(NSArray *)items frame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont strokeColor:(UIColor *)strokeColor normalFontColor:(UIColor *)normalFontColor selectedFontColor:(UIColor *)selectedFontColor  normalFillColor:(UIColor *)normalFillColor selectedFillColor:(UIColor *)selectedFillColor
{
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = cornerRadius>=0?cornerRadius:KCornerRadius;
        self.strokeWidth = KStrokeWidth;//暂时没写这个功能
        self.normalFont = normalFont?normalFont:kNormalFont;
        self.selectedFont = selectedFont?selectedFont:kSelectedFont;
        self.strokeColor = strokeColor?strokeColor:kStrokeColor;
        self.normalFontColor = normalFontColor?normalFontColor:kNormalFontColor;
        self.selectedFontColor = selectedFontColor?selectedFontColor:kSelectedFontColor;
        self.normalFillColor = normalFillColor?normalFillColor:KNormalFillColor;
        self.selectedFillColor = selectedFillColor?selectedFillColor:kSelectedFillColor;
        
        //1.保存数据
        self.items = items;
        self.numberOfSegments = items.count;
        self.selectedIndex = defaultIndex;
        self.lastIndex = defaultIndex;
        //2.添加nativeSegmentControl并设置默认设置
        [self creatNativeSegmentedControlWithItems:items defaultIndex:defaultIndex];
        //3.背景view设置在指定位置
        [self segmentClick:self.nativeSegmentedControl];
        //4.设置UI
        [self creatUIWithDefaultIndex:defaultIndex];
    }
    
    return self;
}

+ (instancetype)segmentViewWithItems:(NSArray *)items frame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex
{
    return [[self alloc] initWithItems:items frame:frame defaultIndex:(NSInteger)defaultIndex cornerRadius:KCornerRadius strokeWidth:KStrokeWidth normalFont:nil selectedFont:nil strokeColor:nil normalFontColor:nil selectedFontColor:nil normalFillColor:nil selectedFillColor:nil];
}

+ (instancetype)segmentViewWithItems:(NSArray *)items frame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont strokeColor:(UIColor *)strokeColor normalFontColor:(UIColor *)normalFontColor selectedFontColor:(UIColor *)selectedFontColor normalFillColor:(UIColor *)normalFillColor selectedFillColor:(UIColor *)selectedFillColor
{
    return [[self alloc] initWithItems:items frame:frame defaultIndex:(NSInteger)defaultIndex cornerRadius:cornerRadius strokeWidth:strokeWidth normalFont:normalFont selectedFont:selectedFont strokeColor:strokeColor normalFontColor:normalFontColor selectedFontColor:selectedFontColor normalFillColor:normalFillColor selectedFillColor:selectedFillColor];
}

+(Class)layerClass
{
    return [CAShapeLayer class];
}

#pragma mark - UI
- (void)creatUIWithDefaultIndex:(NSInteger)index
{
    /**
     *  1.绘制曲线边框和分割线
     */
    //设置图层
    CAShapeLayer * shapeLayer = (CAShapeLayer *)self.layer;
    //边框
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    
    //分割线
    for (NSInteger i = 0; i < _items.count - 1; i ++) {
        UIBezierPath * line = [[UIBezierPath alloc]init];
        CGFloat x = (self.frame.size.width / _items.count);
        
        [line moveToPoint:CGPointMake(x * (i+1), 1)];
        [line addLineToPoint:CGPointMake(x * (i+1), self.frame.size.height - 1)];
        
        [path appendPath:line];
    }
    //设置绘制路径
    shapeLayer.path = path.CGPath;
    //默认填充色
    shapeLayer.fillColor =_normalFillColor.CGColor;
    //边框色
    shapeLayer.strokeColor = _strokeColor.CGColor;
    
    /**
     *  2.设置原生segmentControl的字体和颜色
     */
    //默认字体颜色
    NSDictionary * norAttri = @{NSFontAttributeName:_normalFont,NSForegroundColorAttributeName:_normalFontColor};
    //选中字体颜色
    NSDictionary * seleAttri = @{NSFontAttributeName:_selectedFont,NSForegroundColorAttributeName:_selectedFontColor};
    [self.nativeSegmentedControl setTitleTextAttributes:norAttri forState:UIControlStateNormal];
    [self.nativeSegmentedControl setTitleTextAttributes:seleAttri forState:UIControlStateSelected];
    
    /**
     *  3.设置默认选项
     */
    //设置背景
    [self selectedBgViewMoveToIndex:index];
}


#pragma mark - getter
- (ZYBackgroundView *)selectedBackgroundView
{
    if (!_selectedBackgroundView) {
        ZYBackgroundView *bgView= [[ZYBackgroundView alloc]init];
        _selectedBackgroundView = bgView;
        [self addSubview:_selectedBackgroundView];
        [self sendSubviewToBack:_selectedBackgroundView];
    }
    return _selectedBackgroundView;
}

#pragma mark - 创建原生segmentControl
- (void)creatNativeSegmentedControlWithItems:(NSArray *)items defaultIndex:(NSInteger)index
{
    UISegmentedControl * segementedControl = [[UISegmentedControl alloc]initWithItems:items];
    segementedControl.frame = self.bounds;
    segementedControl.selectedSegmentIndex = index;
    //把segment原先的颜色设置为透明，然后自己用贝塞尔曲线自己画边框
    segementedControl.tintColor = [UIColor clearColor];
    //添加事件
    [segementedControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.nativeSegmentedControl = segementedControl;
    [self addSubview:segementedControl];
}

- (void)segmentClick:(UISegmentedControl *)segmentedControl
{
    //1.将选中背景view移动到指定位置
    [self selectedBgViewMoveToIndex:segmentedControl.selectedSegmentIndex];
    //    [self bringSubviewToFront:self.nativeSegmentedControl];
    //2.调用代理方法
    if ([self.delegate respondsToSelector:@selector(segmentView:from:to:)]) {
        [self.delegate segmentView:self from:self.lastIndex to:segmentedControl.selectedSegmentIndex];
    }
    self.selectedIndex = segmentedControl.selectedSegmentIndex;
    self.lastIndex = segmentedControl.selectedSegmentIndex;
}

#pragma mark - 选中背景view的形变和动画
- (void)selectedBgViewMoveToIndex:(NSInteger )index
{
    CGSize bgSize = self.selectedBackgroundView.bounds.size;//选中背景视图尺寸
    UIBezierPath* rectanglePath;
    
    if (index == 0) {
        rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, bgSize.width, bgSize.height) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(_cornerRadius, _cornerRadius)];
    }
    else if (index == self.items.count - 1)
    {
        rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, bgSize.width, bgSize.height) byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(_cornerRadius, _cornerRadius)];
    }
    else
    {
        rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, bgSize.width, bgSize.height) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(0, 0)];
    }
    
    [self moveAnimationWithIndex:index and:rectanglePath];
}

- (void)moveAnimationWithIndex:(NSInteger)index and:(UIBezierPath *)path
{
    CAShapeLayer *shapeLayer  = (CAShapeLayer *)_selectedBackgroundView.layer;
    shapeLayer.fillColor = _selectedFillColor.CGColor;
    CGFloat x = (self.frame.size.width / _items.count);
    //1.不实现动画
    self.selectedBackgroundView.frame = CGRectMake(index * x, 0, x, self.frame.size.height);
    shapeLayer.path = path.CGPath;
    //2.实现动画（动画连续点有bug）
    //    [UIView animateWithDuration:0.2 animations:^{
    //
    //        _selectedBgView.frame = CGRectMake(index * x, 0, x, self.frame.size.height);
    //        shapeLayer.path = path.CGPath;
    //
    //    }];
}

@end
