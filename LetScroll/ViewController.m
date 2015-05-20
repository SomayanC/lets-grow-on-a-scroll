//
//  ViewController.m
//  LetScroll
//
//  Created by Somayan Chakrabarti on 2014-07-26.
//  Copyright (c) 2014 MayanLabs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) NSMutableArray *dataView;

@property (strong, nonatomic) IBOutlet UIScrollView *briefcaseScroller;
@property (strong, nonatomic) IBOutlet UIScrollView *magnifyingScroller;

@end

#define DATA_VIEW_WIDTH 40.0

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setUpView];
    [self magnify];
}

- (void) setUpView {
    
    self.data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i++) {
        [self.data addObject:[NSNumber numberWithInt:i]];
    }
    
    [self.briefcaseScroller setBackgroundColor:[UIColor lightGrayColor]];
    CGFloat briefcaseScrollerWidth = ((DATA_VIEW_WIDTH * self.data.count) + ((DATA_VIEW_WIDTH / 2) * (self.data.count + 1)));
    self.briefcaseScroller.contentSize = CGSizeMake(briefcaseScrollerWidth, self.briefcaseScroller.frame.size.height);
    self.briefcaseScroller.tag = 1;
    self.briefcaseScroller.delegate = self;
    self.dataView = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.data.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((((DATA_VIEW_WIDTH / 2) * (i + 1)) + (DATA_VIEW_WIDTH * i)), ((self.briefcaseScroller.frame.size.height / 2) - (DATA_VIEW_WIDTH / 2)), DATA_VIEW_WIDTH, DATA_VIEW_WIDTH)];
        button.layer.cornerRadius = (button.frame.size.width / 2);
        [button.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [button.layer setBorderWidth:1.0];
        [button setTitle:[NSString stringWithFormat:@"%ld", ([self.data[i] integerValue] + 1)] forState:UIControlStateNormal];
        
        [self.dataView addObject:button];
        [self.briefcaseScroller addSubview:button];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1) {
        [self magnify];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.tag == 1) {
        CGFloat centralMargin = targetContentOffset->x + ((DATA_VIEW_WIDTH / 2) * 3) + (DATA_VIEW_WIDTH * 2);
        CGFloat rightLimit = (self.briefcaseScroller.contentSize.width - ((DATA_VIEW_WIDTH / 2) * 3) + (DATA_VIEW_WIDTH * 3));
        CGFloat leftLimit = ((DATA_VIEW_WIDTH / 2) * 3) + (DATA_VIEW_WIDTH * 2);
        
        CGFloat newXContentOffset = 0.0;
        
        if (centralMargin > rightLimit) {
            newXContentOffset = (self.briefcaseScroller.contentSize.width - self.briefcaseScroller.frame.size.width);
        }
        else if (centralMargin < leftLimit) {
            newXContentOffset = 0.0;
        }
        else {
            for (int i = 2; i < self.dataView.count; i++) {
                if (abs([self.dataView[i] frame].origin.x - centralMargin) <= 30.0) {
                    CGFloat originalButtonX = (((DATA_VIEW_WIDTH / 2) * (i + 1)) + (DATA_VIEW_WIDTH * i));
                    newXContentOffset = originalButtonX - (((DATA_VIEW_WIDTH / 2) * 3) + (DATA_VIEW_WIDTH * 2));
                    break;
                }
            }
        }
        
        *targetContentOffset = CGPointMake(newXContentOffset, targetContentOffset->y);
    }
}

- (void) magnify {
    for (UIButton *button in self.dataView) {
        CGFloat centralMargin = self.briefcaseScroller.contentOffset.x + ((DATA_VIEW_WIDTH / 2) * 3) + (DATA_VIEW_WIDTH * 2);
        CGFloat distanceFromCentralMargin = abs(button.frame.origin.x - centralMargin);
        CGFloat splashZone = (DATA_VIEW_WIDTH / 2) + DATA_VIEW_WIDTH;
        
        if (distanceFromCentralMargin < splashZone) {
            CGFloat scaleFactor = ((splashZone / 100) - (distanceFromCentralMargin / 100)) + 1.0;
            button.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        }
        else {
            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
