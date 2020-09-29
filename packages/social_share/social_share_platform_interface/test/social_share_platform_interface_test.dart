import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_share_platform_interface/method_channel_social_share.dart';

import 'package:social_share_platform_interface/social_share_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('$SocialSharePlatform', () {
    test('$MethodChannelSocialShare() is the default instance', () {
      expect(SocialSharePlatform.instance, isInstanceOf<MethodChannelSocialShare>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        SocialSharePlatform.instance = ImplementsSocialSharePlatform();
      }, throwsA(isInstanceOf<AssertionError>()));
    });

    test('Can be mocked with `implements`', () {
      final ImplementsSocialSharePlatform mock = ImplementsSocialSharePlatform();
      when(mock.isMock).thenReturn(true);
      SocialSharePlatform.instance = mock;
    });

    test('Can be extended', () {
      SocialSharePlatform.instance = ExtendsSocialSharePlatform();
    });
  });

  group('$MethodChannelSocialShare', () {
    const MethodChannel channel = MethodChannel('github.romatroskin.io/socialShare');
    final List<MethodCall> log = <MethodCall>[];
    final MethodChannelSocialShare socialShare = MethodChannelSocialShare();

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
      });
    });

    tearDown(() {
      log.clear();
    });

    test('share system', () async {
      final result = await socialShare.share(ShareRequestType.system, 'test');
      expect(
        log,
        <Matcher>[
          isMethodCall('share', arguments: <String, Object>{
            'data': 'test',
          })
        ],
      );
      // expect(result, ShareResult(type: ShareResultType.completed, data: 'test'));
    });
  });
}

class ImplementsSocialSharePlatform extends Mock implements SocialSharePlatform {}

class ExtendsSocialSharePlatform extends SocialSharePlatform {}
