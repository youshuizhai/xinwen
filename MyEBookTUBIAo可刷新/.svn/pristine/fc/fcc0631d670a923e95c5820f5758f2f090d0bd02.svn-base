//
//  listCell.m
//  排行榜
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 self. All rights reserved.
//

#import "listCell.h"
#import "model.h"
#import "UIImageView+WebCache.h"
@interface listCell ()
@property(nonatomic,strong)UIImageView *blackgroudImage;


@end

@implementation listCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initionalSubViews];
    }
    return self;
}

-(void)initionalSubViews
{
    self.blackgroudImage=[[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:self.blackgroudImage];
}

-(void)setValuesWithModel:(model *)listmodel
{
    [self.blackgroudImage sd_setImageWithURL:[NSURL URLWithString:listmodel.cover_image] ];
}

-(void)layoutSubviews
{
    self.blackgroudImage.frame=CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height-10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
