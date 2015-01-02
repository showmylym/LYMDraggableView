//
//  LYMDragDemoViewController.m
//  YMDraggableView
//
//  Created by Jerry Ray on 12/7/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import "LYMDragDemoViewController.h"
#import "LYMDraggableView.h"
#import "LYMDraggableDataModel.h"

#define Alert_Tag_Delete_Item 1000

@interface LYMDragDemoViewController ()
<UIScrollViewDelegate, LYMDraggableViewDataSource, LYMDraggableViewDelegate, UIAlertViewDelegate>

// Controls
@property (nonatomic, strong) LYMDraggableView * mainDraggableView;
@property (nonatomic, strong) UIScrollView * mainScrollView;

// Arrays
@property (nonatomic, strong) NSMutableArray * editingArray;
@property (nonatomic, strong) NSArray * resultsArray;

// Source data
@property (nonatomic, strong) NSArray * imageSourceArray;
@property (nonatomic, strong) NSArray * titleSourceArray;

/**
 *  Index of item will be deleted. nil is none of items will be deleted.
 */
@property (nonatomic, strong) NSNumber * willBeDeletedIndex;

// Screen size to fit controls
@property (nonatomic, assign) CGSize screenSize;
// A factor value to 320.0 width of screen.
@property (nonatomic, assign) CGFloat screenScaleFactor;

@property (nonatomic, assign) BOOL hasClickedAddBtn;


@end

@implementation LYMDragDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self basicConstruction];
    [self constructScrollView];
    [self constructDraggableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainDraggableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mainDraggableView.delegate = nil;
    self.mainDraggableView.dataSource = nil;
    self.mainScrollView.delegate = nil;
}

#pragma mark - Construct
- (void)basicConstruction {
    
    self.view.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];

    self.screenSize = [[UIScreen mainScreen] bounds].size;
    self.screenScaleFactor = self.screenSize.width / 320.0;
    self.titleSourceArray = [self allTitles];
    self.imageSourceArray = [self allImageFilePaths];
    self.hasClickedAddBtn = NO;
    
    NSMutableArray * constructedDataArray = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < 20; i ++) {
        LYMDraggableDataModel * dataModel = [[LYMDraggableDataModel alloc] init];
        dataModel.title = [self randomTitle];
        dataModel.imageFilePath = [self randomImagePath];
        [constructedDataArray addObject:dataModel];
        dataModel = nil;
    }
    self.resultsArray = constructedDataArray;


}

- (void)constructScrollView {
    CGRect scrollViewFrame =
    {
        .origin.x = 0.0,
        .origin.y = 0.0,
        .size.width = self.view.frame.size.width,
        .size.height = self.view.frame.size.height - 8.0,
        // 8.0 is margin of scrollView to bottom.
    };
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollEnabled = YES;
    self.mainScrollView.scrollsToTop = YES;
    [self.view addSubview:self.mainScrollView];
}

- (void)constructDraggableView {
    self.mainDraggableView = [[LYMDraggableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.screenSize.width, 0.0) layoutType:LYMDraggableViewLayoutByColumnNum horizontalMargin:15.0 verticalMargin:10.0 vSpace:10.0 maxColumn:4.0 cornerRadius:nil];
    self.mainDraggableView.delegate = self;
    self.mainDraggableView.dataSource = self;
    self.mainDraggableView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.mainDraggableView];

}

- (void)resetNavigationBarButtonItem {
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    if (self.mainDraggableView.isEditing == YES) {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }

}

#pragma mark - Private methods
- (NSArray *)allTitles {
    return @[@"像雾像雨", @"又像风", @"望着天边", @"闻起来不错", @"天气很好", @"艳阳高照", @"情深深", @"雨蒙蒙", @"多少楼台", @"烟雨中", @"新气象", @"继往开来", @"昂首阔步", @"仙风道骨", @"随遇而安", @"不一而足", @"轻舟已过", @"万重山", @"我自横刀", @"向天笑", @"蜀道难", @"难于上青天", @"黄粱一梦", @"千里孤坟", @"无处话", @"凄凉", @"鬓如霜", @"满地黄花", @"Halo", @"Eason", @"Jerry", @"Tom", @"Jim", @"Green", @"Steven", @"Cindy", @"Grace", @"Happiness", @"Goddess", @"Tough-Man"];
}

- (NSArray *)allImageFilePaths {
    NSString * imageSourcePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"bundle"];
    NSError * error = nil;
    NSArray * fileNamesAtPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageSourcePath error:&error];
    NSMutableArray * allFilePaths = [NSMutableArray array];
    for (NSString * fileName in fileNamesAtPath) {
        NSString * filePath = [imageSourcePath stringByAppendingPathComponent:fileName];
        [allFilePaths addObject:filePath];
    }
    if (allFilePaths.count == 0) {
        return nil;
    } else {
        return allFilePaths;
    }
}

- (NSString *)randomTitle {
    int randomIndex = arc4random() % self.titleSourceArray.count;
    return [self.titleSourceArray objectAtIndex:randomIndex];
}

- (NSString *)randomImagePath {
    if (self.imageSourceArray.count > 0) {
        int randomIndex = arc4random() % (self.imageSourceArray.count + 6);
        if (randomIndex < self.imageSourceArray.count) {
            return [self.imageSourceArray objectAtIndex:randomIndex];
        } else {
            //Maybe return a nil image file path, so that show the last character of title.
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)saveEditingResults {
    // TODO: Do something of saving...
}

#pragma mark - Control events handler
- (void)doneButtonPressed:(UIBarButtonItem *)sender {
    // Reset draggableView editing state
    [self.mainDraggableView endEditing];
    [self saveEditingResults];
}

#pragma mark - Draggable View delegate and datasourc
- (NSInteger)numberOfCellsInDraggableView:(LYMDraggableView *)draggableView {
    NSInteger numberOfCells = 1;
    if (draggableView.isEditing) {
        numberOfCells += self.editingArray.count;
    } else {
        numberOfCells += self.resultsArray.count;
    }
    return numberOfCells;
}

- (CGSize)cellSizeInDraggableView:(LYMDraggableView *)draggableView {
    return CGSizeMake(55.0 * self.screenScaleFactor, 75.0 * self.screenScaleFactor);
}

- (CGSize)draggableView:(LYMDraggableView *)draggableView cornerBtnSizeAtIndex:(NSUInteger)index {
    return CGSizeMake(30.0 * self.screenScaleFactor, 30.0 * self.screenScaleFactor);
}

- (LYMDraggableViewCell *)draggableView:(LYMDraggableView *)draggableView cellForIndex:(NSUInteger)index {
    LYMDraggableViewCell * cell = [[LYMDraggableViewCell alloc] initWithSize:[self cellSizeInDraggableView:draggableView] style:LYMDraggableViewCellTypeDefault cornerBtnStyleWhenShaking:LYMDraggableViewCellCornerBtnStyleTopRight];
    NSArray * dataArr = self.resultsArray;
    if (draggableView.isEditing) {
        dataArr = self.editingArray;
    }
    //One more button is Add
    if (index < dataArr.count) {
        LYMDraggableDataModel * dataModel = [dataArr objectAtIndex:index];
        cell.textLabel.text = dataModel.title;
        
        //Corner button

        [cell.cornerBtn setImage:[UIImage imageNamed:@"dragviewcellcornerdel"] forState:UIControlStateNormal];
        
        //Head image
        UIImage * headImage = [UIImage imageWithContentsOfFile:dataModel.imageFilePath];
        if (headImage == nil) {
            //头像为空，用最后一个字符代替
            NSString * name = [dataModel.title stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (name.length == 0) {
                name = @" ";
            } else {
                name = [name substringFromIndex:name.length - 1];
            }
            UILabel * imageLabel        = [[UILabel alloc] initWithFrame:cell.imageView.frame];
            imageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageLabel.textAlignment    = NSTextAlignmentCenter;
            imageLabel.font             = [UIFont systemFontOfSize:38.0];
            imageLabel.backgroundColor  = [UIColor clearColor];
            imageLabel.textColor        = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
            imageLabel.text             = name;
            [cell.imageView addSubview:imageLabel];

            //给imageView设置颜色图片
            UIColor * imageColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
            cell.imageView.backgroundColor = imageColor;
        } else {
            cell.imageView.image = headImage;
        }
#warning Background color for test
        cell.contentView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:190.0/255.0 alpha:1.0];
    } else {
        //添加收藏按钮
        cell.imageView.image = [UIImage imageNamed:@"dragViewAddBtn"];
        cell.textLabel.text = @"添加";
    }
    dataArr = nil;
    return cell;
}

- (void)draggableView:(LYMDraggableView *)draggableView didSelectCellAtIndex:(NSUInteger)index {
    if (draggableView.isEditing == NO) {
        if (index < self.resultsArray.count) {

        } else {
            // 添加按钮
            self.hasClickedAddBtn = YES;
            LYMDraggableDataModel * dataModel = [LYMDraggableDataModel new];
            dataModel.title = [self randomTitle];
            dataModel.imageFilePath = [self randomImagePath];
            self.resultsArray = [self.resultsArray arrayByAddingObject:dataModel];
            [draggableView reloadData];
        }
    }
}

- (void)draggableView:(LYMDraggableView *)draggableView didResizeWithFrame:(CGRect)frame {
    //Content size of scroll view should be equal to draggableView.frame.size in normal situation.
    self.mainScrollView.contentSize = draggableView.frame.size;

    if (self.hasClickedAddBtn == YES) {
        self.hasClickedAddBtn = NO;
        //scroll to bottom if click Btn add to add a new item.
        CGRect scrollViewBottomRect;
        scrollViewBottomRect.origin.x = 0.0;
        scrollViewBottomRect.origin.y = self.mainScrollView.contentSize.height - 1.0;
        scrollViewBottomRect.size.height = 1.0;
        scrollViewBottomRect.size.width = 1.0;
        [self.mainScrollView scrollRectToVisible:scrollViewBottomRect animated:YES];
    }
    
}

- (void)draggableView:(LYMDraggableView *)draggableView cornerBtnPressedAtIndex:(NSUInteger)index {
    UIAlertView * alert = nil;
    if (self.editingArray.count > index) {
        self.willBeDeletedIndex = @(index);
        LYMDraggableDataModel * dataModel = [self.editingArray objectAtIndex:index];
        NSString * title = [NSString stringWithFormat:@"Are you sure to delete %@？", dataModel.title];
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Yes", nil];
        alert.tag = Alert_Tag_Delete_Item;
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Out of bounds for selected index!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    }
    [alert show];
    alert = nil;
}

- (void)draggableView:(LYMDraggableView *)draggableView moveItemAndTouchUpFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex < self.editingArray.count && toIndex < self.editingArray.count) {
        NSLog(@"This item was just moving，from %ld to %ld", (unsigned long)fromIndex, (unsigned long)toIndex);
        LYMDraggableDataModel * fromDataModel = [self.editingArray objectAtIndex:fromIndex];
        [self.editingArray removeObject:fromDataModel];
        [self.editingArray insertObject:fromDataModel atIndex:toIndex];
        self.resultsArray = [self.editingArray copy];
    }
}

- (BOOL)draggableView:(LYMDraggableView *)draggableView canMoveAtIndex:(NSUInteger)index {
    NSArray * dataArr = self.resultsArray;
    if (draggableView.isEditing) {
        dataArr = self.editingArray;
    }
    //The last item can't be moved, deleted, or shaked.
    if (index == dataArr.count) {
        return NO;
    }
    return YES;
}

- (BOOL)draggableView:(LYMDraggableView *)draggableView canShakeWhenEditingAtIndex:(NSUInteger)index {
    NSArray * dataArr = self.resultsArray;
    if (draggableView.isEditing) {
        dataArr = self.editingArray;
    }
    if (index == dataArr.count) {
        return NO;
    }
    return YES;
}

- (BOOL)draggableView:(LYMDraggableView *)draggableView canEditingAtIndex:(NSUInteger)index {
    NSArray * dataArr = self.resultsArray;
    if (draggableView.isEditing) {
        dataArr = self.editingArray;
    }
    if (index == dataArr.count) {
        return NO;
    }
    return YES;
}

- (CGFloat)draggableView:(LYMDraggableView *)draggableView cellEditingScaleUpFactorAtIndex:(NSUInteger)index {
    return 1.2;
}


// Draggableview editing state change
- (void)draggableViewBeginEditing:(LYMDraggableView *)draggableView {
    self.editingArray = [NSMutableArray arrayWithArray:self.resultsArray];
    self.willBeDeletedIndex = nil;
    [self resetNavigationBarButtonItem];

}

- (void)draggableViewEndEditing:(LYMDraggableView *)draggableView {
    [self saveEditingResults];
    self.editingArray = nil;
    self.willBeDeletedIndex = nil;
    [self resetNavigationBarButtonItem];

}

#pragma mark - UIAlertView delegate 
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == Alert_Tag_Delete_Item) {
        if (self.willBeDeletedIndex != nil && buttonIndex != alertView.cancelButtonIndex) {
            NSInteger index = [self.willBeDeletedIndex integerValue];
            if (index < self.editingArray.count && index > 0) {
                [self.editingArray removeObjectAtIndex:index];
                self.resultsArray = [self.editingArray copy];
                //One of way to reload
                [self.mainDraggableView removeCellAtIndex:index];
                //The other way to reload. Continue shaking after reloading all cell
//                [self.mainDraggableView reloadData];
//                [self.mainDraggableView continueShakingWhenEditing];
            }
        }
    }
}



@end
