class MunicipalDetailScreenParams{
  String municipalId;
  Function(bool isFav, int? id, bool? isMunicipal)? onFavUpdate;
  MunicipalDetailScreenParams({required this.municipalId, this.onFavUpdate});
}