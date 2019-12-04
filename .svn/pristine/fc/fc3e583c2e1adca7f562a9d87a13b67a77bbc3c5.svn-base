//
//  ZSSLMaterialCollectCell.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSLMaterialCollectCell.h"

@implementation ZSSLMaterialCollectCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rightBtn.userInteractionEnabled = NO;
    self.nameLabel.textColor = ZSColorListRight;
    self.remarkLabel.textColor = ZSColorListLeft;
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = ZSColorLine;
}

- (void)setModel:(Handles *)model
{
    _model = model;
    self.headImgView.image  = [self getImageByType:SafeStr(model.doccode)];
    self.remarkLabel.text   = SafeStr(model.remark);
    self.nameLabel.text     = SafeStr(model.docname);
    self.checkImgView.image = nil;
    [self.rightBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
    [self.rightBtn setTitle:model.finish == 1 ? @"已上传" : @"未上传"  forState:UIControlStateNormal];
   
    //订单创建人
    if ([global.slOrderDetails.isOrder isEqualToString:@"1"])
    {
        //当前可操作节点
        if (model.isHandle)
        {
            self.checkImgView.image = model.finish    == 1 ? ImageName(@"list_uploaded_n") : ImageName(@"list_nouploaded_n");//待上传/已上传
            [self.rightBtn setTitle:model.finish      == 1 ? @"已上传" : @"待上传"  forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:model.finish == 1 ? ZSColorAllNotice : ZSColorRed forState:UIControlStateNormal];
            if (model.need == 1){
                self.nameLabel.attributedText = [SafeStr(model.docname) addStar];
            }else{
                self.nameLabel.text = SafeStr(model.docname);
            }
        }
    }
    //不是订单创建人
    else
    {
        //可以编辑 先判断是否可以编辑在判断是否显示*号
        if (model.isHandle && model.canDo == 1)
        {
            self.checkImgView.image = model.finish    == 1 ? ImageName(@"list_uploaded_n") : ImageName(@"list_nouploaded_n");//待上传/已上传
            [self.rightBtn setTitle:model.finish      == 1 ? @"已上传" : @"待上传"  forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:model.finish == 1 ? ZSColorAllNotice : ZSColorRed forState:UIControlStateNormal];
            if (model.need == 1){ //必填项
                self.nameLabel.attributedText = [SafeStr(model.docname) addStar];
            }else{
                self.nameLabel.text = SafeStr(model.docname);
            }
        }
    }
}

#pragma mark 根据资料类型返回图片
- (UIImage *)getImageByType:(NSString *)name
{
    UIImage *image  = nil;
    //户口本
    if ([name isEqualToString:@"HKB"])
    {
        image = ImageName(@"bar_household_s");
    }
    //婚姻状况
    else if ([name isEqualToString:@"HYZK"])
    {
        image = ImageName(@"bar_marital_s");
    }
    //银行流水
    else if ([name isEqualToString:@"YHLS"])
    {
        image = ImageName(@"bar_bankwater_s");
    }
    //收入证明
    else if ([name isEqualToString:@"SRZM"])
    {
        image = ImageName(@"bar_income_proof_s");
    }
    //财力证明
    else if ([name isEqualToString:@"CLZM"])
    {
        image = ImageName(@"bar_finanacial_s");
    }
    //不动产权证
    else if ([name isEqualToString:@"BDCQZ"])
    {
        image = ImageName(@"bar_property_rights_s");
    }
    //公证书
    else if ([name isEqualToString:@"GZS"])
    {
        image = ImageName(@"bar_notarization_s");
    }
    //审批单
    else if ([name isEqualToString:@"SPD"])
    {
        image = ImageName(@"bar_approval_for_s");
    }
    //垫款凭证
    else if ([name isEqualToString:@"DKPZ"])
    {
        image = ImageName(@"bar_advances_vouchers_s");
    }
    //他项权证
    else if ([name isEqualToString:@"TXQZ"])
    {
        image = ImageName(@"bar_hexiang_s");
    }
    //产权情况表
    else if ([name isEqualToString:@"CQQKB"])
    {
        image = ImageName(@"bar_property_report_s");
    }
    //评估报告书
    else if ([name isEqualToString:@"YPGBG"])
    {
        image = ImageName(@"bar_appraisal_report_s");
    }
    //收款凭证
    else if ([name isEqualToString:@"SKPZ"])
    {
        image = ImageName(@"bar_first_document_s");
    }
    else if ([name isEqualToString:@"合同资料"])
    {
        image = ImageName(@"bar_contract_s");
    }
    else if ([name isEqualToString:@"其他资料"])
    {
        image = ImageName(@"bar_other_s");
    }
    //买方还款银行卡
    else if ([name isEqualToString:@"BANK_PEPAY"])
    {
        image = ImageName(@"list_maifang_buy");
    }
    //卖方收款银行卡
    else if ([name isEqualToString:@"BANK_GATHER"])
    {
        image = ImageName(@"list_maifang_send");
    }
    //回款确认
    else if ([name isEqualToString:@"HKQR"])
    {
        image = ImageName(@"notice_onlineapplication_n3x");
    }
    //其他随意加的资料默认同一个logo
    else
    {
        image = ImageName(@"bar_backstage_s");
    }
    return image;
}

@end
