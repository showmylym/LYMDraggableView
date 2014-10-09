//
//  RMLongTouchMoveOrRemoveViewController.m
//  UltimatePractice
//
//  Created by Jerry on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMLongTouchMoveOrRemoveViewController.h"
#import "RMDraggableView.h"

@interface RMLongTouchMoveOrRemoveViewController ()
<RMDraggableViewDataSource, RMDraggableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) RMDraggableView * mainDraggableView;

@end

@implementation RMLongTouchMoveOrRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mainDraggableView = [[RMDraggableView alloc] initWithFrame:self.view.frame];
    self.mainDraggableView.delegate = self;
    self.mainDraggableView.dataSource = self;
    [self.mainScrollView addSubview:self.mainDraggableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInDraggableView:(RMDraggableView *)draggableView {
    return 10;
}
- (NSInteger)draggableView:(RMDraggableView *)draggableView numberOfItemsInSection:(NSInteger)section {
    if (section == 9) {
        return 3;
    }
    return 4;
}

- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView indexPath:(NSIndexPath *)indexPath {
    RMDraggableViewCell * cell = [[RMDraggableViewCell alloc] initWithStyle:RMDraggableViewCellTypeDefault];
    cell.imageView.image = nil;
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (indexPath.section + 1) * (indexPath.row + 1)];
    return cell;
}

@end
