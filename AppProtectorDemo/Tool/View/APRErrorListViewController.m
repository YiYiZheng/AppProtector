//
//  APRErrorListViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/20.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRErrorListViewController.h"
#import "AppProtectorViewTool.h"

#import "APRErrorDetailViewController.h"
#import "AppCatchError.h"

@interface APRErrorListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray <AppCatchError*>* errorList;

@property (nonatomic, copy) void (^quitBlock) (void);


@end

@implementation APRErrorListViewController

- (instancetype)initWithErrorList:(NSArray <AppCatchError*>*)list
                        quitBlock:(void (^) (void))quitBlock {
    if (self = [super init]) {
        self.errorList = list;
        self.quitBlock = quitBlock;
    }

    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Error List";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnBack)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ListCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.errorList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];

    AppCatchError *error = self.errorList[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", error.errorName];
    cell.textLabel.textColor = error.isRead ?  [UIColor grayColor] : [UIColor blackColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCatchError *error = self.errorList[indexPath.row];
    error.isRead = YES;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[APRErrorDetailViewController alloc] initWithContent:error.fullDescription] animated:YES];


    [tableView reloadData];
}

- (void)onBtnBack {
    self.quitBlock();
    // The presented vc dismiss self
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
