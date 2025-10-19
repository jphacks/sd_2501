enum TodoStatus {
  notStarted('未完了'),
  inProgress('取り組み中'),
  completed('完了'),
  overdue('期限切れ'); // 期限切れを追加

  const TodoStatus(this.displayName);
  final String displayName;
}