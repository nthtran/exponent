/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI9_0_0RCTScrollViewManager.h"

#import "ABI9_0_0RCTBridge.h"
#import "ABI9_0_0RCTScrollView.h"
#import "ABI9_0_0RCTUIManager.h"

@interface ABI9_0_0RCTScrollView (Private)

- (NSArray<NSDictionary *> *)calculateChildFramesData;

@end

@implementation ABI9_0_0RCTConvert (UIScrollView)

ABI9_0_0RCT_ENUM_CONVERTER(UIScrollViewKeyboardDismissMode, (@{
  @"none": @(UIScrollViewKeyboardDismissModeNone),
  @"on-drag": @(UIScrollViewKeyboardDismissModeOnDrag),
  @"interactive": @(UIScrollViewKeyboardDismissModeInteractive),
  // Backwards compatibility
  @"onDrag": @(UIScrollViewKeyboardDismissModeOnDrag),
}), UIScrollViewKeyboardDismissModeNone, integerValue)

ABI9_0_0RCT_ENUM_CONVERTER(UIScrollViewIndicatorStyle, (@{
  @"default": @(UIScrollViewIndicatorStyleDefault),
  @"black": @(UIScrollViewIndicatorStyleBlack),
  @"white": @(UIScrollViewIndicatorStyleWhite),
}), UIScrollViewIndicatorStyleDefault, integerValue)

@end

@implementation ABI9_0_0RCTScrollViewManager

ABI9_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[ABI9_0_0RCTScrollView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(alwaysBounceHorizontal, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(alwaysBounceVertical, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(bounces, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(bouncesZoom, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(canCancelContentTouches, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(centerContent, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustContentInsets, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(decelerationRate, CGFloat)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(directionalLockEnabled, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(indicatorStyle, UIScrollViewIndicatorStyle)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(keyboardDismissMode, UIScrollViewKeyboardDismissMode)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(maximumZoomScale, CGFloat)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(minimumZoomScale, CGFloat)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(pagingEnabled, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(scrollEnabled, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(scrollsToTop, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(showsHorizontalScrollIndicator, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(showsVerticalScrollIndicator, BOOL)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(stickyHeaderIndices, NSIndexSet)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(scrollEventThrottle, NSTimeInterval)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(zoomScale, CGFloat)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(contentInset, UIEdgeInsets)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(scrollIndicatorInsets, UIEdgeInsets)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(snapToInterval, int)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(snapToAlignment, NSString)
ABI9_0_0RCT_REMAP_VIEW_PROPERTY(contentOffset, scrollView.contentOffset, CGPoint)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(onScrollBeginDrag, ABI9_0_0RCTDirectEventBlock)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(onScroll, ABI9_0_0RCTDirectEventBlock)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(onScrollEndDrag, ABI9_0_0RCTDirectEventBlock)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(onMomentumScrollBegin, ABI9_0_0RCTDirectEventBlock)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(onMomentumScrollEnd, ABI9_0_0RCTDirectEventBlock)
ABI9_0_0RCT_EXPORT_VIEW_PROPERTY(onScrollAnimationEnd, ABI9_0_0RCTDirectEventBlock)

ABI9_0_0RCT_EXPORT_METHOD(getContentSize:(nonnull NSNumber *)ReactABI9_0_0Tag
                  callback:(ABI9_0_0RCTResponseSenderBlock)callback)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused ABI9_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, ABI9_0_0RCTScrollView *> *viewRegistry) {

    ABI9_0_0RCTScrollView *view = viewRegistry[ReactABI9_0_0Tag];
    if (!view || ![view isKindOfClass:[ABI9_0_0RCTScrollView class]]) {
      ABI9_0_0RCTLogError(@"Cannot find ABI9_0_0RCTScrollView with tag #%@", ReactABI9_0_0Tag);
      return;
    }

    CGSize size = view.scrollView.contentSize;
    callback(@[@{
      @"width" : @(size.width),
      @"height" : @(size.height)
    }]);
  }];
}

ABI9_0_0RCT_EXPORT_METHOD(calculateChildFrames:(nonnull NSNumber *)ReactABI9_0_0Tag
                  callback:(ABI9_0_0RCTResponseSenderBlock)callback)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused ABI9_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, ABI9_0_0RCTScrollView *> *viewRegistry) {

    ABI9_0_0RCTScrollView *view = viewRegistry[ReactABI9_0_0Tag];
    if (!view || ![view isKindOfClass:[ABI9_0_0RCTScrollView class]]) {
      ABI9_0_0RCTLogError(@"Cannot find ABI9_0_0RCTScrollView with tag #%@", ReactABI9_0_0Tag);
      return;
    }

    NSArray<NSDictionary *> *childFrames = [view calculateChildFramesData];
    if (childFrames) {
      callback(@[childFrames]);
    }
  }];
}

ABI9_0_0RCT_EXPORT_METHOD(scrollTo:(nonnull NSNumber *)ReactABI9_0_0Tag
                  offsetX:(CGFloat)x
                  offsetY:(CGFloat)y
                  animated:(BOOL)animated)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused ABI9_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry){
    UIView *view = viewRegistry[ReactABI9_0_0Tag];
    if ([view conformsToProtocol:@protocol(ABI9_0_0RCTScrollableProtocol)]) {
      [(id<ABI9_0_0RCTScrollableProtocol>)view scrollToOffset:(CGPoint){x, y} animated:animated];
    } else {
      ABI9_0_0RCTLogError(@"tried to scrollTo: on non-ABI9_0_0RCTScrollableProtocol view %@ "
                  "with tag #%@", view, ReactABI9_0_0Tag);
    }
  }];
}

ABI9_0_0RCT_EXPORT_METHOD(zoomToRect:(nonnull NSNumber *)ReactABI9_0_0Tag
                  withRect:(CGRect)rect
                  animated:(BOOL)animated)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused ABI9_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry){
    UIView *view = viewRegistry[ReactABI9_0_0Tag];
    if ([view conformsToProtocol:@protocol(ABI9_0_0RCTScrollableProtocol)]) {
      [(id<ABI9_0_0RCTScrollableProtocol>)view zoomToRect:rect animated:animated];
    } else {
      ABI9_0_0RCTLogError(@"tried to zoomToRect: on non-ABI9_0_0RCTScrollableProtocol view %@ "
                  "with tag #%@", view, ReactABI9_0_0Tag);
    }
  }];
}

@end
