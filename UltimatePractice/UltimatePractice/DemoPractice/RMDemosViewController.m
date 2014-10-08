//
//  SecondViewController.m
//  UltimatePractice
//
//  Created by Jerry on 9/29/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDemosViewController.h"
#import "RMCommonFunc.h"
#import "RMLongTouchMoveOrRemoveViewController.h"

@interface RMDemosViewController ()
<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RMDemosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[RMCommonFunc SharedInstance] allDynamicClasses] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * demoCellID = @"demoCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:demoCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:demoCellID];
    }
    NSArray * allClassMods = [[RMCommonFunc SharedInstance] allDynamicClasses];
    cell.textLabel.text = [(RMDynamicClassMod *)[allClassMods objectAtIndex:indexPath.row] classKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * clickedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (clickedCell) {
        UIViewController * vc = nil;
        
        if ([clickedCell.textLabel.text isEqualToString:kLongTouchMoveOrRemoveClass]) {
            vc = [[RMLongTouchMoveOrRemoveViewController alloc] initWithNibName:@"RMLongTouchMoveOrRemoveViewController" bundle:nil];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
