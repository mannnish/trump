import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trump/constants/appconfig.dart';
import 'package:trump/models/device.singleton.dart';
import 'package:trump/models/message.model.dart';
import 'package:trump/repo/auth.repo.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();
  MessageModel messageModel = MessageModel();
  DeviceSingleton deviceSingleton = DeviceSingleton();
  late CollectionReference collectionReference;

  @override
  void initState() {
    collectionReference =
        FirebaseFirestore.instance.collection(Collections.messages).doc(widget.uid).collection(Collections.messages);
    messageModel.deviceId = deviceSingleton.deviceId;
    messageModel.deviceName = deviceSingleton.deviceName;
    messageModel.deviceColor = deviceSingleton.deviceColor;
    messageModel.userId = widget.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => AuthRepo.logout(context),
                    icon: const Icon(Icons.logout, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "name",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Online",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(Collections.messages)
                    .doc(widget.uid)
                    .collection(Collections.messages)
                    .orderBy('sent_at')
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        MessageModel messageModel = MessageModel.fromQuerySnapshot(doc);
                        double marginBottom = messageModel.userId == widget.uid ? 3 : 8;
                        var messageUi = Container(
                          padding: EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: marginBottom,
                            bottom: marginBottom,
                          ),
                          child: Align(
                            alignment: (messageModel.deviceId != deviceSingleton.deviceId
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                messageModel.deviceId != deviceSingleton.deviceId
                                    ? Container(
                                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                                        child: Text(
                                          messageModel.deviceName.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: messageModel.deviceColor != null
                                                ? Color(messageModel.deviceColor as int)
                                                : Colors.grey,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (messageModel.deviceId != deviceSingleton.deviceId
                                        ? Colors.grey.shade200
                                        : Colors.blue[200]),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Text(
                                    doc.get('content'),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        return GestureDetector(
                          onLongPress: () {
                            //show cupertirno action sheet
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                title: const Text('Delete message'),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      doc.reference.delete();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: const Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: messageUi,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: () {
                        if (_controller.text.isEmpty || _controller.text.trim().isEmpty) {
                          return;
                        }
                        messageModel.content = _controller.text;
                        messageModel.sentAt = DateTime.now();
                        messageModel.type = "text";
                        collectionReference.add(messageModel.toJson());
                        _controller.clear();
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
