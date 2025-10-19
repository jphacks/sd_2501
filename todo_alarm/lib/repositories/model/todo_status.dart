enum TodoStatus {
  notStarted('未完了'),
  inProgress('取り組み中'),
  completed('完了');

  const TodoStatus(this.displayName);
  final String displayName;
}