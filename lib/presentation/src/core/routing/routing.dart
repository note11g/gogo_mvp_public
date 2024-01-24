library gogo_routing;

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:gogo_mvp_domain/entity/app_info/app_version_info.dart';
import 'package:gogo_mvp_domain/usecase/auth/login_check_usecase.dart';

import '../../pages/chat/chat_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/home/join_ask/join_ask_popup.dart';
import '../../pages/profile_setting/profile_setting_page.dart';
import '../../pages/welcome/welcome_page.dart';
import '../../pages/home/need_update/need_update_popup.dart';

part 'gogo_router_helper.dart';
part 'router_redirect.dart';
part 'pages.dart';