import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_cubit.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      context.read<NotificationCubit>().loadNotifications();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        buildWhen: (previous, current) {
          // Hindari rebuild tidak perlu
          if (previous is NotificationLoaded && current is NotificationLoaded) {
            return previous.notifications.length !=
                    current.notifications.length ||
                previous.unreadCount != current.unreadCount;
          }
          return true;
        },
        builder: (context, state) {
          // ===============================
          // LOADING
          // ===============================
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ===============================
          // ERROR
          // ===============================
          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().loadNotifications();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          // ===============================
          // LOADED
          // ===============================
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const _EmptyNotification();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationCubit>().refresh();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];

                  return NotificationTile(
                    notification: notification,
                    onTap: () {
                      context.read<NotificationCubit>().readNotification(
                        notification,
                      );
                    },
                  );
                },
              ),
            );
          }

          // ===============================
          // FALLBACK
          // ===============================
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// ===============================
/// EMPTY STATE
/// ===============================
class _EmptyNotification extends StatelessWidget {
  const _EmptyNotification();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
