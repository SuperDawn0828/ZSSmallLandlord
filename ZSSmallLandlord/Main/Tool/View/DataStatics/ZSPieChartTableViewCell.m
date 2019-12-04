//
//  ZSPieChartTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/18.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSPieChartTableViewCell.h"
#import "ZSSmallLandlord-Bridging-Header.h"
#import "ZSSmallLandlord-Swift.h"

@interface ZSPieChartTableViewCell ()<ChartViewDelegate>
@property (nonatomic,strong) PieChartView *chartView;
@property (nonatomic,strong) UIView       *centerView;//自定义扇形中间的view
@end

@implementation ZSPieChartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell下分割线的风格
        
        //创建饼状图
        self.chartView = [[PieChartView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSPieChartHeight)];
        self.chartView.delegate = self;
        [self addSubview:self.chartView];
        [self setupPieChartView:self.chartView];
    }
    return self;
}

#pragma mark 设置样式
- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.noDataText = @"暂无数据";//无数据显示
    [chartView setExtraOffsetsWithLeft:40 top:0.f right:40 bottom:0.f];//饼状图的位置
    chartView.legend.enabled = NO;//设置饼状图图例是否显示
    chartView.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
    chartView.chartDescription.enabled = NO;//是否显示饼状图描述
    [chartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];//动画样式
    chartView.rotationAngle = 270;//扇形起点
    chartView.rotationEnabled = NO;//是否允许转动
    chartView.highlightPerTapEnabled = YES;//是否能被选中
    chartView.drawCenterTextEnabled = YES;//是否绘制中心文字
    chartView.drawHoleEnabled = YES;//饼状图是否是空心
    chartView.holeRadiusPercent = 0.6;//空心圆半径占比
    chartView.transparentCircleRadiusPercent = 0.7;//半透明空心圆半径占比
}

#pragma mark 饼状图数据填充
- (void)setDataArray:(NSArray<ZSQuaryPieChartsModel *> *)dataArray
{
    //没数据
    if (dataArray.count == 0)
    {
        self.chartView.centerAttributedText = nil;
        self.chartView.data = nil;
    }
    //有数据
    else
    {
        _dataArray = dataArray;
        NSMutableArray *entries = [[NSMutableArray alloc]init];
        for (int i = 0; i < dataArray.count; i++)
        {
            ZSQuaryPieChartsModel *model = dataArray[i];
            [entries addObject:[[PieChartDataEntry alloc] initWithValue:[model.value doubleValue] label:model.name]];
            if (i == 0)
            {
                //中间文字样式(默认第一个扇形的数据)
                self.chartView.centerAttributedText = [self centerString:model.name
                                                               withValue:[NSString stringWithFormat:@"%@笔",model.value]
                                                             withPercent:[NSString stringWithFormat:@"占%@",model.rate]];
            }
        }
        
        PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@""];
        //设置扇形颜色
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
        [colors addObjectsFromArray:ChartColorTemplates.joyful];
        [colors addObjectsFromArray:ChartColorTemplates.colorful];
        [colors addObjectsFromArray:ChartColorTemplates.liberty];
        [colors addObjectsFromArray:ChartColorTemplates.pastel];
        [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
        dataSet.colors = colors;//扇形颜色
        dataSet.sliceSpace = 0; //扇形与扇形之间的缝隙
        dataSet.selectionShift = 15;//选中区块时, 放大的半径
        dataSet.drawValuesEnabled = YES;//是否绘制百分比
        dataSet.valueLineWidth = 0.5;//折线的粗细
        dataSet.valueLineColor = [UIColor brownColor];//折线的颜色
        dataSet.valueLinePart1OffsetPercentage = 0.7;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        dataSet.valueLinePart1Length = 0.2;//折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.5;//折线中第二段长度最大占比
        dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置(扇形内/扇形外)
        dataSet.xValuePosition = PieChartValuePositionOutsideSlice;//名称位置(扇形内/扇形外)
        
        //创建 PieChartData 对象, 此对象就是 PieChartData 需要最终数据对象
        PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
        NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
        pFormatter.numberStyle = NSNumberFormatterPercentStyle;
        pFormatter.maximumFractionDigits = 2;
        pFormatter.multiplier = @1.f;
        pFormatter.percentSymbol = @"%";
        //折线上面的数值格式
        ChartDefaultValueFormatter *valueFormatter = [[ChartDefaultValueFormatter alloc]initWithFormatter:pFormatter];
        [data setValueFormatter:valueFormatter];
        [data setValueFont:[UIFont systemFontOfSize:10]];
        [data setValueTextColor:[UIColor brownColor]];
        
        //设置数据
        self.chartView.data = data;
    }
}

#pragma mark - ChartViewDelegate
//点击单个扇形调用的方法
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    //中间的文字显示当前点击的扇形的数据
    NSInteger index = (NSInteger)highlight.x;
    if (self.dataArray.count > 0)
    {
        ZSQuaryPieChartsModel *model = self.dataArray[index];
        self.chartView.centerAttributedText = [self centerString:model.name
                                                       withValue:[NSString stringWithFormat:@"%@笔",model.value]
                                                     withPercent:[NSString stringWithFormat:@"占%@",model.rate]];
    }
}

//点击外部收回扇形的方法
- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    //默认显示第一个扇形的数据
    if (self.dataArray.count > 0)
    {
        ZSQuaryPieChartsModel *model = self.dataArray[0];
        self.chartView.centerAttributedText = [self centerString:model.name
                                                       withValue:[NSString stringWithFormat:@"%@笔",model.value]
                                                     withPercent:[NSString stringWithFormat:@"占%@",model.rate]];
    }
}

#pragma mark 设置中间的文字样式
- (NSMutableAttributedString *)centerString:(NSString *)prdType withValue:(NSString *)value withPercent:(NSString *)percent
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",prdType,value,percent]];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:11],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName: ZSColorRed
                                } range:NSMakeRange(0, prdType.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:10],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName: ZSColorListLeft
                                } range:NSMakeRange(prdType.length, centerText.length - prdType.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:10],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName: ZSColorListLeft
                                } range:NSMakeRange(centerText.length - percent.length, percent.length)];
    return centerText;
}

@end
