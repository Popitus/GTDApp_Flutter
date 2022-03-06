abstract class Repository<Element> {
  int get length;
  Element operator [](int index);
  // int removeWhere({required bool Function(Element element) filter});

  // mutators
  void add(Element element);
  void insert(int index, Element element);
  void removeAt(int index);
  void remove(Element element);
  void move(int from, int to);
  void removeList();
}
