import 'package:codephile/models/user.dart';
import 'package:codephile/resources/colors.dart';
import 'package:codephile/screens/following/following_screen.dart';
import 'package:codephile/services/follow.dart';
import 'package:codephile/services/unfollow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileCard extends StatefulWidget {
  final String? title;
  final String? _token;
  final CodephileUser? _user;
  final bool _isFollowing;
  final bool _isMyProfile;
  final Function _callback;

  const ProfileCard(
    this._token,
    this._user,
    this._isFollowing,
    this._isMyProfile,
    this._callback, {
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late bool isFollowing;
  String? _picture;
  String? _name;
  String? _username;
  String? _institute;
  int? _noOfFollowing;

  @override
  void initState() {
    isFollowing = widget._isFollowing;
    if (widget._user == null) {
      _picture = "";
      _name = "";
      _username = "";
      _institute = "";
      _noOfFollowing = 0;
    } else {
      _picture = widget._user!.picture;
      _name = widget._user!.fullname;
      _username = widget._user!.username;
      _institute = widget._user!.institute;
      _noOfFollowing = widget._user!.noOfFollowing;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: codephileMain,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
            child: Container(
              height: MediaQuery.of(context).size.width / 4,
              width: MediaQuery.of(context).size.width / 4,
              alignment: (_picture == "")
                  ? const Alignment(0.0, 0.0)
                  : Alignment.center,
              child: (_picture == "")
                  ? SizedBox(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      child: SvgPicture.asset(
                        'assets/default_user_icon.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                              _picture!,
                            ),
                          )),
                    ),
              decoration: BoxDecoration(
                color: codephileBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              _name!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22.0,
              ),
            ),
          ),
          Text(
            "@" + _username!,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.65),
              fontSize: 16.0,
            ),
          ),
          Container(
            child: (_institute == "")
                ? const SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 0.0),
                    child: Text(
                      _institute!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  )),
              child: (widget._isMyProfile)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "$_noOfFollowing Following",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (widget._isMyProfile) {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FollowingScreen(widget._token)))
                                  .then((v) {
                                widget._callback();
                              });
                            }
                          },
                        )
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "$_noOfFollowing Following",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 10.0, 16.0, 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? codephileMain
                                        : Colors.white,
                                    border: Border.all(
                                      color: codephileMain,
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2.0),
                                    ),
                                  ),
                                  child: isFollowing
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  12.0, 5.0, 2.0, 5.0),
                                              child: Text(
                                                "FOLLOWING",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 8.0, 12.0, 8.0),
                                              child: Icon(
                                                Icons.check,
                                                size: 16.0,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: const <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                16.0,
                                                5.0,
                                                16.0,
                                                5.0,
                                              ),
                                              child: Text(
                                                "FOLLOW",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: codephileMain,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                              onTap: () {
                                if (isFollowing) {
                                  unFollow();
                                } else {
                                  follow();
                                }

                                changeButtonAppearance();
                                //TODO: implement load on follow/ un-follow     Priority: 2
                              },
                            ),
                          ],
                        )
                      ],
                    ),
            ),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: userIconBorderGrey,
          )
        ],
      ),
    );
  }

  void follow() async {
    followUser(widget._token!, widget._user!.id, context).then((statusCode) {
      if (statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Something went wrong. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 12.0,
        );
        setState(() {
          isFollowing = false;
        });
      }
    });
  }

  void unFollow() async {
    unfollowUser(widget._token!, widget._user!.id, context).then((statusCode) {
      if (statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Something went wrong. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 7,
          fontSize: 12.0,
        );
        setState(() {
          isFollowing = true;
        });
      }
    });
  }

  void changeButtonAppearance() {
    if (isFollowing) {
      setState(() {
        isFollowing = false;
      });
    } else {
      setState(() {
        isFollowing = true;
      });
    }
  }
}
