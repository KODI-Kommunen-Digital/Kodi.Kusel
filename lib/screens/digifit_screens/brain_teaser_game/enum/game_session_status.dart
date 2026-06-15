enum GameStageConstant {
  initial('INITIAL_SESSION'),
  progress('IN_PROGRESS'),
  abort('ABORTED'),
  complete('END_SESSION');

  final String name;

  const GameStageConstant(this.name);
}
