enum SomaRole {
  trainee("연수생"),
  mentor("멘토"),
  expert("Expert"),
  oldTrainee("이전 기수"),
  visitor("방문객"),
  none("");

  final String kor;

  const SomaRole(this.kor);

  @Deprecated('Use getRoles instead')
  static List<SomaRole> get roles => getRoles();

  static List<SomaRole> getRoles({bool includeVisitor = false}) =>
      values.where((e) {
        if (includeVisitor && e == SomaRole.visitor) return true;
        return e != SomaRole.none && e != SomaRole.visitor;
      }).toList();

  static SomaRole fromKor(String kor) {
    return values.firstWhere((e) => e.kor == kor);
  }
}
