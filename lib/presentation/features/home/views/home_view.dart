import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../credits/views/credits_view.dart';
import '../../gallery/views/gallery_view.dart';
import '../../ready/views/ready_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final List<Widget> _items = [
    const GalleryView(),
    const CreditsView(),
    const ReadyView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: IndexedStack(
                    index: state.index,
                    children: _items,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 0,
                thickness: 0.15,
              ),
            ],
          ),
          bottomNavigationBar: buildBottomNavigationBar(context, state),
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, HomeTabState state) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: state.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_gallery.tr(),
            icon: const Padding(
              padding: EdgeInsets.all(5),
              child: FaIcon(
                FontAwesomeIcons.circlePlus,
                size: 20,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_credits.tr(),
            icon: const Padding(
              padding: EdgeInsets.all(5),
              child: FaIcon(
                FontAwesomeIcons.star,
                size: 20,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.homeBottomNavBarLabels_ready.tr(),
            icon: const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: FaIcon(
                FontAwesomeIcons.circleCheck,
                size: 20,
              ),
            ),
          ),
        ],
        onTap: (index) {
          BlocProvider.of<HomeTabCubit>(context).changeTab(index);
        },
      ),
    );
  }
}
