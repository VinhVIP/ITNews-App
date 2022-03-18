import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/notification.dart';
import 'package:it_news/data/repositories/notification_repository.dart';
import 'package:it_news/logic/notification/bloc/notification_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return NotificationBloc(NotificationRepository(http.Client()))
          ..add(NotificationFetched());
      },
      child: const ListNotifications(),
    );
  }
}

class ListNotifications extends StatelessWidget {
  const ListNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (BlocProvider.of<NotificationBloc>(context).state.fetchedStatus ==
            NotificationFetchedStatus.success) {
          Navigator.pop(
              context,
              BlocProvider.of<NotificationBloc>(context)
                  .state
                  .countUnreadNotification);
        } else {
          Navigator.pop(context, -1);
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông báo"),
          backgroundColor: Colors.green,
          actions: [
            Tooltip(
              message: "Đánh dấu đã đọc tất cả",
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<NotificationBloc>(context)
                      .add(NotificationReadAll());
                },
                icon: const Icon(Icons.checklist),
              ),
            ),
            Tooltip(
              message: "Xóa tất cả",
              child: IconButton(
                onPressed: () {
                  Utils.showMessageDialog(
                    context: context,
                    title: "Xác nhận",
                    content: "Bạn muốn xóa toàn bộ thông báo?",
                    onOK: () {
                      BlocProvider.of<NotificationBloc>(context)
                          .add(NotificationDeletedAll());
                    },
                  );
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            switch (state.fetchedStatus) {
              case NotificationFetchedStatus.success:
                if (state.notifications.isEmpty) {
                  return const Center(
                    child: Text("Không có thông báo!"),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotificationBloc>().add(NotificationFetched());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      return NotiItem(
                        notifications: state.notifications[index],
                      );
                    },
                    itemCount: state.notifications.length,
                  ),
                );
              case NotificationFetchedStatus.failure:
                return const Center(
                  child: Text("Lỗi tải thông báo!"),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}

class NotiItem extends StatelessWidget {
  const NotiItem({Key? key, required this.notifications}) : super(key: key);
  final Notifications notifications;

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: ValueKey(notifications.idNotification),
      trailingActions: [
        SwipeAction(
          content: Tooltip(
            message: "Xóa",
            child: IconButton(
              onPressed: () {
                context
                    .read<NotificationBloc>()
                    .add(NotificationDeleted(notifications.idNotification));
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
              splashRadius: 25,
            ),
          ),
          color: Colors.transparent,
          onTap: (handler) {},
          widthSpace: 50,
        ),
        if (notifications.status == 0) ...[
          SwipeAction(
            content: Tooltip(
              message: "Đánh dấu đã đọc",
              child: IconButton(
                onPressed: () {
                  context
                      .read<NotificationBloc>()
                      .add(NotificationReadEvent(notifications.idNotification));
                },
                icon: const Icon(Icons.check),
                color: Colors.green,
                splashRadius: 25,
              ),
            ),
            color: Colors.transparent,
            onTap: (handler) {},
            widthSpace: 50,
          ),
        ],
      ],
      child: Card(
        color: notifications.status == 0 ? Colors.white : Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: notifications.status == 0 ? 2 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (notifications.link.contains('post')) {
              viewPost(context);
            } else if (notifications.link.contains('account')) {
              // Todo: Chỉnh api rồi làm sau
              // showDialogLockAccount(context);
            }

            context
                .read<NotificationBloc>()
                .add(NotificationReadEvent(notifications.idNotification));
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notifications.content,
                      style: TextStyle(
                        color: notifications.status == 0
                            ? Colors.green
                            : Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notifications.notificationTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void viewPost(context) {
    int pos = notifications.link.lastIndexOf('/');
    int idPost = int.parse(notifications.link.substring(pos + 1));
    Navigator.pushNamed(context, AppRouter.post, arguments: idPost);
  }

  showDialogLockAccount(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Thông báo"),
            ],
          ),
        );
      },
    );
  }
}
