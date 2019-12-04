//
//  ZSLineChartTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/10/18.
//  Copyright © 2018 黄曼文. All rights reserved.
//

#import "ZSLineChartTableViewCell.h"
#import "ZSSmallLandlord-Bridging-Header.h"
#import "ZSSmallLandlord-Swift.h"
#import "SymbolsValueFormatter.h"

@interface ZSLineChartTableViewCell ()<ChartViewDelegate>
@property (nonatomic,strong) UILabel         *unitLabel;         //单位
@property (nonatomic,strong) LineChartView   *chartView;         //折线图
@property (nonatomic,strong) UILabel         *markLabel;         //折线图点击时显示数值
@property (nonatomic,strong) NSArray         *XtitleArray;       //横坐标标签
@property (nonatomic,strong) NSArray         *YValueArray;       //值
@property (nonatomic,strong) UIView          *btnBackgroundView;
@property (nonatomic,assign) NSInteger       lineChartType;      //折线图类型 1按笔数,2按金额
@end

@implementation ZSLineChartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell下分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //单位
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, 10, 100, 30)];
    self.unitLabel.textColor = ZSColorBlack;
    self.unitLabel.font = [UIFont systemFontOfSize:14];
    self.unitLabel.text = @"单位: 笔";
    [self addSubview:self.unitLabel];
    
    //按钮背景色
    self.btnBackgroundView = [[UIView alloc]initWithFrame:CGRectMake((ZSWIDTH-140)/2, 10, 140, 30)];
    self.btnBackgroundView.backgroundColor = ZSColorWhite;
    self.btnBackgroundView.layer.cornerRadius = 5;
    self.btnBackgroundView.layer.borderWidth = 0.5;
    self.btnBackgroundView.layer.borderColor = ZSColorAllNotice.CGColor;
    self.btnBackgroundView.layer.masksToBounds = YES;
    [self addSubview:self.btnBackgroundView];
    
    //按钮
    NSArray *arrayName = @[@"按笔数",@"按金额"];
    for (int i = 0 ; i < arrayName.count; i++)
    {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(i*70, 0, 70, 30);
        [typeBtn setTitle:arrayName[i] forState:UIControlStateNormal];
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [typeBtn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [typeBtn setTitleColor:ZSColorListLeft forState:UIControlStateNormal];
        [typeBtn setTitleColor:ZSColorWhite forState:UIControlStateSelected];
        [typeBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorWhite] forState:UIControlStateNormal];
        [typeBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorRed] forState:UIControlStateSelected];
        typeBtn.layer.masksToBounds = YES;
        typeBtn.tag = i+100;
        [self.btnBackgroundView addSubview:typeBtn];
        if (i == 0)
        {
            typeBtn.selected = YES;
            self.lineChartType = 1;
        }
    }
    
    //折线图
    [self initLineChartView];
}

- (void)initLineChartView
{
    //折线图
    self.chartView = [[LineChartView alloc]initWithFrame:CGRectMake(GapWidth, 20+CellHeight, ZSWIDTH-GapWidth*2, 220)];
    self.chartView.delegate = self;
    self.chartView.chartDescription.enabled = NO;
    self.chartView.pinchZoomEnabled = YES;
    self.chartView.drawGridBackgroundEnabled = NO;
    self.chartView.noDataText = @"暂无数据";//无数据显示
    self.chartView.legend.enabled = NO;//不展示图例
    [self.chartView setScaleEnabled:YES];//是否可以缩放
    self.chartView.scaleYEnabled = NO;//取消Y轴缩放
    self.chartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    self.chartView.dragEnabled = YES;//启用拖拽图标
    self.chartView.rightAxis.enabled = NO;//不绘制右边轴
    self.chartView.legend.form = ChartLegendFormLine;
    self.chartView.maxVisibleCount = 999;//设置能够显示的数据数量
    [self.chartView animateWithXAxisDuration:1.5];//设置动画
    [self.chartView fitScreen];//重置所有缩放和拖动,使图完全符合它的界限。
    [self addSubview:self.chartView];
    
    //设置Y轴
    ChartYAxis *leftAxis = self.chartView.leftAxis;
    leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
    leftAxis.labelTextColor = ZSColorListRight;//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:9];//文字字体
    leftAxis.drawGridLinesEnabled = YES;//是否画网格
    leftAxis.gridLineWidth = 0.5;//网格线宽度
    leftAxis.gridColor = ZSColorLine;//网格线颜色
    leftAxis.drawZeroLineEnabled = YES;//是否画原点
    leftAxis.zeroLineWidth = 0.5;//圆点线的宽度
    leftAxis.drawAxisLineEnabled = YES;//是否画Y轴
    leftAxis.axisLineColor = ZSColorLine;//Y轴颜色;
    leftAxis.axisLineWidth = 0.5;//Y轴宽度
    leftAxis.forceLabelsEnabled = YES;//不强制绘制指定数量的 label
    leftAxis.axisMinimum = 0;//设置Y轴的最小值
    
    //设置X轴
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;//设置x轴数据在底部
    xAxis.drawGridLinesEnabled = YES;//是否画网格
    xAxis.gridLineWidth = 0.5;//网格线宽度
    xAxis.gridColor = ZSColorLine;//网格线颜色
    xAxis.labelTextColor = ZSColorListRight;//文字颜色
    xAxis.labelFont = [UIFont systemFontOfSize:9];//文字字体
    xAxis.drawAxisLineEnabled = YES;//是否画X轴
    xAxis.axisLineColor = ZSColorLine;//X轴线颜色
    xAxis.axisLineWidth = 0.5;//X轴线宽度
    [xAxis setLabelRotationAngle:60];//X轴坐标倾斜
    
    //选中数据滑动的时候值会变化的标签
    ChartMarkerView *markView = [[ChartMarkerView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    markView.backgroundColor = ZSColorWhite;
    markView.layer.cornerRadius = 5;
    markView.layer.borderWidth = 0.5;
    markView.layer.borderColor = ZSColorListLeft.CGColor;
    markView.layer.masksToBounds = YES;
    markView.chartView = self.chartView;
    
    UIView *markrPoint = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 10, 10)];;
    markrPoint.backgroundColor = ZSColorRed;
    markrPoint.layer.cornerRadius = 5;
    markrPoint.layer.masksToBounds = YES;
    [markView addSubview:markrPoint];
 
    self.markLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 180, 30)];
    self.markLabel.font = [UIFont systemFontOfSize:13];
    self.markLabel.adjustsFontSizeToFitWidth = YES;
    self.markLabel.textAlignment = NSTextAlignmentCenter;
    self.markLabel.textColor = ZSColorListRight;
    [markView addSubview:self.markLabel];
  
    self.chartView.marker = markView;
}

- (void)typeBtnAction:(UIButton *)sender
{
    //UI
    if (sender.selected == YES) {
        return;
    }
    for (int i = 0 ; i < 2; i++)
    {
        if (sender.tag == i+100) {
            sender.selected = YES;
            continue;
        }
        UIButton *btn = (UIButton *)[self.btnBackgroundView viewWithTag:i+100];
        btn.selected = NO;
    }
    
    //Data
    //重新赋值
    if (sender.tag == 100)
    {
        self.unitLabel.text = @"单位: 笔";
        self.lineChartType = 1;
        [self reloadData:self.dataArray];
    }
    else
    {
        self.unitLabel.text = @"单位: 万元";
        self.lineChartType = 2;
        [self reloadData:self.dataArray];
    }
}

#pragma mark 赋值
- (void)setDataArray:(NSArray<ZSQuaryOrderChangeModel *> *)dataArray
{
    if (dataArray.count)
    {
        _dataArray = dataArray;
        [self reloadData:dataArray];
    }
}

- (void)reloadData:(NSArray *)dataArray
{
    //没数据
    if (dataArray.count == 0)
    {
        self.chartView.data = nil;
    }
    //有数据
    else
    {
        //取数据
        NSMutableArray *values = [[NSMutableArray alloc] init];
        NSMutableArray *XtitleArray = [[NSMutableArray alloc] init];
        NSMutableArray *YValueArray = [[NSMutableArray alloc] init];;
        for (int i = 0; i < dataArray.count; i++)
        {
            ZSQuaryOrderChangeModel *model = dataArray[i];
            //设置X轴title
            [XtitleArray addObject:[NSString stringWithFormat:@"%@",model.date]];//X轴坐标日期只显示月份和日期
            self.chartView.xAxis.valueFormatter = [[SymbolsValueFormatter alloc]initWithArray:XtitleArray];//用 SymbolsValueFormatter 的代理方法实现
            [self.chartView.xAxis setLabelRotationAngle:60];//X轴坐标倾斜
            //设置X轴value
            [YValueArray addObject:self.lineChartType == 1 ? model.totalOrderSum : model.totalOrderAmount];
            double YValue = self.lineChartType == 1 ? [model.totalOrderSum doubleValue] : [[ZSTool yuanIntoTenThousandYuanWithCount:model.totalOrderAmount WithType:YES] doubleValue];
            [values addObject:[[ChartDataEntry alloc] initWithX:i y:YValue icon:nil]];
        }
        
        //根据YValueArray数组中的最大值来设置Y轴的labelCount的个数
        CGFloat maxValue = [[YValueArray valueForKeyPath:@"@max.floatValue"] floatValue];
        self.chartView.leftAxis.labelCount = maxValue < 6.0000 ? (int)maxValue : 6;
        
        //设置数据和样式
        LineChartDataSet *set1 = nil;
        if ( self.chartView.data.dataSetCount > 0)
        {
            set1 = (LineChartDataSet *) self.chartView.data.dataSets[0];
            set1.values = values;
            [self.chartView.data notifyDataChanged];
            [self.chartView notifyDataSetChanged];
        }
        else
        {
            //设置折线样式
            set1 = [[LineChartDataSet alloc] initWithValues:values label:nil];
            [set1 setColor:UIColor.redColor];//折线颜色
            set1.lineWidth = 0.5;//折线宽度
            set1.drawIconsEnabled = NO;//是否绘制图标
//            set1.lineDashLengths = @[@5.f, @2.5f];//虚线
//            set1.highlightLineDashLengths = @[@5.f, @2.5f];//虚线
            set1.drawValuesEnabled = NO;//是否绘制折线点的值
            set1.drawCirclesEnabled = YES;//是否绘制折线点
            set1.circleColor = ZSColorRed;//折线点的颜色
            set1.circleRadius = 2;//折现点圆角
            set1.highlightColor = ZSColorListLeft;//点击高亮颜色
            
            //设置渐变填充
            NSArray *gradientColors = @[
                                        (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                        (id)ZSColorRed.CGColor
                                        ];
            CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
            set1.fillAlpha = 1.f;
            set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
            set1.drawFilledEnabled = YES;//是否显示渐变填充
            CGGradientRelease(gradient);
            
            //设置数据
            NSMutableArray *dataSets = [[NSMutableArray alloc] init];
            [dataSets addObject:set1];
            LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
            self.chartView.data = data;
        }
    }
}

#pragma mark - ChartViewDelegate
//点击折线图
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight
{
    //将点击的数据滑动到中间
    [self.chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[self.chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:0.35];
    
    //改变选中的数据时候，label的值跟着变化
    NSInteger index = (NSInteger)highlight.x;
    if (self.dataArray.count > 0)
    {
        ZSQuaryOrderChangeModel *model = self.dataArray[index];
        self.markLabel.text = [NSString stringWithFormat:@" %@ %@ %@笔 %@万元 ", model.date, model.dayOfWeek, model.totalOrderSum, [ZSTool yuanIntoTenThousandYuanWithCount:model.totalOrderAmount WithType:YES]];
    }
}

@end
