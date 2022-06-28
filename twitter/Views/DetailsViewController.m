//
//  DetailsViewController.m
//  twitter
//
//  Created by Amanda Wang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "NSDate+DateTools.h"
#import "APIManager.h"
#import "TweetView.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet TweetView *tweetView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetView.tweet = self.tweet;
    [self.tweetView refreshData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a MMM d, yyyy"];
    self.tweetView.tweetDateLabel.text = [formatter stringFromDate: self.tweet.date];
    [self.tweetView.dateLabelTrailingToSuper setActive:false];
    [self.tweetView.dateLabelYToProfileCenter setActive:false];
    [self.tweetView.buttonBottomToSuperBottomEqual setActive:false];
    [self.tweetView.buttonBottomToSuperBottomGreaterEqual setActive:true];
    [self.tweetView.dateLabelLeadingToSuper setActive:true];
    [self.tweetView.dateLabelTopToProfileImage setActive:true];

    [self.tweetView layoutIfNeeded];

}
@end
