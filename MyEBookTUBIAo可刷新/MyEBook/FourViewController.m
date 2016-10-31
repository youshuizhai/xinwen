
//
//  SecondViewController.m
//  MyEBook
//
//  Created by lanou on 16/10/27.

//
//  ViewController.m
//  MyEBook
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "FourViewController.h"
#import "ModelOfLuBoTu.h"
#import "HeaderView.h"
//#import "TwoCell.h"
#import "DataOfMainCell.h"
#import "UIImageView+WebCache.h"
#import "XDRefresh.h"
static NSUInteger count = 2;

#define width2 [UIScreen mainScreen].bounds.size.width
#define height2 [UIScreen mainScreen].bounds.size.height
@interface FourViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDataDelegate>{
    
    XDRefreshHeader *_header;
    XDRefreshFooter *_footer;
}

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * mArrayOfLuBoTu;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FourViewController
#pragma mark 轮播图数据的加载  self.mArrayOfLuBoTu
-(void)loadDataOfLuBoTu{
    NSString * str=@"http://lib.wap.zol.com.cn/ipj/docList/?v=11.0&class_id=74&page=1&vs=and501&retina=1&modename=M2NOTE";
    //1.生成URL
    NSURL * url=[NSURL URLWithString:str];
    //2.创建会话
    NSURLSession * session=[NSURLSession sharedSession];
    //3.创建任务
    NSURLSessionDataTask * task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            //5.解析数据
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr = dict[@"pics"];
            for (NSDictionary * dict1 in arr) {
                ModelOfLuBoTu * modelOfLuBoTu=[[ModelOfLuBoTu alloc] init];
                [modelOfLuBoTu setValuesForKeysWithDictionary:dict1];
                [self.mArrayOfLuBoTu addObject:modelOfLuBoTu];
                //答应model
                // NSLog(@"dict=%@",modelOfLuBoTu.name);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setScrollValue];
                [self.tableView reloadData];
            });
        }else{
            NSLog(@"%@",error);
        }
    }];
    //4.开启任务
    [task resume];
}

#pragma mark - 加载主要的数据
-(NSMutableArray *)loadData:(NSString *)fileName{
    
    
    NSMutableArray * array=[[NSMutableArray alloc] init];
    //1.生成URL
    NSURL * url=[NSURL URLWithString:fileName];
    //2.创建会话
    NSURLSession * session=[NSURLSession sharedSession];
    //3.创建任务
    NSURLSessionDataTask * task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // NSLog(@"******%@",data);
        if(data){
            //5.解析数据
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
                      NSArray * arr=dict[@"list"];
            
            for (NSDictionary *dict1 in arr) {
                ModelOfLuBoTu *model = [[ModelOfLuBoTu alloc]init];
                [model setValuesForKeysWithDictionary:dict1];
                [array addObject:model];
                // [self.dataSource addObjectsFromArray:arr];///////
                
                //self.zanCunArray=[array mutableCopy];
                
                
                NSLog(@"******%@",model.stitle);
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    [self setScrollValue];
                [self.dataSource addObjectsFromArray:array];
                // NSLog(@"%@",self.dataSource);
                [self.tableView reloadData];
            });
            
        }
    }];
    //4.开启任务
    [task resume];
    return array;
    
    
}



#pragma mark tableview的加载
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
    NSLog(@"aaaaaa");
    */
    
   
    
    //给主要数据的数组初始化
    self.dataSource=[NSMutableArray new];
    
    
    //给第一个页面添加标题
    self.navigationItem.title=@"手机";
    self.navigationController.navigationBar.translucent=NO;
    [self initTableView];
    //数据数组的加载
    self.mArrayOfLuBoTu=[[NSMutableArray alloc] init];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // [self.tableView registerClass:[TwoCell class] forCellReuseIdentifier:@"twocell"];
    
    
    //
    self.tableView.tableHeaderView=[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.width/2)];
    //    //把tableView的边线取消
    //    self.tableView.separatorStyle=NO;
    
    //    self.tableView.tableHeaderView.layer.cornerRadius=30;
    //    self.tableView.tableHeaderView.layer.masksToBounds=YES;
    /************************************************************/
    // 书城主要数据数组的加载
    
    //注册DataOFMain的xib数据
    //注册xib的cell
    UINib *cellNib = [UINib nibWithNibName:@"DataOfMainCell" bundle:nil];
    //通过nib对象注册
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DataOfMainCell"];
    
    
    
    
    
    
    
    __weak typeof(self) weakSelf = self;
    
    
    //刷新头部的方法
    _header =  [XDRefreshHeader headerOfScrollView:self.tableView refreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSLog(@"hello");
                
                NSString *fileName = [NSString stringWithFormat:@"http://lib.wap.zol.com.cn/ipj/docList/?v=11.0&class_id=74&page=1&vs=and501&retina=1&modename=M2NOTE"];
                NSArray *newDataSource = [weakSelf loadData:fileName];
                //书城两组数据的加载
                [self loadDataOfLuBoTu];
                
                
                [_footer resetNoMoreData];
                
                [self.tableView reloadData];
                [_header endRefreshing];
            });
        });
    }];
    
    [_header beginRefreshing];//启动
    
    
    //刷新尾部
    _footer = [XDRefreshFooter footerOfScrollView:self.tableView refreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSLog(@"hello2");
                
                NSString *firstName = [NSString stringWithFormat:@"http://lib.wap.zol.com.cn/ipj/docList/?v=11.0&class_id=74&page=%ld&vs=and501&retina=1&modename=M2NOTE",count];
                              [weakSelf loadData:firstName];
                
                [self.tableView reloadData];
                [_footer endRefreshing];
                
            });
        });
    }];
    
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 赋予轮播图的数据
- (void)setScrollValue
{
    HeaderView *header = (HeaderView *)self.tableView.tableHeaderView;
    [header setImageWithModels:self.mArrayOfLuBoTu];
}


#pragma mark tableView的代理方法
//可以被编辑的行
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//多少个row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
//cell的编辑
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(indexPath.row==0){
    //      TwoCell * cell=[tableView dequeueReusableCellWithIdentifier:@"twocell"];
    //         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        return cell;
    //    }else{
    DataOfMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataOfMainCell"];
    ModelOfLuBoTu *model = self.dataSource[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc2]];
    cell.titleLabel.text = model.stitle;
    cell.timeLabel.text = model.sdate;
    cell.tagLabel.text = [NSString stringWithFormat:@"%@",model.comment_num];        return cell;
    
    //}
}
//row的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(indexPath.row==0){
    //        return [UIScreen mainScreen].bounds.size.width/4;
    //    }else{
    return [UIScreen mainScreen].bounds.size.width/3;
    
    // }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




