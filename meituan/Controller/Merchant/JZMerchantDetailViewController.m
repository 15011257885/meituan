//
//  JZMerchantDetailViewController.m
//  meituan
//
//  Created by jinzelu on 15/7/17.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JZMerchantDetailViewController.h"
#import "NetworkSingleton.h"
#import "JZMerDetailModel.h"
#import "MJExtension.h"
#import "JZMerDetailImageCell.h"

@interface JZMerchantDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_titleLabel;
    NSMutableArray *_dataSourceArray;
}

@end

@implementation JZMerchantDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initData];
    [self setNav];
    [self initTableView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMerchantDetailData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    _dataSourceArray = [[NSMutableArray alloc] init];
}

-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = RGB(250, 250, 250);
    [self.view addSubview:backView];
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, screen_width, 0.5)];
    lineView.backgroundColor = RGB(192, 192, 192);
    [backView addSubview:lineView];
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 23, 23);
    [backBtn setImage:[UIImage imageNamed:@"btn_backItem"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-80, 30, 160, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"团购详情";
    [backView addSubview:_titleLabel];
    
    //收藏
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(screen_width-10-23, 30, 22, 22);
    [collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"icon_collect_highlighted"] forState:UIControlStateHighlighted];
    [backView addSubview:collectBtn];
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(screen_width-10-23-10-23, 30, 22, 22);
    [shareBtn setImage:[UIImage imageNamed:@"icon_merchant_share_normal"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"icon_merchant_share_highlighted"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(OnShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:shareBtn];
    
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - 响应事件
-(void)OnBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OnShareBtn:(UIButton *)sender{
    
}


#pragma mark - 请求数据
-(void)getMerchantDetailData{
    NSString *str1 = @"http://api.meituan.com/group/v1/poi/";
    NSString *str2 = @"?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=8s5pIPqAHXfwBBOWjWssJ6yhpP4%3D&__skno=3A22D2FC-4CE5-461F-8022-49617F529895&__skts=1437114388.938075&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&client=iphone&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-07-17-14-20300&userid=104108621&utm_campaign=AgroupBgroupE72175652459578368_c0_eb21e98ced02c66e9539669c2efedfec0D100Fa20141120nanning__m1__leftflow___ab_pindaochangsha__a__leftflow___ab_gxtest__gd__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_i550poi_ktv__d__j___ab_chunceshishuju__a__a___ab_gxh_82__nostrategy__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi0202__b__a___ab_pindaoquxincelue0630__b__b1___ab_i550poi_xxyl__b__leftflow___ab_i_group_5_6_searchkuang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_pindaoshenyang__a__leftflow___ab_b_food_57_purepoilist_extinfo__a__a___ab_waimaiwending__b__a___ab_waimaizhanshi__b__b1___ab_i550poi_lr__d__leftflow___ab_i_group_5_5_onsite__b__b___ab_xinkeceshi__b__leftflowGmerchant&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",str1,self.poiid,str2];
    [[NetworkSingleton sharedManager] getMerchantDetailResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"商家详情请求成功");
        NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
        if (dataArray.count>0) {
            [_dataSourceArray removeAllObjects];
            JZMerDetailModel *jzMerDetailM = [JZMerDetailModel objectWithKeyValues:dataArray[0]];
            [_dataSourceArray addObject:jzMerDetailM];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error){
        NSLog(@"商家详情请求失败:%@",error);
        
    }];
}

//获取商店图片组
-(void)getMerchantImagesData{
    NSString *urlStr = @"http://api.meituan.com/group/v1/poi/4636105/imgs?__skck=40aaaf01c2fc4801b9c059efcd7aa146&__skcy=bxjqBsqhy3J7%2B4OI2YcZVheKu28%3D&__skno=B3D4BFC9-0E7D-4A26-87C4-36AD824F246A&__skts=1437116397.537090&__skua=bd6b6e8eadfad15571a15c3b9ef9199a&__vhost=api.mobile.meituan.com&ci=1&classified=true&client=iphone&limit=3&movieBundleVersion=100&msid=48E2B810-805D-4821-9CDD-D5C9E01BC98A2015-07-17-14-20300&offset=0&userid=104108621&utm_campaign=AgroupBgroupD100Fa20141120nanning__m1__leftflow___ab_pindaochangsha__a__leftflow___ab_gxtest__gd__leftflow___ab_gxhceshi__nostrategy__leftflow___ab_i550poi_ktv__d__j___ab_chunceshishuju__a__a___ab_gxh_82__nostrategy__leftflow___ab_i_group_5_3_poidetaildeallist__a__b___b1junglehomepagecatesort__b__leftflow___ab_gxhceshi0202__b__a___ab_pindaoquxincelue0630__b__b1___ab_i550poi_xxyl__b__leftflow___ab_i_group_5_6_searchkuang__a__leftflow___i_group_5_2_deallist_poitype__d__d___ab_pindaoshenyang__a__leftflow___ab_b_food_57_purepoilist_extinfo__a__a___ab_waimaiwending__b__a___ab_waimaizhanshi__b__b1___ab_i550poi_lr__d__leftflow___ab_i_group_5_5_onsite__b__b___ab_xinkeceshi__b__leftflowGmerchant&utm_content=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&utm_medium=iphone&utm_source=AppStore&utm_term=5.7&uuid=4B8C0B46F5B0527D55EA292904FD7E12E48FB7BEA8DF50BFE7828AF7F20BB08D&version_name=5.7";
    [[NetworkSingleton sharedManager] getMerchantImagesResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"商家详情请求成功");
    } failureBlock:^(NSString *error){
        NSLog(@"商家详情请求失败：%@",error);
    }];
}






#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 160;
    }else if(indexPath.section == 1){
        return 54;
    }else if (indexPath.section == 2){
        return 40;
    }else{
        return 40;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"detailCell0";
        JZMerDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[JZMerDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
        }
        if (_dataSourceArray.count > 0) {
            JZMerDetailModel *jzMerDM = _dataSourceArray[0];
            cell.BigImgUrl = [jzMerDM.frontImg stringByReplacingOccurrencesOfString:@"w.h" withString:@"300.200"];
            cell.shopName = jzMerDM.name;
            cell.avgPrice = jzMerDM.avgPrice;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIndentifier = @"detailCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            //位置坐标
            UIImageView *locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 20, 20)];
            [locationImgView setImage:[UIImage imageNamed:@"icon_merchant_location"]];
            [cell addSubview:locationImgView];
            //位置信息
            UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, screen_width-40-90, 50)];
            locationLabel.tag = 200;
            locationLabel.textColor = [UIColor grayColor];
            locationLabel.numberOfLines = 2;
            [cell addSubview:locationLabel];
            //
            UIImageView *telImgView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-35, 15, 19, 25)];
            [telImgView setImage:[UIImage imageNamed:@"icon_deal_phone"]];
            [cell addSubview:telImgView];
        }
        
        if (_dataSourceArray.count > 0) {
            JZMerDetailModel *jzMerDM = _dataSourceArray[0];
            UILabel *locationLabel = (UILabel *)[cell viewWithTag:200];
            locationLabel.text = jzMerDM.addr;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 2){
        static NSString *cellIndentifier = @"detailCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *cellIndentifier = @"detailCell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
