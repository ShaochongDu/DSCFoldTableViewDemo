//
//  ViewController.m
//  DSCFoldTableViewDemo
//
//  Created by Caxa on 16/1/11.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ViewController.h"

#import "FolderHeaderView.h"

//  设置列表配置文件
#define kIsUse @"isUse"
#define kModuleIcon @"moduleIcon"
#define kModuleName @"moduleName"
#define kHeaderDes @"headerDes"
#define kFooterDes @"footerDes"
#define kDataArray @"dataArray"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,FolderHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *folderArray;  //  存储已折叠的indexpath数据
@property (nonatomic, strong) NSMutableArray *plistArray;   //  处理后的plist文件数据

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.folderArray = [NSMutableArray array];
    self.plistArray = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self loadPlistFileName:@"DataList.plist"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
/**
 *  加载plist配置文件
 *
 *  @param fileName 文件名称
 */
- (void)loadPlistFileName:(NSString *)fileName
{
    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:str];
    for (NSDictionary *sectionDic in plistArray) {
        BOOL sectionIsUse = [sectionDic[kIsUse] boolValue];
        //  判断整个分组是否可用
        if (sectionIsUse) {
            NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
            [headerDic setObject:sectionDic[kHeaderDes] forKey:kHeaderDes];
            [headerDic setObject:sectionDic[kFooterDes] forKey:kFooterDes];
            
            NSArray *dataArray = sectionDic[kDataArray];
            NSMutableArray *inArray = [NSMutableArray array];
            for (NSDictionary *settingDic in dataArray) {
                BOOL isUse = [settingDic[kIsUse] boolValue];
                //  判断子分组是否可用
                if (isUse) {
                    [inArray addObject:settingDic];
                }
            }
            [headerDic setObject:inArray forKey:kDataArray];
            [self.plistArray addObject:headerDic];
        }
    }
}

#pragma mark - UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.plistArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  拼接indexpath
    if ([self.folderArray containsObject:[NSNumber numberWithInteger:section]]) {
        return 0;
    }
    NSMutableDictionary *dataDic = self.plistArray[section];
    NSMutableArray *sectionArray = dataDic[kDataArray];
    return sectionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfity = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfity];
    }
    NSMutableDictionary *dataDic = self.plistArray[indexPath.section];
    NSArray *dataArray = dataDic[kDataArray];
    NSDictionary *dic = dataArray[indexPath.row];
    cell.textLabel.text = dic[kModuleName];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewIdentify = @"FolderHeaderView";
    FolderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentify];
    if (!headerView) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"FolderHeaderView" owner:self options:nil] lastObject];
        headerView.delegate = self;
        headerView.sectionIndex = section;
    }
    
    NSMutableDictionary *dataDic = self.plistArray[section];
    headerView.headerTitleLabel.text = dataDic[kHeaderDes];
    //  判断当前seciton是否已经展开
    if ([self.folderArray containsObject:[NSNumber numberWithInteger:section]]) {
        headerView.isSectionOpen = NO;
    } else {
        headerView.isSectionOpen = YES;
    }
    
    return headerView;
}

#pragma mark - FolderHeaderViewDelegate
- (void)headerViewDidTaped:(FolderHeaderView *)headerView sectionIndex:(NSInteger)sectionIndex
{
    NSLog(@"tip:indexpath ---> %ld \n\n",sectionIndex);
    
    if ([self.folderArray containsObject:[NSNumber numberWithInteger:sectionIndex]]) {
        [self.folderArray removeObject:[NSNumber numberWithInteger:sectionIndex]];
    } else {
        [self.folderArray addObject:[NSNumber numberWithInteger:sectionIndex]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
