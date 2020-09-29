import 'dart:async';

import 'package:flutter/services.dart';

import 'social_share_platform_interface.dart';

const MethodChannel _channel = MethodChannel('romatroskin.github.io/socialShare');

/// An implementation of [SocialSharePlatform] that uses method channels.
class MethodChannelSocialShare extends SocialSharePlatform {
  @override
  Future<ShareResult> share(ShareRequestType type, String data) async {
    Map<String, dynamic> shareDescription;

    switch (type) {
      case ShareRequestType.system:
        shareDescription = <String, dynamic>{
          'type': 'system',
          'data': data,
        };
        break;
      case ShareRequestType.instagram:
        shareDescription = <String, dynamic>{
          'type': 'instagram',
          'data': data,
        };
        break;
      case ShareRequestType.facebook:
        shareDescription = <String, dynamic>{
          'type': 'facebook',
          'data': data,
        };
        break;
      case ShareRequestType.twitter:
        shareDescription = <String, dynamic>{
          'type': 'twitter',
          'data': data,
        };
        break;
    }

    final Map<String, dynamic> response = await _channel.invokeMapMethod<String, dynamic>(
      'share',
      shareDescription,
    );
    print(response);
    return ShareResult(type: ShareResultType.completed, data: response['data']);
  }
}
