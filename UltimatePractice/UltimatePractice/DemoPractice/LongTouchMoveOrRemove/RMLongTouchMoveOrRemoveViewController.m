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

@property (nonatomic, assign) CGFloat scaleFactor;

@end

@implementation RMLongTouchMoveOrRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.scaleFactor = screenSize.width / 320.0;

    CGFloat width = 320.0 * self.scaleFactor;
    self.mainDraggableView = [[RMDraggableView alloc] initWithFrame:CGRectMake(0.0, 84.0, width, 1.0) layoutType:RMDraggableViewLayoutByColumnNum horizontalMargin:12.0 verticalMargin:12.0 vSpace:24.0 maxColumn:4];
    self.mainDraggableView.backgroundColor = [UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
    self.mainDraggableView.delegate = self;
    self.mainDraggableView.dataSource = self;
    [self.view addSubview:self.mainDraggableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editBarButtonItemPressed:)];

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

- (void)editBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.mainDraggableView endEditing];
}

- (NSInteger)numberOfCellsInDraggableView:(RMDraggableView *)draggableView {
    return 15;
}

- (CGSize)cellSizeInDraggableView:(RMDraggableView *)draggableView {
    return CGSizeMake(60.0 * self.scaleFactor, 80.0 * self.scaleFactor);
}

- (CGSize)draggableView:(RMDraggableView *)draggableView cornerBtnSizeAtIndex:(NSUInteger)index {
    return CGSizeMake(25.0 * self.scaleFactor, 25.0 * self.scaleFactor);
}

- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView cellForIndex:(NSUInteger)index {
    RMDraggableViewCell * cell = [[RMDraggableViewCell alloc] initWithStyle:RMDraggableViewCellTypeDefault cornerBtnStyleWhenShaking:RMDraggableViewCellCornerBtnStyleTopRight];
    NSString * imgName = [NSString stringWithFormat:@"%ld.jpg", (long)index + 1];
    cell.imageView.image = [UIImage imageNamed:imgName];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)index + 1];
    return cell;
}

- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndex:(NSUInteger)index {
    NSString * msg = [NSString stringWithFormat:@"You've just tapped index(%ld), named (%ld) item.", (long)index + 1, (long)index + 1];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Info" message:msg delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];
}

- (void)draggableView:(RMDraggableView *)draggableView cornerBtnPressedAtIndex:(NSUInteger)index {
    NSString * msg = [NSString stringWithFormat:@"Corner Btn Pressed at index(%ld), named (%ld) item.", (long)index + 1, (long)index + 1];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Info" message:msg delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];
}

- (void)draggableView:(RMDraggableView *)draggableView moveItemFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    NSString * msg = [NSString stringWithFormat:@"Item has been moved from (%ld) to (%ld).", (long)fromIndex + 1, (long)toIndex + 1];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Move Result" message:msg delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];

}

@end
