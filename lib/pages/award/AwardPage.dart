import 'package:flutter/material.dart';
import 'package:gocv/models/award.dart';
import 'package:gocv/repositories/award.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';

class AwardPage extends StatefulWidget {
  final String resumeId;

  const AwardPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<AwardPage> createState() => _AwardPageState();
}

class _AwardPageState extends State<AwardPage> {
  AwardRepository awardRepository = AwardRepository();

  List<Award> awardList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchAwards(widget.resumeId);
  }

  fetchAwards(String resumeId) async {
    try {
      final response = await awardRepository.getAwards(widget.resumeId);
      print(response);

      if (response['status'] == Constants.httpOkCode) {
        final List<Award> fetchedAwardList =
            (response['data']['data'] as List).map<Award>((award) {
          return Award.fromJson(award);
        }).toList();

        setState(() {
          awardList = fetchedAwardList;
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.genericErrorMsg,
            Colors.red,
          );
        }
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching skill list: $error';
      });
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Container();
              },
            ),
          );
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? Center(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                )
              : awardList.isEmpty
                  ? const Center(
                      child: Text(
                        'No awards added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchAwards(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: awardList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.price_change,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.8,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Text(
                                                awardList[index].title!,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            awardList[index].link != null
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Helper()
                                                            .launchInBrowser(
                                                                awardList[index]
                                                                    .link!);
                                                      },
                                                      child: const Icon(
                                                        Icons.open_in_new,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Helper().isNullEmptyOrFalse(
                                    awardList[index].description,
                                  )
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            const Icon(
                                              Icons.description,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: width * 0.8,
                                              child: Text(
                                                awardList[index].description!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
