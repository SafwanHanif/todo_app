import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/task_tile.dart';
import 'task_detail_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final results = _query.trim().isEmpty ? <Task>[] : provider.search(_query);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              'Search',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search tasks, categories…',
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.muted),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.muted),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _query.trim().isEmpty
                ? _Hint(subColor: subColor)
                : results.isEmpty
                    ? _NoResults(subColor: subColor)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        children: [
                          Text(
                            '${results.length} result${results.length == 1 ? '' : 's'}',
                            style: TextStyle(fontSize: 13, color: subColor),
                          ),
                          const SizedBox(height: 4),
                          ...results.map((task) => TaskTile(
                                task: task,
                                onToggle: () => provider.toggleComplete(task.id),
                                onTap: () => showTaskDetailSheet(context, task),
                              )),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final Color subColor;

  const _Hint({required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search, size: 56, color: AppColors.track),
          const SizedBox(height: 12),
          Text(
            'Type to search your tasks',
            style: TextStyle(fontSize: 14, color: subColor),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final Color subColor;

  const _NoResults({required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 56, color: AppColors.track),
          const SizedBox(height: 12),
          Text(
            'No results found',
            style: TextStyle(fontSize: 14, color: subColor),
          ),
        ],
      ),
    );
  }
}
