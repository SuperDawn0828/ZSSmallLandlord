//
//  ZSWSLeftRightCell.h
//  ZSMoneytocar
//
//  Created by 武 on 16/7/15.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSBaseTableViewCell.h"
static NSString *const KReuseZSWSLeftRightCellIdentifier=@"ZSWSLeftRightCell";

@interface ZSWSLeftRightCell : UITableViewCell
@property(nonatomic,strong)UILabel     *leftLab;
@property(nonatomic,strong)UITextField *rightTextField;
@property(nonatomic,strong)UILabel     *bottomLab;
//@property(nonatomic,strong)UILabel     *line;
@end

@protocol ZSWSLeftRightCell <NSObject>
@end
