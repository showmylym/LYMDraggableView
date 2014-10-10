//
//  RMLongTouchMoveOrRemoveViewController.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
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

    //cal scaled space, to adapt screen after iPhone 6
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat scaleFactor = screenSize.width / 320.0;

    
    self.mainDraggableView = [[RMDraggableView alloc] initWithFrame:self.view.frame layoutType:RMDraggableViewLayoutByColumnNum horizontalMargin:12.0 verticalMargin:12.0 vSpace:24.0 maxColumn:4];
    self.mainDraggableView.backgroundColor = [UIColor blueColor];
    self.mainDraggableView.delegate = self;
    self.mainDraggableView.dataSource = self;
    [self.view addSubview:self.mainDraggableView];

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

- (NSInteger)numberOfRowsInDraggableView:(RMDraggableView *)draggableView {
    return 4;
}
- (NSInteger)draggableView:(RMDraggableView *)draggableView numberOfColumnsInRow:(NSInteger)section {
    if (section == 3) {
        return 3;
    }
    return 4;
}

- (CGSize)cellSizeInDraggableView:(RMDraggableView *)draggableView {
    return CGSizeMake(60.0, 80.0);
}

- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView cellForColumnAtIndexPath:(NSIndexPath *)indexPath {
    RMDraggableViewCell * cell = [[RMDraggableViewCell alloc] initWithStyle:RMDraggableViewCellTypeDefault];
    NSString * imgName = [NSString stringWithFormat:@"%ld", (long)(indexPath.row + 1) * (indexPath.column + 1)];
    cell.imageView.image = [UIImage imageNamed:imgName];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.row + 1) * (indexPath.row + 1)];
    return cell;
}

- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
