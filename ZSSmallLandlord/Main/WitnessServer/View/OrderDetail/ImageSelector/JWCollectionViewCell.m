//
//  JWCollectionViewCell.m
//  ZSMoneytocar
//
//  Created by 武 on 2017/2/10.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "JWCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+add.h"

@implementation JWCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.videoCoverView.hidden = YES;
    self.deleteBtn.hidden = YES;
    //添加资料
    self.mainImageView.layer.cornerRadius = 4;
    self.mainImageView.clipsToBounds = YES;
    self.mainImageView.image = ImageName(@"list_add_n");
    self.mainImageView.backgroundColor = [UIColor clearColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setFileModel:(ZSWSFileCollectionModel *)fileModel
{
    //数据填充
    if (fileModel.dataUrl.length > 0 || fileModel.imageData || fileModel.image)
    {
        _fileModel = fileModel;
        self.deleteBtn.hidden = NO;
        //优先加载本地的图片
        if (fileModel.imageData)
        {
            self.mainImageView.image = [UIImage imageWithData:fileModel.imageData];
        }
        else if (fileModel.image)
        {
            self.mainImageView.image = fileModel.image;
        }
        else if (fileModel.dataUrl.length > 0)
        {
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,_fileModel.dataUrl]] placeholderImage:defaultImage_square];//加载缩略图
        }
    }
    else
    {
        self.deleteBtn.hidden = YES;
        if (self.isShowAdd){
            self.mainImageView.image = ImageName(@"list_add_n");
        }else{
            self.mainImageView.image = ImageName(@"");
        }
    }
}

- (IBAction)deleteItemClick:(UIButton*)sender
{
    if (self.fileModel.isNewImage == YES)
    {
        NSUInteger needUploadNum = [USER_DEFALT integerForKey:@"needUploadNum"];
        if (needUploadNum > 0) {
            needUploadNum = needUploadNum - 1;
        }
        [USER_DEFALT setInteger:needUploadNum forKey:@"needUploadNum"];
        
        
        if (self.fileModel.dataUrl.length > 0) {
            NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:@"hasbeenUploadNum"];
            if (hasbeenUploadNum > 0) {
                hasbeenUploadNum = hasbeenUploadNum - 1;
            }
            [USER_DEFALT setInteger:hasbeenUploadNum forKey:@"hasbeenUploadNum"];
        }
    }
    
    //删除图片代理
    if (_delegate && [_delegate respondsToSelector:@selector(deleteDataByIndexPath:)])
    {
        [_delegate deleteDataByIndexPath:self.indexPath];
    }
}

@end
