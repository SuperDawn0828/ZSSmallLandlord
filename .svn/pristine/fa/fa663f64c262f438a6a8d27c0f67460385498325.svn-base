//
//  ZSSLOrderScheduleCell.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/28.
//  Copyright © 2017年 黄曼文. All rights reserved.
//  首页--星速贷--订单进度--审批类cell

static NSString *const KReuseZSSLOrderScheduleCellIdentifier = @"ZSSLOrderScheduleCell";

#import <UIKit/UIKit.h>


@protocol ZSSLOrderScheduleCellDelegate <NSObject>
@optional
- (void)currentNameBtnClick:(NSInteger)tag;//拨打电话
- (void)currentOpenAndCloseBtnClick:(NSInteger)tag;//展开收缩
@end

@interface ZSSLOrderScheduleCell : UITableViewCell

@property (nonatomic,  weak)id<ZSSLOrderScheduleCellDelegate> delegate;

//订单进度model
@property(nonatomic,strong)SpdOrderStates *model;

//审批意见是否展开
@property(nonatomic,assign)BOOL isOpen;

//圆点图片
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;

//上半部分的线条
@property (weak, nonatomic) IBOutlet UIView *topView;

//下半部分的线条
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//圆点图片高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImgViewHeightConstraint;

//圆点图片宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImgViewWidthConstraint;

//圆点图片剧左约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImgViewLeftConstraint;

//当前状态 
@property (weak, nonatomic) IBOutlet UILabel *currentStateLabel;

//停留时间
@property (weak, nonatomic) IBOutlet UILabel *stayTimeLabel;

//审批人员
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//审批人员点击btn
@property (strong, nonatomic) UIButton *nameBtn;

//节点名称
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

//节点名称宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLabelWidthContraint;

//审批意见
@property (weak, nonatomic) IBOutlet UILabel *opinionLabel;

//备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

//更多Btn
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

//备注内容
@property (weak, nonatomic) IBOutlet UILabel *remarkContentLabel;

//点击Btn
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

//备注内容高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkContentHightContraint;

//审批意见高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *opinionLabelHightContraint;

//更多按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isOpenBtnHightContraint;

//名字高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHightContraint;

//备注高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHightContraint;

//名字据下约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelBottomContraint;

//备注内容据下约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkContentLabelBottomContraint;

//备注内容据上约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkContentLabelTopContraint;

//名字剧右约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelRightContraint;


#pragma mark 根据角色展示创建订单人
- (NSString *)setNameByCreatOrRoleWithModel:(SpdOrderStates *)model;

#pragma mark cell中细线展示的情况
- (void)setCellDataWithModelWithindexth:(NSIndexPath *)indexPath model:(SpdOrderStates *)model;

@end
