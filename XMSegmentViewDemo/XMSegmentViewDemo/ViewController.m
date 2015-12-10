//
//  ViewController.m
//  XMSegmentViewDemo
//
//  Created by ripper on 15/12/10.
//  Copyright © 2015年 ripper. All rights reserved.
//

#import "ViewController.h"
#import "XMSegmentView.h"
#define kBlueColor [UIColor colorWithRed:0.05f green:0.71f blue:1.00f alpha:1.00f]
#define kOrangeColor [UIColor colorWithRed:0.97f green:0.61f blue:0.14f alpha:1.00f]
#define kGreenColor [UIColor colorWithRed:0.09f green:0.76f blue:0.73f alpha:1.00f]



@interface ViewController ()<XMSegmentViewDelegate>

@property (nonatomic, weak)XMSegmentView *seg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[@"体重",@"脂肪",@"肌肉",@"步行",@"体围"];

    
#pragma mark - 基本使用
    XMSegmentView *segmentView = [XMSegmentView segmentViewWithItems:items frame:CGRectMake(20, 100, 300, 30) defaultIndex:0];
    [self.view addSubview:segmentView];
    
    
    
    
    
    
    
    
#pragma mark - 更多需求(点击变色)
    XMSegmentView *segment = [XMSegmentView segmentViewWithItems:items frame:CGRectMake(20, 200, 300, 30) defaultIndex:0 cornerRadius:15 strokeWidth:5 normalFont:[UIFont systemFontOfSize:15] selectedFont:[UIFont systemFontOfSize:15] strokeColor:kBlueColor normalFontColor:kBlueColor selectedFontColor:[UIColor whiteColor] normalFillColor:[UIColor clearColor] selectedFillColor:kBlueColor];
    segment.delegate = self;//设置代理
    self.seg = segment;
    [self.view addSubview:segment];

}









#pragma mark - XMSegmentViewDelegate
- (void)segmentView:(XMSegmentView *)segmentView from:(NSInteger)fromIdx to:(NSInteger)toIdx
{
    if (fromIdx>=3 && toIdx <3) {
        
        self.seg.normalFontColor = kBlueColor;
        self.seg.strokeColor = kBlueColor;
        self.seg.selectedFillColor = kBlueColor;
        
        [self.seg creatUIWithDefaultIndex:toIdx];//每次设置完新的属性调用一次即可
        
    }else if(fromIdx!=3 && toIdx == 3) {
        
        self.seg.normalFontColor = kOrangeColor;
        self.seg.strokeColor = kOrangeColor;
        self.seg.selectedFillColor = kOrangeColor;
        
        [self.seg creatUIWithDefaultIndex:toIdx];
        
    }else if(fromIdx!=4 && toIdx == 4){
        
        self.seg.normalFontColor = kGreenColor;
        self.seg.strokeColor = kGreenColor;
        self.seg.selectedFillColor = kGreenColor;
        [self.seg creatUIWithDefaultIndex:toIdx];
    }

}

@end
