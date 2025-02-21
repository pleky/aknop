import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/home.dart';
import 'package:flutter_app/app/models/survey.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/resources/pages/detail_survey_page.dart';
import 'package:flutter_app/resources/pages/form_survey_page.dart';
import 'package:flutter_app/resources/pages/landing_page.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/survey_list_controller.dart';

class SurveyListPage extends NyStatefulWidget<SurveyListController> {
  static RouteView path = ("/survey-list", (_) => SurveyListPage());

  SurveyListPage({super.key}) : super(child: () => _SurveyListPageState());
}

class _SurveyListPageState extends NyState<SurveyListPage> {
  /// [SurveyListController] controller
  SurveyListController get controller => widget.controller;
  final Debouncer _debouncer = Debouncer();
  TransactionApiService _transactionApiService = TransactionApiService();

  late ScrollController _scrollController;
  bool _isPinned = false;
  List<Survey> surveys = [];
  HomeModel? homeData;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final isPinned = _scrollController.hasClients && _scrollController.offset >= (150.0 - kToolbarHeight);

    if (isPinned != _isPinned) {
      setState(() {
        _isPinned = isPinned;
      });
    }
  }

  @override
  get init => () async {
        await api<TransactionApiService>(
          (request) => request.getAllSurvey(),
          onSuccess: (response, data) {
            setState(() {
              surveys = data;
            });
          },
        );

        dynamic _authData = await Auth.data();

        await api<TransactionApiService>(
          (request) => request.getHomeData('${_authData['id']}'),
          onSuccess: (response, data) {
            setState(() {
              homeData = data;
            });
          },
        );
      };

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () async {
        await _transactionApiService.getAllSurvey(title: value).then((data) {
          if (data != null) {
            setState(() {
              surveys = data;
            });
          }
        });
      },
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: RefreshIndicator(
          onRefresh: () async {
            reboot();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 130.0, // Height when expanded
                floating: true, // AppBar doesn't float
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(16),
                  title: Text(
                    'Daftar Survey',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: _isPinned ? Colors.white : Colors.black),
                  ),
                  centerTitle: false,
                  background: Container(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.only(top: 16, left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              'https://picsum.photos/100/100',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(homeData?.user?.username ?? '').bodyLarge(),
                              Text(homeData?.user?.email ?? '').bodySmall(),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              await Auth.logout();
                              routeTo(LandingPage.path, navigationType: NavigationType.pushReplace);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('${homeData?.dashboard?.surveyTotal ?? 0}').displaySmall(color: Colors.white),
                              Wrap(
                                children: [
                                  Text('Total ').bodySmall(color: Colors.white).alignCenter(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('${homeData?.dashboard?.surveyCompleted ?? 0}').displaySmall(color: Colors.white),
                              Wrap(
                                children: [
                                  Text('Selesai').bodySmall(color: Colors.white).alignCenter(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('${homeData?.dashboard?.surveyDraft ?? 0}').displaySmall(color: Colors.white),
                              Wrap(
                                children: [
                                  Text('Pending').bodySmall(color: Colors.white).alignCenter(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _handleTextFieldChange,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Color(0xFFebedf0),
                      title: Text(surveys[index].judul ?? ''),
                      subtitle:
                          Text(DateFormat('dd MMM yyyy').format(DateTime.parse(surveys[index].created_at!)).toString()),
                      onTap: () => routeTo(DetailSurveyPage.path, data: surveys[index].id),
                      trailing: surveys[index].status != 'COMPLETED'
                          ? Icon(
                              Icons.pending_actions,
                              color: Colors.orange,
                            )
                          : Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 6),
                  itemCount: surveys.length,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () async {
          routeTo(FormSurveyPage.path, data: 'none');
        },
      ),
    );
  }
}
