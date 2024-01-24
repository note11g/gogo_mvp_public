library go_design_component;

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gogo_mvp_domain/entity/user/soma_role.dart';
import 'package:gogo_mvp_domain/entity/user/user.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';
import 'package:gogo_mvp_domain/entity/user/me.dart';
import 'dart:math' as math show sqrt;

import '../../core/util/photo_util.dart';
import '../../core/util/string_util.dart';
import '../../core/util/measure_util.dart';
import '../color/go_color.dart';
import '../typo/typo.dart';
import '../round/round.dart';

part 'button/base_cta_button.dart';

part 'button/half_cta_button.dart';

part 'button/full_cta_button.dart';

part 'button/min_cta_button.dart';

part 'button/base_button.dart';

part 'button/raw_button.dart';

part 'button/link_button.dart';

part 'button/multi_selection_button.dart';

part 'button/multi_selection_button_unit.dart';

part 'button/icon_button.dart';

part 'text_field/base_text_field.dart';

part 'text_field/text_field_a.dart';

part 'text_field/text_field_b.dart';

part 'text_field/text_field_c.dart';

part 'util_component/text_field_focus_out_helper.dart';

part 'profile/profile_photo_view.dart';

part 'profile/mini_profile_view.dart';

part 'profile/multi_mini_profile_view.dart';

part 'layout/spacer.dart';

part 'layout/divider.dart';

part 'layout/go_row.dart';

part 'layout/fade_horizontal_scrollable_view.dart';

part 'layout/go_dialog.dart';

part 'layout/go_divider_column.dart';

part 'layout/auto_height_page_view.dart';

part 'graphics/go_icon.dart';

part 'graphics/balloon.dart';

part 'chat/chat_box.dart';

part 'chat/date_chat_item.dart';

part 'chat/enter_chat_item.dart';

part 'util_component/full_screen_loading_indicator.dart';

part 'util_component/toast_widget.dart';