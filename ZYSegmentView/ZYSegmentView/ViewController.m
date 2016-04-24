//
//  ViewController.m
//  ZYSegmentView
//
//  Created by ripper on 16/4/24.
//  Copyright © 2016年 ripper. All rights reserved.
//

#import "ViewController.h"
#import "ZYSegmentView.h"
#define kBlueColor [UIColor colorWithRed:0.05f green:0.71f blue:1.00f alpha:1.00f]
#define kOrangeColor [UIColor colorWithRed:0.97f green:0.61f blue:0.14f alpha:1.00f]
#define kGreenColor [UIColor colorWithRed:0.09f green:0.76f blue:0.73f alpha:1.00f]

@interface ViewController ()<ZYSegmentViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //按钮标题
    NSArray *items = @[@"体重",@"脂肪",@"肌肉",@"步行",@"体围"];

    /**
     *  1.创建一个简单的segmentView
     */
    ZYSegmentView *segmentView = [ZYSegmentView segmentViewWithItems:items frame:CGRectMake(20, 100, 300, 30) defaultIndex:0];
    [self.view addSubview:segmentView];
    
    
    /**
     *  2.更多需求
     */
    ZYSegmentView *segment = [ZYSegmentView segmentViewWithItems:items frame:CGRectMake(20, 200, 300, 30) defaultIndex:0 cornerRadius:15 strokeWidth:5 normalFont:[UIFont systemFontOfSize:15] selectedFont:[UIFont systemFontOfSize:15] strokeColor:kBlueColor normalFontColor:kBlueColor selectedFontColor:[UIColor whiteColor] normalFillColor:[UIColor clearColor] selectedFillColor:kBlueColor];
    segment.delegate = self;//设置代理
    [self.view addSubview:segment];
}


#pragma mark - XMSegmentViewDelegate
- (void)segmentView:(ZYSegmentView *)segmentView from:(NSInteger)fromIdx to:(NSInteger)toIdx
{
    switch (toIdx) {
        case 0:
        case 1:
        case 2:
            segmentView.normalFontColor = kBlueColor;
            segmentView.strokeColor = kBlueColor;
            segmentView.selectedFillColor = kBlueColor;
            break;
        case 3:
            segmentView.normalFontColor = kOrangeColor;
            segmentView.strokeColor = kOrangeColor;
            segmentView.selectedFillColor = kOrangeColor;
            break;
        case 4:
            segmentView.normalFontColor = kGreenColor;
            segmentView.strokeColor = kGreenColor;
            segmentView.selectedFillColor = kGreenColor;
            break;
        default:
            break;
    }
    //每次设置完新的属性调用一次刷新UI即可
    [segmentView creatUIWithDefaultIndex:toIdx];
}

@end
