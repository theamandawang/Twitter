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
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *tweetReplyButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetFavoriteButton;

@property (weak, nonatomic) IBOutlet UIButton *tweetRetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetMessageButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a MMM d, yyyy"];
    self.tweetDateLabel.text = [formatter stringFromDate: self.tweet.date];
    self.tweetUserLabel.text = self.tweet.user.name;
    self.tweetTextTextView.text = self.tweet.text;
    self.tweetUserHandleLabel.text = [NSString stringWithFormat: @"@%@", self.tweet.user.screenName];
    [self refreshData];
    NSString *URLString = self.tweet.user.profilePicture;
    [URLString stringByReplacingOccurrencesOfString:@"normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.tweetProfileImageView.image = [UIImage imageWithData: urlData];
    // Do any additional setup after loading the view.
}
-(void) refreshData {
    
    [self.tweetRetweetButton setTitle: [NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal ];
    [self.tweetFavoriteButton setTitle: [NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal ];
    
    
    NSString *favoriteImageName = self.tweet.favorited ? @"favor-icon-red.png" : @"favor-icon.png";
    [self.tweetFavoriteButton setImage: [UIImage imageNamed: favoriteImageName] forState:UIControlStateNormal];
    NSString *retweetImageName = self.tweet.retweeted ? @"retweet-icon-green.png" : @"retweet-icon.png";
    [self.tweetRetweetButton setImage: [UIImage imageNamed: retweetImageName] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapFavorite:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshData];
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if(self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshData];
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshData];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}


@end
