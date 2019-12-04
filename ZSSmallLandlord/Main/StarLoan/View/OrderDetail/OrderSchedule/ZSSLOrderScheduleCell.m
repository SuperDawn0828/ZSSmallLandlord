//
//  ZSSLOrderScheduleCell.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLOrderScheduleCell.h"

@implementation ZSSLOrderScheduleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.remarkContentHightContraint.constant       = 0;
    self.remarkHightContraint.constant              = 0;
    self.remarkContentLabelBottomContraint.constant = 0;
    self.remarkContentLabelTopContraint.constant    = 0;
    self.opinionLabelHightContraint.constant        = 0;
    self.isOpenBtnHightContraint.constant           = 0;
    self.remarkContentLabel.hidden = YES;
    self.remarkLabel.hidden        = YES;
    self.isOpen                    = NO;
    self.model.isOpen              = NO;
    self.remarkContentLabel.textColor = ZSColorListRight;
    self.currentStateLabel.textColor  = ZSPageItemColor;
    self.opinionLabel.textColor       = ZSPageItemColor;
    self.nameLabel.textColor          = ZSColorListRight;

    self.nameBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.top - 5, self.nameLabel.width + 60, self.nameLabel.height + 10)];
    [self.contentView addSubview:self.nameBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setModel:(SpdOrderStates *)model
{
    //姓名
    [NSString setText:[self setNameByCreatOrRoleWithModel:model] label:self.nameLabel imageSpan:5];
    self.nameLabel.textColor = ZSColorRed;
    self.nameBtn.width = self.nameLabel.width + 60;
   
    //节点名称
    self.orderStateLabel.text = SafeStr(model.node);
    
    //耗时时间 最后一条若是已关闭或者是完成审批则不显示耗时时间
    if ([SafeStr(model.node) containsString:@"已关闭"] || [SafeStr(model.node) containsString:@"完成审批"])
    {
        self.stayTimeLabel.text = @"";
        if ([SafeStr(model.node) containsString:@"已关闭"] ){
            self.nameLabel.text = [self setNameByCreatOrRoleWithModel:model];
            self.nameLabel.textColor = ZSColorListRight;            
        }
    }
    else
    {
         self.stayTimeLabel.text = SafeStr(model.now_takes_time);
    }
    
    //第一条是当前状态 其余是创建时间
    self.currentStateLabel.text = SafeStr(model.sign_date);
  
    //审批意见
    self.opinionLabel.hidden = YES;
  
    //1.提交资料类
    if ([SafeStr(model.note_type) isEqualToString:@"DOC"])
    {
        self.nameLabelBottomContraint.constant    = 0;
        if (model.items.length > 0){
            self.opinionLabel.hidden = NO;
            self.opinionLabel.text   = [NSString stringWithFormat:@"%@",model.items];
            self.opinionLabel.textColor = ZSColorListRight;
            self.nameLabelBottomContraint.constant  = 10;
            self.remarkContentLabelTopContraint.constant = 10;
            self.clickBtn.userInteractionEnabled = NO;
        }
    }
    //2.审批意见类
    else if ([SafeStr(model.note_type) isEqualToString:@"AUD"])
    {
        [self getViewsShowByNoteTypeIsAud:model withType:YES];
    }
    //3.添加备注类
    else if ([SafeStr(model.note_type) isEqualToString:@"ADD"])
    {
        self.nameLabelBottomContraint.constant    = 0;
        if (model.remark.length > 0){
            self.opinionLabel.hidden = NO;
            self.opinionLabel.text   = [NSString stringWithFormat:@"%@",model.remark];
            self.opinionLabel.textColor = ZSColorListRight;
            self.nameLabelBottomContraint.constant  = 10;
            self.remarkContentLabelTopContraint.constant = 10;
            self.clickBtn.userInteractionEnabled = NO;
        }
    }
    else
    {
        //关闭的订单
        if ([model.node containsString:@"已关闭"])
        {
            [self getViewsShowByNoteTypeIsAud:model withType:NO];
        }
    }
}

#pragma mark 审批类操作界面展示/订单已关闭界面展示
- (void)getViewsShowByNoteTypeIsAud:(SpdOrderStates *)model withType:(BOOL)isAUD
{
    //有审批意见/关闭原因
    if (model.result.length > 0)
    {
        self.opinionLabelHightContraint.constant     = 16;
        self.remarkContentLabelTopContraint.constant = 0;
        self.openBtn.hidden                      = YES;
        self.opinionLabel.hidden                 = NO;
        self.clickBtn.userInteractionEnabled     = NO;
        NSString *opinionStr =  isAUD == YES ? [NSString stringWithFormat:@"审批意见: %@", model.result] : [NSString stringWithFormat:@"关闭原因: %@", model.result];
        self.opinionLabel.attributedText = [opinionStr drawLabelTextDiffrentColor:ZSColorListRight beginIndex:5 endIndex:(int)opinionStr.length - 5];
    }
    
    //有备注
    if (model.remark.length > 0)
    {
        //1.备注信息存在
        self.openBtn.hidden = NO;
        self.clickBtn.userInteractionEnabled     = YES;
        self.isOpenBtnHightContraint.constant    = 20;
        if (model.isOpen)
        {
            //1.1展示按钮展开状态
            self.remarkHightContraint.constant           = 14;
            self.remarkContentLabelTopContraint.constant = 8;
            self.remarkContentLabelBottomContraint.constant = 10;
            self.remarkContentLabel.text   = model.remark;
            self.remarkContentLabel.hidden = NO;
            self.remarkLabel.hidden        = NO;
            [self.openBtn setImage:[UIImage imageNamed:@"bar_details_arrow_s"] forState:UIControlStateNormal];
            self.remarkContentLabel.text = model.remark;
        }
        else
        {
            //1.2展示按钮关闭状态
            self.remarkContentLabelTopContraint.constant    = 0;
            self.remarkContentLabelBottomContraint.constant = 0;
            self.remarkContentLabel.hidden = YES;
            self.remarkLabel.hidden        = YES;
            [self.openBtn setImage:[UIImage imageNamed:@"bar_details_arrow_n"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark 根据角色展示创建订单人
- (NSString *)setNameByCreatOrRoleWithModel:(SpdOrderStates *)model
{
    NSString *string = @"";
    if (model.creator.length > 0){
        //定单创建人存在
        string = model.creator_role.length > 0 ? [NSString stringWithFormat:@"%@(%@)",SafeStr(model.creator),model.creator_role] : SafeStr(model.creator);
    }else{
        string =  SafeStr(model.creator_role);
    }
    return string;
}

#pragma mark cell中细线展示的情况
- (void)setCellDataWithModelWithindexth:(NSIndexPath *)indexPath model:(SpdOrderStates *)model
{
    //cell竖线的展示隐藏
    [self setValueWithIndexpath:indexPath];
   
#pragma mark 第一行展示
    //1.第一行
    if (indexPath.row == 0)
    {
        self.orderStateLabel.hidden = YES;
        self.nameBtn.enabled = NO;
        
        //1.1已关闭和完成审批不显示名称
        if ([SafeStr(model.node) containsString:@"已关闭"] || [SafeStr(model.node) containsString:@"完成审批"])
        {
            if ([SafeStr(model.node) containsString:@"完成审批"])
            {
                //1.完成审批
                self.currentStateLabel.text = model.node;
                self.orderStateLabel.hidden = YES;
                self.nameLabel.text = @"";
            }
            else
            {
                //2.关闭
//                self.currentStateLabel.text = SafeStr(model.sign_date);
                self.currentStateLabel.text = SafeStr(model.create_date);
                self.orderStateLabel.hidden = NO;
            }
        }
        //1.2其他节点显示名称
        else
        {
            //节点名称
            self.orderStateLabel.text = SafeStr(model.node);
            if ([SafeStr(model.note_type) isEqualToString:@"AUD"])
            {
                self.opinionLabel.text = @"进行审批"; //审批类显示
                self.opinionLabel.textColor = ZSColorListRight;
            }
            //当前节点名称,加一个"中"字
            if ([model.node isEqualToString:@"新增备注"])//新增备注不要加"中"字
            {
                self.currentStateLabel.text = model.node;
                self.nameLabel.text = model.remark;
                self.nameLabel.textColor = ZSColorListRight;
            }
            else
            {
                self.currentStateLabel.text = [NSString stringWithFormat:@"%@中",model.node];
                self.nameLabel.text = NSStringFormat(@"需要:%@",[self setNameByCreatOrRoleWithModel:model]);
                self.nameLabel.textColor = ZSColorListRight;
            }
        }
    }
#pragma mark 其他行展示
    //2.除第一行之外的其他
    else
    {
        self.orderStateLabel.hidden = NO;
        //拨打电话点击事件  初当前进度的不可拨打电话，历史节点可拨打电话
        self.nameBtn.enabled = YES;
        [self.nameBtn addTarget:self action:@selector(nameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.nameBtn.tag = indexPath.row;
    }
    
    //展开btn的点击事件
    [self.clickBtn addTarget:self action:@selector(openBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn.tag = indexPath.row;
}

#pragma mark cell竖线的展示隐藏
- (void)setValueWithIndexpath:(NSIndexPath *)indexPath
{
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    self.pointImgView.image = ImageName(@"");
    self.pointImgViewWidthConstraint.constant  = 8;
    self.pointImgViewHeightConstraint.constant = 8;
    self.pointImgViewLeftConstraint.constant   = 17;
    self.pointImgView.layer.cornerRadius       = 4;
    self.pointImgView.backgroundColor          = UIColorFromRGB(0xcccccc);
    //第一行
    if (indexPath.row == 0)
    {
        self.topView.hidden = YES;
        self.pointImgViewWidthConstraint.constant  = 13;
        self.pointImgViewHeightConstraint.constant = 13;
        self.pointImgViewLeftConstraint.constant   = 15;
        self.pointImgView.layer.cornerRadius       = 6;
        self.pointImgView.backgroundColor          = ZSColorWhite;
        self.pointImgView.image                    = ImageName(@"list_select_s");
        self.stateLabelWidthContraint.constant     = 0;
        self.nameLabelRightContraint.constant      = -55;
    }
}

- (void)nameBtnClicked:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(currentNameBtnClick:)]){
        [_delegate currentNameBtnClick:btn.tag];
    }
}

- (void)openBtnClicked:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(currentOpenAndCloseBtnClick:)]){
        [_delegate currentOpenAndCloseBtnClick:btn.tag];
    }
}

@end
