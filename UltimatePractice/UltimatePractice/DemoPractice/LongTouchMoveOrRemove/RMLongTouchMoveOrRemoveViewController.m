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


    
    self.mainDraggableView = [[RMDraggableView alloc] initWithFrame:CGRectMake(0.0, 84.0, 320.0, 1.0) layoutType:RMDraggableViewLayoutByColumnNum horizontalMargin:12.0 verticalMargin:12.0 vSpace:24.0 maxColumn:4];
    self.mainDraggableView.backgroundColor = [UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
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
- (NSInteger)draggableView:(RMDraggableView *)draggableView numberOfColumnsInRow:(NSInteger)row {
    if (row == 3) {
        return 3;
    }
    return 4;
}

- (CGSize)cellSizeInDraggableView:(RMDraggableView *)draggableView {
    return CGSizeMake(60.0, 80.0);
}

- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView cellForColumnAtIndexPath:(RMIndexPath *)indexPath {
    RMDraggableViewCell * cell = [[RMDraggableViewCell alloc] initWithStyle:RMDraggableViewCellTypeDefault];
    NSString * imgName = [NSString stringWithFormat:@"%ld.jpg", (long)(4 * indexPath.row) + indexPath.column + 1];
    cell.imageView.image = [UIImage imageNamed:imgName];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)(4 * indexPath.row) + indexPath.column + 1];
    return cell;
}

- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndexPath:(RMIndexPath *)indexPath {
    NSString * msg = [NSString stringWithFormat:@"You've just tapped row(%ld) column(%ld), named (%ld) item.", (long)indexPath.row, (long)indexPath.column, (long)(4 * indexPath.row) + indexPath.column + 1];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Info" message:msg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

@end
