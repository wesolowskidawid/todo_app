class Task {
  String name;
  int state;

  Task(this.name, this.state);

  String getName() {
    return name;
  }
  int getState() {
    return state;
  }

  void setState(int newState) {
    state = newState;
  }
}