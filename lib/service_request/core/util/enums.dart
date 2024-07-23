enum FNOLSteps {
  created(
    'FNOL',
    '',
  ),
  policeReport(
    'police',
    'محضر الشرطة',
  ),
  bRepair(
    'repair_before',
    'معاينة قبل الإصلاح',
  ),
  supplement(
    'supplement',
    'معاينة إضافية',
  ),
  resurvey(
    'resurvey',
    'معاينة جديدة',
  ),
  aRepair(
    'After Repair',
    'معاينة بعد الإصلاح',
  ),
  rightSave(
    'Right Save',
    'معاينة حفظ الحق',
  ),
  billing(
    'Billing',
    '',
  );

  get isCreated => this == FNOLSteps.created;

  get isPoliceReport => this == FNOLSteps.policeReport;

  get isBeforeRepair => this == FNOLSteps.bRepair;

  get isSupplement => this == FNOLSteps.supplement;

  get isResurvey => this == FNOLSteps.resurvey;

  get isAfterRepair => this == FNOLSteps.aRepair;

  get isRightSave => this == FNOLSteps.rightSave;

  get isBilling => this == FNOLSteps.billing;

  final String fileNamePrefix;
  final String arName;

  const FNOLSteps(
    this.fileNamePrefix,
    this.arName,
  );
}
