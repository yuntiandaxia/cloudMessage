//
//  VideoViewController.m
//  cloudMessage
//
//  Created by iMac mini on 2017/3/13.
//  Copyright © 2017年 iMac mini. All rights reserved.
//

#import "YTVideoViewController.h"
#import "YTAVPlayView.h"
#import "YTProgressSlider.h"

@implementation YTVideoModel

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = [url copy];
    }
    return self;
}

@end

@interface YTVideoViewController ()

//播放视频时候需要。
@property (nonatomic,strong) AVPlayer      *avPlayer;
@property (nonatomic,strong) AVPlayerItem  *avPlayerItem;
@property (nonatomic,strong) AVPlayerLayer *avPlayerLayer;

//顶端视图按钮
@property (nonatomic,strong) UIView      *topView;
@property (nonatomic,strong) UIButton    *backButton;
//@property (nonatomic,strong) UILabel     *titleLabel;
//@property (nonatomic,strong) UITableView *listTableView; //?

//底部视图按钮
@property (nonatomic,strong) UIView   *bottmView;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UILabel  *timeLabel;
@property (nonatomic,strong) YTProgressSlider *slider;

//视频？
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) CADisplayLink           *link;
@property (nonatomic,assign) NSTimeInterval          lastTime;

//
@property (nonatomic,assign) BOOL  isHidenTabView;
@property (nonatomic,assign) BOOL  isHidenListView;

//
@property (nonatomic,strong) UIView *faildView;

//
//@property (nonatomic,strong) YTVideoModel *videoModel;
@property (nonatomic,strong) NSURL *videoUrl;

//
@property (nonatomic,strong) NSArray *videoArr;

@end


@implementation YTVideoViewController


-(instancetype)initWithVideoUrl:(NSURL *)videourl{
    NSAssert(videourl,@"视频不能空！");
    self = [super init];
    if (self) {
        self.videoUrl = videourl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPlayer];
    
    [self initSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)initPlayer{
    //NSLog(@"%@",self.videoUrl);
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    //对item添加监听
    [self.avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //[self.playItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    
    self.avPlayer      = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    
    YTAVPlayView *avPlayerView = [[YTAVPlayView alloc] initWithMoviePlayerLayer:self.avPlayerLayer frame:self.view.bounds];
    avPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:avPlayerView];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval loadedTime = [self availableDurationWithplayerItem:playerItem];
        NSTimeInterval totalTime = CMTimeGetSeconds(playerItem.duration);
        
        if (!self.slider.isSliding) {
            self.slider.progressPercent = loadedTime/totalTime;
        }
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            //NSLog(@"playerItem is ready");
            
            [self.avPlayer play];
            self.slider.enabled = YES;
            self.playButton.enabled = YES;
        } else{
            NSLog(@"load break");
            //self.faildView.hidden = NO;
        }
    }
}

- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

-(void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //topBar
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = [UIColor blackColor];
    self.topView.alpha = .5;
    [self.view addSubview:self.topView];
    
    self.topView.translatesAutoresizingMaskIntoConstraints = false;
    
    //使得
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.backButton setImage:[UIImage imageNamed:@"gobackBtn"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    
    //list按钮
    UIButton *listButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [listButton setImage:[UIImage imageNamed:@"player_fit"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(showOrHideListTableViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:listButton];
    
    listButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:listButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:listButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:listButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:listButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    

    //bottonBar
    self.bottmView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottmView.backgroundColor = [UIColor blackColor];
    self.bottmView.alpha = 0.5;
    [self.view addSubview:self.bottmView];
    
    self.bottmView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottmView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottmView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottmView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottmView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.playButton setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.enabled = NO;
    [self.bottmView addSubview:self.playButton];
    
    self.playButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.text = @"00:00:00/00:00:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.bottmView addSubview:self.timeLabel];
    
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:labelsize.width + 5]];
    
    //滑块
    self.slider = [[YTProgressSlider alloc] initWithFrame:CGRectZero direction:YTSliderDirectionHorizonal];
    [self.bottmView addSubview:self.slider];
    self.slider.enabled = NO;
    
    self.slider.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.playButton attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.timeLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bottmView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //滑块动作。
    [self.slider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    
    //载入时候的菊花
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.color = [UIColor redColor];
    [self.activity setCenter:self.view.center]; //指定菊花的中心点。
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    [self.view addSubview:self.activity];
    
    self.activity.translatesAutoresizingMaskIntoConstraints = false;
    //指定宽、高和x,y坐标。
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:30]];
    
    //加载失败
    self.faildView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.faildView];
    self.faildView.backgroundColor = [UIColor redColor];
    self.faildView.hidden = YES;
    
    self.faildView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.faildView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.faildView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.faildView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.faildView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //
    UIButton *reLoadButton = [[UIButton alloc] initWithFrame:self.faildView.bounds];
    [reLoadButton setTitle:@"视频加载失败，点击重新加载" forState:UIControlStateNormal];
    [reLoadButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.faildView addSubview:reLoadButton];
    
    reLoadButton.translatesAutoresizingMaskIntoConstraints = false;
}

//视频播放完成
- (void)moviePlayDidEnd
{
    NSLog(@"播放完成");
    [self.avPlayer pause];
    [self.link invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 各种事件点击
- (void)backAction:(UIButton *)button
{
    //[self removeObserveWithPlayerItem:self.avPlayerItem];
    
    [self.avPlayer pause];
    [self.link invalidate];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)reloadAction:(UIButton *)button
{
    //[self changeCurrentplayerItemWithAC_VideoModel:self.videoModel];
    self.faildView.hidden = YES;
}

-(void)showOrHideListTableViewAction:(UIButton *)button{
    NSLog(@"跳转到播放列表");
}

-(void)playOrPauseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.avPlayer.rate == 1) {
        [self.avPlayer pause];
        self.link.paused = YES;
        [self.activity stopAnimating];
    }else{
        [self.avPlayer play];
        self.link.paused = NO;
    }
}

-(void)updateTime{
    NSTimeInterval current = CMTimeGetSeconds(self.avPlayer.currentTime);
    NSTimeInterval total   = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!self.slider.isSliding) {
        self.slider.sliderPercent = current/total;
    }
    
    if (current!=self.lastTime) {
        [self.activity stopAnimating];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:current], isnan(total)?@"00:00:00":[self formatPlayTime:total]];
    }else{
        [self.activity startAnimating];
    }
    self.lastTime = current;
}

//移除处观察者
- (void)removeObserveWithPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"status"];
}

- (NSString *)formatPlayTime:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

//处理滑块
- (void)progressValueChange:(YTProgressSlider *)slider
{
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval duration = self.slider.sliderPercent* CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        
        [self.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
            
        }];
    }
}


- (void)dealloc
{
    //NSLog(@"dead");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserveWithPlayerItem:_avPlayerItem];
}

@end
















































