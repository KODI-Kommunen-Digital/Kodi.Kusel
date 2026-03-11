enum ExerciseStageConstant {
  initial('INITIAL_SESSION'),
  start('START_SESSION'),
  progress('SET_CONFIRMED'),
  abort('ABORTED'),
  complete('END_SESSION');

  final String name;

  const ExerciseStageConstant(this.name);
}
