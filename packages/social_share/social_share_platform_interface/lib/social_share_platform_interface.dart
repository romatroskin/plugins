import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart' show required, visibleForTesting;

import 'method_channel_social_share.dart';

/// The interface that implementations of video_player must implement.
///
/// Platform implementations should extend this class rather than implement it as `social_share`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [SocialSharePlatform] methods.
abstract class SocialSharePlatform {
  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static SocialSharePlatform _instance = MethodChannelSocialShare();

  /// The default instance of [SocialSharePlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [SocialSharePlatform] when they
  /// register themselves.
  ///
  /// Defaults to [MethodChannelSocialShare].
  static SocialSharePlatform get instance => _instance;

  // TODO(amirh): Extract common platform interface logic.
  // https://github.com/flutter/flutter/issues/43368
  static set instance(SocialSharePlatform instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError('Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  /// Initializes the platform interface and disposes all existing players.
  ///
  /// This method is called when the plugin is first initialized
  /// and on every full restart.
  Future<ShareResult> share(ShareRequestType type, String data) {
    throw UnimplementedError('share() has not been implemented.');
  }

  // This method makes sure that VideoPlayer isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}

/// The way in which the share should be done..
///
/// This hust selelct the way to share the data
enum ShareRequestType {
  /// The  system share.
  system,

  /// The instagram share.
  instagram,

  /// The facebook share.
  facebook,

  /// The twitter share.
  twitter
}

/// Type of the result.
///
/// Emitted by the platform implementation when the share is done.
enum ShareResultType {
  /// The share has been canceled.
  canceled,

  /// The share has done.
  completed,

  /// The share error.
  error,

  /// An unknown event has been received.
  unknown,
}

/// Result emitted from the platform implementation.
class ShareResult {
  /// Result is an instance of [ShareResult].
  ///
  /// The [eventType] argument is required.
  ///
  /// Depending on the [eventType], the [duration], [size] and [buffered]
  /// arguments can be null.
  ShareResult({
    @required this.type,
    this.data,
  });

  /// Type of the result
  final ShareResultType type;

  /// Result data
  final String data;
}
