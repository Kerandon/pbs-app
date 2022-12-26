enum Attendance {

  present,
  absent



}

extension AsText on Attendance {
  String toText() {
    switch (this) {
      case Attendance.present:
        return 'Present';
      case Attendance.absent:
        return 'Absent';
    }
  }
}