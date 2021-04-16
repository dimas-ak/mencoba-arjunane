class FormsCheckboxsError {
  bool isSubmited;

  bool isErrorRequired;
  bool isErrorMax;
  bool isErrorMin;

  bool isRequired;
  bool isMax;
  bool isMin;
  int max;
  int min;
  FormsCheckboxsError({
    this.isErrorRequired,
    this.isErrorMax,
    this.isErrorMin,
    this.isSubmited,
    this.isRequired,
    this.isMax,
    this.isMin,
    this.max,
    this.min
  });
}