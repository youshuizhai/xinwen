//
//  HeaderView.m
//  YiChe
//
//  Created by 刘星 on 15/8/8.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "HeaderView.h"
#import "ModelOfLuBoTu.h"
#import "UIImageView+WebCache.h"
#define scrollWideth [UIScreen mainScreen].bounds.size.width
//#define scrollHeight [UIScreen mainScreen].bounds.size.height
// 就是创建scrollview，前期没有数据

@interface HeaderView ()<UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView *scroll;
@property(nonatomic,assign)int i;
@property(nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScroll];
    }
    return self;
}
- (void)createScroll
{
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWideth, self.frame.size.height)];
//    _scroll.contentSize = CGSizeMake(scrollWideth * 10, 0);
    _scroll.pagingEnabled = YES;
    
    [self addSubview:_scroll];
     //创建定时器
     [self timerOn];
    self.scroll.delegate=self;
}

- (void)setImageWithModels:(NSArray *)array
{   //
     self.i=(int)array.count;
    _scroll.contentSize = CGSizeMake(scrollWideth * (self.i+2), 0);
    //
    ModelOfLuBoTu *model2 = [array objectAtIndex:0];
     ModelOfLuBoTu *model1 = [array objectAtIndex:array.count-1];
    for (int i = 0; i <array.count; i++) {
        ModelOfLuBoTu *model = [array objectAtIndex:i];
        
 //       NSString *url = model.image;
//        url = [url stringByReplacingOccurrencesOfString:@"{0}" withString:@"700"];
//        url = [url stringByReplacingOccurrencesOfString:@"{1}" withString:@"350"];
//        model.picCover = url;
        
        //添加轮播图的标题
        UILabel * labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(scrollWideth/9, scrollWideth/2.5, scrollWideth/1.2, 30)];
        labelTitle.text=model.stitle;
        labelTitle.textColor=[UIColor whiteColor];
        labelTitle.font=[UIFont systemFontOfSize:14];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((i+1) * scrollWideth, 0, scrollWideth, self.scroll.frame.size.height)];
        image.backgroundColor = [UIColor cyanColor];
        [image sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:nil];
        [image addSubview:labelTitle];

        [self.scroll addSubview:image];
        
        
    }
    
    //添加第一页和最后一页
    UIImageView * firstImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollWideth, self.scroll.frame.size.height)];
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:model1.imgsrc] placeholderImage:nil];
     //添加轮播图的标题
    UILabel * labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(scrollWideth/9, scrollWideth/2.5, scrollWideth/1.2, 30)];
    labelTitle.text=model1.stitle;
    labelTitle.textColor=[UIColor whiteColor];
    labelTitle.font=[UIFont systemFontOfSize:14];
    [firstImageView addSubview:labelTitle];

    
    [self.scroll addSubview:firstImageView];
    ////添加第一页和最后一页
    UIImageView * lastImageView=[[UIImageView alloc] initWithFrame:CGRectMake(scrollWideth*(array.count+1), 0, scrollWideth, self.scroll.frame.size.height)];
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:model2.imgsrc] placeholderImage:nil];
     //添加轮播图的标题
    UILabel * labelTitle2=[[UILabel alloc] initWithFrame:CGRectMake(scrollWideth/9, scrollWideth/2.5, scrollWideth/1.2, 30)];
    labelTitle2.text=model2.stitle;
    labelTitle2.textColor=[UIColor whiteColor];
    labelTitle2.font=[UIFont systemFontOfSize:14];
    [lastImageView addSubview:labelTitle2];
    

    
    [self.scroll addSubview:lastImageView];
    //显示的第一页
    self.scroll.contentOffset=CGPointMake(scrollWideth, 0);
    //设置页数控制器总页数，即按钮数
    self.pageControl.numberOfPages=self.i;

    
}

//当用户准备拖拽的时候，关闭定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerOff];
}
//当用户停止拖拽的时候，添加一个定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self timerOn];
}

//每隔1秒播放图片，其实是每隔1秒调用imgPlay方法
-(void)timerOn{
    //定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(Action) userInfo:nil repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}




//关闭定时器，并且把定时器设置为nil，这是习惯
-(void)timerOff{
    [self.timer invalidate];
    self.timer=nil;
}




//停止滚动的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page=scrollView.contentOffset.x/scrollView.bounds.size.width;
    if(page==0){
        page=self.i;
    }
    if(page==self.i+1){
        page=1;
    }
    scrollView.contentOffset=CGPointMake(scrollWideth*page, 0);
}

//8 12 345678 1
-(void)Action
{
    NSInteger page=self.scroll.contentOffset.x/self.scroll.bounds.size.width;
    if(page==self.i+1){
        page=1;
        self.scroll.contentOffset=CGPointMake(scrollWideth*page, 0);
        page++;
    }else {
        page++;
        [UIView animateWithDuration:2.5 animations:^{
            self.scroll.contentOffset=CGPointMake(scrollWideth*page, 0);
        }];

    }
}

//这个事判断定时器滚动的时候，实时判断滚动位置，以让Page Controll显示当前的点是哪一个点
//这个需要在总宽度上加上半个scrollView的宽度，是为了保证拖拽到一半时候左右的效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage=(self.scroll.frame.size.width*0.5+self.scroll.contentOffset.x)/self.scroll.frame.size.width;
}

@end








