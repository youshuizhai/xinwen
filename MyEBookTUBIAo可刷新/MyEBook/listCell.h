//
//  listCell.h
//  排行榜
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 self. All rights reserved.
//

#import <UIKit/UIKit.h>
@class model;
@interface listCell : UITableViewCell
-(void)setValuesWithModel:(model *)listmodel;
@end
