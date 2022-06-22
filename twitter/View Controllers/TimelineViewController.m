//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DateTools.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Tweet *> *arrayOfTweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    // Get timeline
    [self fetchTweets];
}
- (void)fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray<Tweet *> *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];

}
- (IBAction)didTapLogout:(id)sender {
    //change window's root controller to go back to login screen w/o segue
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //clear access tokens
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.arrayOfTweets[indexPath.row];
    cell.tweetTextLabel.text = cell.tweet.text;
    cell.tweetUserLabel.text = cell.tweet.user.name;
    cell.tweetUserHandleLabel.text =     [NSString stringWithFormat:@"@%@", cell.tweet.user.screenName];

    cell.tweetDateLabel.text = [cell.tweet.date shortTimeAgoSinceNow];
    
    NSString *URLString = cell.tweet.user.profilePicture;
    [URLString stringByReplacingOccurrencesOfString:@"normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.tweetProfileImageView.image = [UIImage imageWithData: urlData];
    
    //buttons require bracket format rather than dot format
    NSString *retweetImageName = cell.tweet.retweeted ? @"retweet-icon-green.png" : @"retweet-icon.png";
    [cell.tweetRetweetButton setImage: [UIImage imageNamed: retweetImageName] forState:UIControlStateNormal];
    
    [cell.tweetRetweetButton setTitle:[NSString stringWithFormat:@"%d", cell.tweet.retweetCount] forState:UIControlStateNormal];

//    cell.tweetRetweetButton.titleLabel.text = [NSString stringWithFormat:@"%d", cell.tweet.retweetCount];
    
    
    NSString *favoriteImageName = cell.tweet.favorited ? @"favor-icon-red.png" : @"favor-icon.png";
    [cell.tweetFavoriteButton setImage: [UIImage imageNamed: favoriteImageName] forState:UIControlStateNormal];
    
    [cell.tweetFavoriteButton setTitle:[NSString stringWithFormat:@"%d", cell.tweet.favoriteCount] forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets ? self.arrayOfTweets.count : 0;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject: tweet atIndex:0];
    [self.tableView reloadData];
}

@end
